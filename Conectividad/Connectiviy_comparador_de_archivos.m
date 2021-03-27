filepath1 = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG\Makoto ICLabel rejection';
filepath1 = strcat(filepath1, '\');
cd(filepath1)
eegs1 = dir('*.set');
eegs1 = {eegs1.name}';

filepath2 = 'E:\Investigacion\EEG\Pacientes con datos sobre dias de cefalea\EEG\Makoto ICLabel rejection\Final\Fotoestimulacion de igual duracion';
filepath2 = strcat(filepath2, '\');
cd(filepath2)
eegs2 = dir('*.set');
eegs2 = {eegs2.name}';

diff = setdiff(eegs1, eegs2);
disp(diff);
cd(extractBefore(mfilename('fullpath'), mfilename))