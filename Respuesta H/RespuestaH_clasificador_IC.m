% Clasifica los componentes independientes segun su respuesta (H o N), diagnostico (1.1 o 1.2) y status(ictal o interictal) 
% en base a la base de datos dada.

% Direccion de los archivos a procesar.
filepath = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG\Makoto ICLabel rejection\Final\Fotoestimulacion de igual duracion\Fotoestimulacion solo picos\Componentes';
cd(filepath)
files = dir('*.slor');
files = {files.name}';

% Datos de la database.
% Formato: '{ 'DNI' Perimetro cefalico Respuesta Diagnostico Status }
% Ejemplo: { '12345678' 52 'H' 1.1 'INTERICTAL' }
data= {
    
{'16561154' 52 'H' 1.1 'INTERICTAL' }
{'17384808' 55 'H' 1.1 'INTERICTAL' }
{'23021007' 56 'H' 1.1 'ICTAL' }
{'23267975' 52 'H' 1.1 'ICTAL' }
{'26636248' 57 'N' 1.1 'ICTAL' }
{'26681314' 58 'H' 1.1 'ICTAL' }
{'27065788' 57 'H' 1.1 'ICTAL' }
{'27172828' 56 'H' 1.1 'ICTAL' }
{'28456579' 58 'H' 1.2 'INTERICTAL' }
{'29136654' 54 'H' 1.2 'ICTAL' }
{'29166639' 55 'N' 1.1 'ICTAL' }
{'29253079' 55 'N' 1.1 'ICTAL' }
{'30289753' 52 'H' 1.1 'ICTAL' }
{'30469404' 55 'H' 1.2 'ICTAL' }
{'30900116' 59 'H' 1.1 'ICTAL' }
{'30900291' 56.5 'N' 1.1 'INTERICTAL' }
{'30971218' 54 'H' 1.2 'ICTAL' }
{'31337569' 54 'N' 1.1 'INTERICTAL' }
{'31921461' 56 'H' 1.1 'INTERICTAL' }
{'32281962' 54 'H' 1.2 'INTERICTAL' }
{'33029169' 58 'H' 1.2 'ICTAL' }
{'33437020' 54 'H' 1.1 'ICTAL' }
{'33700358' 59 'H' 1.1 'INTERICTAL' }
{'34839043' 56 'H' 1.1 'INTERICTAL' }
{'35109977' 52 'N' 1.1 'ICTAL' }
{'37126067' 54 'H' 1.2 'ICTAL' }
{'37732120' 59 'H' 1.1 'ICTAL' }
{'37732352' 57 'H' 1.2 'ICTAL' }
{'39546581' 59 'N' 1.1 'INTERICTAL' }
{'39733285' 55 'H' 1.1 'PREICTAL' }
{'40506862' 49 'H' 1.1 'ICTAL' }
{'41268250' 50 'H' 1.1 'ICTAL' }
{'41440670' 52 'N' 1.2 'INTERICTAL' }
{'42637732' 57 'N' 1.2 'ICTAL' }
{'42642102' 53 'H' 1.1 'INTERICTAL' }
{'42782803' 54 'H' 1.1 'ICTAL' }
{'44677571' 57 'H' 1.1 'INTERICTAL' }
{'45090150' 56 'H' 1.2 'ICTAL' }
{'45693186' 56 'H' 1.2 'INTERICTAL' }
{'46374112' 55 'H' 1.1 'INTERICTAL' }

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
    
    filename = extractBetween(files{rindex}, '-', '_PHOTO ');
    
    % Itera sobre la base de datos y procesa aquellos archivos que se encuentren en ella.
    for dataindex = 1:length(data)      
       
       % Compara los DNIs.
       if strcmp(filename, data{dataindex}{1})
            freq = extractBetween(files{rindex}, '_PHOTO ', 'Hz-COMP');
            freq = str2double(freq{1});
            hemisf = extractBefore(files{rindex}, strcat('-', filename));
            if data{dataindex}{3} == "H" % Respuesta H
                if freq > 12 % Respuesta H Pico alto
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