% Direccion de los archivos que se quieren procesar.
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Interictales\Limpios';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Ictales\Limpios';

filepath = {
'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios';
'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Interictales\Limpios';
'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Ictales\Limpios';
};

% Itera sobre cada directorio madre.
for findex = 1:length(filepath)
    % Direccion de la carpeta donde se guardan los archivos post script.
    target_path = strcat(filepath{findex},'\', 'Rereferenciados + ICA' ,'\');
    if ~exist(target_path,'dir')
        mkdir(target_path);
    end

    % Cambia el directorio a la carpeta donde estan los archivos ya procesados.
    cd(target_path);

    % Crea una celda con los archivos que ya se encuentran en el directorio donde se guardan los archivos procesado, para evitar
    % procesarlos si ya lo fueron.
    eeg_after_script = dir('*.set');
    eeg_after_script = {eeg_after_script.name}';

    % Busca todos los archivos '*.set' en el directorio para procesarlos.
    cd(filepath{findex});
    eegs = dir('*.set');
    eegs = {eegs.name}';

    eegs = setdiff(eegs, eeg_after_script);

    eeglab;

    % Itera sobre los archivos a importar.
    for index = 1:length(eegs)
        try
            EEG = pop_loadset('filename',eegs{index},'filepath', filepath{findex});

            % Rereferencia a Tp9-Tp10
            EEG = pop_reref(EEG, [find(strcmp({EEG.chanlocs(:).labels}, 'Tp9')) find(strcmp({EEG.chanlocs(:).labels}, 'Tp10'))]);

            % ICA
            EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','off');

            % DIPFIT
            EEG = pop_dipfit_settings(EEG, 'hdmfile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\standard_vol.mat',...
                'coordformat','MNI','mrifile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\standard_mri.mat','chanfile',...
                'E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc','coord_transform',...
                [0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:EEG.nbchan]);

            EEG = pop_multifit(EEG, [1:EEG.nbchan] ,'threshold',100,'plotopt',{'normlen','on'});

            % Guarda.
            EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', target_path);

            catch ME
            warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name); %#ok<MEXCEP>
            continue
        end
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');
        