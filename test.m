filepath = 'E:\Investigacion\EEG\EEG procesados\Migrañosos\Limpios\1 minuto';
filepath = strcat(filepath, '\');

cd(filepath);

eegs = dir();
eegs = eegs([eegs.isdir]);
eegs(ismember( {eegs.name}, {'.', '..'})) = [];
eegs = {eegs.name}';

eeglab;

% for index = 1:length(eegs)
%    eeg_folder = strcat( filepath, eegs{index}, '\');
    eeg_folder = strcat( filepath, eegs{counter}, '\');
    cd(eeg_folder);
    tmp_eegs = dir('*.set');
    tmp_eegs = {tmp_eegs.name};
    ALLEEG = [];
    for eeg_index = 1:length(tmp_eegs)
       EEG = pop_loadset('filename', tmp_eegs{eeg_index}, 'filepath', eeg_folder);
       EEG = pop_select( EEG, 'nochannel',{'AF9h','AF10h', 'EKG'});
       EEG = pop_reref( EEG, [20 21] );
       eegplot(EEG.data, 'srate', EEG.srate, 'winlength', [10], 'title', EEG.filename, 'eloc_file', EEG.chanlocs ); 
       ALLEEG = [ALLEEG EEG];
    end
    eeglab redraw;
    counter = counter + 1;
% end

