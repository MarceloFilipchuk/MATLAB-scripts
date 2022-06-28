% Direccion de los archivos que se quieren procesar.
filepath = 'E:\Investigacion\EEG\NORMALES - CONTROL\RESPUESTA H\EEG'; % 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG';  % 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\REVISAR Dx PRIMERO!!!!!'; % 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG';
filepath = strcat(filepath, '\');

% Direccion de la carpeta donde se guardan los archivos post script.
target_path = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG';
target_path = strcat(target_path, '\');
if ~exist(target_path,'dir')
    mkdir(target_path);
end

% Nombre de la carpeta con los EEGs ya limpios.
target_folder_clean = 'Controles';

% Direccion donde estan los EEGs ya limpios.
target_path = strcat(target_path, target_folder_clean, '\');
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
    filename_after_script{rindex} = strcat(extractBefore(filename_after_script{rindex}, '.set'), '.edf');
end

% Lista de archivos a importar con sus datos.
% Nombre de los archivos a procesar y sus perimetros cefalicos(PC).
% NOTA: Colocar DNIs entre comillas simples y con formato '.edf' al final y agregar PC. 
% Formato:{'DNI.edf' Edad Sexo PC Dx CicloMigraña
% Ejemplo: {'123456.edf 35 'F' 55 '1.2' 'ICTAL'}
eegs ={
% { '44677571.edf' 14 'F' 57 '1.1' 'Interictal' }
% { '46374112.edf' 14 'F' 55 '1.1' 'Interictal' }
% { '45487927.edf' 16 'F' 58 '1.1' 'Interictal' }
% { '43926390.edf' 19 'F' 54 '1.1' 'Interictal' }
% { '42642102.edf' 20 'F' 53 '1.1' 'Interictal' }
% { '39546581.edf' 24 'F' 59 '1.1' 'Interictal' }
% { '34839043.edf' 30 'F' 56 '1.1' 'Interictal' }
% { '35064083.edf' 30 'F' 52 '1.1' 'Interictal' }
% { '33700358.edf' 32 'M' 59 '1.1' 'Interictal' }
% { '31921461.edf' 34 'F' 56 '1.1' 'Interictal' }
% { '31337569.edf' 35 'F' 54 '1.1' 'Interictal' }
% { '29712356-2.edf' 37 'F' 51 '1.1' 'Interictal' }
% { '29154320.edf' 38 'F' NaN '1.1' 'Interictal' }
% { '24671814.edf' 45 'F' 54 '1.1' 'Interictal' }
% { '16561154.edf' 55 'F' 52 '1.1' 'Interictal' }
% { '45693186.edf' 16 'F' 56 '1.2' 'Interictal' }
% { '43143713.edf' 19 'F' NaN '1.2' 'Interictal' }
% { '41440670.edf' 21 'F' 52 '1.2' 'Interictal' }
% { '36142459.edf' 28 'F' 54 '1.2' 'Interictal' }
% { '35915823.edf' 29 'F' 54 '1.2' 'Interictal' }
% { '34989974.edf' 31 'F' 53 '1.2' 'Interictal' }
% { '32281962.edf' 34 'F' 54 '1.2' 'Interictal' }
% { '31058058.edf' 36 'F' 56 '1.2' 'Interictal' }
% { '29275688.edf' 38 'M' 55 '1.2' 'Interictal' }
% { '28456579.edf' 39 'F' 58 '1.2' 'Interictal' }
% { '45090150.edf' 16 'F' 56 '1.1' 'Ictal' }
% { '43143194.edf' 19 'F' 58 '1.1' 'Ictal' }
% { '40506862.edf' 21 'F' 49 '1.1' 'Ictal' }
% { '39693608.edf' 24 'F' 56 '1.1' 'Ictal' }
% { '39073136.edf' 26 'F' 55 '1.1' 'Ictal' }
% { '33437020.edf' 32 'F' 54 '1.1' 'Ictal' }
% { '95760930.edf' 35 'F' 55 '1.1' 'Ictal' }
% { '45936466.edf' 16 'M' 54 '1.1' 'Ictal' }
% { '41680083.edf' 21 'M' 55 '1.1' 'Ictal' }
% { '33437628.edf' 32 'M' 58 '1.1' 'Ictal' }
% { '26790006.edf' 42 'M' 58 '1.1' 'Ictal' }
% { '44273002.edf' 17 'F' NaN '1.2' 'Ictal' }
% { '40026470.edf' 23 'F' 58 '1.1' 'Ictal' }
% { '37107273.edf' 27 'F' NaN '1.2' 'Ictal' }
% { '37732352.edf' 27 'F' 57 '1.2' 'Ictal' }
% { '95926170.edf' 30 'F' NaN '1.2' 'Ictal' }
% { '33029169.edf' 33 'F' 58 '1.2' 'Ictal' }
% { '30469404.edf' 36 'F' 55 '1.2' 'Ictal' }
% { '30971218.edf' 36 'F' 54 '1.2' 'Ictal' }
% { '28655843.edf' 39 'F' 56 '1.2' 'Ictal' }
% { '25921670.edf' 42 'F' 56 '1.2' 'Ictal' }
% { '29136654.edf' 48 'F' 54 '1.2' 'Ictal' }
% { '21628054.edf' 50 'F' 56 '1.2' 'Ictal' }
% { '42783515.edf' 56 'F' 20 '1.2' 'Ictal' }
% { '13153801.edf' 61 'F' 55 '1.2' 'Ictal' }
% { '44475407.edf' 17 'F' 55 'Healthy volunteer' '' }
% { '43229539.edf' 19 'F' 60 'Healthy volunteer' '' }
% { '42915383.edf' 19 'F' 55 'Healthy volunteer' '' }
% { '44672913.edf' 19 'F' 56 'Healthy volunteer' '' }
% { '42978496.edf' 20 'F' 58 'Healthy volunteer' '' }
% { '41736145.edf' 21 'F' 59 'Healthy volunteer' '' }
% { '42979246.edf' 22 'F' 55 'Healthy volunteer' '' }
% { '33380758.edf' 32 'F' 54 'Healthy volunteer' '' }
% { '27549509.edf' 41 'F' 56 'Healthy volunteer' '' }
% { '36447393.edf' 29 'M' 56 'Healthy volunteer' '' }
% { '36239102.edf' 29 'M' 60 'Healthy volunteer' '' }
% { '32683626.edf' 33 'M' 56 'Healthy volunteer' '' }
% { '32875324.edf' 33 'M' NaN 'Healthy volunteer' '' }
% { '32925323.edf' 33 'M' 58 'Healthy volunteer' '' }
% { '32099772.edf' 34 'M' 56 'Healthy volunteer' '' }
% { '32406969.edf' 34 'M' 60 'Healthy volunteer' '' }
% { '30648088.edf' 36 'M' 57 'Healthy volunteer' '' }
% { '31041338.edf' 36 'M' 58 'Healthy volunteer' '' }
% { '30734981.edf' 37 'M' 55 'Healthy volunteer' '' }
% { '29474970.edf' 38 'M' 56 'Healthy volunteer' '' }
% { '44684723.edf' 18 'F' NaN 'Healthy volunteer' '' }
% { '44147956.edf' 18 'F' NaN 'Healthy volunteer' '' }
% { '43693432.edf' 20 'F' NaN 'Healthy volunteer' '' }
% { '42258623.edf' 21 'F' 56 'Healthy volunteer' '' }
% { '40684765.edf' 22 'F' NaN 'Healthy volunteer' '' }
{ '27867986.edf' 42 'F' NaN 'Healthy volunteer' '' }
};

% Cambia al directorio con los EDFs.
cd(filepath);

% Actualiza la lista de EEGs para procesar
for reindex = 1:length(eegs)
    for reindex2 = 1:length(filename_after_script)
        if strcmp(eegs{reindex}{1}, filename_after_script{reindex2}) == 1
            eegs{reindex} = [];
            break
        end
    end
end
eegs = eegs(~cellfun('isempty', eegs));

eeglab;

% % Comentario acerca del set.
% comment = ['DNI: %s; Edad: %d; Sexo: %s; PC: %d; Dx: %s; Ciclo de migraña: %s;\n\n', ...
% '-Elimina los eventos que no son de interés.\n',...
% '-Comienza con el primer evento del EEG.\n',...
% '-Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.\n',...         
% '-Remueve la baseline.\n',...
% '-Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB).\n',...
% '-Cleanline a 50 Hz.\n',...
% '-Re referencia a AVG.\n',...             
% '-ICA y ajuste acorde a radio cefálico pendiente acorde a objetivo del trabajo.\n'
% ];

% Itera sobre los archivos a importar.
for index = 1:length(eegs)
    try
        filename = extractBefore(eegs{index}{1}, '.edf');
        
        % Importa usando la interfaz FILE-IO.
        EEG = pop_fileio(eegs{index}{1}, 'dataformat','auto');
        
        % Agregar datos de paciente.
        EEG.setname = filename;
%         EEG.comments = sprintf(comment, filename, eegs{index}{2}, eegs{index}{3}, eegs{index}{4}, eegs{index}{5}, eegs{index}{6});
        EEG.patient_info.id = filename;
        EEG.patient_info.age = eegs{index}{2};
        EEG.patient_info.sex = eegs{index}{3};
        EEG.patient_info.head_perimeter = eegs{index}{4};
        EEG.patient_info.dx = eegs{index}{5};
        if ~isempty(eegs{index}{6}) % Agrega la fase de la migraña solo en aquellos que son migraña, excluye controles sanos.
            EEG.patient_info.migraine_phase = eegs{index}{6};
        end
        EEG = eeg_checkset( EEG );
        
        % Elimina los espacios en blanco de las etiquetas de los eventos.
        for l = 1:length(EEG.event)
        EEG.event(l).type = strtrim(EEG.event(l).type);
        end
        EEG = eeg_checkset( EEG );
        
        % Elimina los eventos que no son de interes.
        EEG = pop_selectevent( EEG, 'omittype',{'empty' 'PAT I Bipolar EEG' 'PAT II Referen EEG' 'PAT III Bipola EEG' 'REC START VI Bipolar'...
            'A1+A2 OFF' 'IMP CHECK OFF' 'IMP CHECK ON' 'REC START I Bipolar'}, 'deleteevents','on');
        EEG = eeg_checkset( EEG );
        
        % Eliminar canales que no corresponden.
        EEG = pop_select( EEG, 'nochannel',{'E','T1','T2','X2','SpO2','EEG Mark1','EEG Mark2','Events/Markers'});
        
        % Configura canales
        EEG = pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\elec\\standard_1005.elc',...
            'changefield',{20,'labels','AF9h'},'changefield',{21,'labels','AF10h'},'changefield',{21,'type','EOG'},'changefield',...
            {20,'type','EOG'},'changefield',{22,'type','EEG'},'changefield',{23,'type','EEG'},'changefield',{24,'labels','EKG'},...
            'changefield',{24,'type','EKG'},'settype',{'1:19','EEG'},'changefield',{22,'labels','Tp9'},'changefield',{23,'labels','Tp10'},...
            'lookup','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc');
        
        % Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB.
        EEG = pop_eegfiltnew(EEG, 'locutoff',1); 
        EEG = eeg_checkset( EEG );
        
        % Recortar solo fotoestimulacion.
        EEG = pop_rmdat( EEG, {'PHOTO 6Hz'},[0 104] ,0);
        
        % Revisar si hay más de un protocolo de fotoestimulacion hecho y agrega 'check' al final del nombre del archivo.
        if EEG.xmax > 105
            filename = strcat(filename, '_check');
        end
        
        % Actualiza los 'timestamp' de los eventos
        for event_index = 1:length(EEG.event)
            EEG.event(event_index).timestamp = EEG.event(event_index).latency/200;
        end
        
        % Re-referencia a un promedio entre todos los canales.
        EEG = pop_reref( EEG, [] ,'exclude', find(strcmp({EEG.chanlocs(:).labels}, 'EKG'))); % find() busca el indice de EKG.
        EEG = eeg_checkset( EEG );
        
        % Cleanline a 50 Hz (la longitud del EEG tiene que ser divisible por la ventana elegida para que limpie todo).
        EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan] ,'computepower',1,'linefreqs',50,'normSpectrum',...
        0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',2,...
        'winstep',2); %#ok<NBRAK>
        EEG = eeg_checkset( EEG );
        
        % ICA
        EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
        
        % DIPFIT:incluye todo para ubicar los componentes en DIPFIT y excluye el canal de EKG.
        EEG = pop_dipfit_settings( EEG, 'hdmfile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\standard_vol.mat','coordformat','MNI','mrifile','E:\\Investigacion\\MATLAB-scripts\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\standard_mri.mat','chanfile','E:\\Investigacion\\MATLAB-scripts\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc',...
            'coord_transform',[0 0 0 0 0 -1.5708 1 1 1] ,'chansel',find(~strcmp({EEG.chanlocs(:).labels},'EKG')) );
        EEG = pop_multifit(EEG, [1:EEG.nbchan],'threshold',100,'plotopt',{'normlen' 'on'});
        
        % Guarda el EEG.
        EEG = pop_saveset( EEG, 'filename', filename ,'filepath', target_path);
    catch ME
        warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name); %#ok<MEXCEP>
        continue
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');