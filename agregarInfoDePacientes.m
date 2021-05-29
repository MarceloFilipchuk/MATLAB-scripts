% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% PARA MIGRAÑOSOS                                                                        %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

comment = ['DNI: %s; Edad: %d; Sexo: %s; PC: %d; Dx: %s; Ciclo de migraña: %s;\n\n', ...
'-Elimina los eventos que no son de interés.\n',...
'-Comienza con el primer evento del EEG.\n',...
'-Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.\n',...         
'-Remueve la baseline.\n',...
'-Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB).\n',...
'-Cleanline a 50 Hz.\n',...
'-Re referencia a AVG.\n',...             
'-ICA y ajuste acorde a radio cefálico pendiente acorde a objetivo del trabajo.\n'
];

eeglab

filepath = {
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Migrañosos'
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Migrañosos\AVG - Solo ICA'
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Migrañosos\AVG - Solo ICA\Limpios por ICA modificado'
}; 

mig = {
{ '16561154.set' 55 'F' 52 '1.1' 'INTERICTAL' 'E' }
{ '17004849.set' 55 'F' 53 '1.1 + 1.3 + 8.2' 'ICTAL' 'C' }
{ '17384808.set' 55 'F' 55 '1.1 + 1.3 + 8.2' 'INTERICTAL' 'C' }
{ '21628054.set' 50 'F' 56 '1.2' 'ICTAL' 'E' }
{ '22672559.set' 48 'F' 56 '1.1 + 8.2' 'ICTAL' 'C' }
{ '23231229.set' 47 'F' 56 '1.1 + 1.3 + 8.2' 'ICTAL' 'C' }
{ '23267975.set' 47 'F' 52 '1.1' 'ICTAL' 'E' }
{ '24014278.set' 46 'F' [] '1.1 + 8.2' 'ICTAL' 'C' }
{ '24196666.set' 45 'F' 56 '1.1 + 8.2' 'PREICTAL' 'C' }
{ '24671814.set' 45 'F' 54 '1.1' 'INTERICTAL' 'E' }
{ '25921670.set' 42 'F' 56 '1.2' 'ICTAL' 'E' }
{ '26089010.set' 43 'F' 57 '1.3' 'ICTAL' 'C' }
{ '26636248.set' 41 'F' 57 '1.1' 'ICTAL' 'E' }
{ '26681314.set' 41 'M' 58 '' 'ICTAL' '' }
{ '27065788.set' 41 'F' 57 '1.1' 'ICTAL' 'E' }
{ '28357169.set' 39 'F' 57 '1.1 + 1.3 + 8.2' 'ICTAL' 'C' }
{ '28456579.set' 39 'F' 58 '1.2' 'INTERICTAL' 'E' }
{ '28655843.set' 39 'F' 56 '1.2' 'ICTAL' 'E' }
{ '29136654.set' 48 'F' 54 '1.2' 'ICTAL' 'E' }
{ '29275688.set' 38 'M' 55 '1.2' 'INTERICTAL' 'E' }
{ '30122613.set' 37 'F' 56 '1.1 - 8.2' 'PREICTAL' 'C' }
{ '30469404.set' 36 'F' 55 '1.2' 'ICTAL' 'E' }
{ '30971218.set' 36 'F' 54 '1.2' 'ICTAL' 'E' }
{ '31337569.set' 35 'F' 54 '1.1' 'INTERICTAL' 'E' }
{ '31921461.set' 34 'F' 56 '1.1' 'INTERICTAL' 'E' }
{ '32281962.set' 34 'F' 54 '1.2' 'INTERICTAL' 'E' }
{ '33029169.set' 33 'F' 58 '1.2' 'ICTAL' 'E' }
{ '33387926.set' 32 'F' [] '1.1' 'ICTAL' 'E' }
{ '33437020.set' 32 'F' 54 '1.1' 'ICTAL' 'E' }
{ '33700358.set' 32 'M' 59 '1.1' 'INTERICTAL' 'E' }
{ '34070751.set' 31 'F' [] '1.3 + 8.2' 'ICTAL' 'C' }
{ '34839043.set' 30 'F' 56 '1.1' 'INTERICTAL' 'E' }
{ '35109977.set' 30 'F' 52 '1.1' 'ICTAL' 'E' }
{ '37126067.set' 27 'F' 54 '1.1' 'ICTAL' 'E' }
{ '37732352.set' 27 'F' 57 '1.2' 'ICTAL' 'E' }
{ '39546581.set' 24 'F' 59 '1.1' 'INTERICTAL' 'E' }
{ '39733285.set' 24 'F' 55 '1.1' 'PREICTAL' 'E' }
{ '39736478.set' 23 'F' 59 '1.2' 'ICTAL' 'E' }
{ '40506862.set' 21 'F' 49 '1.1' 'ICTAL' 'E' }
{ '41440670.set' 21 'F' 52 '1.2' 'INTERICTAL' 'E' }
{ '42637732.set' 35 'F' 57 '1.2????' 'ICTAL' '' }
{ '42642102.set' 20 'F' 53 '1.1' 'INTERICTAL' 'E' }
{ '43143194.set' 19 'F' 58 '1.1' 'ICTAL' 'E' }
{ '43143713.set' 19 'F' [] '1.2' 'INTERICTAL' 'E' }
{ '43604422.set' 18 'F' [] '1.1 + 1.3' 'ICTAL' 'C' }
{ '43673629.set' 18 'F' 54 '1.1' 'ICTAL' 'E' }
{ '44273002.set' 17 'F' [] '1.2' 'ICTAL' 'E' }
{ '44677571.set' 14 'F' 57 '1.1' 'INTERICTAL' 'E' }
{ '45090150.set' 16 'F' 56 '1.1' 'ICTAL' 'E' }
{ '45693186.set' 16 'F' 56 '1.2' 'INTERICTAL' 'E' }
{ '46374112.set' 14 'F' 55 '1.1' 'INTERICTAL' 'E' }
{ '95926170.set' 30 'F' [] '1.2' 'ICTAL' 'E' }
{ '28127064.set' 39 'F' 57 '1.1 + 8.2' 'ICTAL' 'C' }
{ '36802064.set' 28 'F' [] '1.1 + 8.2' 'ICTAL' 'C' }
{ '30330962.set' 37 'F' 52 '1.1' 'ICTAL' 'E' }
{ '36142459.set' 28 'F' 54 '1.2' 'INTERICTAL' 'E' }
{ '26790006.set' 42 'M' 58 '1.1' 'ICTAL' 'E' }
{ '30844130.set' 36 'F' 57 '1.1 + 8.2' 'ICTAL' 'C' }
{ '95760930.set' 35 'F' 55 '1.1' 'ICTAL' 'E' }
{ '36131374.set' 27 'F' 56 '1.1' 'ICTAL' 'E' }
{ '45487927.set' 16 'F' 58 '1.1' 'INTERICTAL' 'E' }
{ '33437628.set' 32 'M' 58 '1.1' 'ICTAL' 'E' }
{ '39693608.set' 24 'F' 56 '1.1' 'ICTAL' 'E' }
{ '41680083.set' 21 'M' 55 '1.1' 'ICTAL' 'E' }
{ '40026470.set' 23 'F' 58 '1.1' 'ICTAL' 'E' }
{ '31058058.set' 36 'F' 56 '1.2' 'INTERICTAL' 'E' }
{ '35636118.set' 28 'F' 55 '1.1 + 1.3?' 'ICTAL' '' }
{ '29712356.set' 37 'F' 51 '1.1' 'INTERICTAL' 'E' }
{ '29154320.set' 38 'F' [] '1.1' 'INTERICTAL' 'E' }
{ '25455720.set' 44 'F' 56 '1.2 + 1.3' 'ICTAL' 'C' }
{ '39057518.set' 25 'F' 54 '1.1 + 1.3' 'ICTAL' 'C' }
{ '34455144.set' 31 'F' 55 '1.1 + 8.2' 'PREICTAL' 'C' }
{ '26903214.set' 42 'F' 52 '1.1 + 1.3' 'ICTAL' '' }
{ '35915823.set' 29 'F' 54 '1.2' 'INTERICTAL' 'E' }
{ '30628863.set' 36 'F' 55 '1.1' 'ICTAL' 'E' }
{ '45936466.set' 16 'M' 54 '1.1' 'ICTAL' 'E' }
{ '39073136.set' 26 'F' 55 '1.1' 'ICTAL' 'E' }
{ '25736769.set' 43 'F' 56 '1.1' 'ICTAL' 'E' }
{ '13153801.set' 61 'F' 55 '1.2' 'ICTAL' 'E' }
{ '37107273.set' 27 'F' [] '1.2' 'ICTAL' 'E' }
{ '21139530.set' 51 'F' 55 '1.1' 'ICTAL' 'E' }
{ '42783515.set' 56 'F' 20 '1.2' 'ICTAL' 'E' }
{ '29476363.set' 38 'F' 56 '1.1' 'PREICTAL' 'E' }
{ '40026470.set' 23 '' 58 '1.1' 'ICTAL' 'E' }
{ '24367434.set' 46 'F' [] '1.1 + 8.2' 'ICTAL' 'C' }
{ '35064083.set' 30 'F' 52 '1.1' 'INTERICTAL' 'E' }
{ '34989974.set' 31 'F' 53 '1.2' 'INTERICTAL' 'E' }
{ '29606275.set' 48 'F' 55 '1.1 - 8.2' 'ICTAL' 'C' }
{ '43926390.set' 19 'F' 54 '1.1' 'INTERICTAL' 'E' }
{ '28374342.set' 40 'F' 56 '1.1 - 8.2' 'ICTAL' 'C' }
};
for findex = 1:length(filepath)
cd(filepath{findex});
eegs = dir('*.set');
eegs = {eegs.name}';
    for eindex = 1:length(eegs)
        for mindex = 1:length(mig)
            if eegs{eindex} == mig{mindex}{1}
                EEG = pop_loadset('filename',eegs{eindex},'filepath',filepath{findex});
                filename = extractBefore(eegs{eindex}, '.set');
                EEG.comments =[];
                EEG.comments = sprintf(comment, filename, mig{mindex}{2}, mig{mindex}{3}, mig{mindex}{4}, mig{mindex}{5}, mig{mindex}{6});
                EEG.patient_info.id = filename;
                EEG.patient_info.age = mig{mindex}{2};
                EEG.patient_info.sex = mig{mindex}{3};
                EEG.patient_info.head_perimeter = mig{mindex}{4};
                EEG.patient_info.dx = mig{mindex}{5};
                EEG.patient_info.migraine_phase = mig{mindex}{6};
                EEG = pop_saveset( EEG, 'filename', filename ,'filepath', filepath{findex});
            end
        end
    end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% PARA CONTROLES                                                                        %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

