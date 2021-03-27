% Importa archivos '*.edf' usando el File-IO toolbox de la direccion filepath.
% Renombra el set y el archivo con el DNI del paciente.
% Remueve los espacios en blanco de los eventos de fotoestimulacion.
% Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.            
% Elimina los eventos que no son FE y Ojos abiertos/cerrados.
% Remueve la baseline.  
% Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB).
% Recorta y deja solo la fotoestimulacion + 4 segundos despues.
% Cleanline a 50 Hz.
% Re referencia a un promedio entre A1 y A2.             
% ICA que incluye los canales de EOG (AF9h y AF10h) y excluye EKG para ubicarlos.
% Renombra el archivo si tiene mas o menos eventos de los que deberia y agrega '_revisar eventos' al final.
% Guarda los archivos en la carpeta de nombre guardado en la variable 'target_folder'.  
% NOTA: en el script que agrega el radio cefalico calculo la matriz de transformacion para acomodar los electrodos en DIPFIT,
% como en este tienen todos las mismas coordenadas porque no agrego el radio cefalico dejo la matriz estandar que tiene el
% programa.
% ---------------------------------------------------------------------------------------------------------------------------


% Direccion de los archivos que se quieren procesar.
filepath = 'E:\Investigacion\EEG\NORMALES - CONTROL\EEG';
filepath = strcat(filepath, '\');

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
target_folder = 'TODO\SIN PC FE +4 seg';

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

% Procesar todo: process = 1
% Procesar solo lo listado: process = 0
process = 1;

if process == 1
    % Crea una celda con todos los archivos a procesar dentro del directorio.
    eegs = dir('*.edf');
    eegs = {eegs.name}';
   
elseif process == 0    
    % Nombre de los archivos a procesar y sus perimetros cefalicos(PC).
    % NOTA: Colocar DNIs entre comillas simples y con formato '.edf' al final y agregar PC. 
    % Formato:'DNI.edf' 
    % Ejemplo: '123456.edf

    eegs ={
        '17384808.edf'
        '23267975.edf'
        '26636248.edf'
        '26681314.edf'
        '27065788.edf'
        '27172828.edf'
        '28655843.edf'
        '29136654.edf'
        '29166639.edf'
        '30469404.edf'
        '30900116.edf'
        '30900291.edf'
        '31337569.edf'
        '33387926.edf'
        '34839043.edf'
        '37732120.edf'
        '37732352.edf'
        '39546581.edf'
        '39733285.edf'
        '39736478.edf'
        '40506862.edf'
        '41268250.edf'
        '41440670.edf'
        '42642102.edf'
        '42782803.edf'
        '43143194.edf'
        '44273002.edf'
        '45090150.edf'
        '46374112.edf'
        '95926170.edf'
        '16561154.edf'
        '29253079.edf'
        '30289753.edf'
        '30971218.edf'
        '33700358.edf'
        '35109977.edf'
        '37126067.edf'
        '42637732.edf'
        '33437020.edf'
        '31921461.edf'
        '33029169.edf'
        '45693186.edf'
        '28456579.edf'
        '23021007.edf'
        '44677571.edf'
        '32281962.edf'
        '43143713.edf'
        '18820818.edf'
        '14366775.edf' 
        };
else
    disp('ELEGIR UNA OPCION CORRECTA SOBRE QUÉ ARCHIVOS PROCESAR');
end

% Comentario acerca del set.
comment = ['DNI: %s \n\n', ...
'-Importa archivos EDF usando el File-IO toolbox de la direccion filepath.\n',...
'-Renombra el set y el archivo con el DNI del paciente.\n',...
'-Remueve los espacios en blanco de los eventos de fotoestimulacion.\n',...
'-Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.\n',...         
'-Elimina los eventos que no son FE y Ojos abiertos/cerrados.\n',...
'-Remueve la baseline.\n',...
'-Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB).\n',...
'-Recorta y deja solo la fotoestimulacion + 4 segundos despues.\n',...
'-Cleanline a 50 Hz.\n',...
'-Re referencia a un promedio entre A1 y A2.\n',...             
'-ICA que incluye los canales de EOG (AF9h y AF10h) y excluye EKG para ubicarlos.\n',...
'-Renombra el archivo si tiene mas o menos eventos de los que deberia y agrega _revisar eventos al final\n',...
'-NOTA: en el script que agrega el radio cefalico calculo la matriz de transformacion para acomodar los electrodos en DIPFIT',...
'como en este tienen todos las mismas coordenadas porque no agrego el radio cefalico dejo la matriz estandar que tiene el',...
'programa.'];

% Actualiza la lista de EEGs para procesar
eegs = setdiff(eegs, filename_after_script);
eeglab;

% Itera sobre los archivos a importar.
for index = 1:length(eegs)
    filename = extractBefore(eegs{index}, '.edf');
    try
        % Importa usando la interfaz FILE-IO.
        EEG = pop_fileio(eegs{index}, 'dataformat','auto');
        EEG.setname = filename;
        EEG.comments = sprintf(comment, filename);
        EEG = eeg_checkset( EEG );

        % Elimina los espacios en blanco de las etiquetas de los eventos.
        for l = 1:length(EEG.event)
            EEG.event(l).type = strtrim(EEG.event(l).type);
        end
        EEG = eeg_checkset( EEG );
        
        % Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.
        % NOTA: Revisar que al actualizar el plugin DIPFIT a veces hay que actualizar la direccion del 'lookup', coloca 
        % el radio de la cabeza en base al perimetro cefalico ( PC * 10 / (2 * pi) ).

        EEG = pop_select( EEG, 'nochannel',{'E' 'T1' 'T2' 'X2' 'SpO2' 'EEG Mark1' 'EEG Mark2' 'Events/Markers'});
        EEG = eeg_checkset( EEG );
        EEG = pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc',...
            'changefield',{24 'labels' 'EKG'},'changefield',{24 'type' 'EKG'},'changefield',{22 'labels' 'TP9'},'changefield',...
            {23 'labels' 'TP10'},'changefield',{22 'type' 'EEG'},'changefield',{23 'type' 'EEG'},'changefield',{20 'labels' 'AF9h'},...
            'changefield',{20 'type' 'EOG'},'changefield',{21 'labels' 'AF10h'},'changefield',{21 'type' 'EOG'},'settype',...
            {'1:19' 'EEG'},'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc');
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

        % DIPFIT:incluye los EOG (AF9h y AF10h) para ubicar los componentes en DIPFIT y excluye el canal de EKG.
        EEG = pop_dipfit_settings( EEG, 'hdmfile','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\standard_vol.mat',...
            'coordformat','MNI','mrifile','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\standard_mri.mat',...
            'chanfile','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc',...
            'coord_transform',[0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:21] );
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