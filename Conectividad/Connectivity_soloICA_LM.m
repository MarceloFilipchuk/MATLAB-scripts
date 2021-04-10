% Guarda EEGs de EEGLAB en formato '.txt' en una carpeta con el nombre del archivo para hacer analisis 'Cross spectra' de 
% LORETA.
% Toma un EEG de 60 segundos y lo divide en 24 partes de 2.5 segundos cada uno.
% Guarda todo en el mismo directorio dentro de una carpeta con el nombre del archivo procesado.
% ---------------------------------------------------------------------------------------------------------------------------


migraine = 'E:\Investigacion\Cefalea\Investigacion\QEEG\EEG\Migrañosos'; % Directorio de migrañosos
normal = 'E:\Investigacion\Cefalea\Investigacion\QEEG\EEG\Controles'; % Directorio de normales/controles

% Direccion de los archivos a procesar
filepath = {migraine, normal};

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
target_folder = 'Solo ICA';

eeglab;
    
% Itera sobre los directorios a procesar.
for findex = 1:length(filepath)
    
    % Direccion de la carpeta donde se guardan los archivos post script.
    target_path = strcat(filepath{findex}, '\', target_folder, '\');
    if ~exist(target_path, 'dir')
        mkdir(target_path);
    end
    
    % Crea una celda con los archivos que ya se encuentran en el directorio donde se guardan los archivos procesado, para evitar
    % procesarlos si ya lo fueron.
    cd(target_path);
    filename_after_script = dir('*.set');
    filename_after_script = {filename_after_script.name}';

    % Crea una celda con todos los archivos a procesar dentro del directorio.
    cd(filepath{findex});
    eegs = dir('*.set');
    eegs = {eegs.name}';
    
    % Actualiza la lista de EEGs para procesar
    eegs = setdiff(eegs, filename_after_script);

    % Itera sobre los archivos a procesar.
    for index = 1:length(eegs)
        try
            EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath{findex}); 
            
            % Elimina canales de EOG
            EEG = pop_select( EEG, 'nochannel',{'AF9h','AF10h'});
            
            % Re-referencia a TP9-TP10
            EEG = pop_reref( EEG, [20 21] ,'exclude',22);
            
            % ICA.
            EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1); 
            EEG = eeg_checkset( EEG );          

            % DIPFIT:incluye todo para ubicar los componentes en DIPFIT y excluye el canal de EKG.
            EEG = pop_dipfit_settings( EEG, 'hdmfile','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\standard_vol.mat',...
                'coordformat','MNI','mrifile','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\standard_mri.mat',...
                'chanfile','E:\\Investigacion\\eeglab2019_1\\plugins\\dipfit3.4\\standard_BEM\\elec\\standard_1005.elc',...
                'coord_transform',[0 0 0 0 0 -1.5708 1 1 1] ,'chansel', find(~strcmp({EEG.chanlocs(:).labels},'EKG')) );
            EEG = eeg_checkset( EEG );
            EEG = pop_multifit(EEG, [1:EEG.nbchan],'threshold',100,'plotopt',{'normlen' 'on'});
            EEG = eeg_checkset( EEG );

            % Guarda.
            EEG = pop_saveset( EEG, 'filename', eegs{index} ,'filepath', target_path);
        catch
            warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
            continue
        end
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');