% Importa archivos '*.edf' usando el File-IO toolbox de la direccion filepath.
% Renombra el set y el archivo con el DNI del paciente.
% Remueve los espacios en blanco de los eventos de fotoestimulacion.
% Edita los canales usando coordenadas MNI. No usa EOG.
% Elimina los eventos que no son FE y Ojos abiertos/cerrados.
% Remueve la baseline.  
% Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB).
% Recorta y deja solo 1 minuto luego de la fotoestimulacion o ultimo evento.
% Cleanline a 50 Hz.
% Re referencia a un promedio entre A1 y A2.             
% Renombra el archivo si tiene mas o menos eventos de los que deberia y agrega '_revisar eventos' al final.
% Guarda los archivos en la carpeta de nombre guardado en la variable 'target_folder'.  
% NOTA: en el script que agrega el radio cefalico calculo la matriz de transformacion para acomodar los electrodos en DIPFIT,
% como en este tienen todos las mismas coordenadas porque no agrego el radio cefalico dejo la matriz estandar que tiene el
% programa.
% ---------------------------------------------------------------------------------------------------------------------------


% Direccion de los archivos que se quieren procesar.
filepath = 'E:\Investigacion\EEG\NORMALES - CONTROL\CONNECTIVITY\EEG';
filepath = strcat(filepath, '\');

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
target_folder = 'CONECTIVIDAD';

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
process = 0;

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
    '46707761.edf'
    '45347521.edf'
    '44828207.edf'
    '43272306.edf'
    '43136471.edf'
    '43132578.edf'
    '41088886.edf'
    '43361091.edf'
    '43130218.edf'
    '42217829.edf'
    '42385042.edf'
    '41481729.edf'
    '41322619.edf'
    '41736145.edf'
    '39622056.edf'
    '39623876.edf'
    '40750520.edf'
    '39620184.edf'
    '39623688.edf'
    '38736951.edf'
    '36357088.edf'
    '35347104.edf'
    '33639383.edf'
    '36232087.edf'
    '34601430.edf'
    '31769226.edf'
    '34188566.edf'
    '33598751.edf'
    '31219115.edf'
    '31105839.edf'
    '33380758.edf'
    '33303993.edf'
    '29963925.edf'
    '29714464.edf'
    '31055689.edf'
    '27303699.edf'
    '28432926.edf'
    '27550318.edf'
    '27652980.edf'
    '26672197.edf'
    '27076906.edf'
    '24463852.edf'
    '27549509.edf'
    '22808531.edf'
    '23089919.edf'
    '24992919.edf'
    '24615679.edf'
    '22221330.edf'
    '23198334.edf'
    '20998802.edf'
    '21395196.edf'
    '22996280.edf'
    '21390696.edf'
    '20700634.edf'
    '20073257.edf'
    '20224517.edf'
    '17530412.edf'
    '20381885.edf'
    '18017224.edf'
    '18498243.edf'
    '16742233.edf'
    '16740814.edf'
    '16157868.edf'
    '16293599.edf'
    '1700391.edf'
    '14339047.edf'
    '11558391.edf'
    '5951564.edf'
    '16833028.edf'
    '16445692.edf'
    '10171493.edf'
    '41712730.edf'
    '33701475.edf'
    '36447393.edf'
    '30648088.edf'
    '28432439.edf'
    '28104626.edf'
    '25758828.edf'
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
    tmp = []; % Guarda el tiempo en segundos a partir de cuando se va a seleccionar el EEG
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
        
%         % Para migrañosos
%         EEG = pop_select( EEG, 'nochannel',{'PG1' 'PG2' 'E' 'T1' 'T2' 'X2' 'X3' 'X4' 'X5' 'X6' 'SpO2' 'EEG Mark1' 'EEG Mark2' 'Events/Markers'});
%         EEG = eeg_checkset( EEG );
%         EEG=pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc',...
%         'changefield',{20 'labels' 'TP9'},'changefield',{21 'labels' 'TP10'}, 'settype',{'1:21' 'EEG'},'changefield',{22 'labels' 'EKG'}, ...
%         'settype',{'22' 'EKG'}, 'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc');
%         EEG = eeg_checkset( EEG );
%         % -------------------------------------------------------------------------------------------------------------------
              
        % Para los controles
        EEG = pop_select( EEG, 'nochannel',{'PG1' 'PG2' 'E' 'T1' 'T2' 'X3' 'X4' 'X5' 'X6' 'SpO2' 'EEG Mark1' 'EEG Mark2' 'Events/Markers'});
        EEG = eeg_checkset( EEG );
        EEG=pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc',...
        'changefield',{20 'labels' 'TP9'},'changefield',{21 'labels' 'TP10'}, 'settype',{'1:21' 'EEG'}, ...
        'settype',{'22:23' 'EKG'}, 'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc');
        EEG = eeg_checkset( EEG );
        % -------------------------------------------------------------------------------------------------------------------

        % Elimina los eventos que no son FE y Ojos abiertos/cerrados.
        EEG = pop_selectevent( EEG, 'omittype',{'empty' 'PAT I Bipolar EEG' 'REC START VI Bipolar' 'A1+A2 OFF' 'IMP CHECK OFF'...
            'IMP CHECK ON' 'REC START I Bipolar'}, 'deleteevents','on');
        EEG = eeg_checkset( EEG );

        % Remueve la baseline.
        EEG = pop_rmbase( EEG, [],[]);
        EEG = eeg_checkset( EEG );

        % Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB.
        EEG = pop_eegfiltnew(EEG, 'locutoff',1); 
        EEG = eeg_checkset( EEG );
        
        % Recorta y deja 1 minuto de EEG luego de 5 minutos del ultimo evento.
        % Revisa si la FE es para reflejo H o epilepsia o si hubo FE y define el tiempo de corte acorde a esto.
        for eindex = 1:length(EEG.event)
            % Revisa si la fotoestimulacion es para respuesta H.
            if strcmp(EEG.event(eindex).type, 'PHOTO 8Hz')
                eventsFE = {};
                counter = 0;
                % Revisa si el protocolo de fotoestimulacion se repitio.
                for eindex = 1:length(EEG.event)
                   if strcmp(extractBefore(EEG.event(eindex).type, ' '), 'PHOTO')
                       counter = counter + 1;
                      eventsFE{counter} = EEG.event(eindex).type;
                   end
                end
                % Si el protocolo no se repitio, el punto de corte es 5 minutos despues del mismo.
                if length(eventsFE) == length(unique(eventsFE))
                    for findex = 1:length(EEG.event)
                       if strcmp(EEG.event(findex).type, 'PHOTO 6Hz')
                            tmp =  EEG.event(findex).latency / 200 + 100 + 300;
                            break
                       end
                    end
                % El protocolo se repitio, el punto de corte es 5 minutos despues del ultimo evento.    
                else
                    tmp =  EEG.event(length(EEG.event)).latency / 200 + 300;
                end
                break
            % Revisa si la fotoestimulacion es para epilepsia.
            elseif strcmp(EEG.event(eindex).type, 'PHOTO 9Hz')
                for findex = 1:length(EEG.event)
                   if strcmp(EEG.event(findex).type, 'PHOTO 3Hz')
                        tmp =  EEG.event(findex).latency / 200 + 315 +  300;
                        break
                   end
                end
                break
            % No se hizo fotoestimulacion, el punto de corte es 5 minutos despues del ultimo evento.
            else
                tmp =  EEG.event(length(EEG.event)).latency / 200 + 300;
                break
            end
        end      
        EEG = pop_select( EEG, 'time', [tmp (tmp + 60)] );
        EEG = eeg_checkset( EEG );

        % Cleanline a 50 Hz (la longitud del EEG tiene que ser divisible por la ventana elegida para que limpie todo). 
        EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan] ,'computepower',1,'linefreqs',50,'normSpectrum',...
        0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',2,...
        'winstep',2);
        EEG = eeg_checkset( EEG );

        % Re referencia a un promedio entre A1 y A2.
        EEG = pop_reref( EEG, [20 21], 'exclude', 22 );
        EEG = eeg_checkset( EEG );

        % Selecciona el canal de ECG (Varia entre X1 y X2) y lo renombra como EKG.
        [spect] = pop_spectopo(EEG, 1, [0  60000], 'EEG' , 'percent', 100, 'freqrange',[1 80],'electrodes','off',...
        'plot', 'off','plotchans', [20, 21]);
        if spect(1, 3) > spect(2, 3)
        EEG = pop_select( EEG, 'nochannel',{'X2'});
        else
        EEG = pop_select( EEG, 'nochannel',{'X1'});
        end
        EEG=pop_chanedit(EEG, 'changefield',{20 'labels' 'EKG'});

        % Si los eventos no son 1 (1 boundary), renombra agregando '_RevisarEventos'.
        if length(EEG.event) ~= 1
        filename = strcat(filename, '_RevisarEventos');
        end
        if EEG.nbchan ~= 20
        filename = strcat(filename, '_RevisarCanales');
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
% cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');