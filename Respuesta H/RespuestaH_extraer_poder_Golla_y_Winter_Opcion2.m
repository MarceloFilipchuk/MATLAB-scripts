% Calcula los espectros de los electrodos O1 y O2 para los componentes  fundamentales de cada  segmento de fotoestimulacion 
% y crea archivos '*csv' con dichos valores. Permite plotear ademas los resultados promediados entre O1 y O2. Guarda los 
% archivos con los nombres que se especifique  en las variables 'spec_O1', 'spec_O2' y 'spec_AVG'.
% IMPORTANTE: Solo usar en EEGs que tienen cada frecuencia de fotoestimulacion de 9.5 segundos de duracion.
% -------------------------------------------------------------------------

% Nombre de los grupos dentro del estudio (Para no tener que cambiar cada direccion para cada grupo).
group = {
    'Controles';
    'Interictales';
    'Ictales';
};

% Directorios
mother_dir = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\'; % Contiene las carpetas de los grupos.
eegs_dir = '\Limpios\Rereferenciados + ICA'; % Contiene los EEGs.
datspec_dir = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG todos los picos\'; % Contiene los '*.datspec'.

% Nombre y formato de las tablas que se van a crear para O1, O2 y promedio entre O1 y O2.
spec_O1 = 'FFT Abs power O1.xls';
spec_O2 = 'FFT Abs power O2.xls';
spec_AVG = 'FFT Abs power promedio O1-O2.xls';

eeglab;

