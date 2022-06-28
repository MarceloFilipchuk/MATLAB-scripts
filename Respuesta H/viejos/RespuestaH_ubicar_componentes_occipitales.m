% Selecciona componentes localizados en lobulos occipitales previo a pasarlos por el script de Makoto para dejar solo
% aquellos que valgan la pena.
% ---------------------------------------------------------------------------------------------------------------------------

% Direccion de los archivos de EEG.
filepath = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG\RESPUESTA H\TODO\SIN PC FE +4 seg\Limpios por ICA\Fotoestimulacion igualada\Fotoestimulacion solo picos';
filepath = strcat( filepath, '\');

% Direccion donde se van a guardar los componentes.
component_path = 'Componentes';
component_path = strcat(filepath, component_path , '\');
if ~exist(component_path, 'dir')
    mkdir(component_path);
end

% Crea una celda con todos los archivos a procesar.
cd(filepath);
eegs = dir('*.set');
eegs = {eegs.name}';

% Carga el 'head model' que usa eeglab para ubicar los componentes.
hm = load('-mat', fullfile( 'E:\Investigacion\eeglab2019_1\', 'functions', 'supportfiles', 'head_modelColin27_5003_Standard-10-5-Cap339.mat'));

% Crea una matriz con los las regiones y sus lobulos correspondientes.
% NOTA: LO = Left Occipital - RO = Right Occipital.
atlas = {};
counter = 0;
% Agrega a la matriz solo areas que sean de los lobulos occipitales.
for rindex = 1:length(hm.atlas.region)
    if strcmp(hm.atlas.region(rindex), 'RO') || strcmp(hm.atlas.region(rindex), 'LO')
        counter = counter + 1;
        atlas{counter, 1} = hm.atlas.region(rindex);
        atlas{counter, 2} = hm.atlas.label(rindex);
    end
end

cd(component_path);

eeglab;

% Itera sobre los archivos a procesar.
for index = 1: length(eegs)
    [ maxL, maxR ] = deal(0);
    try
        EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath); 
        

        ICidx = [];
        IC = {};
        % Itera sobre los componentes del EEG.
        icounter = 0;
        for rindex = 1:length(EEG.dipfit.model)

            % Busca componentes occipitales, los guarda en IC: { componente indice }.
            for nindex = 1:length(atlas)
                if strcmp(EEG.dipfit.model(rindex).areadk, atlas{nindex, 2}) 
                    icounter = icounter + 1;
                    IC{icounter, 1} = EEG.dipfit.model(rindex);
                    IC{icounter, 2} = rindex;
                end
            end
        end

        % Clasifica componentes segun hemisferios. ICL = izquierda - ICR = derecha.
        [rcounter, lcounter] = deal(0); 
        [ICL, ICR] = deal({});
        for nindex = 1:size(IC, 1)
            if strcmp(IC{nindex, 1}.areadk(length(IC{nindex, 1}.areadk)), 'L')
                lcounter = lcounter + 1;
                ICL{lcounter, 1} = IC{nindex, 1};
                ICL{lcounter, 2} = IC{nindex, 2};
            else
                rcounter = rcounter + 1;
                ICR{rcounter, 1} = IC{nindex, 1};
                ICR{rcounter, 2} = IC{nindex, 2};
            end
        end

        % Calcula la frecuencia del pico.
        freq = str2double(extractBetween(EEG.filename, 'PHOTO ', 'Hz.set'));

        % Calcula espectro de los componentes occipitales.
        comp_spec_r = pop_spectopo(EEG, 0, [0  9500], 'EEG' , 'freq', [freq], 'plotchan', 0, 'plot', 'off' );
        compR = zeros(size(ICR, 1), 102); % Ultima columna para el indice del componente.
        for rindex = 1:size(ICR, 1)
            compR(rindex,1:101) = comp_spec_r(ICR{rindex, 2},:);
            compR(rindex, 102) = ICR{rindex, 2}; % Ultima columna para el indice del componente.
        end
        comp_spec_l = pop_spectopo(EEG, 0, [0  9500], 'EEG' , 'freq', [freq], 'plotchan', 0, 'plot', 'off' );
        compL = zeros(size(ICL, 1), 102); % Ultima columna para el indice del componente.
        for rindex = 1:size(ICL, 1)
            compL(rindex,1:101) = comp_spec_l(ICL{rindex, 2},:);
            compL(rindex, 102) = ICL{rindex, 2}; % Ultima columna para el indice del componente.
        end

        % Busca el componente con maximo poder en la frecuencia de fotoestimulacion.
        maxfreqR = zeros(size(compR, 1), 2);
        for rindex = 1:size(compR, 1)
           maxfreqR(rindex, 1) =  compR(rindex, freq+1) ;
           maxfreqR(rindex, 2) = compR(rindex, 102);
        end
        maxfreqL = zeros(size(compL, 1), 2);
        for rindex = 1:size(compL, 1)
           maxfreqL(rindex, 1) =  compL(rindex, freq+1) ;
           maxfreqL(rindex, 2) = compL(rindex, 102);
        end
        
        maxR = maxfreqR(find(maxfreqR == max( maxfreqR(:, 1))), 2); % Indice del componente derecho.
        maxL = maxfreqL(find(maxfreqL == max( maxfreqL(:, 1))), 2); % Indice del componente izquierdo.

        % Exporta a loreta los componentes.
        if ~isempty(maxR) % Derecho.
            try
                pop_eeglab2loreta(EEG, 'compnum', maxR, 'filecomp', strcat('DER-', extractBefore(eegs{index}, '.set'), '-COMP-') , 'labelonly', 'on');
            catch ME
            end
        end
        if ~isempty(maxL) % Izquierdo.
            try
                pop_eeglab2loreta(EEG, 'compnum', maxL, 'filecomp', strcat('IZQ-', extractBefore(eegs{index}, '.set'), '-COMP-') , 'labelonly', 'on');
            catch ME
            end
        end
    catch ME
        warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
        continue
    end
end

% Elimina el archivo 'loreta_chanlocs.txt'.
try 
    delete(strcat(component_path, '\loreta_chanlocs.txt'));
    disp(">>> loreta_chanlocs.txt eliminados <<<");
catch
    warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');