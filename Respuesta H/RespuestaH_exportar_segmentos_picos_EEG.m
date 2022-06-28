% Direccion de los archivos que se quieren procesar.
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios\Rereferenciados + ICA';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Ictales\Limpios\Rereferenciados + ICA';
filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Interictales\Limpios\Rereferenciados + ICA';

filepath = strcat(filepath, '\');

% Busca todos los archivos '*.set' en el directorio para procesarlos.
cd(filepath);
eegs = dir('*.set');
eegs = {eegs.name}';

eeglab;

folderH = strcat(filepath, 'H response EEG\');
folderN = strcat(filepath, 'N response EEG\');
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
    
    EEG1 = EEG.patient_info.first_peak_EEG;
    EEG1.patient_info = rmfield(EEG.patient_info, {'first_peak_component_L', 'first_peak_component_R' ,'first_peak_EEG', 'second_peak', 'second_peak_power', 'second_peak_EEG', 'second_peak_component_R','second_peak_component_L'});
    EEG1.patient_info.component_L = EEG.patient_info.first_peak_component_L;
    EEG1.patient_info.component_R = EEG.patient_info.first_peak_component_R;
    EEG1.setname = strcat(EEG1.setname,'_',EEG1.patient_info.first_peak);
 
    EEG2 = EEG.patient_info.second_peak_EEG;
    EEG2.patient_info = rmfield(EEG.patient_info, {'second_peak_component_L', 'second_peak_component_R' ,'second_peak_EEG', 'first_peak', 'first_peak_EEG', 'first_peak_power', 'first_peak_component_R','first_peak_component_L'});
    EEG2.patient_info.component_L = EEG.patient_info.second_peak_component_L;
    EEG2.patient_info.component_R = EEG.patient_info.second_peak_component_R; 
    EEG2.setname = strcat(EEG2.setname,'_',EEG2.patient_info.second_peak);
    
    
    % Exporta los segmentos
    if strcmp(EEG.patient_info.response, 'N') % Es respuesta N
        % Pico alfa
        % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
        EEG1 = pop_saveset( EEG1, 'filename', EEG1.setname ,'filepath', N_alpha);
        
        % Pico beta
        % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
        EEG2 = pop_saveset( EEG2, 'filename', EEG2.setname ,'filepath', N_beta);
       
    else % es respuesta H
        % Pico alfa
        % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
        EEG1 = pop_saveset( EEG1, 'filename', EEG1.setname ,'filepath', H_alpha);
        
        % Pico beta
        cd(H_beta)
        % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
        EEG2 = pop_saveset( EEG2, 'filename', EEG2.setname ,'filepath', H_beta);

    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');
    
    
    