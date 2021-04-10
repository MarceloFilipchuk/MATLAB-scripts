filepath = 'E:\Investigacion\EEG\EEG procesados\Migrañosos\Limpios';
target_folder = '1 minuto';
target_path = strcat(filepath, '\', target_folder, '\');

filepath_event = strcat(filepath, '\Con eventos\');
if ~exist(filepath_event, 'dir')
    mkdir(filepath_event);
end

if ~exist(target_path, 'dir')
    mkdir(target_path);
end

% Lista de EEGs ya recortados.
finished_eegs_filepath = 'E:\Investigacion\Cefalea\Investigacion\QEEG\EEG\Migrañosos';
cd(finished_eegs_filepath);
finished_eegs = dir('*.set');
finished_eegs = {finished_eegs.name}';

% EEGs a recortar.
% cd(filepath);
% eegs = dir('*.set');
% eegs = {eegs.name}';
eegs = {
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
'30123167.set'
};

% Recorta los EEGs que no estan en la lista de los ya recortados.
eegs = setdiff(eegs, finished_eegs);

eeglab;
for index = 1:length(eegs)
    EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath);
    FE_Hresponse = any(strcmp({EEG.event(:).type}, 'PHOTO 8Hz'));
    FE_epilepsy = any(strcmp({EEG.event(:).type}, 'PHOTO 3Hz'));
    
    % Tiempo extra a dejar pasar post fotoestimulacion (en segundos)
    extraTime = 180;
    if FE_Hresponse
        % Segundos a los que comienza cada fotoestimulacion (en caso de haber varias)
        FE = {EEG.event((strcmp({EEG.event(:).type}, 'PHOTO 6Hz'))).latency}';
        for findex = 1:size(FE, 1)
            FE{findex,1} = FE{findex,1} / 200; % Corrige diviendo por la tasa de muestreo para obtener los segundos del evento.
            FE{findex, 2} = FE{findex, 1} + 100 + extraTime;
        end
    elseif FE_epilepsy
        FE = {EEG.event((strcmp({EEG.event(:).type}, 'PHOTO 3Hz'))).latency}';
        for findex = 1:size(FE, 1)
            FE{findex,1} = FE{findex,1} / 200; % Corrige diviendo por la tasa de muestreo para obtener los segundos del evento.
            FE{findex, 2} = FE{findex, 1} + 315 + extraTime;
        end
    end

    
    eeg_folder = strcat(target_path, EEG.setname, '\');
    if ~exist(eeg_folder, 'dir')
        mkdir(eeg_folder);
    end
    
    counter = 0;
    for event_index = 1:length(EEG.event)
        if strcmp(EEG.event(event_index).type, 'Ojos abiertos') || strcmp(EEG.event(event_index).type, 'boundary')
            len = EEG.event(event_index).latency/200;
            
            % Define si el segmento va a estar dentro de la fotoestimulacion o sus 3 minutos posteriores.
            dentroDeFE = false;
            for tindex = 1:size(FE, 1)
                if FE{tindex,1} <= len && len <= FE{tindex,2}
                    dentroDeFE = true;
                    break
                end
            end
            
            if ~dentroDeFE % Hace esto solo si el segmento no esta dentro o cerca de la fotoestimulacion.
                EEG2 = pop_select( EEG, 'time', [len len+60.2] );
                if length(EEG2.event) == 1 && EEG2.xmax >= 60.1
                    EEG2.event(2).type = '1 minuto';
                    EEG2.event(2).duration = 0;
                    EEG2.event(2).timestamp = 0;
                    EEG2.event(2).latency = 0;
                    EEG2.event(2).urevent = [];
                    
                    tmp_name = strcat(EEG2.setname, '-', int2str(counter));
                    EEG = pop_editeventvals(EEG,'append',{1,[],[],[],[],[]},'changefield',{2,'latency',len},'changefield',{2,'type',tmp_name});
                    EEG2 = pop_saveset( EEG2, 'filename', tmp_name ,'filepath', eeg_folder);
                    counter = counter + 1;
                end
            end
        end
    end
    
    EEG = pop_saveset( EEG, 'filename', EEG.setname, 'filepath', filepath_event);
    EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath_event);
    
    % Recorta 60 segundos despues de cada evento.
    for event_index = 1:length(EEG.event)
        if strcmp(EEG.event(event_index).type, 'Ojos abiertos') || strcmp(EEG.event(event_index).type, 'boundary')
            disp(event_index);
            len = EEG.event(event_index).latency/200 + 70;
            
            % Define si el segmento va a estar dentro de la fotoestimulacion o sus 3 minutos posteriores.
            dentroDeFE = false;
            for tindex = 1:size(FE, 1)
                if FE{tindex,1} <= len && len <= FE{tindex,2}
                    dentroDeFE = true;
                    break
                end
            end
            
            if ~dentroDeFE % Hace esto solo si el segmento no esta dentro o cerca de la fotoestimulacion.
                EEG2 = pop_select( EEG, 'time',[len len+60.2] );
                if length(EEG2.event) == 1 && EEG2.xmax >= 60.1
                    EEG2.event(2).type = '1 minuto';
                    EEG2.event(2).duration = 0;
                    EEG2.event(2).timestamp = 0;
                    EEG2.event(2).latency = 0;
                    EEG2.event(2).urevent = [];
                    
                    tmp_name = strcat(EEG2.setname, '-', int2str(counter));
                    EEG = pop_editeventvals(EEG,'append',{1,[],[],[],[],[]},'changefield',{2,'latency',len},'changefield',{2,'type',tmp_name});
                    EEG2 = pop_saveset( EEG2, 'filename', tmp_name ,'filepath', eeg_folder);
                    counter = counter + 1;
                else
                    while true %length(EEG2.event) ~= 1 && EEG2.xmax < 60.1
                        len = len + 10;
                        disp("LEN");disp(len);
                        EEG2 = pop_select( EEG, 'time',[len len+60.2] );
                        % Define si el segmento va a estar dentro de la fotoestimulacion o sus 3 minutos posteriores.
                        dentroDeFE = false;
                        for tindex = 1:size(FE, 1)
                            if FE{tindex,1} <= len && len <= FE{tindex,2}
                                dentroDeFE = true;
                                break
                            end
                        end
                        if EEG2.xmax < 60.1 && length(EEG2.event) ~= 1
                            break
                        elseif dentroDeFE
                            continue
                        else
                            EEG2.event(2).type = '1 minuto';
                            EEG2.event(2).duration = 0;
                            EEG2.event(2).timestamp = 0;
                            EEG2.event(2).latency = 0;
                            EEG2.event(2).urevent = [];

                            tmp_name = strcat(EEG2.setname, '-', int2str(counter));
                            EEG = pop_editeventvals(EEG,'append',{1,[],[],[],[],[]},'changefield',{2,'latency',len},'changefield',{2,'type',tmp_name});
                            EEG2 = pop_saveset( EEG2, 'filename', tmp_name ,'filepath', eeg_folder);
                            counter = counter + 1;
                            break
                        end
                    end
                end
            end
        end
    end
    
    EEG = pop_saveset( EEG, 'filename', EEG.setname, 'filepath', filepath_event);
    EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath_event);
    
    % Si originalmente no se logran conseguir 4 EEGs, busca a partir del primero evento + 60 segundos todos aquellas epocas 
    % que sean de un minuto y sin eventos de por medio.
    if counter < 3
        for event_index = 1:length(EEG.event)
            if strcmp(EEG.event(event_index).type, 'Ojos abiertos') || strcmp(EEG.event(event_index).type, 'boundary')
                len = EEG.event(event_index).latency/200 + 140;
                % Define si el segmento va a estar dentro de la fotoestimulacion o sus 3 minutos posteriores.
                dentroDeFE = false;
                for tindex = 1:size(FE, 1)
                    if FE{tindex,1} <= len && len <= FE{tindex,2}
                        dentroDeFE = true;
                        break
                    end
                end
            end
            if ~dentroDeFE % Hace esto solo si el segmento no esta dentro o cerca de la fotoestimulacion.
                EEG2 = pop_select( EEG, 'time',[len len+60.2] );
                if length(EEG2.event) == 1 && EEG2.xmax >= 60.1
                    EEG2.event(2).type = '1 minuto';
                    EEG2.event(2).duration = 0;
                    EEG2.event(2).timestamp = 0;
                    EEG2.event(2).latency = 0;
                    EEG2.event(2).urevent = [];
                    
                    tmp_name = strcat(EEG2.setname, '-', int2str(counter));
                    EEG = pop_editeventvals(EEG,'append',{1,[],[],[],[],[]},'changefield',{2,'latency',len},'changefield',{2,'type',tmp_name});
                    counter = counter + 1;
                    len = len + 61;
                end
                while counter < 5
                    len = len + 10;
                    EEG2 = pop_select( EEG, 'time',[len len+60.2] );
                    % Define si el segmento va a estar dentro de la fotoestimulacion o sus 3 minutos posteriores.
                    dentroDeFE = false;
                    for tindex1 = 1:size(FE, 1)
                        if FE{tindex1,1} <= len && len <= FE{tindex1,2}
                            dentroDeFE = true;
                            break
                        end
                    end
                    if EEG2.xmax < 60.1 || counter == 5 || length(EEG2.event) ~= 1
                        break
                    elseif dentroDeFE
                        continue
                    else
                        EEG2.event(2).type = '1 minuto';
                        EEG2.event(2).duration = 0;
                        EEG2.event(2).timestamp = 0;
                        EEG2.event(2).latency = 0;
                        EEG2.event(2).urevent = [];

                        tmp_name = strcat(EEG2.setname, '-', int2str(counter));
                        EEG = pop_editeventvals(EEG,'append',{1,[],[],[],[],[]},'changefield',{2,'latency',len},'changefield',{2,'type',tmp_name});
                        EEG2 = pop_saveset( EEG2, 'filename', tmp_name ,'filepath', eeg_folder);
                        len = len + 62;
                        counter = counter + 1;
                        break
                    end
                end
            end
        end
    end
    EEG = pop_saveset( EEG, 'filename', EEG.setname, 'filepath', filepath_event);
end
eeglab redraw
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');