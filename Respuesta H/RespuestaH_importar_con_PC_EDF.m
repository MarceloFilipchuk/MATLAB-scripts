% Importa archivos '*.edf' usando el File-IO toolbox de la direccion filepath.
% Renombra el set y el archivo con el DNI del paciente.
% Remueve los espacios en blanco de los eventos de fotoestimulacion.
% Edita los canales y define el radio cefalico del paciente.            
% Elimina los eventos que no son FE y Ojos abiertos/cerrados.
% Remueve la baseline.  
% Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB).
% Recorta y deja solo la fotoestimulacion + 4 segundos despues.
% Cleanline a 50 Hz.
% Renombra el archivo si tiene mas o menos eventos de los que deberia y agrega '_revisar eventos' al final.
% Re referencia a un promedio entre A1 y A2.             
% Crea una matriz de transformacion para acomodar los electrodos al modelo de DIPFIT.
% ICA que incluye los canales de EOG (AF9h y AF10h) y excluye EKG para ubicarlos.
% Guarda los archivos en la carpeta de nombre guardado en la variable 'target_folder'.          
% -------------------------------------------------------------------------


% Direccion de los archivos que se quieren procesar.
filepath = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG';
filepath = strcat(filepath, '\');

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
target_folder = 'TODO\CON PC FE +4 seg';

% Direccion de la carpeta donde se guardan los archivos post script.
target_path = strcat(filepath, target_folder, '\');
if ~exist(target_path,'dir')
    mkdir(target_path);
end

% Cambia el directorio a la carpeta donde estan los archivos ya procesados.
cd(target_path);

% Crea una celda con los archivos que ya se encuentran en el directorio donde se guardan los archivos procesado, para evitar
% procesarlos si ya lo fueron.
filename_after_script = dir('*.set');
filename_after_script = {filename_after_script.name}';
for rindex = 1:length(filename_after_script)
    if length(filename_after_script{rindex}) > 12
        filename_after_script{rindex} = strcat(extractBefore(filename_after_script{rindex}, '_Revisar'), '.edf');
    else
        filename_after_script{rindex} = strcat(extractBefore(filename_after_script{rindex}, '.set'), '.edf');
    end
end

% Cambia el directorio a la carpeta donde estan los archivos a procesar.
cd(filepath);

% Nombre de los archivos a procesar y sus perimetros cefalicos(PC).
% NOTA: Colocar DNIs entre comillas simples y con formato '.edf' al final y agregar PC. 
% Formato:{'DNI.edf' PC} 
% Ejemplo: {'123456.edf' 55}

eegs ={
    
{ '17384808.edf' 55 1.1 '' }
{ '23267975.edf' 52 1.1 '' }
{ '24196666.edf' 56 8.2 '' }
{ '24629394.edf' 55 1.3 '' }
{ '25921670.edf' 56 1.3 '' }
{ '26636248.edf' 57 1.1 '' }
{ '26681314.edf' 58 1.1 '' }
{ '27065788.edf' 57 1.1 '' }
{ '27172828.edf' 56 1.1 '' }
{ '28357169.edf' 57 8.2 '' }
{ '29136654.edf' 54 1.2 '' }
{ '29166639.edf' 55 1.1 '' }
{ '30469404.edf' 55 1.2 '' }
{ '30900116.edf' 59 1.1 '' }
{ '30900291.edf' 56.5 1.1 '' }
{ '31337569.edf' 54 1.1 '' }
{ '34839043.edf' 56 1.1 '' }
{ '37732120.edf' 59  '' }
{ '37732352.edf' 57 1.2 '' }
{ '39546581.edf' 59 1.1 '' }
{ '39733285.edf' 55 1.1 '' }
{ '40506862.edf' 49 1.1 '' }
{ '41268250.edf' 50 1.1 '' }
{ '41440670.edf' 52 1.2 '' }
{ '42642102.edf' 53 1.1 '' }
{ '42782803.edf' 54 1.1 '' }
{ '45090150.edf' 56 1.2 '' }
{ '46374112.edf' 55 1.1 '' }
{ '16561154.edf' 52 1.1 '' }
{ '29253079.edf' 55 1.1 '' }
{ '30122613.edf' 56 8.2 '' }
{ '30289753.edf' 52 1.1 '' }
{ '30971218.edf' 54 1.1 '' }
{ '33700358.edf' 59 8.2 '' }
{ '35109977.edf' 52 1.1 '' }
{ '37126067.edf' 54 1.2 '' }
{ '29275688.edf' 55 1.3 '' }
{ '24671814.edf' 54 1.3 '' }
{ '43673629.edf' 54 1.3 '' }
{ '42637732.edf' 57 1.2 '' }
{ '33437020.edf' 54 1.1 '' }
{ '31921461.edf' 56 1.1 '' }
{ '36428905.edf' 54 8.2 '' }
{ '32238623.edf' 54 8.2 '' }
{ '22672559.edf' 56 8.2 '' }
{ '33029169.edf' 58 1.2 '' }
{ '45693186.edf' 56 1.2 '' }
{ '17004849.edf' 53 8.2 '' }
{ '28456579.edf' 58 1.2 '' }
{ '28859146.edf' 55 8.2 '' }
{ '38329607.edf' 54 8.2 '' }
{ '23021007.edf' 56 1.1 '' }
{ '44677571.edf' 57 1.1 '' }
{ '32281962.edf' 54 1.2 '' }
{ '26089010.edf' 57 1.3 '' }
{ '23231229.edf' 56 8.2 '' }
{ '18820818.edf' 56 1.1 '' }
{ '21628054.edf' 56 1.2 '' }
    };

% Comentario acerca del set.
comment = ['DNI: %s Perimetro cefalico: %.2f Radio cefalico: %e\n\n', ...
'-Importa archivos EDF usando el File-IO toolbox de la direccion filepath.\n',...
'-Renombra el set y el archivo con el DNI del paciente.\n',...
'-Remueve los espacios en blanco de los eventos de fotoestimulacion.\n',...
'-Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.\n',...         
'-Define el radio cefalico del paciente.\n',...
'-Elimina los eventos que no son FE y Ojos abiertos/cerrados.\n',...
'-Remueve la baseline.\n',...
'-Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB).\n',...
'-Recorta y deja solo la fotoestimulacion + 4 segundos despues.\n',...
'-Cleanline a 50 Hz.\n',...
'-Re referencia a un promedio entre A1 y A2.\n',... 
'-ICA que incluye los canales de EOG (AF9h y AF10h) y excluye EKG para ubicarlos.',...
' Crea una matriz de transformacion para acomodar los electrodos al modelo de DIPFIT.\n',...
'-Renombra el archivo si tiene mas o menos eventos de los que deberia y agrega _revisar eventos al final.'];

% Actualiza la lista de EEGs para procesar
eegs = setdiff(eegs, filename_after_script);

eeglab;

% Guarda un struct de todos los canales con sus etiquetas y coordenadas para despues usar en el DIPFIT a la hora de hacer la 
% matriz de transformacion para ubicar espacialmente los componentes.
% NOTA: Revisar esta parte despues de cada actualizacion de DIPFIT
reflocs = readlocs('E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc');

for index = 1:length(eegs)
    filename = extractBefore(eegs{index}{1}, '.edf');
    try
        % Importa usando la interfaz FILE-IO.
        EEG = pop_fileio(eegs{index}{1}, 'dataformat','auto');
        EEG.setname = filename;
        EEG.comments = sprintf(comment, filename, eegs{index}{2}, (eegs{index}{2}*10 / (2 * pi)));
        EEG = eeg_checkset( EEG );

        % Elimina los espacios en blanco de las etiquetas de los eventos.
        for l = 1:length(EEG.event)
            EEG.event(l).type = strtrim(EEG.event(l).type);
        end
        EEG = eeg_checkset( EEG );

        % Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.
        % Coloca el radio de la cabeza en base al perimetro cefalico ( PC * 10 / (2 * pi) ).
        % NOTA: Revisar que al actualizar el plugin DIPFIT a veces hay que actualizar la direccion del 'lookup', coloca 
        % el radio de la cabeza en base al perimetro cefalico ( PC * 10 / (2 * pi) ).
        EEG = pop_select( EEG, 'nochannel',{'E' 'T1' 'T2' 'X2' 'SpO2' 'EEG Mark1' 'EEG Mark2' 'Events/Markers'});
        EEG = eeg_checkset( EEG );
        EEG = pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc',...
            'changefield',{24 'labels' 'EKG'},'changefield',{24 'type' 'EKG'},'changefield',{22 'labels' 'TP9'},'changefield',...
            {23 'labels' 'TP10'},'changefield',{22 'type' 'EEG'},'changefield',{23 'type' 'EEG'},'changefield',{20 'labels' 'AF9h'},...
            'changefield',{20 'type' 'EOG'},'changefield',{21 'labels' 'AF10h'},'changefield',{21 'type' 'EOG'},'settype',...
            {'1:19' 'EEG'},'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc');
        EEG = pop_chanedit(EEG, 'changefield',{1 'sph_radius' eegs{index}{2}*10 / (2 * pi)});
        EEG = eeg_checkset( EEG );

        % Elimina los eventos que no son FE y Ojos abiertos/cerrados.
        EEG = pop_selectevent( EEG, 'type',{'Ojos abiertos' 'Ojos cerrados' 'PHOTO 10Hz' 'PHOTO 12Hz' 'PHOTO 14Hz'...
            'PHOTO 16Hz' 'PHOTO 18Hz' 'PHOTO 20Hz' 'PHOTO 22Hz' 'PHOTO 24Hz' 'PHOTO 6Hz' 'PHOTO 8Hz'},'deleteevents','on');
        EEG = eeg_checkset( EEG );

        % Remueve la baseline.
        EEG = pop_rmbase( EEG, [],[]);
        EEG = eeg_checkset( EEG );

        % Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB.
        EEG = pop_eegfiltnew(EEG, 'locutoff',1); 
        EEG = eeg_checkset( EEG );

        % Recorta y deja solo la fotoestimulacion.
        EEG = pop_rmdat( EEG, {'PHOTO 6Hz'},[0 104] ,0);
        EEG = eeg_checkset( EEG );

        % Cleanline a 50 Hz (la longitud del EEG tiene que ser divisible por la ventana elegida para que limpie todo). 
        EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan] ,'computepower',1,'linefreqs',50,'normSpectrum',...
            0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',2,...
            'winstep',2);
        EEG = eeg_checkset( EEG );

        % Re referencia a un promedio entre A1 y A2.
        EEG = pop_reref(EEG, [22 23], 'exclude', find(strcmp({EEG.chanlocs(:).labels}, 'EKG')));
        EEG = eeg_checkset(EEG);

        % ICA.
        EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1); 
        EEG = eeg_checkset( EEG );          

        % Calcula la matriz de transformacion para acomodar cada cabeza al modelo DIPFIT.
        [chanlocs_out, transform] = coregister(EEG.chanlocs, reflocs, 'chaninfo1', EEG.chaninfo, 'warp', 'auto',...
            'manual', 'off');
        % DIPFIT:incluye los EOG (AF9h y AF10h) para ubicar los componentes en DIPFIT y excluye el canal de EKG.
        EEG = pop_dipfit_settings( EEG, 'hdmfile','C:\\Program Files\\Polyspace\\R2019b\\bin\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\standard_vol.mat',...
            'coordformat','MNI','mrifile','C:\\Program Files\\Polyspace\\R2019b\\bin\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\standard_mri.mat',...
            'chanfile','C:\\Program Files\\Polyspace\\R2019b\\bin\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc',...
            'coord_transform', transform,'chansel', find(~strcmp({EEG.chanlocs(:).labels},'EKG')) );
        EEG = eeg_checkset( EEG );
        EEG = pop_multifit(EEG, [1:EEG.nbchan],'threshold',100,'plotopt',{'normlen' 'on'});
        EEG = eeg_checkset( EEG );

        % Si los eventos no son 11 (1 boundary y 10 de fotoestimulacion, renombra agregando '_RevisarEventos'.
        if length(EEG.event) ~= 11
            filename = strcat(filename, '_RevisarEventos');
        end

        % Guarda el EEG.
        EEG = pop_saveset( EEG, 'filename', filename ,'filepath', target_path);

    catch ME
        warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
        continue
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');