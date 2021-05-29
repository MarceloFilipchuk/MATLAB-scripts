filepath = 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Migrañosos\AVG - Solo ICA\Limpios por ICA modificado';
filename = EEG.setname;
comps = [
    

13 16


];

EEG = pop_subcomp( EEG, comps, 0);
% EEG.original_EEG.rejected_components = [ EEG.original_EEG.rejected_components comps]; 
% EEG.original_EEG.rejected_components = sort(EEG.original_EEG.rejected_components);
EEG.setname = filename;
EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', filepath); 
try
    CURRENTSET = CURRENTSET + 1;
    EEG = ALLEEG(CURRENTSET);
    eeglab redraw;
    EEG = pop_iclabel(EEG, 'default');
    pop_eegplot( EEG, 1, 1, 1);
    pop_viewprops(EEG, 0, [1:size(EEG.etc.ic_classification.ICLabel.classifications, 1)], 'IClabel' );
catch ME
    disp("Insertar mas EEGs");
end

% 39546581 45936466

% for i = 41:length(ALLEEG)
%     pop_eegplot( ALLEEG(i), 1, 1, 1);
% end

% EEG2 = pop_reref( EEG, [find(strcmp({EEG.chanlocs.labels}, 'TP9')) find(strcmp({EEG.chanlocs.labels}, 'TP10'))] );
% pop_eegplot( EEG2, 1, 1, 1);
