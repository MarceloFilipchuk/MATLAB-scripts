filepath = "E:\Investigacion\Cefalea\Investigacion\QEEG\SLOR para clasificar - limitadas";
filepath = strcat(filepath, '\');

target_path = "E:\Investigacion\Cefalea\Investigacion\QEEG\SLOR -  limitadas";
target_path = strcat(target_path, '\');
cd(target_path);

eegs = {
{ '44677571.slor' E  1.1 'INTERICTAL' '41088886.slor' }
{ '46374112.slor' E  1.1 'INTERICTAL' '43132578.slor' }
{ '45090150.slor' E  1.1 'ICTAL' '43136471.slor' }
{ '45487927.slor' E  1.1 'INTERICTAL' '43272306.slor' }
{ '45936466.slor' E  1.1 'ICTAL' '43130218.slor' }
{ '43673629.slor' E  1.1 'ICTAL' '43361091.slor' }
{ '43143194.slor' E  1.1 'ICTAL' '42385042.slor' }
{ '42642102.slor' E  1.1 'INTERICTAL' '42217829.slor' }
{ '42782803.slor' E  1.1 'ICTAL' '41322619.slor' }
{ '40506862.slor' E  1.1 'ICTAL' '39623876.slor' }
{ '41268250.slor' E  1.1 'ICTAL' '41736145.slor' }
{ '41680083.slor' E  1.1 'ICTAL' '39622056.slor' }
{ '40026470.slor' E  1.1 'ICTAL' '40750520.slor' }
{ '39546581.slor' E  1.1 'INTERICTAL' '38736951.slor' }
{ '39733285.slor' E  1.1 'PREICTAL' '39623688.slor' }
{ '39693608.slor' E  1.1 'ICTAL' '39620184.slor' }
{ '39073136.slor' E  1.1 'ICTAL' '36357088.slor' }
{ '37126067.slor' E  1.1 'ICTAL' '34601430.slor' }
{ '36131374.slor' E  1.1 'ICTAL' '36232087.slor' }
{ '34839043.slor' E  1.1 'INTERICTAL' '31105839.slor' }
{ '35109977.slor' E  1.1 'ICTAL' '34188566.slor' }
{ '33387926.slor' E  1.1 'ICTAL' '33598751.slor' }
{ '33437020.slor' E  1.1 'ICTAL' '31219115.slor' }
{ '33700358.slor' E  1.1 'INTERICTAL' '29963925.slor' }
{ '33437628.slor' E  1.1 'ICTAL' '33380758.slor' }
{ '31921461.slor' E  1.1 'INTERICTAL' '33303993.slor' }
{ '31337569.slor' E  1.1 'INTERICTAL' '29714464.slor' }
{ '42637732.slor' E  1.1 'ICTAL' '32406969.slor' }
{ '95760930.slor' E  1.1 'ICTAL' '31055689.slor' }
{ '30628863.slor' E  1.1 'ICTAL' '30648088.slor' }
{ '30661493.slor' E  1.1 'ICTAL' '28432926.slor' }
{ '30900116.slor' E  1.1 'ICTAL' '28432439.slor' }
{ '30330962.slor' E  1.1 'ICTAL' '27652980.slor' }
{ '29712356.slor' E  1.1 'INTERICTAL' '26672197.slor' }
{ '30123167.slor' E  1.1 'INTERICTAL' '27550318.slor' }
{ '29166639.slor' E  1.1 'ICTAL' '24463852.slor' }
{ '29253079.slor' E  1.1 'ICTAL' '27076906.slor' }
{ '29154320.slor' E  1.1 'INTERICTAL' '28104626.slor' }
{ '29476363.slor' E  1.1 'PREICTAL' '27549509.slor' }
{ '28127064.slor' E  1.1 'ICTAL' '25758828.slor' }
{ '26636248.slor' E  1.1 'ICTAL' '22808531.slor' }
{ '27065788.slor' E  1.1 'ICTAL' '23089919.slor' }
{ '26681314.slor' E  1.1 'ICTAL' '24992919.slor' }
{ '26903214.slor' E  1.1 'ICTAL' '24615679.slor' }
{ '26790006.slor' E  1.1 'ICTAL' '22221330.slor' }
{ '25736769.slor' E  1.1 'ICTAL' '20998802.slor' }
{ '24671814.slor' E  1.1 'INTERICTAL' '21395196.slor' }
{ '23021007.slor' E  1.1 'ICTAL' '23198334.slor' }
{ '23267975.slor' E  1.1 'ICTAL' '20700634.slor' }
{ '22672559.slor' E  1.1 'ICTAL' '20224517.slor' }
{ '21139530.slor' E  1.1 'ICTAL' '18498243.slor' }
{ '17842655.slor' E  1.1 'PREICTAL' '16833028.slor' }
{ '16561154.slor' E  1.1 'INTERICTAL' '16445692.slor' }
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
