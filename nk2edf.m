% Pasa carpetas que contienen el EEG en formato Nihon Kohden a formato EDF.
% ---------------------------------------------------------------------------------------------------------------------------

% Directorio de archivos a procesar (directorio raiz) y donde se van a guardar los EDF finales.
eeg_dir = "C:\Users\Marce\Desktop 2\Nueva carpeta";

% La direccion de 'nk2edf.exe' esta en la carpeta de scripts.
nk2edf_filepath = extractBefore(mfilename('fullpath'), mfilename); 

% Lista las carpetas que contienen los EEG en formato de Nihon Kohden.
cd(eeg_dir);
eeg_folder = dir;
eeg_folder = eeg_folder([eeg_folder.isdir]);
eeg_folder(ismember( {eeg_folder.name}, {'.', '..'})) = [];
eeg_folder = {eeg_folder.name};

% Lista los EEG ya pasados a EDF
edf_postscript = dir('*.edf');
edf_postscript = {edf_postscript.name};
for edf_index = 1:length(edf_postscript)
    edf_postscript{edf_index} = extractBefore(edf_postscript{edf_index}, '.edf');
%     if cellfun(@(s) contains(s, '-'), {edf_postscript{edf_index}})
%         edf_postscript{edf_index} = extractBefore(edf_postscript{edf_index}, '-');
%     else
%         edf_postscript{edf_index} = extractBefore(edf_postscript{edf_index}, '.edf');
%     end
end

% Lista final de carpetas a procesar.
eeg_folder = setdiff(eeg_folder, edf_postscript);

% Itera sobre las carpetas de cada EEG.
for folder_index = 1:length(eeg_folder)
    try
        % Carpeta con el DNI del paciente como nombre.
        folder_dir = strcat(eeg_dir, "\", eeg_folder{folder_index}, "\NKT\EEG2100\");
        cd(folder_dir);

        % Busca el archivo '.eeg' para transformar a EDF.
        eeg = dir('*.eeg');
        eeg = {eeg.name};
        eeg = eeg{1};

        % Ejecuta el archivo 'nk2edf' y pasa como argumento el archivo que quiero cambiar a EDF.
        cmd = sprintf(strrep(strcat(nk2edf_filepath, "nk2edf.exe %s"), "\", "\\"), eeg); % 'strrep' soluciona caracteres de escape
        system(cmd);

        % Busca el archivo ya pasado a EDF.
        edf = dir('*.edf');
        edf = {edf.name};

        % En caso de que se creen mas de un EDF por EEG.
        if length(edf) == 1
            % Direccion del EDF.
            edf = edf{1};
            edf = strcat(folder_dir,"\",  edf);

            % Mueve el EDF a la carpeta raiz y lo renombra con el DNI del paciente.
            movefile(edf, strcat(eeg_dir,"\", eeg_folder{folder_index}, ".edf"))
        else
            % Agrega el indice a cada EDF
            for edf_final_index = 1:length(edf)
                % Direccion del EDF.
                edf_2 = strcat(folder_dir, "\", edf{edf_final_index});

                % Mueve el EDF a la carpeta raiz y lo renombra con el DNI del paciente.
                movefile(edf_2, strcat(eeg_dir,"\", eeg_folder{folder_index}, "-", int2str(edf_final_index), ".edf"));
            end
        end
    catch ME
        warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name); %#ok<MEXCEP>
        continue
    end
end

cd(extractBefore(mfilename('fullpath'), mfilename));
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');