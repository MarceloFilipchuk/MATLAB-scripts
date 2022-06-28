% Clasifica archivos cross spectra (.crss) segun su respuesta (H o N), diagnostico (1.1 o 1.2) y status(ictal o interictal) 
% en base a la base de datos dada.

% Direccion de los archivos a procesar.
filepath = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG\RESPUESTA H\TODO\SIN PC FE +4 seg\Limpios por ICA\Fotoestimulacion igualada\Fotoestimulacion solo picos\Cross spectra\TODO';
cd(filepath)
files = dir('*.slor');
files = {files.name}';

% Datos de la database.
% Formato: '{ 'DNI' Perimetro cefalico Respuesta Diagnostico Status }
% Ejemplo: { '12345678' 52 'H' 1.1 'INTERICTAL' }
data= {
    
{ '14366775' 55 'H' 11 'ICTAL' }
{ '16561154' 55 'H' 11 'ICTAL' }
{ '17004849' 55 'H' 11 'ICTAL' }
{ '17384808' 55 'H' 11 'ICTAL' }
{ '18820818' 55 'N' 11 'ICTAL' }
{ '21628054' 55 'H' 11 'ICTAL' }
{ '22672559' 55 'H' 11 'ICTAL' }
{ '23021007' 55 'H' 11 'ICTAL' }
{ '23231229' 55 'N' 11 'ICTAL' }
{ '23267975' 55 'H' 11 'ICTAL' }
{ '23460234' 55 'N' 11 'ICTAL' }
{ '24014278' 55 'H' 11 'ICTAL' }
{ '24196666' 55 'N' 11 'ICTAL' }
{ '24629394' 55 'H' 11 'ICTAL' }
{ '24671814' 55 'N' 11 'ICTAL' }
{ '25758828' 55 'N' 11 'ICTAL' }
{ '25921670' 55 'H' 11 'ICTAL' }
{ '26089010' 55 'H' 11 'ICTAL' }
{ '26636248' 55 'N' 11 'ICTAL' }
{ '26681314' 55 'H' 11 'ICTAL' }
{ '27065788' 55 'H' 11 'ICTAL' }
{ '27172828' 55 'H' 11 'ICTAL' }
{ '28127064' 55 'H' 11 'ICTAL' }
{ '28357169' 55 'H' 11 'ICTAL' }
{ '28456579' 55 'H' 11 'ICTAL' }
{ '28655843' 55 'N' 11 'ICTAL' }
{ '28859146' 55 'H' 11 'ICTAL' }
{ '29136654' 55 'H' 11 'ICTAL' }
{ '29166639' 55 'N' 11 'ICTAL' }
{ '29253079' 55 'N' 11 'ICTAL' }
{ '30122613' 55 'N' 11 'ICTAL' }
{ '30289753' 55 'H' 11 'ICTAL' }
{ '30469404' 55 'H' 11 'ICTAL' }
{ '30900116' 55 'H' 11 'ICTAL' }
{ '30900291' 55 'N' 11 'ICTAL' }
{ '30971218' 55 'H' 11 'ICTAL' }
{ '31337569' 55 'N' 11 'ICTAL' }
{ '31921461' 55 'H' 11 'ICTAL' }
{ '32238623' 55 'N' 11 'ICTAL' }
{ '32281962' 55 'H' 11 'ICTAL' }
{ '33029169' 55 'H' 11 'ICTAL' }
{ '33387926' 55 'N' 11 'ICTAL' }
{ '33437020' 55 'H' 11 'ICTAL' }
{ '33700358' 55 'H' 11 'ICTAL' }
{ '34070751' 55 'H' 11 'ICTAL' }
{ '34839043' 55 'H' 11 'ICTAL' }
{ '35109977' 55 'N' 11 'ICTAL' }
{ '36428905' 55 'N' 11 'ICTAL' }
{ '37126067' 55 'H' 11 'ICTAL' }
{ '37732120' 55 'H' 11 'ICTAL' }
{ '37732352' 55 'H' 11 'ICTAL' }
{ '37820607' 55 'H' 11 'ICTAL' }
{ '38329607' 55 'H' 11 'ICTAL' }
{ '38634441' 55 'H' 11 'ICTAL' }
{ '39546581' 55 'N' 11 'ICTAL' }
{ '39733285' 55 'H' 11 'ICTAL' }
{ '39736478' 55 'N' 11 'ICTAL' }
{ '40506862' 55 'H' 11 'ICTAL' }
{ '41268250' 55 'H' 11 'ICTAL' }
{ '41440670' 55 'N' 11 'ICTAL' }
{ '41680083' 55 'N' 11 'ICTAL' }
{ '42439139' 55 'N' 11 'ICTAL' }
{ '42637732' 55 'N' 11 'ICTAL' }
{ '42642102' 55 'H' 11 'ICTAL' }
{ '42782803' 55 'H' 11 'ICTAL' }
{ '43143194' 55 'N' 11 'ICTAL' }
{ '43143713' 55 'N' 11 'ICTAL' }
{ '43604422' 55 'H' 11 'ICTAL' }
{ '43673629' 55 'H' 11 'ICTAL' }
{ '43923349' 55 'N' 11 'ICTAL' }
{ '44273002' 55 'H' 11 'ICTAL' }
{ '44677571' 55 'H' 11 'ICTAL' }
{ '45090150' 55 'H' 11 'ICTAL' }
{ '45487927' 55 'H' 11 'ICTAL' }
{ '45693186' 55 'H' 11 'ICTAL' }
{ '46374112' 55 'H' 11 'ICTAL' }
{ '95926170' 55 'H' 11 'ICTAL' }

};

