% for i = 41:length(ALLEEG)
%     pop_eegplot( ALLEEG(i), 1, 1, 1);
% end
% EEG2 = pop_reref( EEG, [find(strcmp({EEG.chanlocs.labels}, 'TP9')) find(strcmp({EEG.chanlocs.labels}, 'TP10'))] );
% pop_eegplot( EEG2, 1, 1, 1);
% original_filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles';
% clean_filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios';
% cd(original_filepath)
% eegs = dir('*.set');
% eegs = {eegs.name}';
% cd(clean_filepath)
% eegs_clean = dir('*.set');
% eegs_clean = {eegs_clean.name}';
% eegs = setdiff(eegs, eegs_clean)

% load_eeg = {
% '29474970.set'
% '30648088.set'
% '30734981.set'
% '31041338.set'
% '32406969.set'
% '32925323.set'
% '40684765.set'
% '42258623.set'
% '42978496.set'
% '43693432.set'
% '44147956.set'
% };
% EEG = pop_loadset('filename',load_eeg,'filepath','E:\\Investigacion\\Cefalea\\Trabajos\\Respuesta H\\EEG\\Controles\\');
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'study',0); eeglab redraw


targetpath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios';
filename = EEG.setname;
comps = [
    





];

% Backup.
EEG.original_EEG = EEG;
EEG.original_EEG.rejected_components = comps;

EEG = pop_subcomp( EEG, comps, 0);
EEG = pop_select( EEG, 'nochannel',{'EKG'});

EEG.setname = filename;
EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', targetpath); 
try
    CURRENTSET = CURRENTSET + 1;
    EEG = ALLEEG(CURRENTSET);
    eeglab redraw;
    EEG = pop_iclabel(EEG, 'default');
%     pop_eegplot( EEG, 1, 1, 1);
    pop_viewprops(EEG, 0, [1:size(EEG.etc.ic_classification.ICLabel.classifications, 1)], 'IClabel' );
    pop_subcomp(EEG) % Para ver la ventana para rechazar ICs.
catch ME
    disp("Insertar mas EEGs");
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    eeglab redraw;
end





