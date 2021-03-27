% Recorta todas las frecuencias de fotoestimulacion para que tenga igual duracion (9.5 segundos)
% ---------------------------------------------------------------------------------------------------------------------------


% Direccion de los archivos que se quieren procesar.
filepath = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG\TODO\CON PC FE +4 seg\Limpios por ICA';
filepath = strcat(filepath, '\');

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
target_path = 'Fotoestimulacion igualada';

% Direccion de la carpeta donde se guardan los archivos post script.
target_path = strcat(filepath, target_path, '\');
if ~exist(target_path, 'dir')
    mkdir(target_path);
end

% Cambia el directorio a la carpeta donde estan los archivos ya procesados.
cd(target_path);

% Crea un array con los archivos que ya se encuentran en el directorio donde se guardan los archivos procesado, para evitar
% procesarlos si ya lo fueron.
filename_after_script = dir('*.set');
filename_after_script = {filename_after_script.name}';

% Cambia el directorio a la carpeta donde estan los archivos a procesar.
cd(filepath);

% Crea una celda con todos los archivos a procesar dentro del directorio.
eegs = dir('*.set');
eegs = {eegs.name}';

eeglab;

% Itera sobre los archivos a procesar
for index = 1:length(eegs)
    if ~ismember(eegs{index}, filename_after_script)
        try
            EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath); 

            EEG = pop_rmdat( EEG, {'PHOTO 10Hz' 'PHOTO 12Hz' 'PHOTO 14Hz' 'PHOTO 16Hz' 'PHOTO 18Hz' 'PHOTO 20Hz' 'PHOTO 22Hz' 'PHOTO 24Hz' 'PHOTO 6Hz' 'PHOTO 8Hz'},[0 9.5] ,0);

            EEG = pop_saveset( EEG, 'filename', eegs{index} ,'filepath', target_path);
        catch ME
            warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
            continue
        end
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');