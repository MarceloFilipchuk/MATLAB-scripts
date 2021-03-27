filepath = "E:\Investigacion\Cefalea\Investigacion\QEEG\SLOR para clasificar - limitadas";
filepath = strcat(filepath, '\');

target_path = "E:\Investigacion\Cefalea\Investigacion\QEEG\SLOR -  limitadas";
target_path = strcat(target_path, '\');
cd(target_path);

eegs = {
{ "4642410.slor" 'C' 8.2 'ICTAL' "10171493.slor" }
{ "17004849.slor" 'C' 8.2 'ICTAL' "16833028.slor" }
{ "17384808.slor" 'C' 8.2 'INTERICTAL' "16445692.slor" }
{ "18820818.slor" 'C' 1.3 'ICTAL' "24992919.slor" }
{ "23231229.slor" 'C' 8.2 'ICTAL' "16740814.slor" }
{ "24014278.slor" 'C' 8.2 'ICTAL' "18498243.slor" }
{ "24196666.slor" 'C' 8.2 'PREICTAL' "20381885.slor" }
{ "25455720.slor" 'C' 1.3 'ICTAL' "17530412.slor" }
{ "26089010.slor" 'C' 1.3 'ICTAL' "20224517.slor" }
{ "28357169.slor" 'C' 8.2 'ICTAL' "24615679.slor" }
{ "28859146.slor" 'C' 8.2 'ICTAL' "20998802.slor" }
{ "30122613.slor" 'C' 8.2 'PREICTAL' "24463852.slor" }
{ "30844130.slor" 'C' 8.2 'ICTAL' "27076906.slor" }
{ "34070751.slor" 'C' 8.2 'ICTAL' "31105839.slor" }
{ "36428905.slor" 'C' 8.2 'ICTAL' "36357088.slor" }
{ "36802064.slor" 'C' 8.2 'ICTAL' "34601430.slor" }
{ "38329607.slor" 'C' 8.2 'ICTAL' "38736951.slor" }
{ "43604422.slor" 'C' 1.3 'ICTAL' "41088886.slor" }
{ "16561154.slor" 'E' 1.1 'INTERICTAL' "5951564.slor" }
{ "17842655.slor" 'E' 1.1 'PREICTAL' "10683535.slor" }
{ "21628054.slor" 'E' 1.2 'ICTAL' "14339047.slor" }
{ "22672559.slor" 'E' 1.1 'ICTAL' "16293599.slor" }
{ "23021007.slor" 'E' 1.1 'ICTAL' "16742233.slor" }
{ "23267975.slor" 'E' 1.1 'ICTAL' "16157868.slor" }
{ "24671814.slor" 'E' 1.1 'INTERICTAL' "18017224.slor" }
{ "25921670.slor" 'E' 1.2 'ICTAL' "20700634.slor" }
{ "26636248.slor" 'E' 1.1 'ICTAL' "22996280.slor" }
{ "26672624.slor" 'E' 1.2 'ICTAL' "20073257.slor" }
{ "26681314.slor" 'E' 1.1 'ICTAL' "28104626.slor" }
{ "26790006.slor" 'E' 1.1 'ICTAL' "25758828.slor" }
{ "27065788.slor" 'E' 1.1 'ICTAL' "21390696.slor" }
{ "28127064.slor" 'E' 1.1 'ICTAL' "21395196.slor" }
{ "28456579.slor" 'E' 1.2 'INTERICTAL' "22221330.slor" }
{ "28655843.slor" 'E' 1.2 'ICTAL' "23198334.slor" }
{ "29136654.slor" 'E' 1.2 'ICTAL' "1700391.slor" }
{ "29166639.slor" 'E' 1.1 'ICTAL' "22808531.slor" }
{ "29253079.slor" 'E' 1.1 'ICTAL' "23089919.slor" }
{ "29275688.slor" 'E' 1.2 'INTERICTAL' "28432439.slor" }
{ "30330962.slor" 'E' 1.1 'ICTAL' "27549509.slor" }
{ "30469404.slor" 'E' 1.2 'ICTAL' "27652980.slor" }
{ "30900116.slor" 'E' 1.1 'ICTAL' "30648088.slor" }
{ "30971218.slor" 'E' 1.2 'ICTAL' "26672197.slor" }
{ "31337569.slor" 'E' 1.1 'INTERICTAL' "32406969.slor" }
{ "31921461.slor" 'E' 1.1 'INTERICTAL' "29714464.slor" }
{ "32281962.slor" 'E' 1.2 'INTERICTAL' "31055689.slor" }
{ "33029169.slor" 'E' 1.2 'ICTAL' "29963925.slor" }
{ "33387926.slor" 'E' 1.1 'ICTAL' "33380758.slor" }
{ "33437020.slor" 'E' 1.1 'ICTAL' "33303993.slor" }
{ "33437628.slor" 'E' 1.1 'ICTAL' "36447393.slor" }
{ "33700358.slor" 'E' 1.1 'INTERICTAL' "33701475.slor" }
{ "34839043.slor" 'E' 1.1 'INTERICTAL' "34188566.slor" }
{ "35109977.slor" 'E' 1.1 'ICTAL' "33598751.slor" }
{ "36131374.slor" 'E' 1.1 'ICTAL' "36232087.slor" }
{ "36142459.slor" 'E' 1.2 'INTERICTAL' "31769226.slor" }
{ "37126067.slor" 'E' 1.1 'ICTAL' "35347104.slor" }
{ "37732352.slor" 'E' 1.2 'ICTAL' "33639383.slor" }
{ "39546581.slor" 'E' 1.1 'INTERICTAL' "40750520.slor" }
{ "39693608.slor" 'E' 1.1 'ICTAL' "39623688.slor" }
{ "39733285.slor" 'E' 1.1 'PREICTAL' "39620184.slor" }
{ "39736478.slor" 'E' 1.2 'ICTAL' "39623876.slor" }
{ "40506862.slor" 'E' 1.1 'ICTAL' "41322619.slor" }
{ "41268250.slor" 'E' 1.1 'ICTAL' "41736145.slor" }
{ "41440670.slor" 'E' 1.2 'INTERICTAL' "39622056.slor" }
{ "41680083.slor" 'E' 1.1 'ICTAL' "41712730.slor" }
{ "42637732.slor" 'E' 1.1 'ICTAL' "28432926.slor" }
{ "42642102.slor" 'E' 1.1 'INTERICTAL' "42385042.slor" }
{ "42782803.slor" 'E' 1.1 'ICTAL' "41481729.slor" }
{ "43143194.slor" 'E' 1.1 'ICTAL' "43130218.slor" }
{ "43143713.slor" 'E' 1.2 'INTERICTAL' "42217829.slor" }
{ "43673629.slor" 'E' 1.1 'ICTAL' "43361091.slor" }
{ "44273002.slor" 'E' 1.2 'ICTAL' "43132578.slor" }
{ "44677571.slor" 'E' 1.1 'INTERICTAL' ".slor" }
{ "45090150.slor" 'E' 1.1 'ICTAL' ".slor" }
{ "45487927.slor" 'E' 1.1 'INTERICTAL' "43136471.slor" }
{ "45693186.slor" 'E' 1.2 'INTERICTAL' "43272306.slor" }
{ "46374112.slor" 'E' 1.1 'INTERICTAL' ".slor" }
{ "95760930.slor" 'E' 1.1 'ICTAL' "27550318.slor" }
{ "95926170.slor" 'E' 1.2 'ICTAL' "31219115.slor" }
};

mkdir(strcat(target_path, 'Cronicos\'));
mkdir(strcat(target_path, 'Cronicos\Migrañosos'));
mkdir(strcat(target_path, 'Cronicos\Controles'));
mkdir(strcat(target_path, 'Episodicos'));
mkdir(strcat(target_path, 'Episodicos\Migrañosos'));
mkdir(strcat(target_path, 'Episodicos\Controles'));
mkdir(strcat(target_path, 'Episodicos\ICTALES'));
mkdir(strcat(target_path, 'Episodicos\ICTALES\Migrañosos'));
mkdir(strcat(target_path, 'Episodicos\ICTALES\Controles'));
mkdir(strcat(target_path, 'Episodicos\INTERICTALES'));
mkdir(strcat(target_path, 'Episodicos\INTERICTALES\Migrañosos'));
mkdir(strcat(target_path, 'Episodicos\INTERICTALES\Controles'));
mkdir(strcat(target_path, 'Episodicos\Aura'));
mkdir(strcat(target_path, 'Episodicos\Aura\ICTALES'));
mkdir(strcat(target_path, 'Episodicos\Aura\ICTALES\Migrañosos'));
mkdir(strcat(target_path, 'Episodicos\Aura\ICTALES\Controles'));
mkdir(strcat(target_path, 'Episodicos\Aura\INTERICTALES'));
mkdir(strcat(target_path, 'Episodicos\Aura\INTERICTALES\Migrañosos'));
mkdir(strcat(target_path, 'Episodicos\Aura\INTERICTALES\Controles'));
mkdir(strcat(target_path, 'Episodicos\Sin Aura'));
mkdir(strcat(target_path, 'Episodicos\Sin Aura\ICTALES'));
mkdir(strcat(target_path, 'Episodicos\Sin Aura\ICTALES\Migrañosos'));
mkdir(strcat(target_path, 'Episodicos\Sin Aura\ICTALES\Controles'));
mkdir(strcat(target_path, 'Episodicos\Sin Aura\INTERICTALES'));
mkdir(strcat(target_path, 'Episodicos\Sin Aura\INTERICTALES\Migrañosos'));
mkdir(strcat(target_path, 'Episodicos\Sin Aura\INTERICTALES\Controles'));

for index = 1:length(eegs)
    mig = strcat(filepath, eegs{index}{1});
    control = strcat(filepath, eegs{index}{5});
    
    %Divide episodicos y cronicos
    if strcmp(eegs{index}{2}, 'C')
        try
            copyfile(mig, strcat(target_path, "Cronicos\Migrañosos")) % Migrañoso
            copyfile(control, strcat(target_path, "Cronicos\Controles")) % Control
        catch ME
            warning("%s Line(%d) in '%s'", ME.message,  ME.stack.line, ME.stack.name);
            continue
        end
    else
        try
            copyfile(mig, strcat(target_path, "Episodicos\Migrañosos")) % Migrañoso
            copyfile(control, strcat(target_path, "Episodicos\Controles")) % Control
        catch ME
            warning("%s Line(%d) in '%s'", ME.message,  ME.stack.line, ME.stack.name);
            continue
        end
        
        % Divide ictales e interictales
        if strcmp(eegs{index}{4}, 'ICTAL') 
            try
                copyfile(mig, strcat(target_path, "Episodicos\ICTALES\Migrañosos")) % Migrañoso
                copyfile(control, strcat(target_path, "Episodicos\ICTALES\Controles")) % Control
            catch ME
                warning("%s Line(%d) in '%s'", ME.message,  ME.stack.line, ME.stack.name);
                continue
            end
        else
            try
                copyfile(mig, strcat(target_path, "Episodicos\INTERICTALES\Migrañosos")) % Migrañoso
                copyfile(control, strcat(target_path, "Episodicos\INTERICTALES\Controles")) % Control
            catch ME
                warning("%s Line(%d) in '%s'", ME.message,  ME.stack.line, ME.stack.name);
                continue
            end
        end
        
        % Divide por diagnostico
        if eegs{index}{3} == 1.2 % Aura
            if strcmp(eegs{index}{4}, 'ICTAL')
                try
                    copyfile(mig, strcat(target_path, "Episodicos\Aura\ICTALES\Migrañosos")) % Migrañoso
                    copyfile(control, strcat(target_path, "Episodicos\Aura\ICTALES\Controles")) % Control
                catch ME
                    warning("%s Line(%d) in '%s'", ME.message,  ME.stack.line, ME.stack.name);
                    continue
                end
            else
                try
                    copyfile(mig, strcat(target_path, "Episodicos\Aura\INTERICTALES\Migrañosos")) % Migrañoso
                    copyfile(control, strcat(target_path, "Episodicos\Aura\INTERICTALES\Controles")) % Control
                catch ME
                    warning("%s Line(%d) in '%s'", ME.message,  ME.stack.line, ME.stack.name);
                    continue
                end
            end
        else % Sin aura
            if strcmp(eegs{index}{4}, 'ICTAL')
                try
                    copyfile(mig, strcat(target_path, "Episodicos\Sin Aura\ICTALES\Migrañosos")) % Migrañoso
                    copyfile(control, strcat(target_path, "Episodicos\Sin Aura\ICTALES\Controles")) % Control
                catch ME
                    warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
                    continue
                end
            else
                try
                    copyfile(mig, strcat(target_path, "Episodicos\Sin Aura\INTERICTALES\Migrañosos")) % Migrañoso
                    copyfile(control, strcat(target_path, "Episodicos\Sin Aura\INTERICTALES\Controles")) % Control
                catch ME
                    warning("%s Line %d in '%s'", ME.message,  ME.stack.line, ME.stack.name);
                    continue
                end
            end
        end 
    end
end
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');