% Nombre de las carpetas donde se van a guardar los archivos.   
Hresp = strcat(filepath, '\Respuesta H');
Nresp = strcat(filepath, '\Respuesta N');

highH = strcat(Hresp, '\Pico alto');
highN = strcat(Nresp, '\Pico alto');
lowH = strcat(Hresp, '\Pico bajo');
lowN = strcat(Nresp, '\Pico bajo');

auralowH = strcat(lowH, '\Aura');
auralowN = strcat(lowN, '\Aura');
aurahighH = strcat(highH, '\Aura');
aurahighN = strcat(highN, '\Aura');
noauralowH = strcat(lowH, '\Sin aura');
noauralowN = strcat(lowN, '\Sin aura');
noaurahighH = strcat(highH, '\Sin aura');
noaurahighN = strcat(highN, '\Sin aura');

auralowHict = strcat(auralowH, '\Ictal');
auralowHinterict = strcat(auralowH, '\Interictal');
auralowNict = strcat(auralowN, '\Ictal');
auralowNinterict = strcat(auralowN, '\Interictal');
aurahighHict = strcat(aurahighH, '\Ictal');
aurahighHinterict = strcat(aurahighH, '\Interictal');
aurahighNict = strcat(aurahighN, '\Ictal');
aurahighNinterict = strcat(aurahighN, '\Interictal');

noauralowHict = strcat(noauralowH, '\Ictal');
noauralowHinterict = strcat(noauralowH, '\Interictal');
noauralowNict = strcat(noauralowN, '\Ictal');
noauralowNinterict = strcat(noauralowN, '\Interictal');
noaurahighHict = strcat(noaurahighH, '\Ictal');
noaurahighHinterict = strcat(noaurahighH, '\Interictal');
noaurahighNict = strcat(noaurahighN, '\Ictal');
noaurahighNinterict = strcat(noaurahighN, '\Interictal');

% Crea los directorios donde se van a guardar los archivos ya clasificados
dirs = {
    Hresp; Nresp; highH; highN; lowH; lowN; auralowH; auralowN; aurahighH; aurahighN; noauralowH; noauralowN; noaurahighH;
    noaurahighN; auralowHict; auralowHinterict; auralowNict; auralowNinterict; aurahighHict; aurahighHinterict; aurahighNict;
    aurahighNinterict; noauralowHict; noauralowHinterict; noauralowNict; noauralowNinterict; noaurahighHict; noaurahighHinterict;
    noaurahighNict; noaurahighNinterict;
    };
for dirindex = 1:length(dirs)
    if ~exist(dirs{dirindex}, 'dir')
        mkdir(dirs{dirindex});
    end
end

