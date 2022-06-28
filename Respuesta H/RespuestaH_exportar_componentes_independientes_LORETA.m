% Direccion de los archivos que se quieren procesar.
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios\Rereferenciados + ICA';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Ictales\Limpios\Rereferenciados + ICA';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Interictales\Limpios\Rereferenciados + ICA';

filepath = strcat(filepath, '\');

% Busca todos los archivos '*.set' en el directorio para procesarlos.
cd(filepath);
eegs = dir('*.set');
eegs = {eegs.name}';

eeglab;

folderH = strcat(filepath, 'H response Components\');
folderN = strcat(filepath, 'N response Components\');
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
    
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');    
    
    