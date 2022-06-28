% Directorio del trabajo (donde se guarda el archivo final)
workdir = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS';
workdir = strcat(workdir, '\');

% Directorios que se revisan 
filepath = {
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Interictales vs Controles\LORETA Voxels';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Ictales vs Controles\LORETA Voxels';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Cronicos vs Controles\LORETA Voxels';
};

final = {};
sigfinal = {};
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
    name = extractBetween(filepath{findex}, workdir,...
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

% Final contiene resultados que estan presentes en TODOS los test simultaneamente.
final = intersect(InterictVsCont(:,1), IctVsCont(:,1));
final = intersect(final, CronVsCont(:,1));

writecell(final, strcat(workdir, 'BA significativas INTERSECT.xls'));

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');