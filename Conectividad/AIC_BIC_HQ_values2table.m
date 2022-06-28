filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Interictales';
filepath = strcat(filepath, '\');
ARorders = 30; % Revisar antes de correr el script. Se debe colocar "a mano".
 
cd(filepath)
list = dir('*ProjLorRoi-AICmin.txt');
list = {list.name}';
patients = size(list, 1);

sz = [ARorders 79];
varTypes = [repmat("double",1, 79)];
tmpstring = "AIC%d";
tmpvarname = [];
for idx = 1:1:patients
    tmpvarname = [tmpvarname, repmat(sprintf(tmpstring, idx),1,1)];
end
tmpstring1 = "BIC%d"; 
for idx = 1:1:patients
    tmpvarname = [tmpvarname, repmat(sprintf(tmpstring1, idx),1,1)];
end
tmpstring2 = "HQ%d"; 
for idx = 1:1:patients
    tmpvarname = [tmpvarname, repmat(sprintf(tmpstring2, idx),1,1)];
end
varNames = ["ARorder" tmpvarname "AICavg" "BICavg" "HQavg" ];

% Crea la tabla vacia.
finaltable = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames', varNames);
finaltable.ARorder(:) = 1:1:ARorders;

% Itera sobre cada txt que contiene los valores de 'AR order' y los 3 coeficientes para cada paciente.
for index = 1:length(list)
    tmptable = readtable(strcat(filepath, list{index}));
    % 1+index porque la primera columna es el 'AR order' y ahi comienza el criterio de AIC.
    finaltable(:,1+index) = table(tmptable.AIC);
    % 1+index+patients porque ahi comienza el siguiente criterio de BIC.
    finaltable(:,1+index+patients) = table(tmptable.BIC);
    % 1+index+patients+patients porque ahi comienza el siguiente criterio de HQ.
    finaltable(:,1+index+patients+patients) = table(tmptable.HQ);
end

% Carga los promedios para cada coeficiente a lo largo de cada paciente para cada 'AR order'.
for rindex = 1:size(finaltable, 1)
    finaltable.AICavg(rindex) = mean(table2array(finaltable(rindex, 2:(patients+1))));
    finaltable.BICavg(rindex) = mean(table2array(finaltable(rindex, (patients+2):(patients*2+1))));
    finaltable.HQavg(rindex) = mean(table2array(finaltable(rindex, (patients*2+2):(patients*3+1))));
end
  
writetable(finaltable, strcat(filepath , '3 criterios Interictales.xls'));
 
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');