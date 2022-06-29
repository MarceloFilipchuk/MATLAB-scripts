filename = 'E:\Investigacion\Cefalea\Trabajos\Respuesta H\EEG picos\Controles\H response EEG\Alpha peak\27549509.datspec';

[spectra params freq] = std_readfile(filename, 'channels', {'O1' 'O2'}, 'measure', 'spec');

powfft= mean([spectra{1}(:,19:end,1) spectra{1}(:,19:end,2)],2)';
powpsd= mean([spectra{1}(:,19:end,1) spectra{1}(:,19:end,2)],2)';

test = mean([spectra{1}(:,1:18,1)], 2);% mean([spectra{1}(:,1:18:,2)],2)';
10*log10(mean([spectra{1}(10,1:18,1)]))
10*log10(mean([spectra{1}(10,1:18,2)]))

plot([1:1:99], powfft(1:99), [1:1:99], powpsd(2:100))

plot([1:1:99], 10*log10(powfft(1:99)), [1:1:99], 38.986146443288106+[10*log10(powpsd(2:100)) ])
ylabel('10*log10 Power')
xlabel('Frequencies (Hz)')
legend({'FFT', 'Welch'})
title('AVG O1-O2')