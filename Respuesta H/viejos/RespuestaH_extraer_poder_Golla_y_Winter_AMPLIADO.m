% Calcula los espectros de los electrodos O1 y O2 para los componentes  fundamentales de cada  segmento de fotoestimulacion 
% y crea archivos '*csv' con dichos valores. Permite plotear ademas los resultados promediados entre O1 y O2. Guarda los 
% archivos con los nombres que se especifique  en las variables 'spec_O1', 'spec_O2' y 'spec_AVG'.
% IMPORTANTE: Solo usar en EEGs que tienen cada frecuencia de fotoestimulacion de 9.5 segundos de duracion.
% -------------------------------------------------------------------------
                                                                                                                            

% Direccion de los archivos que se quieren procesar.
filepath = ...
    'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios';
filepath = strcat(filepath, '\');

% Nombre y formato de las tablas que se van a crear para O1, O2 y promedio entre O1 y O2.
spec_O1 = 'espectro_O1.xls';
spec_O2 = 'espectro_O2.xls';
spec_AVG = 'espectro_promedio.xls';

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
etiq = ["DNI", "PHOTO 6Hz", "PHOTO 8Hz", "PHOTO 10Hz", "PHOTO 12Hz", "PHOTO 14Hz", "PHOTO 16Hz",...
    "PHOTO 18Hz", "PHOTO 20Hz", "PHOTO 22Hz", "PHOTO 24Hz", "Max 1er pico", "Max 2do pico", "Respuesta", "MATLAB"];

% Para identificar los segmentos de fotoestimulacion acorde a frecuencia.
label = 'PHOTO %dHz';

eeglab;

% Cada iteracion abre un archivo.
for index = 1:len
    
    filename = eegs{index}; 
    
    try
        EEG = pop_loadset('filename',filename,'filepath', filepath);
        
        % Cada iteracion calcula el espectro para la frecuencia correspondiente k = frecuencia que quiero y k+1 = indice de
        % la frecuencia que necesito de la funcion (porque arranca en 0Hz). 
        k = 6;
        for o = 1:10
            
            spectra_begining = 0;
            spectra_end = 0;

            beg_label= sprintf(label, k);
            end_label= sprintf(label, k+2);
            
            % Itera sobre los eventos para buscar la etiqueta adecuada.
            for evindex = 1:length(EEG.event)
                if strcmp(EEG.event(evindex).type, beg_label)
                    spectra_begining = EEG.event(evindex).latency/200*1000;
                elseif strcmp(EEG.event(evindex).type, end_label)
                    spectra_end = EEG.event(evindex).latency/200*1000;
                end
                if k == 24
                    spectra_end = spectra_begining + 9500;
                end
            end
            
            % Calcula el espectro para la frecuencia necesitada en el rango de tiempo correspondiente al evento.
            TOPO = pop_spectopo(EEG, 1, [spectra_begining spectra_end], 'EEG' ,...
                'percent', 100, 'plot', 'off', 'plotchans', [9, 10]);
            O1_final(index, o) = TOPO(1, (k+1)); 
            O2_final(index, o) = TOPO(2, (k+1)); 
            eeg_id(index) = extractBefore(eegs{index}, '.set');
            
            k = k+2;
        end

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
        final_matrices{r2index}{r_index, 15} =  strcat("{ '", final_matrices{r2index}{r_index, 1}, ".set', '", final_matrices{r2index}{r_index, 12},...
            "', '", final_matrices{r2index}{r_index, 13}, "' }");
    end
end

% Escribe las matrices (AVG tiene el indice 1 de la variable 'final_matrices', O1 tiene el indice 2 y O3 tiene el indice 3.
try
writecell(final_matrices{1}, strcat(filepath, spec_AVG));
writecell(final_matrices{2}, strcat(filepath, spec_O1));
writecell(final_matrices{3}, strcat(filepath, spec_O2));
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