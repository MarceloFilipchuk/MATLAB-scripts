% Direcciones para revisar.
voxelpath = {
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\Voxels\Ictales vs Controles';
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\Voxels\Cronicos vs Ictales';
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\Voxels\Ictales vs Interictales';
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\Voxels\Interictales vs Controles';
};

% Itera sobre cada carpeta.
for pindex = 1:length(voxelpath)
    % Crea una lista de las imagenes dentro de la carpeta.
    cd(voxelpath{pindex})
    tables = dir('*.csv');
    tables = {tables.name}';
    
    finalpath = strcat(voxelpath{pindex}, '\LORETA Voxels\');
    if ~exist(finalpath, 'dir')
        mkdir(finalpath);
    end
    
    % Itera sobre cada tabla de voxeles.
    for mindex = 1:length(tables)
        voxtable = readtable(tables{mindex});
        voxtable(:,4:6) = [];
        voxtable = movevars(voxtable, 'VoxelValue', 'Before', 'X_MNI_');
        voxtable.Hemisfere(:) = "";

        for index = 1:size(voxtable,1)
            if strcmp( voxtable.Structure{index}, '*')
                voxtable.Structure{index} = voxtable.Lobe{index};
            end
        end

        % Agrega el hemisferio a las estructuras
        for index = 1:size(voxtable,1)
            if voxtable.X_MNI_(index) > 0
                voxtable.Hemisfere(index,:) = 'R';
                voxtable.Structure(index) = strcat('R -', {' '}, voxtable.Structure(index));
            elseif voxtable.X_MNI_(index, :) < 0
                voxtable.Hemisfere(index,:) = 'L';
                voxtable.Structure(index) = strcat('L -', {' '}, voxtable.Structure(index));
            else
                voxtable.Hemisfere(index, :) = 'LR';
                voxtable.Structure(index) = strcat('LR -', {' '}, voxtable.Structure(index));
            end
        end
        
        % Elimina duplicados.
        [~, Idx, ~] = unique(voxtable.Structure(:));
        voxtable = voxtable(Idx,:);


        % Aca comienza a separar duplicados en ambos hemisferios.
        final = voxtable;
        for index = size(voxtable,1):-1:1
            for index2 = size(voxtable,1):-1:1
                if index ~= index2 % Para no comparar valores del mismo indice.
                    if strcmp( extractAfter(voxtable.Structure{index}, ' - '), extractAfter(voxtable.Structure{index2}, ' - '))
                        if ~contains( extractBefore(voxtable.Structure(index), ' - '), 'Left and Right')
                            tmpstr = extractAfter(voxtable.Structure(index), ' - ');
                            voxtable.Structure(index) = strcat('LR', {' - '}, tmpstr );
                            voxtable(index2, :) = []; % Delete row
                        end
                    end
                else
                    break
                end
            end
        end 
        

        writetable(final, strcat(finalpath, strcat(extractBefore(tables{mindex},'.csv'), '.xls')));
    end
end
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');