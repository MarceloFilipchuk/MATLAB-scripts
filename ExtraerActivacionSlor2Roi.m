% filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Activacion Slor2RoI\Controles';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Activacion Slor2RoI\Cronicos';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Activacion Slor2RoI\Migrañosos\Ictales';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Activacion Slor2RoI\Migrañosos\Interictales';

rows = ["Delta";"Theta";"Alpha";"Beta";"Gamma";];
cols = ["", "BA25", "BA31", "BA40", "L-BA07", "R-BA20", "R-BA34"];

cd(filepath)
tmpslors = dir('*-sLorRoiSubjW.txt');
sz = size(tmpslors,1);
slors = cell(sz,1);

for index = 1:sz
    slors{index} = strcat(tmpslors(index).folder, '\', tmpslors(index).name);
end

tmpcell = zeros(5,6,sz);

for index = 1:size(slors,1)
    tmpcell(:,:,index) = readmatrix(slors{index});
end
tmpcell = mean(tmpcell,3);
% Agrega bandas.
final = horzcat(rows, tmpcell);
% Agrega ROIs.
final = vertcat(cols, final);
writematrix(final, strcat(filepath, '\', 'Slor2Rois.xls'));

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');