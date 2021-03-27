filename = EEG.setname;
EEG = pop_fileio(strcat(filepath, '\', filename, '.edf'), 'dataformat','auto');
EEG.comments = sprintf(comment, filename);
EEG = eeg_checkset( EEG );
EEG.setname = filename;

% Elimina los espacios en blanco de las etiquetas de los eventos.
for l = 1:length(EEG.event)
EEG.event(l).type = strtrim(EEG.event(l).type);
end
EEG = eeg_checkset( EEG );

% Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.
% NOTA: Revisar que al actualizar el plugin DIPFIT a veces hay que actualizar la direccion del 'lookup', coloca 
% el radio de la cabeza en base al perimetro cefalico ( PC * 10 / (2 * pi) ).

% Para migrañosos
EEG = pop_select( EEG, 'nochannel',{'PG1' 'PG2' 'E' 'T1' 'T2' 'X2' 'X3' 'X4' 'X5' 'X6' 'SpO2' 'EEG Mark1' 'EEG Mark2' 'Events/Markers'});
EEG = eeg_checkset( EEG );
EEG = pop_chanedit(EEG, 'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc',...
'changefield',{20 'labels' 'TP9'},'changefield',{21 'labels' 'TP10'}, 'settype',{'1:21' 'EEG'},'changefield',{22 'labels' 'EKG'}, ...
'settype',{'22' 'EKG'}, 'lookup','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc');
EEG = eeg_checkset( EEG );
% -------------------------------------------------------------------------------------------------------------------

% Elimina los eventos que no son FE y Ojos abiertos/cerrados.
EEG = pop_selectevent( EEG, 'omittype',{'empty' 'PAT I Bipolar EEG' 'REC START VI Bipolar' 'A1+A2 OFF' 'IMP CHECK OFF'...
    'IMP CHECK ON' 'REC START I Bipolar'}, 'deleteevents','on');
EEG = eeg_checkset( EEG );

EEG = pop_select( EEG, 'notime', [0 90] );

% Remueve la baseline.
EEG = pop_rmbase( EEG, [],[]);
EEG = eeg_checkset( EEG );

% Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB.
EEG = pop_eegfiltnew(EEG, 'locutoff',1); 
EEG = eeg_checkset( EEG );

% Cleanline a 50 Hz (la longitud del EEG tiene que ser divisible por la ventana elegida para que limpie todo). 
EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:EEG.nbchan] ,'computepower',1,'linefreqs',50,'normSpectrum',...
0,'p',0.05,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',2,...
'winstep',2); %#ok<NBRAK>
EEG = eeg_checkset( EEG );

% Re-referencia a un promedio entre todos los canales.
EEG = pop_reref(EEG, [] ,'exclude', find(strcmp({EEG.chanlocs(:).labels}, 'EKG')));

eeglab redraw;

pop_eegplot( EEG, 1, 1, 1);