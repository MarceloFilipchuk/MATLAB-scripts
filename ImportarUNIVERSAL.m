% Importar usando FILE-IO.
% Eliminar eventos en blanco.
% Definir en comentarios de set DNI, sexo, edad, perimetro cefalico, diagnostico y ciclo de migraña. Definir parametros de
% importacion (ej: referencia, modelo de cabeza usado para canales, si se definio o no el PC... etc).
% Eliminar canales que no son usables.
% Definir nombre de canales a usar.
% Definir modelo MNI para canales y coordenadas.
% NO definir el perimetro cefalico.
% Eliminar eventos que no sean de interes.
% Remover baseline.
% Dejar frecuencias superiores a XHz (ver que valores convienen, tutorial dice 1Hz pero depende de lo que se quiera hacer).
% Recortar a partir del primer evento de interes.
% Cleanline.
% Re-referenciar a promedio de canales (cualquier cosa despues puedo re-referenciar).
% Guardar EEG.
% Limpiar posteriormente artefactos musculares.
% El ICA y la definicion del perimetro cefalico necesario para ello se van a hacer posteriormente en base al objetivo del
% trabajo.
% ---------------------------------------------------------------------------------------------------------------------------


% Direccion de los archivos que se quieren procesar.
filepath = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG';
filepath = strcat(filepath, '\');

% Direccion de la carpeta donde se guardan los archivos post script.
target_path = 'E:\Investigacion\EEG\EEG procesados\Migrañosos';
target_path = strcat(target_path, '\');
if ~exist(target_path,'dir')
    mkdir(target_path);
end

% Nombre de la carpeta con los EEGs ya limpios.
target_folder_clean = 'Limpios';


% Direccion donde estan los EEGs ya limpios.
target_path_clean = strcat(target_path, target_folder_clean, '\');
if ~exist(target_path_clean,'dir')
    mkdir(target_path_clean);
end

% Cambia el directorio a la carpeta donde estan los archivos ya procesados.
cd(target_path_clean);

% Crea una celda con los archivos que ya se encuentran en el directorio donde se guardan los archivos procesado, para evitar
% procesarlos si ya lo fueron.
filename_after_script = dir('*.set');
filename_after_script = {filename_after_script.name}';
for rindex = 1:length(filename_after_script)
    filename_after_script{rindex} = strcat(extractBefore(filename_after_script{rindex}, '.set'), '.edf');
end
    

% Para cuando se importan controles (a veces tienen el canal de ECG en X2 en vez de X1).
control = contains(upper(filepath), upper('control'));

% Nombre de los archivos a procesar y sus perimetros cefalicos(PC).
% NOTA: Colocar DNIs entre comillas simples y con formato '.edf' al final y agregar PC. 
% Formato:{'DNI.edf' Edad Sexo PC Dx CicloMigraña
% Ejemplo: {'123456.edf 35 'F' 55 '1.2' 'ICTAL'}

eegs ={
{ '16561154.edf' 55 'F' 52 '1.1' 'INTERICTAL' }
{ '21628054.edf' 50 'F' 56 '1.2' 'ICTAL' }
{ '22672559.edf' 48 'F' 56 '1.1' 'ICTAL' }
{ '23021007.edf' 47 'F' 56 '1.1' 'ICTAL' }
{ '23267975.edf' 47 'F' 52 '1.1' 'ICTAL' }
{ '24671814.edf' 45 'F' 54 '1.1' 'INTERICTAL' }
{ '25921670.edf' 42 'F' 56 '1.2' 'ICTAL' }
{ '26636248.edf' 41 'F' 57 '1.1' 'ICTAL' }
{ '26681314.edf' 41 'M' 58 '1.1' 'ICTAL' }
{ '27065788.edf' 41 'F' 57 '1.1' 'ICTAL' }
{ '28456579.edf' 39 'F' 58 '1.2' 'INTERICTAL' }
{ '28655843.edf' 39 'F' 56 '1.2' 'ICTAL' }
{ '29136654.edf' 48 'F' 54 '1.2' 'ICTAL' }
{ '29166639.edf' 38 'F' 55 '1.1' 'ICTAL' }
{ '29253079.edf' 38 'F' 55 '1.1' 'ICTAL' }
{ '29275688.edf' 38 'M' 55 '1.2' 'INTERICTAL' }
{ '30469404.edf' 36 'F' 55 '1.1 + 1.2' 'ICTAL' }
{ '30900116.edf' 36 'M' 59 '1.1' 'ICTAL' }
{ '30971218.edf' 36 'F' 54 '1.1 + 1.2' 'ICTAL' }
{ '31337569.edf' 35 'F' 54 '1.1' 'INTERICTAL' }
{ '31921461.edf' 34 'F' 56 '1.1' 'INTERICTAL' }
{ '32281962.edf' 34 'F' 54 '1.2' 'INTERICTAL' }
{ '33029169.edf' 33 'F' 58 '1.2' 'ICTAL' }
{ '33387926.edf' 32 'F' 0 '1.1' 'ICTAL' }
{ '33437020.edf' 32 'F' 54 '1.1' 'ICTAL' }
{ '33700358.edf' 32 'M' 59 '1.1' 'INTERICTAL' }
{ '34839043.edf' 30 'F' 56 '1.1' 'INTERICTAL' }
{ '35109977.edf' 30 'F' 52 '1.1' 'ICTAL' }
{ '37126067.edf' 27 'F' 54 '1.1' 'ICTAL' }
{ '37732352.edf' 27 'F' 57 '1.2' 'ICTAL' }
{ '39546581.edf' 24 'F' 59 '1.1' 'INTERICTAL' }
{ '39733285.edf' 24 'F' 55 '1.1' 'PREICTAL' }
{ '39736478.edf' 23 'F' 59 '1.2' 'ICTAL' }
{ '40506862.edf' 21 'F' 49 '1.1' 'ICTAL' }
{ '41268250.edf' 21 'F' 50 '1.1' 'ICTAL' }
{ '41440670.edf' 21 'F' 52 '1.1 + 1.2' 'INTERICTAL' }
{ '42637732.edf' 35 'F' 57 '1.1' 'ICTAL' }
{ '42642102.edf' 20 'F' 53 '1.1' 'INTERICTAL' }
{ '42782803.edf' 20 'F' 54 '1.1' 'ICTAL' }
{ '43143194.edf' 19 'F' 58 '1.1' 'ICTAL' }
{ '43143713.edf' 19 'F' 0 '1.2' 'INTERICTAL' }
{ '43673629.edf' 18 'F' 54 '1.1' 'ICTAL' }
{ '44273002.edf' 17 'F' 0 '1.2' 'ICTAL' }
{ '44677571.edf' 14 'F' 57 '1.1' 'INTERICTAL' }
{ '45090150.edf' 16 'F' 56 '1.1' 'ICTAL' }
{ '45693186.edf' 16 'F' 56 '1.2' 'INTERICTAL' }
{ '46374112.edf' 14 'F' 55 '1.1' 'INTERICTAL' }
{ '95926170.edf' 30 'F' 0 '1.2' 'ICTAL' }
{ '28127064.edf' 39 'F' 57 '1.1' 'ICTAL' }
{ '26672624.edf' 42 'F' 57 '1.1 + 1.2' 'ICTAL' }
{ '30330962.edf' 37 'F' 52 '1.1' 'ICTAL' }
{ '36142459.edf' 28 'F' 54 '1.2' 'INTERICTAL' }
{ '26790006.edf' 42 'M' 58 '1.1' 'ICTAL' }
{ '95760930.edf' 35 'F' 55 '1.1' 'ICTAL' }
{ '17842655.edf' 54 'F' 59 '1.1' 'PREICTAL' }
{ '36131374.edf' 27 'F' 56 '1.1' 'ICTAL' }
{ '45487927.edf' 16 'F' 58 '1.1' 'INTERICTAL' }
{ '33437628.edf' 32 'M' 58 '1.1' 'ICTAL' }
{ '39693608.edf' 24 'F' 56 '1.1' 'ICTAL' }
{ '41680083.edf' 21 'M' 55 '1.1' 'ICTAL' }
{ '40026470.edf' 23 'F' 58 '1.1' 'ICTAL' }
{ '31058058.edf' 36 'F' 56 '1.1 + 1.2' 'INTERICTAL' }
{ '29712356.edf' 37 'F' 51 '1.1' 'INTERICTAL' }
{ '29154320.edf' 38 'F' 0 '1.1' 'INTERICTAL' }
{ '35915823.edf' 29 'F' 54 '1.2' 'INTERICTAL' }
{ '30628863.edf' 36 'F' 55 '1.1' 'ICTAL' }
{ '30661493.edf' 36 'F' 56 '1.1' 'ICTAL' }
{ '45936466.edf' 16 'M' 54 '1.1' 'ICTAL' }
{ '39073136.edf' 26 'F' 55 '1.1' 'ICTAL' }
{ '25736769.edf' 43 'F' 56 '1.1' 'ICTAL' }
{ '13153801.edf' 61 'F' 55 '1.2' 'ICTAL' }
{ '37107273.edf' 27 'F' 0 '1.2' 'ICTAL' }
{ '21139530.edf' 51 'F' 55 '1.1' 'ICTAL' }
{ '42783515.edf' 56 'F' 20 '1.2' 'ICTAL' }
{ '26903214.edf' 52 'F' 42 '1.1' 'ICTAL' }
{ '29476363.edf' 38 'F' 56 '1.1' 'PREICTAL' }
{ '30123167.edf' 37 'F' 57 '1.1' 'INTERICTAL' }
};

% Comentario acerca del set.
comment = ['DNI: %s; Edad: %d; Sexo: %s; PC: %d; Dx: %s; Ciclo de migraña: %s;\n\n', ...
'-Elimina los eventos que no son de interés.\n',...
'-Comienza con el primer evento del EEG.\n',...
'-Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.\n',...         
'-Remueve la baseline.\n',...
'-Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB).\n',...
'-Cleanline a 50 Hz.\n',...
'-Re referencia a AVG.\n',...             
'-ICA y ajuste acorde a radio cefálico pendiente acorde a objetivo del trabajo.\n'
];

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

% Itera sobre los archivos a importar.
for index = 1:length(eegs)
    try
        filename = extractBefore(eegs{index}{1}, '.edf');
        
        % Importa usando la interfaz FILE-IO.
        EEG = pop_fileio(eegs{index}{1}, 'dataformat','auto');
        
        % Agrega datos del paciente.
        EEG.setname = filename;
        EEG.comments = sprintf(comment, filename, eegs{index}{2}, eegs{index}{3}, eegs{index}{4}, eegs{index}{5}, eegs{index}{6});
        EEG.patient_info.id = filename;
        EEG.patient_info.age = eegs{index}{2};
        EEG.patient_info.sex = eegs{index}{3};
        EEG.patient_info.head_perimeter = eegs{index}{4};
        EEG.patient_info.dx = eegs{index}{5};
        EEG.patient_info.migraine_phase = eegs{index}{6};
        EEG = eeg_checkset( EEG );

        % Elimina los espacios en blanco de las etiquetas de los eventos.
        for l = 1:length(EEG.event)
        EEG.event(l).type = strtrim(EEG.event(l).type);
        end
        EEG = eeg_checkset( EEG );
        
        % Revisa si se grabó con canales de EOG
        EOG_chan = any(strcmp({EEG.chanlocs(:).labels},'PG1')) || any(strcmp({EEG.chanlocs(:).labels},'PG2'));
        
        % Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.
        % NOTA: Revisar que al actualizar el plugin DIPFIT a veces hay que actualizar la direccion del 'lookup', coloca 
        % el radio de la cabeza en base al perimetro cefalico ( PC * 10 / (2 * pi) ).
        EEG = pop_select( EEG, 'nochannel',{'E' 'T1' 'T2' 'SpO2' 'EEG Mark1' 'EEG Mark2' 'Events/Markers' 'X3' 'X4' 'X5' 'X6'});
        
        if EOG_chan % Si los canales de EOG (PG1 y PG2) estan, los renombra como AF9h y AF10h.           
            if ~control
                EEG = pop_select( EEG, 'nochannel',{'X2'});
                EEG = pop_chanedit(EEG, 'changefield',{24 'labels' 'EKG'} ,'changefield',{24,'type','EKG'});
            end
            EEG = pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc',...
                'settype',{'1:19','EEG'},'changefield',{20,'labels','AF9h'},'changefield',{21,'labels','AF10h'},'changefield',...
                {22,'labels','TP9'},'changefield',{23,'labels','TP10'},'changefield',{23,'type','EEG'},'changefield',{22,'type','EEG'},...
                'changefield',{20,'type','EOG'},'changefield',{21,'type','EOG'},'lookup','E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc');
        else % El EEG no se grabó usando los canales de EOG
            if ~control
                EEG = pop_select( EEG, 'nochannel',{'X2'}); 
                EEG = pop_chanedit(EEG, 'changefield',{22 'labels' 'EKG'} ,'changefield',{22,'type','EKG'});
            end
            EEG = pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc',...
                'settype',{'1:21','EEG'},'changefield',{20,'labels','TP9'},'changefield',{21,'labels','TP10'},'lookup',...
                'E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc');
        end
        EEG = eeg_checkset( EEG );

        % Elimina los eventos que no son de interes.
        EEG = pop_selectevent( EEG, 'omittype',{'empty' 'PAT I Bipolar EEG' 'PAT II Referen EEG' 'PAT III Bipola EEG' 'REC START VI Bipolar'...
            'A1+A2 OFF' 'IMP CHECK OFF' 'IMP CHECK ON' 'REC START I Bipolar'}, 'deleteevents','on');
        EEG = eeg_checkset( EEG );

        % Remueve la baseline.
        EEG = pop_rmbase( EEG, [],[]);
        EEG = eeg_checkset( EEG );

        % Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB.
        EEG = pop_eegfiltnew(EEG, 'locutoff',1); 
        EEG = eeg_checkset( EEG );

        % Recorta hasta el primer evento y deja el EEG de longitud par (para que CleanLine lo limpie completo)
        if isempty(EEG.event)
            EEG = pop_select( EEG, 'time',[0 (EEG.xmax - mod(EEG.xmax, 2))] );
        else
            EEG = pop_rmdat( EEG, {EEG.event(1).type},[0 EEG.xmax] ,0);
            EEG = pop_rmdat( EEG, {EEG.event(1).type},[0 (EEG.xmax - mod(EEG.xmax, 2))] ,0);        
%             eeg_duration = EEG.xmax - EEG.event(1).latency/200;
%             eeg_duration = eeg_duration - mod(eeg_duration, 2);
%             EEG = pop_rmdat( EEG, {EEG.event(1).type},[0 eeg_duration] ,0);
        end

        % Actualiza los 'timestamp' de los eventos
        for event_index = 1:length(EEG.event)
            EEG.event(event_index).timestamp = EEG.event(event_index).latency/200;
        end

        % Cleanline a 50 Hz (la longitud del EEG tiene que ser divisible por la ventana elegida para que limpie todo). 
        EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan] ,'computepower',1,'linefreqs',50,'normSpectrum',...
        0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',2,...
        'winstep',2); %#ok<NBRAK>
        EEG = eeg_checkset( EEG );

        % Elimina canales de EKG equivocados.
        if control
            if EOG_chan % Se usaron canales para EOG.
                % Deja el canal de EKG (a veces se confunden y X1 no contiene el ECG, sino X2).
                [spect] = pop_spectopo(EEG, 1, [0  EEG.xmax*1000], 'EEG' , 'percent', 100, 'freqrange',[1 80],'electrodes','off',...
                'plot', 'off','plotchans', [24, 25]);
                if spect(1, 21) > spect(2, 21)
                    EEG.old_EKG = EEG.data(25,:);
                    EEG = pop_select( EEG, 'nochannel',{'X2'});
                else
                    EEG.old_EKG = EEG.data(24,:);
                    EEG = pop_select( EEG, 'nochannel',{'X1'});
                end
                EEG = pop_chanedit(EEG, 'changefield',{24 'labels' 'EKG'} ,'changefield',{24,'type','EKG'});
            else % No usaron canales para EOG.
                % Deja el canal de EKG (a veces se confunden y X1 no contiene el ECG, sino X2).
                [spect] = pop_spectopo(EEG, 1, [0  EEG.xmax*1000], 'EEG' , 'percent', 100, 'freqrange',[1 80],'electrodes','off',...
                'plot', 'off','plotchans', [22, 23]);
                if spect(1, 21) > spect(2, 21)
                    EEG.old_EKG = EEG.data(23,:);
                    EEG = pop_select( EEG, 'nochannel',{'X2'});
                else
                    EEG.old_EKG = EEG.data(22,:);
                    EEG = pop_select( EEG, 'nochannel',{'X1'});
                end
                EEG = pop_chanedit(EEG, 'changefield',{22 'labels' 'EKG'} ,'changefield',{22,'type','EKG'});
            end
            EEG = eeg_checkset( EEG );    
        end

        % Re-referencia a un promedio entre todos los canales.
        EEG = pop_reref( EEG, [] ,'exclude', find(strcmp({EEG.chanlocs(:).labels}, 'EKG'))); % find() busca el indice de EKG.
        EEG = eeg_checkset( EEG );

        % Guarda el EEG.
        EEG = pop_saveset( EEG, 'filename', filename ,'filepath', target_path); %#ok<NASGU>
    catch ME
        warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name); %#ok<MEXCEP>
        continue
    end
end
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');