comment = ['DNI: %s; Edad: %d; Sexo: %s; PC: %d; Dx: %s; \n\n', ...
'-Elimina los eventos que no son de interés.\n',...
'-Comienza con el primer evento del EEG.\n',...
'-Edita los canales usando coordenadas MNI y AF9h y AF10h para los EOG1 y EOG2 respectivamente.\n',...         
'-Remueve la baseline.\n',...
'-Deja solo las frecuencias superiores a 1Hz(paso indicado en el tutorial de EEGLAB).\n',...
'-Cleanline a 50 Hz.\n',...
'-Re referencia a AVG.\n',...             
'-ICA y ajuste acorde a radio cefálico pendiente acorde a objetivo del trabajo.\n'
];

filepath= {
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Controles'
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Controles\AVG - Solo ICA'
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\EEG\Controles\AVG - Solo ICA\Limpios por ICA modificado'
};

control = {
{ '41088886.set' 17 'F' []  'Control' }
{ '43132578.set' 17 'F' []  'Control' }
{ '43272306.set' 17 'F' []  'Control' }
{ '42217829.set' 19 'F' []  'Control' }
{ '38736951.set' 24 'F' []  'Control' }
{ '31105839.set' 30 'F' []  'Control' }
{ '29963925.set' 32 'F' []  'Control' }
{ '33303993.set' 32 'F' []  'Control' }
{ '29714464.set' 33 'F' []  'Control' }
{ '26672197.set' 38 'F' []  'Control' }
{ '28104626.set' 40 'M' []  'Control' }
{ '21395196.set' 45 'F' []  'Control' }
{ '16445692.set' 55 'M' []  'Control' }
{ '34188566.set' 30 'F' []  'Control' }
{ '33598751.set' 30 'F' []  'Control' }
{ '31219115.set' 30 'F' []  'Control' }
{ '33380758.set' 32 'F' []  'Control' }
{ '31055689.set' 35 'F' []  'Control' }
{ '27652980.set' 38 'F' []  'Control' }
{ '36357088.set' 26 'F' []  'Control' }
{ '34601430.set' 27 'F' []  'Control' }
{ '36232087.set' 27 'F' []  'Control' }
{ '20998802.set' 45 'F' []  'Control' }
{ '20700634.set' 46 'F' []  'Control' }
{ '18498243.set' 51 'F' []  'Control' }
  
};
for findex = 1:1%length(filepath)
cd(filepath{findex});
eegs = dir('*.set');
eegs = {eegs.name}';
    for eindex = 1:length(eegs)
        for mindex = 1:length(control)
            if eegs{eindex} == control{mindex}{1}
                EEG = pop_loadset('filename',eegs{eindex},'filepath',filepath{findex});
                filename = extractBefore(eegs{eindex}, '.set');
                EEG.comments = [];
                try
                    EEG.patient_info = rmfield(EEG.patient_info, "migraine_phase");
                catch ME
                end
                EEG.comments = sprintf(comment, filename, control{mindex}{2}, control{mindex}{3}, control{mindex}{4}, control{mindex}{5});
                EEG.patient_info.id = filename;
                EEG.patient_info.age = control{mindex}{2};
                EEG.patient_info.sex = control{mindex}{3};
                EEG.patient_info.head_perimeter = control{mindex}{4};
                EEG.patient_info.dx = control{mindex}{5};
                EEG = pop_saveset( EEG, 'filename', filename ,'filepath', filepath{findex});
            end
        end
    end
end

