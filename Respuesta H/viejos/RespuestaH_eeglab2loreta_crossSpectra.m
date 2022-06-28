% Guarda EEGs de EEGLAB en una carpeta con el nombre del archivo para hacer analisis 'Cross spectra' de LORETA.
% Clasifica cada archivo en base a la frecuencia de fotoestimulacion y crea dentro de esta carpeta un archivo '.txt' para
% definir las bandas de frecuencia a usar con LORETA.

% Direccion de los archivos a procesar
filepath = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG\RESPUESTA H\TODO\SIN PC FE +4 seg\Limpios por ICA\Fotoestimulacion igualada\Fotoestimulacion solo picos';
filepath = strcat( filepath, '\');
cd(filepath);
eegs = dir('*.set');
eegs = {eegs.name}';

% Direccion donde guardar
target_path = 'Cross spectra';
target_path = strcat(filepath, target_path, '\');
if ~exist(target_path, 'dir')
    mkdir(target_path);
end

eeglab;

% Itera sobre los archivos a procesar.
for rindex = 1:length(eegs)
    EEG = pop_loadset('filename', eegs{rindex}, 'filepath', filepath); 
    
    % Direccion donde se va a guardar el archivo acorde a su frecuencia.
    path = strcat(target_path, extractBetween(eegs{rindex}, '_' , '.set'));
    path = path{1};
    
    % Crea la carpeta de la frecuencia y el archivo con las bandas para LORETA.
    if ~exist(path, 'dir')
        mkdir(path);
        fid = fopen(strcat(path, '\','frequency bands.txt'), 'w+');
        freq = extractBetween(eegs{rindex}, '_PHOTO ', 'Hz.set');
        freq = freq{1};
        fid = fprintf(fid, '1\n%s %s', freq, freq) ;
        fclose('all');
    end
    
    % Direccion del EEG con su carpeta homonima.
    path = strcat(path, '\', extractBefore(eegs{rindex}, '.set'), '\');
    mkdir(path);
    cd(path);
    
    % Exporta el segmento de fotoestimulacion en formato '.txt' para procesar con LORETA.
    eeglab2loreta(EEG.chanlocs, EEG.data, 'filecomp', extractBefore(EEG.filename, '.set'), 'exporterp', 'on', 'labelonly', 'on' );
    
    % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
    delete(strcat(path, '\loreta_chanlocs.txt'));
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');