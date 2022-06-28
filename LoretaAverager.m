% Promedia LORETAs en formato '.*txt'. 
% Filas = voxeles (6239), columnas = TFs o Freqs.

% Directorio madre.
filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Seed-to-whole brain Connectivity Maps BA25 Completa y Bilateral por Bandas\SLOR por bandas Promediado';
filepath = strcat(filepath, '\');

% Crea lista de '*.txt' dentro del directorio.
cd(filepath);
tmplist = dir(strcat(filepath, '**\*.txt'));
sz = size(tmplist, 1);
list = cell(1, sz);
for dindex = 1:sz
    list{dindex} = strcat(tmplist(dindex).folder, '\', tmplist(dindex).name);
end
list = list';

% Itera sobre cada '*.txt' y promedia todas las columnas en una sola.
for index = 1:sz
    tmp = readmatrix(list{index});
    tmp = mean(tmp, 2);
    writematrix(tmp, list{index})
end

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');