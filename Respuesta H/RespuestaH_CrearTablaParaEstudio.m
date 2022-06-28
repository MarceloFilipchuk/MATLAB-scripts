eegs = dir('E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG picos\**\*.set');
cd('E:\Investigacion\Cefalea\Trabajos\Respuesta H\');
eeglab
% Crea lista de pacientes.
for index = 1:size(eegs, 1)
    EEG1 = pop_loadset('filename', eegs(index).name, 'filepath', eegs(index).folder);
    
    % Filepath
    finaltable{index,1}  = strcat(eegs(index).folder,'\', eegs(index).name);
    patients(index).filepath = strcat(eegs(index).folder,'\', eegs(index).name);
    % Subject
    finaltable{index,2}  = extractBefore(EEG1.setname, '_PHOTO');
    patients(index).subject = extractBefore(EEG1.setname, '_PHOTO');
    % Condition
    if isfield(EEG1.patient_info, 'first_peak')
        finaltable{index,3} = 'Alpha peak';
        patients(index).condition = 'Alpha peak';
    else
        finaltable{index,3} = 'Beta peak';
        patients(index).condition = 'Beta peak';
    end
    % Group
    if isfield(EEG1.patient_info, 'migraine_phase')
        finaltable{index,4} = [EEG1.patient_info.migraine_phase,' ', EEG1.patient_info.response];
         patients(index).group = [EEG1.patient_info.migraine_phase,' ', EEG1.patient_info.response];
    else
        finaltable{index,4} = [EEG1.patient_info.dx,' ', EEG1.patient_info.response];
        patients(index).group = [EEG1.patient_info.dx,' ', EEG1.patient_info.response];
    end
    % Comps
    finaltable{index,5} = [EEG1.patient_info.component_L.index EEG1.patient_info.component_R.index];
    patients(index).comps = [EEG1.patient_info.component_L.index EEG1.patient_info.component_R.index];
    
    patients(index).component_R = EEG1.patient_info.component_R.index;
    patients(index).component_L = EEG1.patient_info.component_L.index;
    
    % Response
    patients(index).response = EEG1.patient_info.response;
end

save('patients.mat', 'patients');

% Crea lista de comandos
commands = cell(length(patients),1);
for index = 1:length(patients)
    commands{index} = {'index',index,'load',patients(index).filepath,'subject',patients(index).subject,'condition',patients(index).condition,'group',patients(index).group, 'comps', patients(index).comps};
end

save('commands.mat', 'commands');

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');