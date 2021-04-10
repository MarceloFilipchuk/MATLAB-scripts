filepath = 'E:\Investigacion\EEG\EEG procesados\Migrañosos\Limpios';
target_folder = '1 minuto';
target_path = strcat(filepath, '\', target_folder, '\');

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
'16561154.set'
'22672559.set'
'23021007.set'
'23267975.set'
'24671814.set'
'26636248.set'
'26681314.set'
'27065788.set'
'29166639.set'
'29253079.set'
'30900116.set'
'31337569.set'
'31921461.set'
'33387926.set'
'33437020.set'
'33700358.set'
'34839043.set'
'35109977.set'
'37126067.set'
'39546581.set'
'39733285.set'
'40506862.set'
'41268250.set'
'42637732.set'
'42642102.set'
'42782803.set'
'43143194.set'
'43673629.set'
'44677571.set'
'45090150.set'
'46374112.set'
'28127064.set'
'30330962.set'
'26790006.set'
'95760930.set'
'17842655.set'
'36131374.set'
'45487927.set'
'33437628.set'
'39693608.set'
'41680083.set'
'40026470.set'
'29712356.set'
'29154320.set'
'26903214.set'
'30628863.set'
'30661493.set'
'45936466.set'
'39073136.set'
'25736769.set'
'21139530.set'
'29476363.set'
'30123167.set'
};

% Recorta los EEGs que no estan en la lista de los ya recortados.
eegs = setdiff(eegs, finished_eegs);

eeglab;
for index = 1:length(eegs)
    EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath);
    FE_Hresponse = any(strcmp({EEG.event(:).type}, 'PHOTO 8Hz'));
    FE_epilepsy = any(strcmp({EEG.event(:).type}, 'PHOTO 3Hz'));
    
%     if any(length(EEG.event(strcmp({EEG.event(:).type}, 'PHOTO 6Hz'))) > 1) || any(length(EEG.event(strcmp({EEG.event(:).type}, 'PHOTO 3Hz'))) > 1)
%         if FE_Hresponse 
%             for lenindex = 1:length(EEG.event(strcmp({EEG.event(:).type}, 'PHOTO 6Hz')))
%                 EEG = pop_select(EEG, 'time', [EEG.event(strcmp({EEG.event(:).type}, 'PHOTO 6Hz')).latency/200 (100 + 180)]);
%             end
%         elseif FE_epilepsy
%             EEG = pop_select( EEG, 'time',[{EEG.event(strcmp({EEG.event(:).type}, 'PHOTO 6Hz')).latency/200 (315 + 180)}]);
%         end
%     end
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

