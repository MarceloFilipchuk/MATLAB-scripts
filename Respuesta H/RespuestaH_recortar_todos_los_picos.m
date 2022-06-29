% Recortar en segmentos de fotoestimulacion cada EEG para poder cargarlo en STUDY.

% Direccion de los archivos que se quieren procesar.
filepath = {
    'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios\Rereferenciados + ICA';
    'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Interictales\Limpios\Rereferenciados + ICA';
    'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Ictales\Limpios\Rereferenciados + ICA';
};

eeglab;
    
% Itera sobre cada directorio.
for findex = 1:length(filepath)
    
    % Direccion donde guardar los segmentos.
    target_path = strcat(filepath{findex}, '\Todos los picos\');
    if ~exist(target_path, 'dir'); mkdir(target_path);end

    % Busca todos los archivos '*.set' en el directorio para procesarlos.
    cd(filepath{findex});
    eegs = dir('*.set');
    eegs = {eegs.name}';

    % Para identificar los segmentos de fotoestimulacion acorde a frecuencia.
    label = 'PHOTO %dHz';

    % Cada iteracion abre un archivo.
    for index = 1:length(eegs)
    filename = eegs{index};
        try
            EEG = pop_loadset('filename',filename,'filepath', filepath{findex});
            
            % Itera por todas las frecuencias de fotoestimulacion dentro del mismo EEG.
            for eegindex = 6:2:24
                % Nombre del evento.
                fe_event= sprintf(label, eegindex);
                % Corta el segmento correspondiente.
                EEG2 = pop_epoch(EEG, {fe_event}, [0 9.505], 'newname', EEG.setname, 'epochinfo', 'yes');
                % Guarda el EEG original con sus datos sobre respuestas y picos agregados.
                EEG2 = pop_saveset( EEG2, 'filename', strcat(EEG.setname, '_',fe_event) ,'filepath', target_path);

            end
        catch ME
            warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
            continue
        end
    end
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');