% ICA y DIPFIT de todo el EEG.
% Selecciona componentes con >=70% de chances de ser cerebral y con una varianza residual de menos del 15% (script de Makoto).
% Guarda el EEG.
% ---------------------------------------------------------------------------------------------------------------------------


filepath= 'E:\Investigacion\Cefalea\Investigacion\QEEG\EEG\Controles\Solo ICA';
filepath = strcat(filepath, '\');

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
target_folder = 'Limpios por ICA modificado';

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

% Actualiza la lista de EEGs.
eegs = setdiff(eegs, filename_after_script);

eeglab;

% Itera sobre los archivos a procesar.
for index = 1:length(eegs)
    try
        EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath); 

        % Makoto's how to perform component selection using ICLabel() and dipole information (02/20/2020 updated)--------
        % Perform IC rejection using ICLabel scores and r.v. from dipole fitting.

        EEG = iclabel(EEG, 'default');

        % Components that are not 'brain' or 'others'.
        muscleIdx = find(EEG.etc.ic_classification.ICLabel.classifications(:,2) >= 0.6);
        eyeIdx = find(EEG.etc.ic_classification.ICLabel.classifications(:,3) >= 0.6);    
        lnIdx = find(EEG.etc.ic_classification.ICLabel.classifications(:,5) >= 0.6);
        chnIdx = find(EEG.etc.ic_classification.ICLabel.classifications(:,6) >= 0.6);
        eye_muscle_Idx = find(EEG.etc.ic_classification.ICLabel.classifications(:,2) +...
            EEG.etc.ic_classification.ICLabel.classifications(:,3) >= 0.6);

        % Take all bad components.
        badIcIdx = unique([muscleIdx' eye_muscle_Idx' eyeIdx' lnIdx' chnIdx' 1]); % IC1 suele ser cardíaco.

        % Plotea los componentes eliminados.
%             pop_prop_extended(EEG, 0, [1]); % Plotea componente cardiaco.
%             pop_viewprops(EEG, 0, badIcIdx, {'freqrange', [2 80]}, 1, 'ICLabel'); % Plotea todos los componentes a eliminar.

        % Guarda el EEG original y los componentes a remover para comparaciones futuras.
        EEG.original_EEG = EEG;
        EEG.original_EEG.rejected_components = badIcIdx;


        % Perform IC rejection.
        EEG = pop_subcomp(EEG, badIcIdx, 0, 0); % Elimina solo los componentes listados.

        % Post-process to update ICLabel data structure.
        EEG.etc.ic_classification.ICLabel.classifications = EEG.etc.ic_classification.ICLabel.classifications(setdiff([1:EEG.nbchan], badIcIdx)',:);

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

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');