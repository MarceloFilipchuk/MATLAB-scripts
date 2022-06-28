% Directorio del trabajo (donde se guarda el archivo final)
workdir = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\T-test on Log transf Subject-wise\buscar ROIS intersect';
workdir = strcat(workdir, '\');

cd(workdir)
tmplist = dir('**\*\*.xls');
len = size(tmplist, 1);
list = cell(len, 1);
for index = 1:len
    list{index} = strcat(tmplist(index).folder, '\', tmplist(index).name);
end

buscar = {
'L -BA25'
'L -BA31'
'L -BA40'
'L -BA7'
'R -BA20'
'R -BA25'
'R -BA31'
'R -BA34'
'R -BA40'
};

for index = 1:size(list, 1)
    tmptable = readtable(list{index});
    if size(tmptable, 1) ~= 0
        tmptable = removevars(tmptable, {'VoxelTvalue','X_MNI','Y_MNI','Z_MNI','Lobe','Structure'});
        tmptable = table2cell(tmptable);
        for index1 = 1:size(tmptable, 1)
            tmptable{index1, 4} = strcat( tmptable{index1, 2}, ' -BA', num2str(tmptable{index1, 1}) );
        end
        tmpindex = [tmptable{:,3}] < 0.05;
        finaltable = {tmptable{tmpindex, 4}}';
        final = intersect(finaltable, buscar);
        if size(final, 1) ~= 0
            writecell(final, strcat(extractBefore(tmplist(index).folder, '\LORETA Voxels'), '\',tmplist(index).name));
        end
    end
    
    
end
