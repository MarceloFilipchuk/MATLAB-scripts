filepath = {
    'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios\Rereferenciados + ICA\Fotoestimulacion solo picos\Respuesta H\Primer pico';
    'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios\Rereferenciados + ICA\Fotoestimulacion solo picos\Respuesta H\Segundo pico';
};

tmp = {};
commands = {};
patients = struct('filepath', {}, 'subject', {}, 'group', {}, 'response', {}, 'components', {}, 'peak', {}, 'left_comp', {}, 'right_comp', {});
eeglab;
% Itera sobre cada archivo en el directorio.
counter = 1;
for findex = 1:length(filepath)
    cd(filepath{findex});
    eegs = dir('*.set');
    eegs = {eegs.name}';
    for index = 1:length(eegs)
        EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath{findex});
        
        if str2double(extractBetween(EEG.filename, 'PHOTO ', 'Hz')) <= 12
            peak = '1st peak';
        else 
            peak = '2nd peak';
        end
        patients(counter).filepath = strcat(EEG.filepath, '\', EEG.filename);
        patients(counter).subject = EEG.setname;
        patients(counter).group = extractBetween(filepath{findex}, '\Respuesta H\EEG\', '\Limpios\');
        patients(counter).response = EEG.response;
        patients(counter).components = [EEG.left_occipital_ic.comp_index EEG.right_occipital_ic.comp_index];
        patients(counter).peak = peak;
        if ~isempty(EEG.left_occipital_ic)
        patients(counter).left_comp = EEG.left_occipital_ic.comp_index;
        else
            patients(counter).left_comp = [];
        end
        if ~isempty(EEG.right_occipital_ic)
        patients(counter).right_comp = EEG.right_occipital_ic.comp_index;
        else
            patients(counter).right_comp = [];
        end
        
        tmp = {};
        tmp{1} = 'index';
        tmp{2} = counter;
        tmp{3} = 'load';
        tmp{4} = strcat(EEG.filepath, '\', EEG.filename);
        tmp{5} = 'subject';
        tmp{6} = EEG.setname;
        tmp{7} = 'condition';
        tmp{8} = peak;
        tmp{9} = 'group';
        tmp{10} = EEG.response;
        tmp{11} = 'comps';
        tmp{12} = [EEG.left_occipital_ic.comp_index EEG.right_occipital_ic.comp_index];
        commands{counter} = tmp;
        
        counter = counter + 1;
    end
end

cd(extractBefore(mfilename('fullpath'), mfilename))
save patients
commands = commands';
save commands
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw;
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');