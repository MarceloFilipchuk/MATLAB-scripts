% Guarda EEGs de EEGLAB en formato '.txt' en una carpeta con el nombre del archivo para hacer analisis 'Cross spectra' de 
% LORETA.
% Toma un EEG de 60 segundos y lo divide en 6 partes de 10 segundos cada uno.
% Guarda todo en el mismo directorio dentro de una carpeta con el nombre del archivo procesado.
% ---------------------------------------------------------------------------------------------------------------------------


normal = 'E:\Investigacion\Cefalea\Investigacion\QEEG\EEG\Controles\AVG - Solo ICA\Limpios por ICA modificado';
migraine = 'E:\Investigacion\Cefalea\Investigacion\QEEG\EEG\Migrañosos\AVG - Solo ICA\Limpios por ICA modificado';

% Direccion de los archivos a procesar
filepath = { normal, migraine };

% Direccion donde guardar
target_folder = 'SLOR para clasificar';
target_path = 'E:\Investigacion\Cefalea\Investigacion\QEEG';
target_path = strcat(target_path, '\', target_folder);
if ~exist(target_path,'dir')
    mkdir(target_path);
end

eeglab;
    
% Itera sobre los directorios a procesar.
for findex = 1:length(filepath)
    
    cd(filepath{findex});
    eegs = dir('*.set');
    eegs = {eegs.name}';

    % Itera sobre los archivos a procesar.
    for rindex = 1:length(eegs)
        try
            EEG = pop_loadset('filename', eegs{rindex}, 'filepath', filepath{findex}); 
            
            % Re-referencia a TP9-TP10.
            EEG = pop_reref( EEG, [20 21] );
            
            % Direccion del EEG con su carpeta homonima.
%             path = strcat(target_path, '\', extractBefore(eegs{rindex}, '.set'), '\');
%             mkdir(path);
%             cd(path);
            cd(target_path);
            
            % Nombre para los archivos a guardar.
            filename = extractBefore(EEG.filename, '.set');

%             % Divide el EEG en 6 segmentos de 10 segundos cada uno.
%             for index = 0:5
%                 start = 2000 * index + 1;
%                 fin = start + 2000;
%                 % Exporta el segmento en formato '.txt' para procesar con LORETA.
%                 eeglab2loreta(EEG.chanlocs, EEG.data(:,start:fin), 'filecomp', strcat(filename,'-' ,int2str(index)), 'exporterp', 'on', 'labelonly', 'on' );
%             end
    
            % Exporta el todo segmento en formato '.txt' para procesar con LORETA.
            eeglab2loreta(EEG.chanlocs, EEG.data, 'filecomp', filename, 'exporterp', 'on', 'labelonly', 'on' );

%             % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
%             delete(strcat(path, '\loreta_chanlocs.txt'));
        catch
            warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
            continue
        end
    end
end

% Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
delete(strcat(target_path, '\loreta_chanlocs.txt'));

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');