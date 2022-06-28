
ictales = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Ictales\AIC Ictales.xls');
cronicos = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Cronicos\AIC Cronicos.xls');
controles = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Controles\AIC Controles.xls');
interictales = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Interictales\AIC Interictales.xls');


% ictales = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\AIC Ictales\AIC Ictales.xls');
% cronicos = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\AIC Cronicos\AIC Cronicos.xls');
% controles = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\AIC Controles\AIC Controles.xls');
% interictales = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\AIC Interictales\AIC Interictales.xls');

hold on
minAR= [];  
x = 1:1:size(interictales, 1); 

figure('NumberTitle', 'off', 'Name', 'AIC')
subplot(4,1,1);  
plot(x,interictales.AVG,'-b')
title('AIC Interictales');
minAR = find(interictales.AVG == min(interictales.AVG));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,2) ;
plot(ictales.AVG,'-b')
title('AIC Ictales');
minAR = find(ictales.AVG == min(ictales.AVG));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,3);
plot(cronicos.AVG, '-b')
title('AIC Cronicos'); 
minAR = find(cronicos.AVG == min(cronicos.AVG));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,4);
plot(controles.AVG, '-b')
title('AIC Controles'); 
minAR = find(controles.AVG == min(controles.AVG));
xline(minAR,'--k', sprintf('%d', minAR) );

hold off

ictales = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Ictales\3 criterios Ictales.xls');
cronicos = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Cronicos\3 criterios Cronicos.xls');
controles = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Controles\3 criterios Controles.xls');
interictales = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh ROIs Intersect\AIC Interictales\3 criterios Interictales.xls');

% ictales = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\AIC Ictales\3 criterios Ictales.xls');
% cronicos = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\AIC Cronicos\3 criterios Cronicos.xls');
% controles = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\AIC Controles\3 criterios Controles.xls');
% interictales = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\AIC Interictales\3 criterios Interictales.xls');


minAR= [];  
x = 1:1:size(interictales, 1); 

hold on
figure('NumberTitle', 'off', 'Name', 'AIC averages')
subplot(4,1,1);  
plot(x,interictales.AICavg,'-b')
title('AIC Interictales');
minAR = find(interictales.AICavg == min(interictales.AICavg));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,2) ;
plot(x, ictales.AICavg,'-b')
title('AIC Ictales');
minAR = find(ictales.AICavg == min(ictales.AICavg));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,3);
plot(x, cronicos.AICavg, '-b')
title('AIC Cronicos'); 
minAR = find(cronicos.AICavg == min(cronicos.AICavg));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,4);
plot(x, controles.AICavg, '-b')
title('AIC Controles'); 
minAR = find(controles.AICavg == min(controles.AICavg));
xline(minAR,'--k', sprintf('%d', minAR) );

hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on
figure('NumberTitle', 'off', 'Name', 'BIC averages')
subplot(4,1,1);  
plot(x, interictales.BICavg,'-b')
title('BIC Interictales');
minAR = find(interictales.BICavg == min(interictales.BICavg));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,2) ;
plot(x, ictales.BICavg,'-b')
title('BIC Ictales');
minAR = find(ictales.BICavg == min(ictales.BICavg));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,3);
plot(x, cronicos.BICavg, '-b')
title('BIC Cronicos'); 
minAR = find(cronicos.BICavg == min(cronicos.BICavg));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,4);
plot(x, controles.BICavg, '-b')
title('BIC Controles'); 
minAR = find(controles.BICavg == min(controles.BICavg));
xline(minAR,'--k', sprintf('%d', minAR) );

hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on
figure('NumberTitle', 'off', 'Name', 'HQ averages')
subplot(4,1,1);  
plot(x, interictales.HQavg,'-b')
title('HQ Interictales');
minAR = find(interictales.HQavg == min(interictales.HQavg));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,2) ;
plot(x, ictales.HQavg,'-b')
title('HQ Ictales');
minAR = find(ictales.HQavg == min(ictales.HQavg));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,3);
plot(x, cronicos.HQavg, '-b')
title('HQ Cronicos'); 
minAR = find(cronicos.HQavg == min(cronicos.HQavg));
xline(minAR,'--k', sprintf('%d', minAR) );

subplot(4,1,4);
plot(x, controles.HQavg, '-b')
title('HQ Controles'); 
minAR = find(controles.HQavg == min(controles.HQavg));
xline(minAR,'--k', sprintf('%d', minAR) );

hold off

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');