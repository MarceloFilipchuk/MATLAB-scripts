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

folderH = strcat(filepath, 'H response\');
folderN = strcat(filepath, 'N response\');
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
        % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
        eeglab2loreta(EEG.patient_info.first_peak_EEG.chanlocs, EEG.patient_info.first_peak_EEG.data, 'filecomp', strcat(EEG.setname,'_',EEG.patient_info.first_peak) , 'exporterp', 'on', 'labelonly', 'on' );
        % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
        delete(strcat(N_alpha, '\loreta_chanlocs.txt'));
        
        % Pico beta
        cd(N_beta)
        % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
        eeglab2loreta(EEG.patient_info.second_peak_EEG.chanlocs, EEG.patient_info.second_peak_EEG.data, 'filecomp', strcat(EEG.setname,'_',EEG.patient_info.second_peak) , 'exporterp', 'on', 'labelonly', 'on' );
        % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
        delete(strcat(N_beta, '\loreta_chanlocs.txt'));
    else % es respuesta H
        % Pico alfa
        cd(H_alpha)
        % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
        eeglab2loreta(EEG.patient_info.first_peak_EEG.chanlocs, EEG.patient_info.first_peak_EEG.data, 'filecomp', strcat(EEG.setname,'_',EEG.patient_info.first_peak) , 'exporterp', 'on', 'labelonly', 'on' );
        % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
        delete(strcat(H_alpha, '\loreta_chanlocs.txt'));
        
        % Pico beta
        cd(H_beta)
        % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
        eeglab2loreta(EEG.patient_info.second_peak_EEG.chanlocs, EEG.patient_info.second_peak_EEG.data, 'filecomp', strcat(EEG.setname,'_',EEG.patient_info.second_peak) , 'exporterp', 'on', 'labelonly', 'on' );
        % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
        delete(strcat(H_beta, '\loreta_chanlocs.txt'));
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');
    
    
    