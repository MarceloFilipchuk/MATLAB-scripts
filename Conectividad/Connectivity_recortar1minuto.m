% filepath = 'E:\Investigacion\EEG\EEG procesados\Migrañosos\Limpios';
% 
% % Direccion de los EEG con un minuto ya extraido.
% minute = strcat(filepath, '\1 minuto'); % Aca guarda el minuto que se extrajo para que ya para el futuro
% if ~exist(minute, 'dir')
%     mkdir(minute);
% end
% 
% % Direccion objetivo.
% target_path = 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Migrañosos';
% 
% % Direccion con el EEG completo para agregar la marca de tiempo del minuto.
% event_path = strcat(filepath, '\Con eventos');
% if ~exist(event_path, 'dir')
%     mkdir(event_path);
% end
% % Electros que estan en la lista pero no se encuentran en el directorio.
% missing = {};
% 
% eegs = {
% '43604422.set'
% '39057518.set'
% '36802064.set'
% '34070751.set'
% '34455144.set'
% '30844130.set'
% '30122613.set'
% '28357169.set'
% '28127064.set'
% '26089010.set'
% '24196666.set'
% '24014278.set'
% '24367434.set'
% '23231229.set'
% '29606275.set'
% '17004849.set'
% '17384808.set'
% '25455720.set'
% '28374342.set'
% '26903214.set'
% '22672559.set'
% '24457312.set'
% '26681314.set'
% '32354708.set'
% '23419359.set'
% 
% };
% 
% % Quita los eegs de los cuales ya se extrajeron 1 minuto
% cd(target_path)
% already_processed_eegs = dir('*.set'); % EEGs en el directorio objetivo de los que faltan 1 minuto
% already_processed_eegs = {already_processed_eegs.name}';
% eegs = setdiff(eegs, already_processed_eegs); % EEGs finales que faltan procesar
% 
% eeglab
% counter = 1;
% for index = 1:length(eegs)
%     try
%         EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath);
%         ALLEEG = [ALLEEG EEG];
%     catch ME
%         missing{counter} = eegs{index};
%         conter = counter + 1;
%         continue
%     end
% end
% eeglab redraw;
% 
% 
% EEG3 = EEG;
% EEG3 = pop_select( EEG3, 'nochannel',{'EKG'});
% EEG3 = pop_reref( EEG3, [find(strcmp({EEG3.chanlocs.labels}, 'TP9')) find(strcmp({EEG3.chanlocs.labels}, 'TP10'))] );
% eegplot(EEG3.data, 'srate', EEG3.srate, 'title', EEG3.setname, 'eloc_file', EEG3.chanlocs, 'events', EEG3.event);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

cortar = [
   


330 390


];

% Recorta el segmento para el minuto
EEG2 = pop_select( EEG, 'time', cortar );
EEG2 = eeg_checkset( EEG2 );

% Guarda en la carpeta con los minutos recortados
EEG2 = pop_saveset( EEG2, 'filename', EEG.setname ,'filepath', minute); 
% Guarda en directorio objetivo
EEG2 = pop_saveset( EEG2, 'filename', EEG.setname ,'filepath', target_path); 

% Agrega el evento al EEG completo para el minuto
EEG = pop_editeventvals(EEG,'append',{1,[],[],[],[],[]},'changefield',{2,'latency',cortar(1)},'changefield',{2,'type','1 minuto'});
EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', event_path); 
try
    counter = CURRENTSET + 1;
    EEG = ALLEEG(counter);
    CURRENTSET = counter;
    eeglab redraw
%     pop_eegplot( EEG, 1, 1, 1);
    EEG3 = EEG;
    EEG3 = pop_select( EEG3, 'nochannel',{'EKG'});
    EEG3 = pop_reref( EEG3, [find(strcmp({EEG3.chanlocs.labels}, 'TP9')) find(strcmp({EEG3.chanlocs.labels}, 'TP10'))] );
    eegplot(EEG3.data, 'srate', EEG3.srate, 'title', EEG3.setname, 'eloc_file', EEG3.chanlocs, 'events', EEG3.event);
catch ME
    disp(">> No hay más eegs");
end