% Itera sobre los archivos a clasificar.
for rindex = 1:length(files)
    
    filename = extractBefore(files{rindex}, '_PHOTO ');
    
    % Itera sobre la base de datos y procesa aquellos archivos que se encuentren en ella.
    for dataindex = 1:length(data)      
       
       % Compara los DNIs.
       if strcmp(filename, data{dataindex}{1})
            freq = extractBetween(files{rindex}, '_PHOTO ', 'Hz.slor');
            freq = str2double(freq{1});
            if data{dataindex}{3} == "H" % Respuesta H
                if freq > 12 % Resepuesta H Pico alto
                    if data{dataindex}{4} == 1.1 % Respuesta H Pico alto Sin aura
                        if strcmp(data{dataindex}{5}, 'ICTAL') % Respuesta H Pico alto Sin aura Ictal
                            copyfile(files{rindex}, noaurahighHict);
                        elseif strcmp(data{dataindex}{5}, 'INTERICTAL') % Respuesta H Pico alto Sin aura Interictal
                            copyfile (files{rindex}, noaurahighHinterict)
                        end
                    else % Respuesta H Pico alto Aura
                        if strcmp(data{dataindex}{5}, 'ICTAL') % Respuesta H Pico alto Aura Ictal
                            copyfile(files{rindex}, aurahighHict);
                        elseif strcmp(data{dataindex}{5}, 'INTERICTAL') % Respuesta H Pico alto Aura Interictal
                            copyfile(files{rindex}, aurahighHinterict);
                        end
                    end
                else % Respuesta H Pico bajo 
                    if data{dataindex}{4} == 1.1  % Respuesta H Pico bajo Sin aura
                        if strcmp(data{dataindex}{5}, 'ICTAL') % Respuesta H Pico bajo Sin aura Ictal
                            copyfile(files{rindex}, noauralowHict);
                        elseif strcmp(data{dataindex}{5}, 'INTERICTAL') % Respuesta H Pico bajo Sin aura Interictal
                            copyfile (files{rindex}, noauralowHinterict)
                        end
                    else % Respuesta H Pico bajo Aura
                        if strcmp(data{dataindex}{5}, 'ICTAL') % Respuesta H Pico bajo Aura Ictal
                            copyfile(files{rindex}, auralowHict);
                        elseif strcmp(data{dataindex}{5}, 'INTERICTAL') % Respuesta H Pico bajo Aura Interictal
                            copyfile(files{rindex}, auralowHinterict);
                        end
                    end
                end
                
            else % Respuesta N
                if freq > 12 % Respuesta N Pico alto
                    if data{dataindex}{4} == 1.1 % Respuesta N Pico alto Sin aura
                        if strcmp(data{dataindex}{5}, 'ICTAL') % Respuesta N Pico alto Sin aura Ictal
                            copyfile(files{rindex}, noaurahighNict);
                        elseif strcmp(data{dataindex}{5}, 'INTERICTAL') % Respuesta N Pico alto Sin aura Interictal
                            copyfile (files{rindex}, noaurahighNinterict)
                        end
                    else % Respuesta H Pico alto Aura
                        if strcmp(data{dataindex}{5}, 'ICTAL') % Respuesta N Pico alto Aura Ictal
                            copyfile(files{rindex}, aurahighNict);
                        elseif strcmp(data{dataindex}{5}, 'INTERICTAL') % Respuesta N Pico alto Aura Interictal
                            copyfile(files{rindex}, aurahighNinterict);
                        end
                    end
                else % Respuesta N Pico bajo 
                    if data{dataindex}{4} == 1.1  % Respuesta N Pico bajo Sin aura
                        if strcmp(data{dataindex}{5}, 'ICTAL') % Respuesta N Pico bajo Sin aura Ictal
                            copyfile(files{rindex}, noauralowNict);
                        elseif strcmp(data{dataindex}{5}, 'INTERICTAL') % Respuesta N Pico bajo Sin aura Interictal
                            copyfile (files{rindex}, noauralowNinterict)
                        end
                    else % Respuesta H Pico bajo Aura
                        if strcmp(data{dataindex}{5}, 'ICTAL') % Respuesta N Pico bajo Aura Ictal
                            copyfile(files{rindex}, auralowNict);
                        elseif strcmp(data{dataindex}{5}, 'INTERICTAL') % Respuesta N Pico bajo Aura Interictal
                            copyfile(files{rindex}, auralowNinterict);
                        end
                    end
                end
            end
        end
    end
end

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');