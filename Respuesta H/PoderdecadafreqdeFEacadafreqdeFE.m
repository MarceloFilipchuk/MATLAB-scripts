etiq = ["PHOTO 6Hz", "PHOTO 8Hz", "PHOTO 10Hz", "PHOTO 12Hz", "PHOTO 14Hz", "PHOTO 16Hz",...
    "PHOTO 18Hz", "PHOTO 20Hz", "PHOTO 22Hz", "PHOTO 24Hz"];
FEfreq = [6:2:24];
tmpmat = zeros(10,10);
power = ["6Hz", "8Hz", "10Hz", "12Hz", "14Hz", "16Hz","18Hz", "20Hz", "22Hz", "24Hz"];
% Index itera sobre cada tanda de fotoestimulacion.
for index = 1:length(etiq) 
    
EEG2 = pop_rmdat( EEG, {sprintf('PHOTO %dHz', FEfreq(index))},[0 9.5] ,0);
            
% Calcula el espectro para la frecuencia necesitada en el rango de tiempo correspondiente al evento.
[spectra, freqs] = pop_spectopo(EEG2, 1, [0 9500], 'EEG' , 'percent', 100, 'plot', 'off', 'plotchans', [9, 10]);
spectra = mean(spectra,1);
freqs = freqs';

% Index2 itera sobre frecuencias de FE dentro de la misma frecuencia de fotoestimulacion.
for index2 = 1:10
    tmpmat(index, index2) = spectra(1, find(freqs == FEfreq(index2)));
end

end
heatmap(Hpatient)
xticklabels(power)
zticklabels(etiq)