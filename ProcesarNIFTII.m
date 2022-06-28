% filepath = {
% 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NIIs clasificados\Controles';
% 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NIIs clasificados\Cronicos';
% 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NIIs clasificados\Migrañosos\Ictales\Aura';
% 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NIIs clasificados\Migrañosos\Ictales\Sin aura';
% 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NIIs clasificados\Migrañosos\Interictales\Aura';
% 'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NIIs clasificados\Migrañosos\Interictales\Sin aura';
% };

filepath = {
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NII clasificados NORMALIZADOS\Controles';
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NII clasificados NORMALIZADOS\Cronicos';
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NII clasificados NORMALIZADOS\Migrañosos\Ictales';
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\NII clasificados NORMALIZADOS\Migrañosos\Interictales';
};

for findex = 1:length(filepath)
    cd(filepath{findex})
    gz = dir('*.gz');
    gz = {gz.name}';

    patients = gz;
    for index = 1:length(patients)
        patients(index) = extractBefore(patients(index), '-');
    end
    patients = unique(patients);

    for index = 1:length(patients)
        patient = patients{index};

        % Itera sobre los '*.gz'. de cada paciente.
        tmp = gz(contains( gz, patients{index}));
        for tindex = 1:length(tmp)
            tmpfile = extractBetween(tmp(tindex), '-SubjW', '.nii.gz');
            switch tmpfile{1}
                case '001'
                    movefile(strcat(filepath{findex}, '\', tmp{tindex}), strcat(filepath{findex}, '\', patient, '-', 'Delta', '.nii.gz'));
                case '002'
                    movefile(strcat(filepath{findex}, '\', tmp{tindex}), strcat(filepath{findex}, '\', patient, '-', 'Theta', '.nii.gz'));
                case '003'
                    movefile(strcat(filepath{findex}, '\', tmp{tindex}), strcat(filepath{findex}, '\', patient, '-', 'Alpha', '.nii.gz'));
                case '004'
                    movefile(strcat(filepath{findex}, '\', tmp{tindex}), strcat(filepath{findex}, '\', patient, '-', 'Beta', '.nii.gz'));
                case '005'
                    movefile(strcat(filepath{findex}, '\', tmp{tindex}), strcat(filepath{findex}, '\', patient, '-', 'Gamma', '.nii.gz'));
            end
        end
    end
end

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');