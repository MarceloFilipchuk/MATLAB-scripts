% DEFINIR EL INDEX TIPEANDOLO EN LA CONSOLA => index = 1;.

% Direccion de los archivos que se quieren procesar.
filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Controles\Limpios\Rereferenciados + ICA';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Ictales\Limpios\Rereferenciados + ICA';
% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG\Interictales\Limpios\Rereferenciados + ICA';

filepath = strcat(filepath, '\');

% Busca todos los archivos '*.set' en el directorio para procesarlos.
cd(filepath);
eegs = dir('*.set');
eegs = {eegs.name}';

eeglab;
sz = [71 11];
% varTypes = ["double", "double", "string", "string", "string", "double", "double", "double", "double", "double", "double"];
varNames = ["id", "age", "sex", "dx", "response", "alpha_R_x", "alpha_R_y", "alpha_R_z", "alpha_L_x", "alpha_L_y", "alpha_L_z",...
    "beta_R_x", "beta_R_y", "beta_R_z", "beta_L_x", "beta_L_y", "beta_L_z"];

% final = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames', varNames) ;
tmp = cell(sz);

for index = 1:length(eegs)
    EEG = pop_loadset('filename', eegs{index}, 'filepath', filepath);

    tmp{index, 1 } = EEG.patient_info.id;
    tmp{index, 2 }  = EEG.patient_info.age;
    tmp{index, 3 }  = EEG.patient_info.sex;
    tmp{index, 4 }  = EEG.patient_info.dx;
    tmp{index, 5 }  = EEG.patient_info.response;
    tmp{index, 6 }  = EEG.patient_info.first_peak_component_R.coordinates.x;
    tmp{index, 7 }  = EEG.patient_info.first_peak_component_R.coordinates.y;
    tmp{index, 8 }  = EEG.patient_info.first_peak_component_R.coordinates.z;
    tmp{index, 9 }  = EEG.patient_info.first_peak_component_L.coordinates.x;
    tmp{index, 10 }  = EEG.patient_info.first_peak_component_L.coordinates.y;
    tmp{index, 11 }  = EEG.patient_info.first_peak_component_L.coordinates.z;
    tmp{index, 12 }  = EEG.patient_info.second_peak_component_R.coordinates.x;
    tmp{index, 13 }  = EEG.patient_info.second_peak_component_R.coordinates.y;
    tmp{index, 14 }  = EEG.patient_info.second_peak_component_R.coordinates.z;
    tmp{index, 15 }  = EEG.patient_info.second_peak_component_L.coordinates.x;
    tmp{index, 16 }  = EEG.patient_info.second_peak_component_L.coordinates.y;
    tmp{index, 17 }  = EEG.patient_info.second_peak_component_L.coordinates.z;

%         index = index + 1;
end


finaltable = cell2table(tmp, "VariableNames", varNames);
writetable(finaltable, 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\Tabla final.xls');