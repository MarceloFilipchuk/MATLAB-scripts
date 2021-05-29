filepath = 'E:\Investigacion\Cefalea\Investigacion\QEEG\EEG\Migrañosos';  %'E:\Investigacion\EEG\EEG procesados\Migrañosos\Limpios\1 minuto'; % 
   

target_folder = 'Episodicos sin aura';
target_path = strcat('E:\Investigacion\EEG\EEG procesados\Migrañosos\Limpios\1 minuto', '\', target_folder);
if ~exist(target_path, 'dir')
    mkdir(target_path);
end

% Lista de EEGs ya recortados.

cd(target_path);
finished_eegs = dir('*.set');
finished_eegs = {finished_eegs.name}';

eegs = {
'45090150.set'
'43143194.set'
'40506862.set'
'39693608.set'
'39073136.set'
'33437020.set'
'95760930.set'
'45936466.set'
'41680083.set'
'33437628.set'
'26790006.set'
'44273002.set'
'40026470.set'
'37107273.set'
'37732352.set'
'95926170.set'
'33029169.set'
'30469404.set'
'30971218.set'
'28655843.set'
'25921670.set'
'29136654.set'
'21628054.set'
'42783515.set'
'13153801.set'
'44677571.set'
'46374112.set'
'45487927.set'
'43926390.set'
'42642102.set'
'39546581.set'
'34839043.set'
'35064083.set'
'33700358.set'
'31921461.set'
'31337569.set'
'29712356.set'
'29154320.set'
'24671814.set'
'16561154.set'
'45693186.set'
'43143713.set'
'41440670.set'
'36142459.set'
'35915823.set'
'34989974.set'
'32281962.set'
'31058058.set'
'29275688.set'
'28456579.set'
'43604422.set'
'39057518.set'
'36802064.set'
'34070751.set'
'34455144.set'
'30844130.set'
'30122613.set'
'28357169.set'
'28127064.set'
'26089010.set'
'24196666.set'
'24014278.set'
'24367434.set'
'23231229.set'
'29606275.set'
'17004849.set'
'17384808.set'
'25455720.set'
'28374342.set'
'26903214.set'
'22672559.set'
'24457312.set'
'26681314.set'
'32354708.set'
'23419359.set'

};

% Busca los EEGs que no estan en la lista de los ya recortados.
eegs = setdiff(eegs, finished_eegs);

eeglab
% for findex = 1:length(filepath) % Itera sobre directorios con eeg.
    for index = 1:length(eegs) % Itera sobre la lista de eegs
        try
            EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath ); %{findex});
            EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', target_path);
        catch ME
            continue
        end
    end
% end




