recortar = [
    

30 90



];

EEGpower = pop_select( EEG, 'time', recortar );

% Calcula el poder del segmento (EXPERIMENTAL).
[spectra, freqs] = pop_spectopo(EEGpower, 1, [EEGpower.xmin  EEGpower.xmax*1000], 'EEG' , 'percent', 100, 'freqrange',[1 100],...
'plot', 'off','plotchans', [find(strcmp({EEGpower.chanlocs(:).labels}, 'O1')), find(strcmp({EEGpower.chanlocs(:).labels}, 'O2'))]);

% delta=1-3, theta=4-7, alpha=8-12, beta=13-24, gamma=25-100
deltaIdx = find(freqs>=1 & freqs<=3);
thetaIdx = find(freqs>=4 & freqs<=7);
alphaIdx = find(freqs>=8 & freqs<=12);
betaIdx  = find(freqs>=12 & freqs<=24);
gammaIdx = find(freqs>=25 & freqs<=100);
musckeIdx = find(freqs>=20 & freqs<=40);

% compute absolute power
deltaPower = mean(10.^(spectra(deltaIdx)/10));
thetaPower = mean(10.^(spectra(thetaIdx)/10));
alphaPower = mean(10.^(spectra(alphaIdx)/10));
betaPower  = mean(10.^(spectra(betaIdx)/10));
gammaPower = mean(10.^(spectra(gammaIdx)/10));
%%%%%%%%%%%%%%%%%

% Poder relativo
totalRelativePower = deltaPower + thetaPower + alphaPower + betaPower + gammaPower;
relDelta = deltaPower / totalRelativePower;
relTheta = thetaPower / totalRelativePower;
relAlpha = alphaPower / totalRelativePower;
relBeta = betaPower / totalRelativePower;
relGamma = gammaPower / totalRelativePower;

relPower = {{'Delta'} {'Theta'} {'Alpha'} {'Beta'} {'Gamma'} {'Total'}};
relPower{2,1} = relDelta;
relPower{2,2} = relTheta;
relPower{2,3} = relAlpha;
relPower{2,4} = relBeta;
relPower{2,5} = relGamma;
relPower{2,6} = totalRelativePower/totalRelativePower;