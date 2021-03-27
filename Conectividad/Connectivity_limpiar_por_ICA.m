% ICA y DIPFIT de todo el EEG.
% Selecciona componentes con >=70% de chances de ser cerebral, que este ubicados en cerebro y con una varianza residual de
% menos del 15% (script de Makoto).
% Guarda el EEG.
% ---------------------------------------------------------------------------------------------------------------------------


filepath= 'E:\Investigacion\EEG\NORMALES - CONTROL\CONNECTIVITY\EEG\CONECTIVIDAD';
filepath = strcat(filepath, '\');

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
target_folder = 'Limpios por ICA';

% Direccion de la carpeta donde se guardan los archivos post script.
target_path = strcat(filepath, target_folder, '\');
if ~exist(target_path, 'dir')
    mkdir(target_path);
end

% Cambia el directorio a la carpeta donde estan los archivos ya procesados.
cd(target_path);

% Crea un array con los archivos que ya se encuentran en el directorio donde se guardan los archivos procesado, para evitar
% procesarlos si ya lo fueron.
filename_after_script = dir('*.set');
filename_after_script = {filename_after_script.name}';

% Cambia el directorio a la carpeta donde estan los archivos a procesar.
cd(filepath);

% Crea una celda con todos los archivos a procesar dentro del directorio.
eegs = dir('*.set');
eegs = {eegs.name}';

eeglab;

% Itera sobre los archivos a procesar.
for index = 1:length(eegs)
    brainIdx = [];
    goodRvIdx = [];
    insideBrainIdx = [];
    goodIcIdx1 = [];
    if ~ismember(eegs{index}, filename_after_script)
        try
            EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath); 
            
            % Makoto's how to perform component selection using ICLabel() and dipole information (02/20/2020 updated)--------
            % Perform IC rejection using ICLabel scores and r.v. from dipole fitting.
            % ICA.
            EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1); 
            EEG = eeg_checkset( EEG );          
            
            % DIPFIT:incluye todo para ubicar los componentes en DIPFIT y excluye el canal de EKG.
            EEG = pop_dipfit_settings( EEG, 'hdmfile','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\standard_vol.mat',...
                'coordformat','MNI','mrifile','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\standard_mri.mat',...
                'chanfile','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc',...
                'coord_transform',[0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:19] );
            EEG = eeg_checkset( EEG );
            EEG = pop_multifit(EEG, [1:EEG.nbchan],'threshold',100,'plotopt',{'normlen' 'on'});
            EEG = eeg_checkset( EEG );

            EEG = iclabel(EEG, 'default'); % Original output from eegh has a bug: the second input ('default') is without ''--this is fixed here.
            brainIdx  = find(EEG.etc.ic_classification.ICLabel.classifications(:,1) >= 0.7); % > 70% brain == good ICs.

            % Perform IC rejection using residual variance of the IC scalp maps.
            rvList    = [EEG.dipfit.model.rv];
            goodRvIdx = find(rvList < 0.15)'; % < 15% residual variance == good ICs.

            % Perform IC rejection using inside brain criterion.
            load(EEG.dipfit.hdmfile); % This returns 'vol'.
            dipoleXyz = zeros(length(EEG.dipfit.model),3);
            for icIdx = 1:length(EEG.dipfit.model)
                dipoleXyz(icIdx,:) = EEG.dipfit.model(icIdx).posxyz(1,:);
            end
            depth = ft_sourcedepth(dipoleXyz, vol);
            depthThreshold = 1;
            insideBrainIdx = find(depth<=depthThreshold);

            % Take AND across the three criteria.
            goodIcIdx = intersect(brainIdx, goodRvIdx);
            goodIcIdx = intersect(goodIcIdx, insideBrainIdx);

            % Perform IC rejection.
            EEG = pop_subcomp(EEG, goodIcIdx, 0, 1);

            % Post-process to update ICLabel data structure.
            EEG.etc.ic_classification.ICLabel.classifications = EEG.etc.ic_classification.ICLabel.classifications(goodIcIdx,:);

            % Post-process to update EEG.icaact.
            EEG.icaact = [];
            EEG = eeg_checkset(EEG, 'ica');
            
            % ---------------------------------------------------------------------------------------------------------------
            if length(EEG.setname) > 8
                EEG.setname = extractBefore(EEG.setname, ' pruned with ICA');
            end
            
            % Elimina el canal de EKG
            EEG = pop_select( EEG, 'nochannel',{'EKG'});
            
            EEG = pop_saveset( EEG, 'filename', eegs{index} ,'filepath', target_path);

        catch ME
            warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
            continue
        end
    end    
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');