% Nombre de los grupos dentro del estudio (Para no tener que cambiar cada direccion para cada grupo).
group = {
    'Controles';
    'Interictales';
    'Ictales';
};

% Directorios.
mother_dir = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\'; % Contiene las carpetas de los grupos de EEGs.
eegs_dir = '\Limpios\Rereferenciados + ICA'; % Contiene los EEGs.
target_dir = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\LORETA componentes independientes\'; % Va a contener los '*.txt'.

eeglab;

% Itera sobre cada grupo
for gindex = 1:length(group)
    
    % Direccion de los archivos que se quieren procesar.
    filepath = strcat(mother_dir, group{gindex}, eegs_dir, '\');
    
    % Direccion final de los archivos donde se van a guardar.
    final_path = strcat(target_dir, group{gindex}, '\');
    
    % Busca todos los archivos '*.set' en el directorio para procesarlos.
    cd(filepath);
    eegs = dir('*.set');
    eegs = {eegs.name}';

    folderH = strcat(final_path, 'H response\');
    folderN = strcat(final_path, 'N response\');
    H_alpha = strcat(folderH, 'Alpha peak');
    H_beta = strcat(folderH, 'Beta peak\');
    N_alpha = strcat(folderN, 'Alpha peak\');
    N_beta = strcat(folderN, 'Beta peak\');
    if ~exist(folderH, 'dir') || ~exist(folderN, 'dir')
        mkdir(folderH);
        mkdir(folderN);
        mkdir(H_alpha);
        mkdir(H_beta);
        mkdir(N_alpha);
        mkdir(N_beta);
    end

    % Cada iteracion abre un archivo.
    for index = 1:length(eegs)
        EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath);

        % Exporta los segmentos
        if strcmp(EEG.patient_info.response, 'N') % Es respuesta N
            % Pico alfa
            cd(N_alpha)
            % Exporta los componentes izquierdos y derechos occipitales '.txt' para procesar con LORETA.
            if ~isempty(EEG.patient_info.first_peak_component_R.index)
                eeglab2loreta(EEG.patient_info.first_peak_EEG.chanlocs, EEG.patient_info.first_peak_EEG.icawinv, 'filecomp', strcat(EEG.setname,'_First_peak_IC_Right_Idx-') ,'compnum', EEG.patient_info.first_peak_component_R.index, 'exporterp', 'off', 'labelonly', 'on' );
            end
            if ~isempty(EEG.patient_info.first_peak_component_L.index)
                eeglab2loreta(EEG.patient_info.first_peak_EEG.chanlocs, EEG.patient_info.first_peak_EEG.icawinv, 'filecomp', strcat(EEG.setname,'_First_peak_IC_Left_Idx-') ,'compnum', EEG.patient_info.first_peak_component_L.index, 'exporterp', 'off', 'labelonly', 'on' );

            end
            % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
            delete(strcat(N_alpha, '\loreta_chanlocs.txt'));

            % Pico beta
            cd(N_beta)
            % Exporta los componentes izquierdos y derechos occipitales '.txt' para procesar con LORETA.
            if ~isempty(EEG.patient_info.second_peak_component_R.index)
                eeglab2loreta(EEG.patient_info.second_peak_EEG.chanlocs, EEG.patient_info.second_peak_EEG.icawinv, 'filecomp', strcat(EEG.setname,'_Second_peak_IC_Right_Idx-') ,'compnum', EEG.patient_info.second_peak_component_R.index, 'exporterp', 'off', 'labelonly', 'on' );

            end
            if ~isempty(EEG.patient_info.second_peak_component_L.index)
                eeglab2loreta(EEG.patient_info.second_peak_EEG.chanlocs, EEG.patient_info.second_peak_EEG.icawinv, 'filecomp', strcat(EEG.setname,'_Second_peak_IC_Left_Idx-') ,'compnum', EEG.patient_info.second_peak_component_L.index, 'exporterp', 'off', 'labelonly', 'on' );

            end
            % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
            delete(strcat(N_beta, '\loreta_chanlocs.txt'));
        else % es respuesta H
            % Pico alfa
            cd(H_alpha)
            % Exporta los componentes izquierdos y derechos occipitales '.txt' para procesar con LORETA.
            if ~isempty(EEG.patient_info.first_peak_component_R.index)
                eeglab2loreta(EEG.patient_info.first_peak_EEG.chanlocs, EEG.patient_info.first_peak_EEG.icawinv, 'filecomp', strcat(EEG.setname,'_First_peak_IC_Right_Idx-') ,'compnum', EEG.patient_info.first_peak_component_R.index, 'exporterp', 'off', 'labelonly', 'on' );

            end
            if ~isempty(EEG.patient_info.first_peak_component_L.index)
                eeglab2loreta(EEG.patient_info.first_peak_EEG.chanlocs, EEG.patient_info.first_peak_EEG.icawinv, 'filecomp', strcat(EEG.setname,'_First_peak_IC_Left_Idx-') ,'compnum', EEG.patient_info.first_peak_component_L.index, 'exporterp', 'off', 'labelonly', 'on' );

            end
            % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
            delete(strcat(H_alpha, '\loreta_chanlocs.txt'));

            % Pico beta
            cd(H_beta)
            % Exporta los componentes izquierdos y derechos occipitales '.txt' para procesar con LORETA.
            if ~isempty(EEG.patient_info.second_peak_component_R.index)
                eeglab2loreta(EEG.patient_info.second_peak_EEG.chanlocs, EEG.patient_info.second_peak_EEG.icawinv, 'filecomp', strcat(EEG.setname,'_Second_peak_IC_Right_Idx-') ,'compnum', EEG.patient_info.second_peak_component_R.index, 'exporterp', 'off', 'labelonly', 'on' );

            end
            if ~isempty(EEG.patient_info.second_peak_component_L.index)
                eeglab2loreta(EEG.patient_info.second_peak_EEG.chanlocs, EEG.patient_info.second_peak_EEG.icawinv, 'filecomp', strcat(EEG.setname,'_Second_peak_IC_Left_Idx-') ,'compnum', EEG.patient_info.second_peak_component_L.index, 'exporterp', 'off', 'labelonly', 'on' );

            end
            % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
            delete(strcat(H_beta, '\loreta_chanlocs.txt'));
        end
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');