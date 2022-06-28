% Requiere de WFU_pickatlas para poder extraer los hemisferios de las estructuras que estan entre X = -5 y X = 5;

tdist2T = @(t,df) (betainc(df/(df+t^2),df/2,0.5)); % tdist2T(t-value, DegreesOfFreedom)
DF = 48; % IMPORTANTE DEFINIR ESTA CONSTANTE ANTES DE TODO <<<<<<<<<<<<<DEGREES OF FREEDOM


% Direcciones para revisar.
voxelpath = {
%'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Cronicos vs Controles';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Cronicos vs Interictales';
%'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Ictales vs Controles';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Ictales vs Cronicos';
%'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Interictales vs Controles';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Interictales vs Ictales';
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
    for vindex = 1:length(tables)
        tmptable = [];
        voxtable = readtable(tables{vindex}, 'PreserveVariableNames', 1);
        voxtable(:,4:6) = []; % Borra las columnas con las coordenadas de Tailarach.
        voxtable = movevars(voxtable, 'VoxelValue', 'Before', 'X(MNI)');
        voxtable.Hemisphere(:) = "";
        voxtable.Properties.VariableNames([1 2 3 4 5]) = {'VoxelTvalue', 'X_MNI', 'Y_MNI', 'Z_MNI', 'Brodmann_area'}; % Renombra las columnas para evitar conflictos.
        
        % A veces algunas listas estan vacias porque no contienen valores de activacion. Se mantienen para que no hayan malentendidos.
        if ~isempty(voxtable)           
            % Busca en el atlas en los casos en donde la estructura figura como '*'.
            for index = 1:size(voxtable,1)
                if strcmp( voxtable.Structure{index}, '*')
                    structure = mni2atlas([voxtable.X_MNI(index), voxtable.Y_MNI(index), voxtable.Z_MNI(index)], [2]); %#ok<NBRAK>
                    voxtable.Structure(index) = extractAfter(structure.label(1), "% ");
                end
            end

            % Agrega el hemisferio a las estructuras
            for index = 1:size(voxtable,1)
                if voxtable.X_MNI(index) >= 5
                    voxtable.Hemisphere(index,:) = 'R';
                elseif voxtable.X_MNI(index, :) <= -5
                    voxtable.Hemisphere(index,:) = 'L';
                end
            end

            % Busca los hemisferios faltantes en el atlas WFU (aquellos con X mayor o menor que 10, que son estructuras 
            % centrales de las que se podria dudar el hemisferio. Valores con 'Hemisphere' == "" no contienen hemisferios y 
            % son estos los que se buscan. El resto se dejan como estan.
            try
                % Agrego el '%' a X porque la funcion 'wfu_extract_labels' admite que las 3 primeras lineas tengan comentarios,
                % asi evito que salte error por intentar leer los encabezados de la tabla como si fuesen coordenadas MNI.
                tmptable = table(voxtable.X_MNI, voxtable.Y_MNI,voxtable.Z_MNI, 'VariableNames', { '%X ', 'Y', 'Z'});
                writetable(tmptable, 'tmptable.txt','Delimiter','\t')
                wfu_extract_labels('E:\Investigacion\Programas\spm12\toolbox\wfu_pickatlas\MNI_atlas_templates\TD_hemisphere.nii',...
                    strcat(voxelpath{pindex},'\tmptable.txt'), strcat(voxelpath{pindex},'\tmptable_final.txt') );
                tmptable = readtable(strcat(voxelpath{pindex},'\tmptable_final.txt'), 'PreserveVariableNames', 1);
                delete(strcat(voxelpath{pindex},'\tmptable.txt'));
                delete(strcat(voxelpath{pindex},'\tmptable_final.txt'));
            catch ME
                warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name); %#ok<MEXCEP>
            end

            % Agrega el hemisferio.
            for index = 1:size(voxtable,1)       
                if voxtable.Hemisphere(index) == ""
                    if contains(tmptable.Var4(index), 'Right')
                        voxtable.Hemisphere(index) =  "R";
                    elseif contains(tmptable.Var4(index), 'Left')
                        voxtable.Hemisphere(index) =  "L";
                    elseif strcmp(tmptable.Var4(index), 'NA')
                        error('>> No se encontró hemisferio para estas coordenadas <<');
                    else
                        voxtable.Hemisphere(index) = tmptable.Var4(index);
                    end
                end
            end

            % Agrega el hemisferio a las estructuras.
            for index = 1:size(voxtable,1)
                if strcmp(voxtable.Hemisphere(index), "R")
                    voxtable.Structure(index) = strcat('R -', {' '}, voxtable.Structure(index));
                elseif strcmp(voxtable.Hemisphere(index), "L")
                    voxtable.Structure(index) = strcat('L -', {' '}, voxtable.Structure(index));
                end
            end

            % Elimina duplicados.
            [~, Idx, ~] = unique(voxtable.Structure(:));
            Idx = sort(Idx);
            voxtable = voxtable(Idx,:);

%             % Aca comienza a separar duplicados en ambos hemisferios. EN CONSTRUCCION
%             final = removevars(voxtable, {'VoxelTvalue','X_MNI','Y_MNI','Z_MNI','Hemisphere'});
%             for index = size(final,1):-1:1
%                 for index2 = size(final,1):-1:1
%                     if index ~= index2 % Para no comparar valores del mismo indice.
%                         if strcmp( extractAfter(final.Structure{index}, ' - '), extractAfter(final.Structure{index2}, ' - '))
%                                 tmpstr = extractAfter(final.Structure(index), ' - ');
%                                 final.Structure(index) = strcat('LR', {' - '}, tmpstr );
%                                 final(index2, :) = []; % Delete row.
%                         end
%                     else
%                         break
%                     end
%                 end
%             end
        end
%     % Final unifica las estructuras que se repiten en ambos hemisferios. EN CONSTRUCCION.
%     writetable(final, strcat(finalpath, strcat(extractBefore(tables{mindex},'.csv'), '.xls')));
    
        % Agrega los valores T a cada estructura acorde al valor al VoxelTvalue
        for tindex = 1:size(voxtable, 1)
            voxtable.P_value(tindex) = tdist2T(voxtable.VoxelTvalue(tindex), DF);
        end

        % Voxtable contiene la lista de estructuras y sus respectivos hemisferios, valores de activacion y coordenadas.
        writetable(voxtable, strcat(finalpath, strcat(extractBefore(tables{vindex},'.csv'), '.xls')));
    end
end
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');