% Itera sobre cada grupo
for gindex = 1:length(group)
    % Direccion de los archivos que se quieren procesar.
    filepath = strcat(mother_dir, group{gindex}, eegs_dir);
    filepath = strcat(filepath, '\');

    % Busca todos los archivos '*.set' en el directorio para procesarlos.
    cd(filepath);
    eegs = dir('*.set');
    eegs = {eegs.name}';

    % Crea las matrices vacias para guardar los valores y etiquetas.
    len = length(eegs);
    final = zeros(len, 10);
    O1_final = zeros(len, 10);
    O2_final = zeros(len, 10);
    avgO1O2 =   zeros(len, 10);
    eeg_id = strings(len, 1);
    % Original
%     etiq = ["DNI", "PHOTO 6Hz", "PHOTO 8Hz", "PHOTO 10Hz", "PHOTO 12Hz", "PHOTO 14Hz", "PHOTO 16Hz",...
%         "PHOTO 18Hz", "PHOTO 20Hz", "PHOTO 22Hz", "PHOTO 24Hz", "Max 1er pico", "Max 2do pico", "Respuesta", "MATLAB"];


    % Cada iteracion abre un archivo.
    for index = 1:len
    
    filename = eegs{index}; 
    % 'tmp' va a contener datos temporales de la respuesta para agregar los datos de la respuesta del paciente al archivo.
    tmp = [];
    tmp = cell(1,11);
    try
        EEG = pop_loadset('filename',filename,'filepath', filepath);
        % Elimina el EEG original guardado (para ahorrar espacio, a esta altura no es util)
        try
        EEG = rmfield( EEG , 'original_EEG' );
        catch ME
        end
        
        
        % Cada iteracion calcula el espectro para la frecuencia correspondiente k = frecuencia que quiero y k+1 = indice de
        % la frecuencia que necesito de la funcion (porque arranca en 0Hz). 
        fe_events = [6:2:24];
        for idx = 1:1:10

            beg_label= sprintf(label, k);

            EEG2 = pop_epoch(EEG, {fe_event}, [0 9.505], 'newname', EEG.setname, 'epochinfo', 'yes');
            EEG2.history = [];

            % Calcula el espectro para la frecuencia necesitada en el rango de tiempo correspondiente al evento.
            [spectra, freqs] = pop_spectopo(EEG2, 1, [0 9500], 'EEG' ,...
                'percent', 100, 'plot', 'off', 'plotchans', [9, 10]);
            idx = find(freqs == k);
            O1_final(index, o) = 10.^(spectra(1,idx)/10);
            O2_final(index, o) = 10.^(spectra(2,idx)/10);
            eeg_id(index) = extractBefore(eegs{index}, '.set');
            
            % Agrega datos temporales. Columnas contienen protocolo de FE, picos y respuesta.
            tmp{1,o+1} = (10.^(spectra(1,idx)/10) + 10.^(spectra(2,idx)/10) )/2; % Promedio de O1 y O2
            
            if k < 24 % Para tranquilidad mia.
                k = k+2;
            end
        end
        
        % Calculos finales para definir respuesta y frecuencia de picos dentro del paciente.
        tmp{1,1} = EEG.patient_info.id;
        
        % Normaliza por maximo alfa.
        norm_factor = max([tmp{1,3:5}]); % Pico maximo en alfa.
        for tmpindex = 2:11 % Columnas 1 al 10 contienen poder en protocolos de FE. Columna 1 es DNI.
            tmp{1, tmpindex} = tmp{1, tmpindex} / norm_factor;
        end
        max_alpha_idx = find([tmp{1,3:5}] == 1) + 2; % +2 porque 1era columna es ID y la 2da es FE a 6Hz y las quiero saltar.
        max_beta_idx = find([tmp{1,7:11}] == max([tmp{7:11}]) ) + 6;  % +6 porque las 6 primeras columnas son datos que quiero saltar.
        
        % Define respuesta.
        if tmp{1,max_beta_idx}/tmp{1,max_alpha_idx} > 1/3
            EEG.patient_info.response = 'H';
        else
            EEG.patient_info.response = 'N';
        end
        
        % Define picos, guarda la etiqueta y el EEG correspondiente a cada uno.
%         EEG.patient_info.first_peak = etiq{1, max_alpha_idx};
%         tmpEEG1 = pop_rmdat( EEG, {EEG.patient_info.first_peak},[0 9.5] ,0);      
%         tmpEEG1 = pop_runica(tmpEEG1, 'icatype', 'runica', 'extended',1,'interrupt','off');
%         tmpEEG1 = pop_dipfit_settings(tmpEEG1, 'hdmfile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\standard_vol.mat',...
%             'coordformat','MNI','mrifile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\standard_mri.mat','chanfile',...
%             'E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\elec\\standard_1005.elc','coord_transform',...
%             [0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:tmpEEG1.nbchan]);
%         tmpEEG1 = pop_multifit(tmpEEG1, [1:tmpEEG1.nbchan] ,'threshold',100,'plotopt',{'normlen','on'});
%         EEG.patient_info.first_peak_EEG =  tmpEEG1;
%         
%         EEG.patient_info.second_peak = etiq{1, max_beta_idx};
%         tmpEEG2 = pop_rmdat( EEG, {EEG.patient_info.second_peak},[0 9.5] ,0);      
%         tmpEEG2 = pop_runica(tmpEEG2, 'icatype', 'runica', 'extended',1,'interrupt','off');
%         tmpEEG2 = pop_dipfit_settings(tmpEEG2, 'hdmfile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\standard_vol.mat',...
%             'coordformat','MNI','mrifile','E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\standard_mri.mat','chanfile',...
%             'E:\\Investigacion\\eeglab2021.1\\plugins\\dipfit4.3\\standard_BEM\\elec\\standard_1005.elc','coord_transform',...
%             [0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:tmpEEG2.nbchan]);
%         tmpEEG2 = pop_multifit(tmpEEG2, [1:tmpEEG2.nbchan] ,'threshold',100,'plotopt',{'normlen','on'});
%         EEG.patient_info.second_peak_EEG =  tmpEEG2;
%         
%         % Guarda el EEG original con sus datos sobre respuestas y picos agregados.
%         EEG = pop_saveset( EEG, 'filename', EEG.setname ,'filepath', filepath);
        
    catch ME
        warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
        continue
    end
end

% Llena la matriz de avgO1O2 con el promedio entre los dos canales.
for c_index = 1:length(eegs)
    for r_index = 1:10
        avgO1O2(c_index, r_index) = (O1_final(c_index, r_index) + O2_final(c_index, r_index)) / 2;
    end
end

% Normaliza los valores de avgO1O2.
% Itera sobre filas.
for gindex = 1:size(avgO1O2, 1)
   norm_factor = max(avgO1O2(gindex, 2:4));
   % Itera sobre columnas, normalizando cada valor
   for jindex = 1:size(avgO1O2,2)
      avgO1O2(gindex, jindex) = avgO1O2(gindex, jindex)/norm_factor;  
   end
end

% Crea la estructura de las matrices finales que se van a escribir.
csv_file_final = cell(len+1, 14);

% Carga las etiquetas en la estructura de matriz final.
for c_index = 1:length(etiq)
    csv_file_final{1, c_index} = etiq(c_index);
end

% Carga los DNIs de los pacientes a la estructura de matriz final.
for r_index = 1:len
    csv_file_final{r_index+1, 1} = extractBefore(eegs{r_index, 1}, '.set');
end

% Para poder iterar sobre todas las matrices finales al cargarlas y no hacer tantas lineas de codigo.
% final_matrices = {csv_file_finalAVG, csv_file_finalO1, csv_file_finalO2}
final_matrices = cell(1,3);
[final_matrices{1}, final_matrices{2}, final_matrices{3}] = deal(csv_file_final);

% Carga los datos de los DNIS y espectros a las matrices a escribir.
% Itera sobre filas.
for r_index = 1:len
    csv_r_index = r_index +1; % Porque en la matrices finales la primera fila es de etiquetas.
    % Itera sobre columnas.
    for c_index = 1:10
        csv_c_index = c_index +1; % Porque en las matrices finales la primera columna es de DNIs.
        final_matrices{1}{csv_r_index, csv_c_index} = avgO1O2(r_index, c_index);
        final_matrices{2}{csv_r_index, csv_c_index} = O1_final(r_index, c_index);
        final_matrices{3}{csv_r_index, csv_c_index} = O2_final(r_index, c_index);
    end
end

% Carga la frecuencia de fotoestimulacion donde estan los picos, la respuesta y la matriz para usar en MATLAB en otro script.
% NO TOCAR... MAGIA.
for r_index = 2:length(csv_file_final) %Itera sobre las filas de la matriz final. Indice arranca en 2 porque 1 corresponde a las etiquetas.    
    for r2index = 1:length(final_matrices) % Itera sobre cada matriz final
        % Carga la etiqueta de la frecuencia del 1er pico.
        final_matrices{r2index}{r_index, 12} = etiq(find(cellfun(@double,...
            {final_matrices{r2index}{r_index,2:11}})== max([final_matrices{r2index}{r_index, 3:5}]))+1);
        % Carga la etiqueta de la frecuencia del 2do pico.
        final_matrices{r2index}{r_index, 13} = etiq(find(cellfun(@double,...
            {final_matrices{r2index}{r_index,2:11}})== max([final_matrices{r2index}{r_index, 7:11}]))+1);
        % Carga el tipo de respuesta 'H' o 'N' segun corresponda.
        if (max([final_matrices{r2index}{r_index, 7:11}]) / max([final_matrices{r2index}{r_index, 3:5}])) > 1/3
            final_matrices{r2index}{r_index, 14} = 'H';
        else
            final_matrices{r2index}{r_index, 14} = 'N';
        end
        % Carga las matrices MATLAB para otro script
        final_matrices{r2index}{r_index, 15} =  strcat("{ '", final_matrices{r2index}{r_index, 1}, ".set', '",...
            final_matrices{r2index}{r_index, 14} , "', '", final_matrices{r2index}{r_index, 12}, "', '",...
            final_matrices{r2index}{r_index, 13}, "' }");
    end
end

% Escribe las matrices (AVG tiene el indice 1 de la variable 'final_matrices', O1 tiene el indice 2 y O3 tiene el indice 3.
try
writecell(final_matrices{1}, strcat(filepath, 'normalizado_', spec_AVG));
writecell(final_matrices{2}, strcat(filepath, 'normalizado_', spec_O1));
writecell(final_matrices{3}, strcat(filepath, 'normalizado_', spec_O2));
catch ME
    warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
end

csv_final_AVG = final_matrices{1};
csv_final_O1 = final_matrices{2};
csv_final_O2 = final_matrices{3};

% Plotea el poder en 2D del promedio entre O1 y O2.
% figure
% plot_line = plot(avgO1O2');
% xticklabels(etiq(2:11))
% legend(eeg_id)
% xlabel('Fotoestimulacion')
% ylabel('Poder')

% Plotea el poder en superficie del promedio entre O1 y O2.
% if len > 1
%     figure
%     plot_surf = surf(avgO1O2);
%     hold on
%     plot_surf.Parent.XTick = 1:1:10;
%     plot_surf.Parent.YTick = 1:1:length(eeg_id);
%     xticks(1:1:10)
%     yticklabels(eeg_id)
%     xticklabels(etiq(2:11))
%     zlabel('Poder')
%     ylabel('Paciente')
%     xlabel('Fotoestimulacion')
% end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');