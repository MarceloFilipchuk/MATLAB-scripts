filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Interictales';
filepath = strcat(filepath, '\');

cd(filepath)
list = dir('*ProjLorRoi-MultiAic.txt');
list = {list.name}';

sz = [30 28];
varTypes = [repmat("double",1, 28)];
tmpstring = "AIC%d";
tmpvarname = [];
for idx = 1:1:25
    tmpvarname = [tmpvarname, repmat(sprintf(tmpstring, idx),1,1)];
end
varNames = ["ARorder" tmpvarname "AVG" "Ttest"];
finaltable = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames', varNames);
finaltable.ARorder(:) = 1:1:30;
for index = 1:length(list)
    tmptable = readtable(strcat(filepath, list{index}));
    finaltable(:,1+index) = table(tmptable.AIC);
end

for rindex = 1:size(finaltable, 1)
    finaltable.AVG(rindex) = mean(table2array(finaltable(rindex, 2:26))); 
end
minval = find([finaltable.AVG] == min([finaltable.AVG])); % Fila con el menor valor de promedio.
for rindex = 1:size(finaltable, 1)
    [h, p] = ttest2( table2array(finaltable(rindex, 2:26)) , table2array(finaltable(minval, 2:26)) ); % h = 1 rechaza hipotesis nula.
    finaltable.Ttest(rindex) = h;
end
 
writetable(finaltable, strcat(filepath , 'AIC Interictales.xls'));
 
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');