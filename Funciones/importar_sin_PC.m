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


function importar_sin_PC (eegs, filepath ,target_folder)
    
    % Direccion de la carpeta donde se guardan los archivos post script.
    target_path = strcat(filepath, target_folder, '\');
    if ~exist(target_path,'dir')
        mkdir(target_path);
    end

    % Cambia el directorio a la carpeta donde estan los archivos ya procesados.
    cd(target_path);

    % Crea un array con los archivos que ya se encuentran en el directorio donde se guardan los archivos procesado, para evitar
    % procesarlos si ya lo fueron.
    filename_after_script = dir('*.set');
    filename_after_script = {filename_after_script.name}';
    
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

    if ~ismember(filename, filename_after_script)
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
        EEG = pop_chanedit(EEG, 'changefield',{21 'labels' 'AF9h'},'changefield',{21 'type' 'EOG'},'changefield',...
        {22 'labels' 'AF10h'},'changefield',{22 'type' 'EOG'},'changefield',{23 'labels' 'TP9'},'changefield',...
        {24 'labels' 'TP10'},'changefield',{27 'labels' 'EKG'},'changefield',{27 'type' 'EKG'},'changefield',...
        {25 'type' 'EEG'},'changefield',{25 'type' ''},'changefield',{23 'type' 'EEG'},'changefield',...
        {24 'type' 'EEG'},'changefield',{30 'labels' 'EEGMark1'},'changefield',{31 'labels' 'EEGMark2'},'settype',...
        {'1:19' 'EEG'},'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc');
        EEG = eeg_checkset( EEG );
        EEG = pop_select( EEG, 'nochannel',{'E' 'T1' 'T2' 'X2' 'SpO2' 'EEGMark1' 'EEGMark2' 'Events/Markers'});
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
        EEG = pop_reref( EEG, [22 23], 'exclude',24 );
        EEG = eeg_checkset( EEG );

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
    end
end
        
        