%     counter = 0;
    eeg_folder = strcat(target_path, EEG.setname, '\');
    if ~exist(eeg_folder, 'dir')
        mkdir(eeg_folder);
    end
    
    saved_A = [];
    for event_index = 1:length(EEG.event)
        if strcmp(EEG.event(event_index).type, 'Ojos abiertos') || strcmp(EEG.event(event_index).type, 'boundary')
            len = EEG.event(event_index).latency/200;
            
            dentroDeFE = false;
            % Define si el segmento va a estar dentro de la fotoestimulacion o sus 3 minutos posteriores.
            for tindex = 1:size(FE, 1)
                if FE{tindex,1} <= len && len <= FE{tindex,2}
                    dentroDeFE = true;
                    break
                end
            end
            
            if ~dentroDeFE % Hace esto solo si el segmento no esta dentro o cerca de la fotoestimulacion.
                EEG2 = pop_select( EEG, 'time',[len (len + 60.2)] );
                if length(EEG2.event) == 1 && EEG2.xmax >= 60
                    EEG2.event(2).type = '1 minuto';
                    EEG2.event(2).duration = 0;
                    EEG2.event(2).timestamp = 0;
                    EEG2.event(2).latency = 0;
                    EEG2.event(2).urevent = [];

                    % Calcula el poder del segmento (EXPERIMENTAL).
                    [spectra, freqs] = pop_spectopo(EEG2, 1, [EEG2.xmin  EEG2.xmax*1000], 'EEG' , 'percent', 100, 'freqrange',[1 100],...
                    'plot', 'off','plotchans', [find(strcmp({EEG2.chanlocs(:).labels}, 'O1')), find(strcmp({EEG2.chanlocs(:).labels}, 'O2'))]);
                    spectra = mean(spectra); % Calcula media de poder de O1 y O2.

                    % delta=1-3, theta=4-7, alpha=8-12, beta=13-24, gamma=25-100
                    deltaIdx = find(freqs>=1 & freqs<=3);
                    thetaIdx = find(freqs>=4 & freqs<=7);
                    alphaIdx = find(freqs>=8 & freqs<=12);
                    betaIdx  = find(freqs>=12 & freqs<=24);
                    gammaIdx = find(freqs>=25 & freqs<=100);
                    musckeIdx = find(freqs>=20 & freqs<=40);

                    % compute absolute power
                    deltaPower = mean(10.^(spectra(deltaIdx)/10));
                    thetaPower = mean(10.^(spectra(thetaIdx)/10));
                    alphaPower = mean(10.^(spectra(alphaIdx)/10));
                    betaPower  = mean(10.^(spectra(betaIdx)/10));
                    gammaPower = mean(10.^(spectra(gammaIdx)/10));
                    %%%%%%%%%%%%%%%%%

                    % Poder relativo
                    totalRelativePower = deltaPower + thetaPower + alphaPower + betaPower + gammaPower;
                    relDelta = deltaPower / totalRelativePower;
                    relTheta = thetaPower / totalRelativePower;
                    relAlpha = alphaPower / totalRelativePower;
                    relBeta = betaPower / totalRelativePower;
                    relGamma = gammaPower / totalRelativePower;

                    relPower = {{'Delta'} {'Theta'} {'Alpha'} {'Beta'} {'Gamma low'} {'Total'}};
                    relPower{2,1} = relDelta;
                    relPower{2,2} = relTheta;
                    relPower{2,3} = relAlpha;
                    relPower{2,4} = relBeta;
                    relPower{2,5} = relGamma;
                    relPower{2,6} = totalRelativePower/totalRelativePower;
                    
%                     if relAlpha >= 0.50
%                         EEG2 = pop_saveset( EEG2, 'filename', strcat(EEG2.setname, '-', int2str(counter)) ,'filepath', eeg_folder);
                        saved_A = [ saved_A EEG2 ]; %#ok<*AGROW>
%                         counter = counter + 1;
%                     end
                end
            end
        end
    end
    saved_B = [];
    % Si originalmente no se logran conseguir 5 EEGs, busca a partir del primero evento todos aquellas epocas que sean de un
    % minuto y sin eventos de por medio.
    if length(saved_A) <= 3
        counter = 0;
        for event_index = 1:length(EEG.event)
            if strcmp(EEG.event(event_index).type, 'Ojos abiertos') || strcmp(EEG.event(event_index).type, 'boundary')
                len = EEG.event(event_index).latency/200 + 60;
%                 len = EEG.event(event_index).latency/200;
                while counter < 5 
                    EEG2 = pop_select( EEG, 'time',[len (len + 60.2)] );
                    % Si llega el fin del EEG sale del loop.
                    if EEG2.xmax < 60
                        break
                    end
                    % Define si el segmento va a estar dentro de la fotoestimulacion o sus 3 minutos posteriores.
                    dentroDeFE = false;
                    for tindex = 1:size(FE, 1)
                        if FE{tindex,1} <= len && len <= FE{tindex,2}
                            dentroDeFE = true;
                            break
                        end
                    end
                    if ~dentroDeFE && length(EEG2.event) == 1 % Hace esto solo si el segmento no esta dentro o cerca de la fotoestimulacion.
                        EEG2.event(2).type = '1 minuto';
                        EEG2.event(2).duration = 0;
                        EEG2.event(2).timestamp = 0;
                        EEG2.event(2).latency = 0;
                        EEG2.event(2).urevent = [];

                        % Calcula el poder del segmento (EXPERIMENTAL).
                        [spectra, freqs] = pop_spectopo(EEG2, 1, [EEG2.xmin  EEG2.xmax*1000], 'EEG' , 'percent', 100, 'freqrange',[1 100],...
                        'plot', 'off','plotchans', [find(strcmp({EEG2.chanlocs(:).labels}, 'O1')), find(strcmp({EEG2.chanlocs(:).labels}, 'O2'))]);
                        spectra = mean(spectra); % Calcula media de poder de O1 y O2.

                        % delta=1-3, theta=4-7, alpha=8-12, beta=13-24, gamma=25-100
                        deltaIdx = find(freqs>=1 & freqs<=3);
                        thetaIdx = find(freqs>=4 & freqs<=7);
                        alphaIdx = find(freqs>=8 & freqs<=12);
                        betaIdx  = find(freqs>=12 & freqs<=24);
                        gammaIdx = find(freqs>=25 & freqs<=100);

                        % compute absolute power
                        deltaPower = mean(10.^(spectra(deltaIdx)/10));
                        thetaPower = mean(10.^(spectra(thetaIdx)/10));
                        alphaPower = mean(10.^(spectra(alphaIdx)/10));
                        betaPower  = mean(10.^(spectra(betaIdx)/10));
                        gammaPower = mean(10.^(spectra(gammaIdx)/10));
                        %%%%%%%%%%%%%%%%%

                        % Poder relativo
                        totalRelativePower = deltaPower + thetaPower + alphaPower + betaPower + gammaPower;
                        relDelta = deltaPower / totalRelativePower;
                        relTheta = thetaPower / totalRelativePower;
                        relAlpha = alphaPower / totalRelativePower;
                        relBeta = betaPower / totalRelativePower;
                        relGamma = gammaPower / totalRelativePower;

                        relPower = {{'Delta'} {'Theta'} {'Alpha'} {'Beta'} {'Gamma'} {'Total'}};
                        relPower{2,1} = relDelta;
                        relPower{2,2} = relTheta;
                        relPower{2,3} = relAlpha;
                        relPower{2,4} = relBeta;
                        relPower{2,5} = relGamma;
                        relPower{2,6} = totalRelativePower/totalRelativePower;
                        
%                         if relAlpha >= 0.5
%                             EEG2 = pop_saveset( EEG2, 'filename', strcat(EEG2.setname, '-', int2str(counter)) ,'filepath', eeg_folder);
                            counter = counter + 1;
                            saved_B = [ saved_B EEG2 ]; %#ok<*AGROW>
%                         end
                    end
                    len = len + 60;
                end
            end
        end    
    end
    counter = 0;
    saved = [];
    for kindex = 1:length(saved_A)
        for jindex = 1:length(saved_B)
            if isequal(saved_A(kindex).data(:,:), saved_B(jindex).data(:,:))
                saved_A(kindex) = [];
            end
        end
    end
    saved = [saved_A, saved_B];
    for sindex = 1:length(saved)
        EEG2 = pop_saveset( saved(sindex), 'filename', strcat(saved(sindex).setname, '-', int2str(counter)) ,'filepath', eeg_folder);
        counter = counter+1;
    end
end
eeglab redraw
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');