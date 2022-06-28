% filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\LORETA componentes fundamentales\ROI\Controles\H response\Alpha peak';
filepath = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\LORETA componentes fundamentales\ROI\Interictales\H response\Alpha peak';
filepath = strcat(filepath, '\');
cd(filepath)

% Acomoda el template que contiene la mascara occipital
template = readmatrix('E:\Investigacion\Cefalea\Trabajos\Respuesta H\ROI occipital cortex\Occipital_cortex-BA17-18-19-ROI-slorTransposed');
template(:,2:end) = [];
slors = dir('*-slorTransposed.txt');
slors = {slors.name}';

for index = 1:length(slors)
    % tmpslor contiene el archivo en texto de LORETA a pasar por mascara
    tmpslor = [];
    tmpslor = readmatrix(slors{index});
    tmpslor(:,1:2) = []; 
    % Limpia a 0 lo que no este en la ROI.
    tmpslor(template == 0) = 0;
    % RECORDAR HACER LOGARITMIZACION
    tmpslor(tmpslor ~= 0) = log(tmpslor(tmpslor ~= 0)); 
    writematrix(tmpslor, strcat(filepath, extractBefore(slors{index}, '-slorTransposed.txt'), '_masked.txt'))
end

