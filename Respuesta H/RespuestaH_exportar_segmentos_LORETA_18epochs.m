% Nombre de los grupos dentro del estudio (Para no tener que cambiar cada direccion para cada grupo).
group = {
    'Controles';
    'Interictales';
    'Ictales';
};

% Directorios.
mother_dir = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\'; % Contiene las carpetas de los grupos de EEGs.
eegs_dir = '\Limpios\Rereferenciados + ICA'; % Contiene los EEGs.
target_dir = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\LORETA segmentos 18 epocas\'; % Va a contener los '*.txt'.

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

    % Nombre de los directorios.
    folderH = strcat(final_path, 'H response\');
    folderN = strcat(final_path, 'N response\');
    H_alpha = strcat(folderH, 'Alpha peak');
    H_beta = strcat(folderH, 'Beta peak\');
    N_alpha = strcat(folderN, 'Alpha peak\');
    N_beta = strcat(folderN, 'Beta peak\');
    
    % Crea los directorios.
    mkdir(folderH);
    mkdir(folderN);
    mkdir(H_alpha);
    mkdir(H_beta);
    mkdir(N_alpha);
    mkdir(N_beta);


    % Cada iteracion abre un archivo.
    for index = 1:length(eegs)
        % Carga el EEG
        mainEEG = pop_loadset('filename',eegs{index},'filepath', filepath);
        
        % Se repite el codigo porque el primero es para el primer pico, y el segundo, para el segundo pico, xD.
        % Divide el EEG en 18 epocas de 1 segundo cada una con una superposicion del 50% entre epoca y epoca.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % PRIMER PICO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        EEG_array = mainEEG.patient_info.first_peak_EEG; % Copia la estructura del EEG en el primer pico.
        idxf(1,1:10) = 0:1:9.5; 
        idxf(2,1:10) = 0.5:1:9.5;
        eegindex = 1;
        % Divide los segmentos y los guarda en un array. Son dos loops porque tienen indices de tiempo distinto para superponerse.
        for tmpindex = 1:9
            EEG_array(eegindex) = pop_select( mainEEG.patient_info.first_peak_EEG, 'time',[idxf(1,tmpindex) idxf(1,tmpindex+1)] );
            EEG_array(eegindex).setname = strcat(mainEEG.patient_info.first_peak_EEG.setname,'-', num2str(eegindex));
            eegindex = eegindex + 1;
        end
        for tmpindex = 1:9
            EEG_array(eegindex) = pop_select( mainEEG.patient_info.first_peak_EEG, 'time',[idxf(2,tmpindex) idxf(2,tmpindex+1)] );
            EEG_array(eegindex).setname = strcat(mainEEG.patient_info.first_peak_EEG.setname,'-', num2str(eegindex));
            eegindex = eegindex + 1;
        end
        % Itera sobre cada una de las 18 epocas.
        for tmpindex = 1:18
        EEG = EEG_array(tmpindex);
            % Exporta los segmentos
            if strcmp(mainEEG.patient_info.response, 'N') % Es respuesta N
                final_N_alpha = strcat(N_alpha, '\', mainEEG.patient_info.first_peak_EEG.setname, '\');
                mkdir(final_N_alpha);
                cd(final_N_alpha)
                % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
                eeglab2loreta(EEG.chanlocs, EEG.data, 'filecomp', EEG.setname, 'exporterp', 'on', 'labelonly', 'on' );
                % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
                delete(strcat(final_N_alpha, '\loreta_chanlocs.txt'));
            else % es respuesta H
                final_H_alpha = strcat(H_alpha, '\', mainEEG.patient_info.first_peak_EEG.setname, '\');
                mkdir(final_H_alpha);
                cd(final_H_alpha)
                % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
                eeglab2loreta(EEG.chanlocs, EEG.data, 'filecomp', EEG.setname, 'exporterp', 'on', 'labelonly', 'on' );
                % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
                delete(strcat(final_H_alpha, '\loreta_chanlocs.txt'));
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SEGUNDO PICO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        EEG_array = mainEEG.patient_info.second_peak_EEG; % Copia la estructura del EEG en el segundo pico.
        idxf(1,1:10) = 0:1:9.5; 
        idxf(2,1:10) = 0.5:1:9.5;
        eegindex = 1;
        % Divide los segmentos y los guarda en un array. Son dos loops porque tienen indices de tiempo distinto para superponerse.
        for tmpindex = 1:9
            EEG_array(eegindex) = pop_select( mainEEG.patient_info.second_peak_EEG, 'time',[idxf(1,tmpindex) idxf(1,tmpindex+1)] );
            EEG_array(eegindex).setname = strcat(mainEEG.patient_info.second_peak_EEG.setname,'-', num2str(eegindex));
            eegindex = eegindex + 1;
        end
        for tmpindex = 1:9
            EEG_array(eegindex) = pop_select( mainEEG.patient_info.second_peak_EEG, 'time',[idxf(2,tmpindex) idxf(2,tmpindex+1)] );
            EEG_array(eegindex).setname = strcat(mainEEG.patient_info.second_peak_EEG.setname,'-', num2str(eegindex));
            eegindex = eegindex + 1;
        end
        % Itera sobre cada una de las 18 epocas.
        for tmpindex = 1:18
        EEG = EEG_array(tmpindex);
            % Exporta los segmentos
            if strcmp(mainEEG.patient_info.response, 'N') % Es respuesta N
                final_N_beta = strcat(N_beta, '\', mainEEG.patient_info.second_peak_EEG.setname, '\');
                mkdir(final_N_beta);
                cd(final_N_beta)
                % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
                eeglab2loreta(EEG.chanlocs, EEG.data, 'filecomp', EEG.setname, 'exporterp', 'on', 'labelonly', 'on' );
                % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
                delete(strcat(final_N_beta, '\loreta_chanlocs.txt'));
            else % es respuesta H
                final_H_beta = strcat(H_beta, '\', mainEEG.patient_info.second_peak_EEG.setname, '\');
                mkdir(final_H_beta);
                cd(final_H_beta)
                % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
                eeglab2loreta(EEG.chanlocs, EEG.data, 'filecomp', EEG.setname, 'exporterp', 'on', 'labelonly', 'on' );
                % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
                delete(strcat(final_H_beta, '\loreta_chanlocs.txt'));
            end
        end
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');