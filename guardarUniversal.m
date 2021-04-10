% Direccion de la carpeta donde se guardan los archivos post script.
target_path = 'E:\Investigacion\EEG\EEG procesados\Migrañosos';
target_path = strcat(target_path, '\');

% Nombre de la carpeta con los EEGs ya limpios.
target_folder_clean = 'Limpios';

% Direccion donde estan los EEGs ya limpios.
target_path_clean = strcat(target_path, target_folder_clean, '\');

control = contains(upper(target_path), upper('control'));

% Guarda el EEG.
if control
    EEG = rmfield(EEG, 'old_EKG'); % EEG.data(24,:) = EEG.old_EKG(:); eeglab redraw;
end
EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', target_path_clean);
disp(strcat(">> Terminado ", EEG.setname));
newset = CURRENTSET + 1;
delete(strcat(target_path, EEG.filename))

try
    EEG = ALLEEG(newset); 
    CURRENTSET = newset;
    eeglab redraw
    pop_eegplot( EEG, 1, 1, 1);
catch ME
    disp(">> Insertar más set de datos");
end