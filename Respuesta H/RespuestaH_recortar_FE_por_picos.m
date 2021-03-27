% Recorta los segmentos de fotoestimulacion de los pacientes donde estan los primer y segudo picos
% ---------------------------------------------------------------------------------------------------------------------------


% Direccion de los archivos que se quieren procesar.
filepath = 'E:\Investigacion\EEG\NORMALES - CONTROL\EEG\TODO\SIN PC FE +4 seg\Limpios por ICA';
filepath = strcat(filepath, '\');

% Cambia el directorio a la carpeta donde estan los archivos a procesar.
cd(filepath);

% Nombre de la carpeta y con el que se van a guardar los archivos post-script.
target_path = 'Fotoestimulacion solo picos';

% Direccion de la carpeta donde se guardan los archivos post script.
target_path = strcat(filepath, target_path, '\');
if ~exist(target_path, 'dir')
    mkdir(target_path);
end

% Formato: { 'DNI' 'Frecuencia de pico bajo' 'Frecuencia de pico alto' }
eegs = {
    
{ '14748072.set', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '14969812.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '21855683.set', 'PHOTO 10Hz', 'PHOTO 20Hz' }
{ '22757300.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '23194037.set', 'PHOTO 10Hz', 'PHOTO 18Hz' }
{ '23379293.set', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '23451296.set', 'PHOTO 10Hz', 'PHOTO 22Hz' }
{ '24016335.set', 'PHOTO 12Hz', 'PHOTO 24Hz' }
{ '24303035.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '24510521.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '25758828.set', 'PHOTO 10Hz', 'PHOTO 18Hz' }
{ '26393565.set', 'PHOTO 10Hz', 'PHOTO 20Hz' }
{ '27549509.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '28104626.set', 'PHOTO 8Hz', 'PHOTO 16Hz' }
{ '28118438.set', 'PHOTO 10Hz', 'PHOTO 22Hz' }
{ '28432439.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '29474970.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '29609231.set', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '29657387.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '30648088.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '30734981.set', 'PHOTO 10Hz', 'PHOTO 16Hz' }
{ '31041338.set', 'PHOTO 10Hz', 'PHOTO 24Hz' }
{ '32099772.set', 'PHOTO 10Hz', 'PHOTO 18Hz' }
{ '32406969.set', 'PHOTO 12Hz', 'PHOTO 18Hz' }
{ '32683626.set', 'PHOTO 12Hz', 'PHOTO 22Hz' }
{ '32875324.set', 'PHOTO 10Hz', 'PHOTO 22Hz' }
{ '33380758.set', 'PHOTO 10Hz', 'PHOTO 20Hz' }
{ '36447393.set', 'PHOTO 12Hz', 'PHOTO 18Hz' }
{ '39692052.set', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '41736145.set', 'PHOTO 12Hz', 'PHOTO 20Hz' }
{ '41828477.set', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '41963456.set', 'PHOTO 10Hz', 'PHOTO 24Hz' }
{ '42051853.set', 'PHOTO 12Hz', 'PHOTO 20Hz' }
{ '42915383.set', 'PHOTO 12Hz', 'PHOTO 16Hz' }
{ '42981569.set', 'PHOTO 10Hz', 'PHOTO 18Hz' }
{ '43229539.set', 'PHOTO 10Hz', 'PHOTO 20Hz' }
{ '43272957.set', 'PHOTO 10Hz', 'PHOTO 18Hz' }

};

eeglab;

% Itera sobre los archivos a procesar.
for rindex = 1:length(eegs)
    EEG1filename = strcat(extractBefore(eegs{rindex}{1}, '.set'), '_', eegs{rindex}{2}, '.set');
    EEG2filename = strcat(extractBefore(eegs{rindex}{1}, '.set'), '_', eegs{rindex}{3}, '.set');
    
    if ~isfile(strcat(target_path, EEG1filename)) || ~isfile(strcat(target_path, EEG2filename))
        try
            EEG = pop_loadset('filename', eegs{rindex}{1}, 'filepath', filepath); 
            
            if ~isfile(strcat(target_path, EEG1filename))
                EEG1 = EEG;
                EEG1 = pop_rmdat( EEG1, {eegs{rindex}{2}},[0 9.5] ,0);
                EEG1 = pop_runica(EEG1, 'icatype', 'runica', 'extended',1,'interrupt','off');
                EEG1 = pop_multifit(EEG1, [1:EEG1.nbchan] ,'threshold',100,'plotopt',{'normlen' 'on'});
                EEG1 = pop_saveset( EEG1, 'filename', EEG1filename ,'filepath', target_path);
            end
            if ~isfile(strcat(target_path, EEG2filename))
                EEG2 = EEG;
                EEG2 = pop_rmdat( EEG2, {eegs{rindex}{3}},[0 9.5] ,0);
                EEG2 = pop_runica(EEG2, 'icatype', 'runica', 'extended',1,'interrupt','off');
                EEG2 = pop_multifit(EEG2, [1:EEG2.nbchan] ,'threshold',100,'plotopt',{'normlen' 'on'});
                EEG2 = pop_saveset( EEG2, 'filename', EEG2filename , 'filepath', target_path);
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