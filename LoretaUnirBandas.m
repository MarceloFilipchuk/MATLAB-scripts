% Promedia LORETAs en formato '.*txt'. 
% Filas = voxeles (6239), columnas = TFs o Freqs.

% Directorio madre.
filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Seed-to-whole brain Connectivity Maps BA25 Completa y Bilateral por Bandas\TXT2CONN por bandas Promediado';
filepath = strcat(filepath, '\');

% Patron de string para eliminar del nombre de las carpetas para cada paciente.
strtemplate = '-LagPartialConnSeeded(roisXfreq)-slorTransposed';

% Lista de cada BANDA. IMPORTANTE: colocar en el orden deseado, de arriba hacia abajo.
bandlist = {
'Delta'; 
'Theta'; 
'Alpha'; 
'Beta'; 
'Gamma';
};
sz3 = size(bandlist, 1);

% Crea lista de carpetas que contienen todos los archivos de cada GRUPO.
cd(filepath);
tmpfolders = dir(filepath);
tmpfolders = tmpfolders(3:end);
sz1 = size(tmpfolders, 1); % Numero de grupos.
folders = cell(1, sz1);
for findex = 1:sz1
    folders{findex} = strcat(tmpfolders(findex).folder, '\', tmpfolders(findex).name);
end
folders = folders'; 

% Itera sobre cada carpeta que contiene a los grupos (dentro de las cuales estan las bandas. Promedia cada txt en una sola
% columna.
for index = 1:sz1 
    % Itera sobre cada BANDA.
    for index2 = 1:sz3
        % Crea lista de '*.txt' dentro del directorio.
        tmplist = dir(strcat(folders{index},'\', bandlist{index2},'\**\*.txt'));
        sz2 = size(tmplist, 1); % Numero de pacientes.
        list = cell(1, sz2);
        for dindex = 1:sz2
            list{dindex} = strcat(tmplist(dindex).folder, '\', tmplist(dindex).name);
        end
        list = list';

        % Itera sobre cada '*.txt' y promedia todas las columnas en una sola.
        for index3 = 1:sz2
            tmp = readmatrix(list{index3});
            tmp = mean(tmp, 2);
            writematrix(tmp, list{index3})
        end
    end
end

% Itera sobre cada carpeta de cada grupo para juntar cada '*.txt' (de las distintas bandas por cada paciente) en una sola carpeta
% por paciente.
for index = 1:sz1 % Itera sobre cada GRUPO
    cd(strcat(folders{index}, '\'));
    tmp_patient_list = dir('**\*.txt');
    tmp_patient_list = {tmp_patient_list.name}';
    tmp_patient_list = unique(tmp_patient_list);
    
    finaldir = strcat(folders{index}, '\AllFreqs\');
    
    if ~exist(finaldir, 'dir')
        mkdir(finaldir);
    end
    % Itera sobre cada PACIENTE.
    for index2 = 1:size(tmp_patient_list, 1)
        tmpfile = zeros(6239, sz3); % Inicializa la matriz de cada paciente
        
        % Directorio donde van a estar los 5 mapas de CADA PACIENTE.
        ptedir = strcat(finaldir, extractBefore(tmp_patient_list{index2}, strtemplate));
        if ~exist(ptedir, 'dir')
            mkdir(ptedir);
        end
        
        % Itera sobre cada BANDA.
        for index3 = 1:sz3 
            % Direccion del PACIENTE en la BANDA actual
            tmpfiledir = strcat(folders{index}, '\', bandlist{index3}, '\', tmp_patient_list{index2});
            tmp = readmatrix(tmpfiledir);
            writematrix(tmp, strcat(ptedir, '\', extractBefore(tmp_patient_list{index2}, strtemplate), '-', num2str(index3), '-', bandlist{index3},'.txt'));
%             tmpfile(:, index3) = tmp(:);
        end
        
%         writematrix(tmpfile, strcat(finaldir, tmp_patient_list{index2}));
    end
end

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');