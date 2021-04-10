% filepath = 'E:\Investigacion\EEG\EEG procesados\Migrañosos\Limpios';
% target_folder = '1 minuto';
% target_path = strcat(filepath, '\', target_folder, '\');
% 
% if ~exist(target_path, 'dir')
%     mkdir(target_path);
% end
% 
% % Lista de EEGs ya recortados.
% finished_eegs_filepath = 'E:\Investigacion\Cefalea\Investigacion\QEEG\EEG\Migrañosos';
% cd(finished_eegs_filepath);
% finished_eegs = dir('*.set');
% finished_eegs = {finished_eegs.name}';
% 
% finished_eegs_2_filepath = strcat(filepath, '\', 'Con eventos');
% if ~exist(finished_eegs_2_filepath, 'dir')
%     mkdir(finished_eegs_2_filepath);
% end
% cd(finished_eegs_2_filepath);
% finished_eegs_2 = dir('*.set');
% finished_eegs_2 = {finished_eegs_2.name}';
% 
% finished_eegs = [finished_eegs; finished_eegs_2];
% 
% eegs = {
% '16561154.set'
% '22672559.set'
% '23021007.set'
% '23267975.set'
% '24671814.set'
% '26636248.set'
% '26681314.set'
% '27065788.set'
% '29166639.set'
% '29253079.set'
% '30900116.set'
% '31337569.set'
% '31921461.set'
% '33387926.set'
% '33437020.set'
% '33700358.set'
% '34839043.set'
% '35109977.set'
% '37126067.set'
% '39546581.set'
% '39733285.set'
% '40506862.set'
% '41268250.set'
% '42637732.set'
% '42642102.set'
% '42782803.set'
% '43143194.set'
% '43673629.set'
% '44677571.set'
% '45090150.set'
% '46374112.set'
% '28127064.set'
% '30330962.set'
% '26790006.set'
% '95760930.set'
% '17842655.set'
% '36131374.set'
% '45487927.set'
% '33437628.set'
% '39693608.set'
% '41680083.set'
% '40026470.set'
% '29712356.set'
% '29154320.set'
% '26903214.set'
% '30628863.set'
% '30661493.set'
% '45936466.set'
% '39073136.set'
% '25736769.set'
% '21139530.set'
% '29476363.set'
% '30123167.set'
% };
% % Recorta los EEGs que no estan en la lista de los ya recortados.
% eegs = setdiff(eegs, finished_eegs);
% 
% eeglab
% for index = 1:length(eegs)
%     EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath);
%     ALLEEG = [ALLEEG EEG];
% end
% eeglab redraw;

cortar = [
   




998 1058
 

];

event_path = 'E:\Investigacion\EEG\EEG procesados\Migrañosos\Limpios\Con eventos';

filepath = 'E:\Investigacion\EEG\EEG procesados\Migrañosos\Limpios';

target_path = strcat(filepath, '\', '1 minuto');
if ~exist(target_path, 'dir')
    mkdir(target_path);
end

EEG2 = pop_select( EEG, 'time', cortar );
EEG2 = eeg_checkset( EEG2 );
EEG2 = pop_saveset( EEG2, 'filename', EEG.setname ,'filepath', target_path);

EEG = pop_editeventvals(EEG,'append',{1,[],[],[],[],[]},'changefield',{2,'latency',cortar(1)},'changefield',{2,'type','1 minuto'});
EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', event_path);
try
    counter = CURRENTSET + 1;
    EEG = ALLEEG(counter);
    CURRENTSET = counter;
    eeglab redraw
    pop_eegplot( EEG, 1, 1, 1);
catch ME
    disp(">> No hay más eegs");
end




