% Crea el STUDY para calcular valores espectrales con FFT. Carga de a un paciente (10 condiciones para cada uno), por
% cuestiones de memoria.

load patients_GOLLA.mat
load commands_GOLLA.mat

for index = 1:10:length(patients_GOLLA)
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    tmpcommands = {commands_GOLLA{index:index+9,:}};
    [STUDY ALLEEG] = std_editset( STUDY, [], 'name','GOLLA STUDY',...
    'commands',...
    tmpcommands,'updatedat','off','rmclust','on' );

    [STUDY ALLEEG] = std_checkset(STUDY, ALLEEG);
    CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
%     [STUDY, ALLEEG] = std_precomp(STUDY, ALLEEG, {},'savetrials','on','recompute','on','spec','on','specparams',{'specmode','fft','logtrials','off'});
    [STUDY, ALLEEG] = std_precomp(STUDY, ALLEEG, {},'savetrials','on','recompute','on','spec','on','specparams',{'specmode','psd','logtrials','off','overlap',100});
    [ALLEEG EEG CURRENTSET ALLCOM] = deal([]);
end

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');

