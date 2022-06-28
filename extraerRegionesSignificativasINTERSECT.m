filepath = {
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Cronicos vs Controles\LORETA Voxels';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Cronicos vs Ictales\LORETA Voxels';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Ictales vs Controles\LORETA Voxels';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Ictales vs Interictales\LORETA Voxels';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\Interictales vs Controles\LORETA Voxels';
};

% Itera sobre cada directorio.
for findex = 1:length(filepath)
    
    % Crea una lista de las tablas dentro de la carpeta.
    cd(filepath{findex})
    tables = dir('*.xls');
    tables = {tables.name}';
    
    % Itera sobre cada tabla.
    counter = 1;
    sig = {}; % Va a contener todas las zonas significativas de cada test a lo largo de todas las bandas.
    for tindex = 1:length(tables)
        voxtable = readtable(strcat(filepath{findex},'\', tables{tindex}), 'PreserveVariableNames', 1);
        
        % Itera sobre cada linea de la tabla.
        for vindex = 1:size(voxtable, 1)
            if voxtable.P_value(vindex) < 0.05
                sig{counter, 1} = extractAfter(voxtable.Structure{vindex}, ' - ');
                counter = counter + 1;
            end
        end
    end
    
    sig = sig(~cellfun('isempty',sig));
    sig = unique(sig);
    
    % Define cada tabla final.
    name = extractBetween(filepath{findex},'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\T-test on Log transf Subject-wise - VOXELS\',...
        '\LORETA Voxels');
    switch name{1}
        case 'Cronicos vs Controles'
            CronVsCont = sig;
        case 'Cronicos vs Ictales'
            CronVsIct = sig;
        case 'Ictales vs Controles'
            IctVsCont = sig;
        case 'Ictales vs Interictales'
            IctVsInterict = sig;
        case 'Interictales vs Controles'
            InterictVsCont = sig;
    end
end

% Final contiene resultados que estan presentes en TODOS los test simultaneamente.
% final = intersect(CronVsCont, CronVsIct);
% final = intersect(final, IctVsCont);
% final = intersect(final, IctVsInterict);
% final = intersect(final, InterictVsCont);

% Final contiene resultados que estan presentes en SOLAMENTE VS CONTROLES los test simultaneamente.
final = intersect(InterictVsCont, IctVsCont);
final = intersect(final, CronVsCont);





cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');