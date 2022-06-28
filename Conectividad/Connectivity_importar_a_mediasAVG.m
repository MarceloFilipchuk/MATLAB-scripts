% Importa archivos '*.edf' usando el File-IO toolbox de la direccion filepath.
% Renombra el set y el archivo con el DNI del paciente.
% Remueve los espacios en blanco de los eventos de fotoestimulacion.
% Edita los canales usando coordenadas MNI.
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
filepath = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG';
filepath = strcat(filepath, '\');

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
% target_folder = 'CONECTIVIDAD';

% Direccion de la carpeta donde se guardan los archivos post script.
target_path = 'E:\Investigacion\Cefalea\Investigacion\QEEG\EEG\Migrañosos';
target_path = strcat(target_path, '\');
% target_path = strcat(filepath, target_folder, '\');
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
'4642410.edf'
'16561154.edf'
'17004849.edf'
'17384808.edf'
'17842655.edf'
'18820818.edf'
'21628054.edf'
'22672559.edf'
'23021007.edf'
'23231229.edf'
'23267975.edf'
'24014278.edf'
'24196666.edf'
'24671814.edf'
'25455720.edf'
'25921670.edf'
'26089010.edf'
'26636248.edf'
'26672624.edf'
'26681314.edf'
'26790006.edf'
'27065788.edf'
'28127064.edf'
'28357169.edf'
'28456579.edf'
'28655843.edf'
'28859146.edf'
'29136654.edf'
'29166639.edf'
'29253079.edf'
'29275688.edf'
'30122613.edf'
'30330962.edf'
'30469404.edf'
'30844130.edf'
'30900116.edf'
'30971218.edf'
'31337569.edf'
'31921461.edf'
'32281962.edf'
'33029169.edf'
'33387926.edf'
'33437020.edf'
'33437628.edf'
'33700358.edf'
'34070751.edf'
'34839043.edf'
'35109977.edf'
'36131374.edf'
'36142459.edf'
'36428905.edf'
'36802064.edf'
'37126067.edf'
'37732352.edf'
'38329607.edf'
'39546581.edf'
'39693608.edf'
'39733285.edf'
'39736478.edf'
'40506862.edf'
'41268250.edf'
'41440670.edf'
'41680083.edf'
'42637732.edf'
'42642102.edf'
'42782803.edf'
'43143194.edf'
'43143713.edf'
'43604422.edf'
'43673629.edf'
'44273002.edf'
'44677571.edf'
'45090150.edf'
'45487927.edf'
'45693186.edf'
'46374112.edf'
'95760930.edf'
'95926170.edf'
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
        
        % Para migrañosos
%         EEG = pop_select( EEG, 'nochannel',{'PG1' 'PG2' 'E' 'T1' 'T2' 'X2' 'X3' 'X4' 'X5' 'X6' 'SpO2' 'EEG Mark1' 'EEG Mark2' 'Events/Markers'});
%         EEG = eeg_checkset( EEG );
%         EEG=pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc',...
%         'changefield',{20 'labels' 'TP9'},'changefield',{21 'labels' 'TP10'}, 'settype',{'1:21' 'EEG'},'changefield',{22 'labels' 'EKG'}, ...
%         'settype',{'22' 'EKG'}, 'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc');
%         EEG = eeg_checkset( EEG );
        % -------------------------------------------------------------------------------------------------------------------
              
        % Para los controles
        EEG = pop_select( EEG, 'nochannel',{'PG1' 'PG2' 'E' 'T1' 'T2' 'X3' 'X4' 'X5' 'X6' 'SpO2' 'EEG Mark1' 'EEG Mark2' 'Events/Markers'});
        EEG = eeg_checkset( EEG );
        EEG=pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2021.0\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc',...
        'changefield',{20 'labels' 'TP9'},'changefield',{21 'labels' 'TP10'}, 'settype',{'1:21' 'EEG'}, ...
        'settype',{'22:23' 'EKG'}, 'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc');
        EEG = eeg_checkset( EEG );

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
        
%         Recorta y deja 1 minuto de EEG luego de 5 minutos del ultimo evento.
%         Revisa si la FE es para reflejo H o epilepsia o si hubo FE y define el tiempo de corte acorde a esto.
        for eindex = 1:length(EEG.event)
            % Revisa si la fotoestimulacion es para respuesta H.
            if strcmp(EEG.event(eindex).type, 'PHOTO 8Hz')
                eventsFE = {};
                counter = 0;
                % Revisa si el protocolo de fotoestimulacion se repitio.
                for eindex2 = 1:length(EEG.event)
                   if strcmp(extractBefore(EEG.event(eindex2).type, ' '), 'PHOTO')
                       counter = counter + 1;
                       eventsFE{counter} = EEG.event(eindex2).type; %#ok<SAGROW>
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
            % No se hizo fotoestimulacion, el punto de corte es 50 segundos despues del comienzo.
            else
                tmp =  50;
            end
        end      
        EEG = pop_select( EEG, 'notime', [0 tmp] );
        EEG = eeg_checkset( EEG );
%         EEG = pop_select( EEG, 'notime', [0 50] );
        
        % Re-referencia a un promedio entre todos los canales.
        EEG = pop_reref(EEG, [] ,'exclude', find(strcmp({EEG.chanlocs(:).labels}, 'EKG')));
        EEG = eeg_checkset(EEG);

        % Cleanline a 50 Hz (la longitud del EEG tiene que ser divisible por la ventana elegida para que limpie todo). 
        EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan] ,'computepower',1,'linefreqs',50,'normSpectrum',...
        0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',2,...
        'winstep',2); %#ok<NBRAK>
        EEG = eeg_checkset( EEG );
        
        % Selecciona el canal de ECG (Varia entre X1 y X2) y lo renombra como EKG.
        [spect] = pop_spectopo(EEG, 1, [0  60000], 'EEG' , 'percent', 100, 'freqrange',[1 80],'electrodes','off',...
        'plot', 'off','plotchans', [22, 23]);
        if spect(1, 3) > spect(2, 3)
        EEG = pop_select( EEG, 'nochannel',{'X2'});
        else
        EEG = pop_select( EEG, 'nochannel',{'X1'});
        end
        EEG = pop_chanedit(EEG, 'changefield',{22 'labels' 'EKG'});
        % -------------------------------------------------------------------------------------------------------------------
        
        [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG);
    catch ME
        warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
        continue
    end
end
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');