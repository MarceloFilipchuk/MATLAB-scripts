% Revisa si tiene protocolo de respuesta H
final = {};


filepath_control = 'E:\Investigacion\EEG\NORMALES - CONTROL\RESPUESTA H\EEG';

eeg_control = {   
'44475407.edf'
'43229539.edf'
'42915383.edf'
'44672913.edf'
'42978496.edf'
'41736145.edf'
'42979246.edf'
'36447393.edf'
'36239102.edf'
'33380758.edf'
'32683626.edf'
'32875324.edf'
'32925323.edf'
'30648088.edf'
'31041338.edf'
'27549509.edf'
};


filepath_mig = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG';
eeg_mig = {
'45693186.edf'
'43926390.edf'
'43143713.edf'
'42642102.edf'
'41440670.edf'
'39546581.edf'
'36142459.edf'
'35915823.edf'
'34989974.edf'
'33700358.edf'
'31921461.edf'
'32281962.edf'
'31337569.edf'
'29712356.edf'
'28456579.edf'
'29275688.edf'
'45090150.edf'
'45936466.edf'
'44273002.edf'
'43143194.edf'
'40506862.edf'
'41680083.edf'
'39736478.edf'
'37107273.edf'
'95926170.edf'
'33437020.edf'
'33437628.edf'
'33029169.edf'
'95760930.edf'
'30469404.edf'
'30971218.edf'
'26790006.edf'
};

filepath_eegs = {filepath_control, eeg_control;
    filepath_mig, eeg_mig};
counter = 1;

eeglab
for path_index = 1:size(filepath_eegs, 1)
    
    filepath = filepath_eegs{path_index,1};
    eegs = filepath_eegs{path_index, 2};
    
    cd(filepath);
    for index = 1:length(eegs)
        try 
            filename = extractBefore(eegs{index}, '.edf');
            EEG = pop_fileio(eegs{index}, 'dataformat','auto');
            % Elimina los espacios en blanco de las etiquetas de los eventos.
            for l = 1:length(EEG.event)
                EEG.event(l).type = strtrim(EEG.event(l).type);
            end
            EEG = eeg_checkset( EEG );

            EOG_chan = any(strcmp({EEG.chanlocs(:).labels},'PG1')) || any(strcmp({EEG.chanlocs(:).labels},'PG2'));
            H_protocol = any(strcmp({EEG.event(:).type},'PHOTO 10Hz'));

            final{counter, 1} = filename; % DNI
            if EOG_chan % Tiene canales EOG
                final{counter, 2} = 'EOG_true';
            else
                final{counter, 2} = 'EOG_FALSE';
            end
            if H_protocol
                final{counter, 3} = 'H_protocol_true';
            else
                final{counter, 3} = 'H_protocol_FALSE';
            end
        catch ME
            % Poner missing en la celda final
            final{counter, 1} = 'MISSING';
            continue
        end
        counter = counter + 1;
    end
end
    