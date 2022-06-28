% Recorta los segmentos de fotoestimulacion de los pacientes donde estan los primer y segudo picos
% ---------------------------------------------------------------------------------------------------------------------------


% Direccion de los archivos que se quieren procesar.
filepath = {
'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios\Rereferenciados + ICA';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Ictales\Limpios\Rereferenciados + ICA';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Interictales\Limpios\Rereferenciados + ICA';

filepath = strcat(filepath, '\');

% Busca todos los archivos '*.set' en el directorio para procesarlos.
cd(filepath);
eegs = dir('*.set');
eegs = {eegs.name}';

eeglab;

% Itera sobre los archivos a procesar.
for index = 1%:length(eegs)
    
    try
        EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath);
        
        [right_occipital_IC, left_occipital_IC] = deal([]);
        
        % Primer pico
        EEG1 = EEG.patient_info.first_peak_EEG;

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
            tmp = find(strcmp({EEG1.dipfit.model.areadk}, occipital{xindex,1})); % Encuentra indices de IC occipitales
            IC_idx = [IC_idx tmp];
        end
        for xindex = 1:length(IC_idx)
            occipital_IC(xindex).comp_index = IC_idx(xindex);
            occipital_IC(xindex).location = EEG1.dipfit.model(IC_idx(xindex)).areadk;
            occipital_IC(xindex).hemisphere = occipital{find(strcmp({occipital{:,1}}, occipital_IC(xindex).location)) ,2};
        end

        first_peak_freq = str2double(extractBetween(EEG.patient_info.first_peak,'PHOTO ','Hz'));

        % Itera sobre cada componente occipital
        for icindex = 1:length(occipital_IC)
            [IC_spectre, freq_labels] = pop_spectopo(EEG1, 0, [0  9500], 'EEG' , 'freq', first_peak_freq, 'plotchan', 0, 'plot', 'off' );
            freq_idx = find(freq_labels==first_peak_freq);
            % Poder en la frecuencia del componente fundamental.
            occipital_IC(icindex).response = 10.^(IC_spectre(occipital_IC(icindex).comp_index, freq_idx)/10);
        end

        % Selecciona aquellos con mayor valor en la frecuencia de fotoestimulacion.
        left_occipital_IC = [];
        right_occipital_IC = [];
        
        % Left occipital IC
        left_occipital_IC = occipital_IC(strcmp({occipital_IC.hemisphere}, 'LO'));
        left_occipital_IC = left_occipital_IC(find([left_occipital_IC.response]' == max([left_occipital_IC.response])));

        % Right occipital IC
        right_occipital_IC = occipital_IC(strcmp({occipital_IC.hemisphere}, 'RO'));
        right_occipital_IC = right_occipital_IC(find([right_occipital_IC.response]' == max([right_occipital_IC.response])));

        % Carga los datos en el EEG.
        % Datos componente derecho.
        [EEG.patient_info.first_peak_component_R.index, EEG.patient_info.first_peak_component_R.coordinates.x, EEG.patient_info.first_peak_component_R.coordinates.y ...
            EEG.patient_info.first_peak_component_R.coordinates.z] = deal([]); % Vacia los campos (por las dudas).
        try
            EEG.patient_info.first_peak_component_R.index = right_occipital_IC.comp_index;
            EEG.patient_info.first_peak_component_R.coordinates.x = EEG1.dipfit.model(right_occipital_IC.comp_index).posxyz(1);
            EEG.patient_info.first_peak_component_R.coordinates.y = EEG1.dipfit.model(right_occipital_IC.comp_index).posxyz(2);
            EEG.patient_info.first_peak_component_R.coordinates.z = EEG1.dipfit.model(right_occipital_IC.comp_index).posxyz(3);
        catch ME
        end    
            
        % Datos componente izquierdo.
        [EEG.patient_info.first_peak_component_L.index, EEG.patient_info.first_peak_component_L.coordinates.x, EEG.patient_info.first_peak_component_L.coordinates.y ...
            EEG.patient_info.first_peak_component_L.coordinates.z] = deal([]); % Vacia los campos (por las dudas).
        try
            EEG.patient_info.first_peak_component_L.index = left_occipital_IC.comp_index;
            EEG.patient_info.first_peak_component_L.coordinates.x = EEG1.dipfit.model(left_occipital_IC.comp_index).posxyz(1);
            EEG.patient_info.first_peak_component_L.coordinates.y = EEG1.dipfit.model(left_occipital_IC.comp_index).posxyz(2);
            EEG.patient_info.first_peak_component_L.coordinates.z = EEG1.dipfit.model(left_occipital_IC.comp_index).posxyz(3);
        catch ME
        end 
        
        % Segundo pico
        EEG2 = EEG.patient_info.second_peak_EEG;

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
            tmp = find(strcmp({EEG2.dipfit.model.areadk}, occipital{xindex,1})); % Encuentra indices de IC occipitales
            IC_idx = [IC_idx tmp];
        end
        for xindex = 1:length(IC_idx)
            occipital_IC(xindex).comp_index = IC_idx(xindex);
            occipital_IC(xindex).location = EEG2.dipfit.model(IC_idx(xindex)).areadk;
            occipital_IC(xindex).hemisphere = occipital{find(strcmp({occipital{:,1}}, occipital_IC(xindex).location)) ,2};
        end

        second_peak_freq = str2double(extractBetween(EEG.patient_info.second_peak,'PHOTO ','Hz'));

        % Itera sobre cada componente occipital
        for icindex = 1:length(occipital_IC)
            [IC_spectre, freq_labels] = pop_spectopo(EEG2, 0, [0  9500], 'EEG' , 'freq', second_peak_freq, 'plotchan', 0, 'plot', 'off' );
            freq_idx = find(freq_labels==second_peak_freq);
            % Poder en la frecuencia del componente fundamental.
            occipital_IC(icindex).response = 10.^(IC_spectre(occipital_IC(icindex).comp_index, freq_idx)/10);
        end

        % Selecciona aquellos con mayor valor en la frecuencia de fotoestimulacion.
        left_occipital_IC = [];
        right_occipital_IC = [];
        
        % Left occipital IC
        left_occipital_IC = occipital_IC(strcmp({occipital_IC.hemisphere}, 'LO'));
        left_occipital_IC = left_occipital_IC(find([left_occipital_IC.response]' == max([left_occipital_IC.response])));

        % Right occipital IC
        right_occipital_IC = occipital_IC(strcmp({occipital_IC.hemisphere}, 'RO'));
        right_occipital_IC = right_occipital_IC(find([right_occipital_IC.response]' == max([right_occipital_IC.response])));

        % Carga los datos en el EEG.
        % Datos componente derecho.
        [EEG.patient_info.second_peak_component_R.index, EEG.patient_info.second_peak_component_R.coordinates.x, EEG.patient_info.second_peak_component_R.coordinates.y ...
            EEG.patient_info.second_peak_component_R.coordinates.z] = deal([]); % Vacia los campos (por las dudas).
        try
            EEG.patient_info.second_peak_component_R.index = right_occipital_IC.comp_index;
            EEG.patient_info.second_peak_component_R.coordinates.x = EEG2.dipfit.model(right_occipital_IC.comp_index).posxyz(1);
            EEG.patient_info.second_peak_component_R.coordinates.y = EEG2.dipfit.model(right_occipital_IC.comp_index).posxyz(2);
            EEG.patient_info.second_peak_component_R.coordinates.z = EEG2.dipfit.model(right_occipital_IC.comp_index).posxyz(3);
        catch ME
        end    
            
        % Datos componente izquierdo.
        [EEG.patient_info.second_peak_component_L.index, EEG.patient_info.second_peak_component_L.coordinates.x, EEG.patient_info.second_peak_component_L.coordinates.y ...
            EEG.patient_info.second_peak_component_L.coordinates.z] = deal([]); % Vacia los campos (por las dudas).
        try
            EEG.patient_info.second_peak_component_L.index = left_occipital_IC.comp_index;
            EEG.patient_info.second_peak_component_L.coordinates.x = EEG2.dipfit.model(left_occipital_IC.comp_index).posxyz(1);
            EEG.patient_info.second_peak_component_L.coordinates.y = EEG2.dipfit.model(left_occipital_IC.comp_index).posxyz(2);
            EEG.patient_info.second_peak_component_L.coordinates.z = EEG2.dipfit.model(left_occipital_IC.comp_index).posxyz(3);
        catch ME
        end
        
        % Guarda el EEG original con sus datos sobre picos actualizados.
        EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', filepath);
        
    catch ME
        warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
        continue
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');