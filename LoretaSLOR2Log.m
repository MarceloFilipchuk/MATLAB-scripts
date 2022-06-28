% Abre archivos de LORETA en formato *.txt y aplica el logaritmo natural (Log e) de cada valor.
% Luego vuelve a guardar en formato *.txt.

% Directorio MADRE (que contiene todas las carpetas y subcarpetas con los archivos finales).
filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Seed-to-whole brain Connectivity Maps\4.2 -CONN2TXT2Log separado por Bandas RIGHT';
filepath = strcat(filepath, '\');

% Crea lista de archivos a procesar dentro del directorio madre (*.txt).
cd(filepath)
tmplist = dir('**/*.txt'); % Lista temporal.
list_sz = size(tmplist, 1); % Numero de archivos a procesar dentro de la lista. Ambas tienen el mismo tamaño en filas.
list = cell(list_sz, 1); % Lista final con la direccion final de cada archivo en cada celda.

% Crea la lista final.
for lindex = 1: list_sz
    list{lindex} = strcat(tmplist(lindex).folder, '\', tmplist(lindex).name);
end

% Itera sobre cada texto dentro de la lista.
for index = 1:list_sz
    % Abre el *.txt de LORETA.
    tmp = readmatrix(list{index});
    tmp = tmp(:,3); % Corrige porque las 2 primeras columnas que exporta LORETA son NaN.

    % Logaritmo en base 'e' de cada valor que no sea cero.
    tmp(tmp ~= 0) = log(tmp(tmp ~= 0));

    % Vuelve a guardar el texto dentro de la MISMA CARPETA.
    writematrix(tmp, list{index});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Patron de string para eliminar del nombre de las carpetas para cada paciente.
strtemplate = '-LagPartialConnSeeded(roisXfreq)-slorTransposed';

% Crea lista de carpetas que contienen todos los archivos de cada GRUPO.
cd(filepath);
tmpfolders = dir(filepath);
tmpfolders = tmpfolders(3:end);
sz1 = size(tmpfolders, 1); % Numero de carpetas de grupos.
folders = cell(1, sz1);
for findex = 1:sz1
    folders{findex} = strcat(tmpfolders(findex).folder, '\', tmpfolders(findex).name);
end
folders = folders'; 

% Lista de cada BANDA. 1 carpeta por banda. IMPORTANTE: colocar en el orden deseado, de arriba hacia abajo.
bandlist = {
'Delta'; 
'Theta'; 
'Alpha'; 
'Beta'; 
'Gamma';
};
sz3 = size(bandlist, 1);


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
        end
    end
end

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');