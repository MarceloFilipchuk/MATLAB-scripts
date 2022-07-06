% Crea matrices para cargar el STUDY y calcular poder con con FFT usando las funciones del STUDY de EEGLAB.

eegs = dir('E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG todos los picos\**\*.set');

eeglab
% Crea lista de pacientes.
for index = 1:size(eegs, 1)
    EEG1 = pop_loadset('filename', eegs(index).name, 'filepath', eegs(index).folder);
    
    % Filepath
    finaltable_GOLLA{index,1}  = strcat(eegs(index).folder,'\', eegs(index).name);
    patients_GOLLA(index).filepath = strcat(eegs(index).folder,'\', eegs(index).name);
    
    % Subject
    finaltable_GOLLA{index,2}  = EEG1.setname;
    patients_GOLLA(index).subject = EEG1.setname;
    
    % Condition
    tmp = extractBetween(eegs(index).name, '_', '.set');
    finaltable_GOLLA{index,3} = tmp{1};
    patients_GOLLA(index).condition = tmp{1};
    
    % Group
    if isfield(EEG1.patient_info, 'migraine_phase')
        finaltable_GOLLA{index,4} = EEG1.patient_info.migraine_phase;
        patients_GOLLA(index).group = EEG1.patient_info.migraine_phase;
    else
        finaltable_GOLLA{index,4} = EEG1.patient_info.dx;
        patients_GOLLA(index).group = EEG1.patient_info.dx;
    end
    % For sorting
    tmp2 = extractBetween(eegs(index).name, '_PHOTO ', 'Hz.set');
    finaltable_GOLLA{index,5} = str2num(tmp2{1});
    patients_GOLLA(index).fe_freq = str2num(tmp2{1});
end

% for index = 1:length(patients_GOLLA)
%     tmp2 = extractBetween(patients_GOLLA(index).condition, 'PHOTO ', 'Hz');
%     patients_GOLLA(index).fe_freq = str2num(tmp2{1});
% end

% For sorting
t = struct2table(patients_GOLLA);
t = sortrows(t,{'group', 'subject', 'fe_freq'},'ascend');
patients_GOLLA = table2struct(t);

save('E:\Investigacion\MATLAB-scripts\Respuesta H\patients_GOLLA.mat', 'patients_GOLLA');

% Crea lista de comandos
commands_GOLLA = cell(length(patients_GOLLA),1);
for index = 1:length(patients_GOLLA)
    commands_GOLLA{index} = {'index',index,'load',patients_GOLLA(index).filepath,'subject',patients_GOLLA(index).subject,'condition',patients_GOLLA(index).condition,'group',patients_GOLLA(index).group};
end

save('E:\Investigacion\MATLAB-scripts\Respuesta H\commands_GOLLA.mat', 'commands_GOLLA');

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');