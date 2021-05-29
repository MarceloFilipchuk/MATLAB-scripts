% Guarda EEGs de EEGLAB en formato '.txt' en una carpeta con el nombre del archivo para hacer analisis 'Cross spectra' de 
% LORETA.
% Toma un EEG de 60 segundos y lo divide en 6 partes de 10 segundos cada uno.
% Guarda todo en el mismo directorio dentro de una carpeta con el nombre del archivo procesado.
% ---------------------------------------------------------------------------------------------------------------------------


% normal = 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Controles\AVG - Solo ICA\Limpios por ICA modificado';
migraine = 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Migrañosos\CRONICOS\AVG - Solo ICA\Limpios por ICA modificado';

% Direccion de los archivos a procesar
filepath = { migraine};% , normal };

% Direccion donde guardar
target_folder = 'SLOR clasificados\Cronicos\';
target_path = 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL';
target_path = strcat(target_path, '\', target_folder);
if ~exist(target_path,'dir')
    mkdir(target_path);
end

target_mig = strcat(target_path, '/Migrañosos');
target_mig_ictal = strcat(target_mig, '/Ictales');
target_mig_ictal_aura = strcat(target_mig_ictal, '/Aura');
target_mig_ictal_noaura = strcat(target_mig_ictal, '/Sin aura');
target_mig_interictal = strcat(target_mig, '/Interictales');
target_mig_interictal_aura = strcat(target_mig_interictal, '/Aura');
target_mig_interictal_noaura = strcat(target_mig_interictal, '/Sin aura');
target_control = strcat(target_path, '/Controles');


target_final = {target_control, target_mig, target_mig_ictal, target_mig_ictal_aura, target_mig_ictal_noaura, ...
    target_mig_interictal, target_mig_interictal_aura, target_mig_interictal_noaura};

for tindex = 1:length(target_final)
    if ~exist(target_final{tindex}, 'dir')
        mkdir(target_final{tindex});
    end
end

eeglab;
    
% Itera sobre los directorios a procesar.
for findex = 1:length(filepath)
    
% cd(filepath{findex});
% eegs = dir('*.set');
% eegs = {eegs.name}';

eegs = {
'43604422.set'
'39057518.set'
'36802064.set'
'34070751.set'
'34455144.set'
'30844130.set'
'30122613.set'
'28357169.set'
'28127064.set'
'26089010.set'
'24196666.set'
'24014278.set'
'24367434.set'
'23231229.set'
'29606275.set'
'17004849.set'
'17384808.set'
'25455720.set'
'28374342.set'
'26903214.set'
'22672559.set'
'24457312.set'
'26681314.set'
'32354708.set'
};

    % Itera sobre los archivos a procesar.
    for rindex = 1:length(eegs)
        try
            EEG = pop_loadset('filename', eegs{rindex}, 'filepath', filepath{findex}); 
            
            % Re-referencia a TP9-TP10.
            EEG = pop_reref( EEG, [find(strcmp({EEG.chanlocs.labels}, 'TP9')) find(strcmp({EEG.chanlocs.labels}, 'TP10'))] );

            
            % Clasifica cada EEG y lo pone en su carpeta homonima.
%             if strcmp(EEG.patient_info.dx, 'Control') % Es control
%                 target_path = target_control;
%             else % Es migrañoso
%                 if strcmp(EEG.patient_info.migraine_phase, 'INTERICTAL') % Es interictal
%                     if strcmp(EEG.patient_info.dx, '1.1') % No tiene aura
%                         target_path = target_mig_interictal_noaura;
%                     else % Tiene aura
%                         target_path = target_mig_interictal_aura;
%                     end
%                 else % Es ictal
%                     if strcmp(EEG.patient_info.dx, '1.1') % No tiene aura
%                         target_path = target_mig_ictal_noaura;
%                     else % Tiene aura
%                         target_path = target_mig_ictal_aura;
%                     end
%                 end
%             end

            path = strcat(target_path, '\', extractBefore(eegs{rindex}, '.set'), '\');
            mkdir(path);
            cd(path);
            
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

            % Elimina el archivo 'loreta_chanlocs.txt' que se crea siempre que se exporta desde EEGLAB a LORETA.
            delete(strcat(path, '\loreta_chanlocs.txt'));
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