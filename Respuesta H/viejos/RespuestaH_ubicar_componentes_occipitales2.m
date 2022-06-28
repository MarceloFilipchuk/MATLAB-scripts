filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios\Rereferenciados + ICA';
cd(filepath);
% Array vacio.
% test = struct('eeg', {});

% Lista a procesar
eegs = {
{ '27549509.set', 'H', 'PHOTO 10Hz', 'PHOTO 18Hz' }
{ '27867986.set', 'H', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '29474970.set', 'N', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '30648088.set', 'N', 'PHOTO 10Hz', 'PHOTO 18Hz' }
{ '30734981.set', 'N', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '31041338.set', 'H', 'PHOTO 10Hz', 'PHOTO 22Hz' }
{ '32099772.set', 'N', 'PHOTO 10Hz', 'PHOTO 18Hz' }
{ '32406969.set', 'H', 'PHOTO 12Hz', 'PHOTO 18Hz' }
{ '32683626.set', 'H', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '32875324.set', 'N', 'PHOTO 10Hz', 'PHOTO 22Hz' }
{ '32925323.set', 'H', 'PHOTO 12Hz', 'PHOTO 18Hz' }
{ '33380758.set', 'H', 'PHOTO 10Hz', 'PHOTO 20Hz' }
{ '36239102.set', 'N', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '36447393.set', 'N', 'PHOTO 12Hz', 'PHOTO 18Hz' }
{ '40684765.set', 'N', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '41736145.set', 'N', 'PHOTO 12Hz', 'PHOTO 20Hz' }
{ '42258623.set', 'H', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '42915383.set', 'N', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '42978496.set', 'N', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '42979246.set', 'N', 'PHOTO 10Hz', 'PHOTO 18Hz' }
{ '43229539.set', 'N', 'PHOTO 10Hz', 'PHOTO 20Hz' }
{ '43693432.set', 'N', 'PHOTO 8Hz', 'PHOTO 24Hz' }
{ '44147956.set', 'H', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '44475407.set', 'H', 'PHOTO 10Hz', 'PHOTO 18Hz' }
{ '44672913.set', 'H', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '44684723.set', 'N', 'PHOTO 10Hz', 'PHOTO 16Hz' }
};
eeglab

for index = 1:size(eegs, 1)
    try
        % Carga el EEG
        EEG = pop_loadset('filename', eegs{index}{1},'filepath', filepath);

        % Struct => filepath, subject, group, comps, compN_left, compN_right, compH_left, compH_right
        %patient = struct('filepath', EEG.filepath, 'subject', EEG.setname, 

        hm = load('head_modelColin27_5003_Standard-10-5-Cap339.mat', '-mat');
        idx = [];
        idx = [find(strcmp({hm.atlas.region{:}}, 'RO')), find(strcmp({hm.atlas.region{:}}, 'LO'))];
        % Contiene las etiquetas que corresponden al lobulo occipital sin discriminar hemisferio
        occipital = [];
        occipital = horzcat({hm.atlas.label{idx}}', {hm.atlas.region{idx}}');

        % Esto devuelve los componentes que están en lobulo occipital
        occipital_IC = [];
        occipital_IC = struct('comp_index',{}, 'hemisphere', {}, 'location', {}, 'response', {}); % Esta es la que me importa.
        IC_idx = [];
        tmp = [];
        for xindex = 1:length(occipital)
            tmp = find(strcmp({EEG.dipfit.model.areadk}, occipital{xindex,1})); % Encuentra indices de IC occipitales
            IC_idx = [IC_idx tmp];
        end
        for xindex = 1:length(IC_idx)
            occipital_IC(xindex).comp_index = IC_idx(xindex);
            occipital_IC(xindex).location = EEG.dipfit.model(IC_idx(xindex)).areadk;
            occipital_IC(xindex).hemisphere = occipital{find(strcmp({occipital{:,1}}, occipital_IC(xindex).location)) ,2};
        end
        
        % Calcula respuesta de los componentes solo si tienen respuesta H
        if strcmp(eegs{index}{2}, 'H')
            % Itera sobre cada componente occipital
            for icindex = 1:length(occipital_IC)
                % Primer pico
                EEG2 = pop_rmdat( EEG, {eegs{index}{3}},[0 9.5] ,0);
                first_peak_freq = str2double(extractBetween(eegs{index}{3},'PHOTO ','Hz'));
                [IC_spectre, freq_labels] = pop_spectopo(EEG2, 0, [0  9500], 'EEG' , 'freq', first_peak_freq, 'plotchan', 0, 'plot', 'off' );
                freq_idx = find(freq_labels==first_peak_freq);
                first_peak = 10.^(IC_spectre(occipital_IC(icindex).comp_index, freq_idx)/10);

                % Segundo pico
                EEG2 = pop_rmdat( EEG, {eegs{index}{4}},[0 9.5] ,0);
                second_peak_freq = str2double(extractBetween(eegs{index}{4},'PHOTO ','Hz'));
                [IC_spectre, freq_labels] = pop_spectopo(EEG2, 0, [0  9500], 'EEG' , 'freq', second_peak_freq, 'plotchan', 0, 'plot', 'off' );
                freq_idx = find(freq_labels==second_peak_freq);
                second_peak = 10.^(IC_spectre(occipital_IC(icindex).comp_index, freq_idx)/10);
                
                if second_peak/first_peak > 1/3
                    occipital_IC(icindex).response = 'H';
                else
                    occipital_IC(icindex).response = 'N';
                end
            end
        end
        % Guarda los resultados dentro del EEG
        EEG.occipital_ic = occipital_IC;
        EEG.response = eeg{index}{2}; % Guarda el tipo de respuesta en el EEG.
        EEG.first_peak = eeg{index}{3};
        EEG.second_peak = eeg{index}{4};
        % Guarda EEG.
        EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', filepath);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
        
%         template = 'PHOTO %dHz';
%         component_cell = {};
%         % Itera sobre cada indice de componentes
%         for index1 = 1:length(occipital_IC)
%             component_cell{index1,1} = EEG.setname; % Nombre del paciente
%             component_cell{index1,2} = occipital_IC(index1);  % Componente del paciente
%             counter = 3; % Columna a partir de la cual se colocan los datos espectrales
%             for index2 = 6:2:24 % Itera sobre cada frecuencia de fotoestimulacion
%                 EEG2 = pop_rmdat( EEG, {sprintf(template, index2)},[0 9.5] ,0);
%                 [IC_spectre, freq_labels] = pop_spectopo(EEG2, 0, [0  9500], 'EEG' , 'freq', index2+1, 'plotchan', 0, 'plot', 'off' );
%                 freq_idx = find(freq_labels==index2);
%                 component_cell{index1,counter} = 10.^(IC_spectre(occipital_IC(index1), freq_idx)/10);
%                 counter = counter + 1;
%             end
%         end
% 
%         for index3 = 1:size(component_cell, 1)
%             if ( (max([component_cell{index3, 8:12}])) / max([component_cell{index3, 4:6}]) ) > 1/3
%                     component_cell{index3, 13} = 'H';
%                 else
%                     component_cell{index3, 13} = 'N';
%             end
%         end
    catch ME
        warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
        continue
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');