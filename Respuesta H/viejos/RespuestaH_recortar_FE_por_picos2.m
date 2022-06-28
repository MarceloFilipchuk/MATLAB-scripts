% Recorta los segmentos de fotoestimulacion de los pacientes donde estan los primer y segudo picos
% ---------------------------------------------------------------------------------------------------------------------------


% Direccion de los archivos que se quieren procesar.
filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios\Rereferenciados + ICA';
filepath = strcat(filepath, '\');

% Cambia el directorio a la carpeta donde estan los archivos a procesar.
cd(filepath);

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
target_path = 'Fotoestimulacion solo picos';

% Direccion de la carpeta donde se guardan los archivos post script.
target_path = strcat(filepath, target_path, '\');
if ~exist(target_path, 'dir')
    mkdir(target_path);
end

% Formato: { 'DNI' 'Frecuencia de pico bajo' 'Frecuencia de pico alto' }
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

eeglab;

% Itera sobre los archivos a procesar.
for index = 1:length(eegs)
    EEG1filename = strcat(extractBefore(eegs{index}{1}, '.set'), '_', eegs{index}{3}, '.set');
    EEG2filename = strcat(extractBefore(eegs{index}{1}, '.set'), '_', eegs{index}{4}, '.set');
    if eegs{index}{2} == 'H'
        target_path_final = strcat(target_path, 'Respuesta H\');
    else
        target_path_final = strcat(target_path, 'Respuesta N\');
    end
    if ~exist(target_path_final, 'dir')
        mkdir(target_path_final);
    end
%     if ~isfile(strcat(target_path, EEG1filename)) || ~isfile(strcat(target_path, EEG2filename))
        try
            EEG = pop_loadset('filename', eegs{index}{1}, 'filepath', filepath); 
            EEG.response = eegs{index}{2};
            EEG.first_peak = {eegs{index}{3}};
            EEG.second_peak = {eegs{index}{4}};
            
            % Elimina el EEG original guardado (para ahorrar espacio, a esta altura no es util)
            EEG = rmfield( EEG , 'original_EEG' );
            
            % Primer pico
            [right_occipital_IC, left_occipital_IC] = deal([]);
            target_path1 = strcat(target_path_final, 'First peak\');
            if ~exist(target_path1, 'dir')
                mkdir(target_path1);
            end
            if ~isfile(strcat(target_path1, EEG1filename))
                EEG1 = EEG;
                EEG1 = pop_rmdat( EEG1, {eegs{index}{3}},[0 9.5] ,0);
                % ICA
                EEG1 = pop_runica(EEG1, 'icatype', 'runica', 'extended',1,'interrupt','off');
                % DIPFIT
                EEG1 = pop_dipfit_settings(EEG1, 'hdmfile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\standard_vol.mat',...
                    'coordformat','MNI','mrifile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\standard_mri.mat','chanfile',...
                    'E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\elec\\standard_1005.elc','coord_transform',...
                    [0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:EEG1.nbchan]);
                EEG1 = pop_multifit(EEG1, [1:EEG1.nbchan] ,'threshold',100,'plotopt',{'normlen','on'});
                

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
                
                first_peak_freq = str2double(extractBetween(eegs{index}{3},'PHOTO ','Hz'));
                
                % Itera sobre cada componente occipital
                for icindex = 1:length(occipital_IC)
                    [IC_spectre, freq_labels] = pop_spectopo(EEG1, 0, [0  9500], 'EEG' , 'freq', first_peak_freq, 'plotchan', 0, 'plot', 'off' );
                    freq_idx = find(freq_labels==first_peak_freq);
                    % first_peak = 10.^(IC_spectre(occipital_IC(icindex).comp_index, freq_idx)/10);
                    occipital_IC(icindex).response = 10.^(IC_spectre(occipital_IC(icindex).comp_index, freq_idx)/10);
                end
                
                % Left occipital IC
                left_occipital_IC = occipital_IC(strcmp({occipital_IC.hemisphere}, 'LO'));
                left_occipital_IC =left_occipital_IC(find([left_occipital_IC.response]' == max([left_occipital_IC.response])));
                
                % Right occipital IC
                right_occipital_IC = occipital_IC(strcmp({occipital_IC.hemisphere}, 'RO'));
                right_occipital_IC =right_occipital_IC(find([right_occipital_IC.response]' == max([right_occipital_IC.response])));
                
                EEG1.right_occipital_ic = right_occipital_IC;
                EEG1.left_occipital_ic = left_occipital_IC;
                EEG1.peak = '1st peak';
                EEG1 = pop_saveset( EEG1, 'filename', EEG1filename ,'filepath', target_path1);
            end
            
            % Segundo pico.
            [right_occipital_IC, left_occipital_IC] = deal([]);
            target_path2 = strcat(target_path_final, 'Second peak\');
            if ~exist(target_path2, 'dir')
                mkdir(target_path2);
            end
            if ~isfile(strcat(target_path2, EEG2filename))
                EEG2 = EEG;
                EEG2 = pop_rmdat( EEG2, {eegs{index}{4}},[0 9.5] ,0);
                % ICA
                EEG2 = pop_runica(EEG2, 'icatype', 'runica', 'extended',1,'interrupt','off');
                % DIPFIT
                EEG2 = pop_dipfit_settings(EEG2, 'hdmfile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\standard_vol.mat',...
                    'coordformat','MNI','mrifile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\standard_mri.mat','chanfile',...
                    'E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\elec\\standard_1005.elc','coord_transform',...
                    [0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:EEG2.nbchan]);
                EEG2 = pop_multifit(EEG2, [1:EEG2.nbchan] ,'threshold',100,'plotopt',{'normlen','on'});


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

                second_peak_freq = str2double(extractBetween(eegs{index}{4},'PHOTO ','Hz'));

                % Itera sobre cada componente occipital
                for icindex = 1:length(occipital_IC)
                    [IC_spectre, freq_labels] = pop_spectopo(EEG2, 0, [0  9500], 'EEG' , 'freq', second_peak_freq, 'plotchan', 0, 'plot', 'off' );
                    freq_idx = find(freq_labels==second_peak_freq);
                    % first_peak = 10.^(IC_spectre(occipital_IC(icindex).comp_index, freq_idx)/10);
                    occipital_IC(icindex).response = 10.^(IC_spectre(occipital_IC(icindex).comp_index, freq_idx)/10);
                end

                % Left occipital IC
                left_occipital_IC = occipital_IC(strcmp({occipital_IC.hemisphere}, 'LO'));
                left_occipital_IC =left_occipital_IC(find([left_occipital_IC.response]' == max([left_occipital_IC.response])));

                % Right occipital IC
                right_occipital_IC = occipital_IC(strcmp({occipital_IC.hemisphere}, 'RO'));
                right_occipital_IC =right_occipital_IC(find([right_occipital_IC.response]' == max([right_occipital_IC.response])));

                EEG2.right_occipital_ic = right_occipital_IC;
                EEG2.left_occipital_ic = left_occipital_IC;
                
                EEG2.peak = '2nd peak';
                EEG2 = pop_saveset( EEG2, 'filename', EEG2filename ,'filepath', target_path2);
            end

        catch ME
            warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
            continue
        end
%     end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');