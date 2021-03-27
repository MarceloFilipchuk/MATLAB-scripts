cortar = [
   

310 370


];
 
EEG = pop_select( EEG, 'time', cortar );
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', target_path);

try
    counter = CURRENTSET + 1;
    EEG = ALLEEG(counter);
    CURRENTSET = counter;
    eeglab redraw
    pop_eegplot( EEG, 1, 1, 1);
catch ME
    disp(">> No hay más eegs");
end


