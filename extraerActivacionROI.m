filepath = {
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\NII clasificados NORMALIZADOS\Controles';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\NII clasificados NORMALIZADOS\Cronicos';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\NII clasificados NORMALIZADOS\Migrañosos\Ictales';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\NII clasificados NORMALIZADOS\Migrañosos\Interictales';
};

ROI_filepath = {
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\BA25.nii';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\BA31.nii';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\BA40.nii';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\L-BA7.nii';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\R-BA20.nii';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\R-BA34.nii';
};

header = {'DNI', 'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma' };

% Itera sobre cada ROI.
for rindex = 1:length(ROI_filepath)
    ROI = niftiread(ROI_filepath{rindex});
    ROI_name = strcat(extractBetween(ROI_filepath{rindex}, 'ROI\', '.nii'), '.xls');
    
    % Itera sobre cada directorio.
    for findex = 1:length(filepath)
        table = {};
        table = header;

        % Crea una lista de pacientes que estan dentro del directorio.
        cd(filepath{findex})
        patients = dir('*.nii');
        patients = {patients.name}';
        patients = extractBefore(patients, '-');
        patients = unique(patients);

        % Itera sobre la lista de pacientes.
        for pindex = 1:length(patients)
            table{pindex+1, 1} = patients{pindex};

            % Contiene lista de '*.nii' de un paciente.
            patientNII = dir('*.nii');
            patientNII = {patientNII.name}';
            patientNII = patientNII(contains(patientNII, patients{pindex})); 

            % Itera sobre cada archivo
            for nindex = 1:length(patientNII)
                nifti = niftiread(patientNII{nindex});
                band = extractBetween(patientNII{nindex}, '-', '.nii');
                final = nifti .* ROI; % Aplica la ROI a todo el mapa
%                 final = log(final(:));  % Aplica Log base 'e' a todos los valores dentro de la ROI. OPCIONAL
                ROIsize = length(ROI(ROI ~= 0)); % Tamaño de la ROI.
                switch band{1}
                    case 'Delta'
                        column = 2;
                    case 'Theta'
                        column = 3;
                    case 'Alpha'
                        column = 4;
                    case 'Beta'
                        column = 5;
                    case 'Gamma'
                        column = 6;
                end
                table{pindex+1, column} = sum(final,'all') / ROIsize; % Calcula promedio de valores DENTRO del mapa
            end
        end
        writecell(table, ROI_name{1});
    end
end

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');