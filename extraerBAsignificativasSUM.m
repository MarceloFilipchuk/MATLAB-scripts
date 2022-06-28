filepath = {
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test Subject-wise\T-test Subject-wise VOXELS\Cronicos vs Controles\LORETA Voxels';
% 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test Subject-wise\T-test Subject-wise VOXELS\Cronicos vs Ictales\LORETA Voxels';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test Subject-wise\T-test Subject-wise VOXELS\Ictales vs Controles\LORETA Voxels';
% 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test Subject-wise\T-test Subject-wise VOXELS\Ictales vs Interictales\LORETA Voxels';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test Subject-wise\T-test Subject-wise VOXELS\Interictales vs Controles\LORETA Voxels';
};

sigfinal = {}; % BORRAR
% Itera sobre cada directorio.
for findex = 1:length(filepath)
    
    % Crea una lista de las tablas dentro de la carpeta.
    cd(filepath{findex})
    tables = dir('*.xls');
    tables = {tables.name}';
    
    % Itera sobre cada tabla.
    sig = {}; % Va a contener todas las zonas significativas de cada test a lo largo de todas las bandas.
    for tindex = 1:length(tables)
        
        voxtable = readtable(strcat(filepath{findex},'\', tables{tindex}), 'PreserveVariableNames', 1);
        voxtable.Properties.VariableNames{5} = 'Brodmann_area';
        tmp = {}; % Contiene zonas sigificativas a lo largo de cada banda.
        tmpcounter = 1;
            
        if ~isempty(voxtable)
            voxtable = voxtable(cellfun(@isempty, strfind(voxtable.Hemisphere, 'Inter-Hemispheric')), :);
            
            % Itera sobre cada linea de la tabla.
            for vindex = 1:size(voxtable, 1)
                if voxtable.P_value(vindex) < 0.05
                    tmp{tmpcounter, 1} = strcat(voxtable.Hemisphere{vindex},' - ', 'BA', num2str(voxtable.Brodmann_area(vindex))); % extractAfter(voxtable.Structure{vindex}, ' - ');
                    tmpcounter = tmpcounter + 1;
                end
            end
            tmp = unique(tmp);
            sigfinal = vertcat(tmp, sigfinal);
            sig = vertcat(tmp, sig);
        end
    end
    
    sig = sig(~cellfun('isempty',sig));
    [uniquesig, ~, c] = unique(sig); % Elimina valores repetidos dentro de 'sig'.
    quantities = hist(c, length(uniquesig));
    quantities = quantities';
    uniquesig(:,2) = num2cell(quantities);
    uniquesig = sortrows(uniquesig, 2, 'descend'); %  La segunda columna contiene las cantidades.
    
    % Define cada tabla final.
    name = extractBetween(filepath{findex},'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test Subject-wise\T-test Subject-wise VOXELS\',...
        '\LORETA Voxels');
    switch name{1}
        case 'Interictales vs Controles'
            InterictVsCont = uniquesig;
        case 'Ictales vs Controles'
            IctVsCont = uniquesig;
        case 'Cronicos vs Controles'
            CronVsCont = uniquesig;
    end
end

sigfinal = sigfinal(~cellfun('isempty',sigfinal));% BORRAR
uniquesigfinal = unique(sigfinal);
uniquesigfinal(:,2) = num2cell(zeros(size(uniquesigfinal, 1),1));
% Itera sobre la listas de los unicos (que se yo, estoy re loco)
for index = 1:length(uniquesigfinal) % Itera sobre el unico original
    counter = 0;
    for sindex = 1:length(sigfinal) % Itera sobre la lista con multiples clones
        if strcmp(uniquesigfinal(index,1), sigfinal(sindex,1)) % Si son iguales, se suman
           counter = counter + 1;
           uniquesigfinal(index,2) = num2cell(counter);
        end
    end
end
uniquesigfinal = sortrows(uniquesigfinal, 2, 'descend');
writecell(uniquesigfinal, 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test Subject-wise\T-test Subject-wise VOXELS\BA significativas sumadas.xls');    

finalhdr = {'Interictales Vs Controles', '', 'Ictales Vs Controles', '', 'Cronicos Vs Controles', ''};
tmpfinal = {CronVsCont, IctVsCont, InterictVsCont};
maxsize = max(cellfun('size', tmpfinal, 1));
final = strings(maxsize, 6);
for index = 1:size(InterictVsCont,1)
    final(index, 1:2) = InterictVsCont(index, 1:2);
end
for index = 1:size(IctVsCont,1)
    final(index, 3:4) = IctVsCont(index, 1:2);
end
for index = 1:size(CronVsCont,1)
    final(index, 5:6) = CronVsCont(index, 1:2);
end
final = vertcat(finalhdr, final);

writematrix(final, 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test Subject-wise\T-test Subject-wise VOXELS\BA significativas.xls');

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');