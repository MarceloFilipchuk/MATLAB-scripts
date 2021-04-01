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
filepath = 'E:\Investigacion\EEG\NORMALES - CONTROL\RESPUESTA H\EEG';
filepath = strcat(filepath, '\');

% Direccion de la carpeta donde se guardan los archivos post script.
target_path = 'E:\Investigacion\EEG\EEG procesados\Controles';
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
{ '5951564.edf' 68 'F' 0 'Control' '' }
{ '10683535.edf' 65 'M' 0 'Control' '' }
{ '14339047.edf' 57 'F' 0 'Control' '' }
{ '16293599.edf' 54 'F' 0 'Control' '' }
{ '16742233.edf' 52 'F' 0 'Control' '' }
{ '16157868.edf' 53 'F' 0 'Control' '' }
{ '18017224.edf' 51 'F' 0 'Control' '' }
{ '20700634.edf' 46 'F' 0 'Control' '' }
{ '22996280.edf' 46 'F' 0 'Control' '' }
{ '20073257.edf' 49 'F' 0 'Control' '' }
{ '28104626.edf' 40 'M' 57 'Control - Protocolo de respuesta H' '' }
{ '25758828.edf' 42 'M' 55 'Control - Protocolo de respuesta H' '' }
{ '21390696.edf' 46 'F' 0 'Control' '' }
{ '21395196.edf' 45 'F' 0 'Control' '' }
{ '22221330.edf' 44 'F' 0 'Control' '' }
{ '23198334.edf' 45 'F' 0 'Control' '' }
{ '1700391.edf' 55 'F' 0 'Control' '' }
{ '22808531.edf' 42 'F' 0 'Control' '' }
{ '23089919.edf' 43 'F' 0 'Control' '' }
{ '28432439.edf' 38 'M' 55 'Control - Protocolo de respuesta H' '' }
{ '27549509.edf' 41 'F' 56 'Control - Protocolo de respuesta H' '' }
{ '27652980.edf' 38 'F' 0 'Control' '' }
{ '30648088.edf' 36 'M' 57 'Control - Protocolo de respuesta H' '' }
{ '26672197.edf' 38 'F' 0 'Control' '' }
{ '32406969.edf' 34 'M' 60 'Control - Protocolo de respuesta H' '' }
{ '29714464.edf' 33 'F' 0 'Control' '' }
{ '31055689.edf' 35 'F' 0 'Control' '' }
{ '29963925.edf' 32 'F' 0 'Control' '' }
{ '33380758.edf' 32 'F' 54 'Control - Protocolo de respuesta H' '' }
{ '33303993.edf' 32 'F' 0 'Control' '' }
{ '36447393.edf' 29 'M' 56 'Control - Protocolo de respuesta H' '' }
{ '33701475.edf' 29 'M' 0 'Control' '' }
{ '34188566.edf' 30 'F' 0 'Control' '' }
{ '33598751.edf' 30 'F' 0 'Control' '' }
{ '36232087.edf' 27 'F' 0 'Control' '' }
{ '31769226.edf' 29 'F' 0 'Control' '' }
{ '35347104.edf' 26 'F' 0 'Control' '' }
{ '33639383.edf' 26 'F' 0 'Control' '' }
{ '40750520.edf' 23 'F' 0 'Control' '' }
{ '39623688.edf' 24 'F' 0 'Control' '' }
{ '39620184.edf' 24 'F' 0 'Control' '' }
{ '39623876.edf' 21 'F' 0 'Control' '' }
{ '41322619.edf' 20 'F' 0 'Control' '' }
{ '41736145.edf' 21 'F' 59 'Control - Protocolo de respuesta H' '' }
{ '39622056.edf' 21 'F' 0 'Control' '' }
{ '41712730.edf' 20 'M' 60 'Control - Protocolo de respuesta H' '' }
{ '28432926.edf' 36 'F' 0 'Control' '' }
{ '42385042.edf' 19 'F' 0 'Control' '' }
{ '41481729.edf' 20 'F' 0 'Control' '' }
{ '43130218.edf' 18 'F' 0 'Control' '' }
{ '42217829.edf' 19 'F' 0 'Control' '' }
{ '43361091.edf' 18 'F' 0 'Control' '' }
{ '43132578.edf' 17 'F' 0 'Control' '' }
{ '43136471.edf' 17 'F' 0 'Control' '' }
{ '43272306.edf' 17 'F' 0 'Control' '' }
{ '27550318.edf' 38 'F' 0 'Control' '' }
{ '31219115.edf' 30 'F' 0 'Control' '' }
{ '10171493.edf' 66 'M' 0 'Control' '' }
{ '16833028.edf' 54 'M' 0 'Control' '' }
{ '16445692.edf' 55 'M' 0 'Control' '' }
{ '24992919.edf' 44 'F' 0 'Control' '' }
{ '16740814.edf' 52 'F' 0 'Control' '' }
{ '18498243.edf' 51 'F' 0 'Control' '' }
{ '20381885.edf' 51 'F' 0 'Control' '' }
{ '17530412.edf' 50 'F' 0 'Control' '' }
{ '20224517.edf' 49 'F' 0 'Control' '' }
{ '24615679.edf' 44 'F' 0 'Control' '' }
{ '20998802.edf' 45 'F' 0 'Control' '' }
{ '24463852.edf' 40 'F' 0 'Control' '' }
{ '27076906.edf' 40 'F' 0 'Control' '' }
{ '31105839.edf' 30 'F' 0 'Control' '' }
{ '36357088.edf' 26 'F' 0 'Control' '' }
{ '34601430.edf' 27 'F' 0 'Control' '' }
{ '38736951.edf' 24 'F' 0 'Control' '' }
{ '41088886.edf' 17 'F' 0 'Control' '' }
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
        EOG_chan = false;
        for chan_index = 1:EEG.nbchan
            if strcmp(EEG.chanlocs(chan_index).labels, 'PG1') || strcmp(EEG.chanlocs(chan_index).labels, 'PG2')
                EOG_chan = true;
                break
            end
        end

        % Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.
        % NOTA: Revisar que al actualizar el plugin DIPFIT a veces hay que actualizar la direccion del 'lookup', coloca 
        % el radio de la cabeza en base al perimetro cefalico ( PC * 10 / (2 * pi) ).
        EEG = pop_select( EEG, 'nochannel',{'E' 'T1' 'T2' 'SpO2' 'EEG Mark1' 'EEG Mark2' 'Events/Markers'});
        
        if EOG_chan % Si los canales de EOG (PG1 y PG2) estan, los renombra como AF9h y AF10h.
            if control
                % Deja el canal de EKG (a veces se confunden y X1 no contiene el ECG, sino X2).
                [spect] = pop_spectopo(EEG, 1, [0  60000], 'EEG' , 'percent', 100, 'freqrange',[1 80],'electrodes','off',...
                'plot', 'off','plotchans', [24, 25]);
                if spect(1, 51) < spect(2, 51)
                    EEG.old_EKG = EEG.data(25,:);
                    EEG = pop_select( EEG, 'nochannel',{'X2'});
                else
                    EEG.old_EKG = EEG.data(24,:);
                    EEG = pop_select( EEG, 'nochannel',{'X1'});
                end
            else
                EEG = pop_select( EEG, 'nochannel',{'X2'});
            end
            EEG = pop_chanedit(EEG, 'changefield',{24 'labels' 'EKG'} ,'changefield',{24,'type','EKG'});
            EEG = pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc',...
                'settype',{'1:19','EEG'},'changefield',{20,'labels','AF9h'},'changefield',{21,'labels','AF10h'},'changefield',...
                {22,'labels','TP9'},'changefield',{23,'labels','TP10'},'changefield',{23,'type','EEG'},'changefield',{22,'type','EEG'},...
                'changefield',{20,'type','EOG'},'changefield',{21,'type','EOG'},'lookup','E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc');
            EEG = eeg_checkset( EEG );
        else % El EEG no se grabó usando los canales de EOG
            if control
                % Deja el canal de EKG (a veces se confunden y X1 no contiene el ECG, sino X2).
                [spect] = pop_spectopo(EEG, 1, [0  60000], 'EEG' , 'percent', 100, 'freqrange',[1 80],'electrodes','off',...
                'plot', 'off','plotchans', [22, 23]);
                if spect(1, 51) < spect(2, 51)
                    EEG.old_EKG = EEG.data(23,:);
                    EEG = pop_select( EEG, 'nochannel',{'X2'});
                else
                    EEG.old_EKG = EEG.data(22,:);
                    EEG = pop_select( EEG, 'nochannel',{'X1'});
                end
            else
                EEG = pop_select( EEG, 'nochannel',{'X2'});
            end
            EEG = pop_chanedit(EEG, 'changefield',{22 'labels' 'EKG'} ,'changefield',{22,'type','EKG'});
            EEG = pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc',...
                'settype',{'1:21','EEG'},'changefield',{20,'labels','TP9'},'changefield',{21,'labels','TP10'},'lookup',...
                'E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc');
            EEG = eeg_checkset( EEG );
        end

        % Elimina los eventos que no son de interes.
        EEG = pop_selectevent( EEG, 'omittype',{'empty' 'PAT I Bipolar EEG' 'REC START VI Bipolar' 'A1+A2 OFF' 'IMP CHECK OFF'...
            'IMP CHECK ON' 'REC START I Bipolar'}, 'deleteevents','on');
        EEG = eeg_checkset( EEG );

        % Remueve la baseline.
        EEG = pop_rmbase( EEG, [],[]);
        EEG = eeg_checkset( EEG );

        % Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB.
        EEG = pop_eegfiltnew(EEG, 'locutoff',1); 
        EEG = eeg_checkset( EEG );

        % Recorta hasta el primer evento y deja el EEG de longitud par (para que CleanLine lo limpie completo)
        EEG = pop_rmdat( EEG, {EEG.event(1).type},[0 EEG.xmax] ,0);
        EEG = pop_rmdat( EEG, {EEG.event(1).type},[0 (EEG.xmax - mod(EEG.xmax, 2))] ,0);        
%         eeg_duration = EEG.xmax - EEG.event(1).latency/200;
%         eeg_duration = eeg_duration - mod(eeg_duration, 2);
%         EEG = pop_rmdat( EEG, {EEG.event(1).type},[0 eeg_duration] ,0);

        % Actualiza los 'timestamp' de los eventos
        for event_index = 1:length(EEG.event)
            EEG.event(event_index).timestamp = EEG.event(event_index).latency/200;
        end

        % Cleanline a 50 Hz (la longitud del EEG tiene que ser divisible por la ventana elegida para que limpie todo). 
        EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan] ,'computepower',1,'linefreqs',50,'normSpectrum',...
        0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',2,...
        'winstep',2); %#ok<NBRAK>
        EEG = eeg_checkset( EEG );

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
