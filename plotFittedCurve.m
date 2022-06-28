load noborrar.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
integ = plot(fittedmodel,'integral');
xinteg = integ.XData;
yinteg = integ.YData;
threshold =yinteg(yinteg>0.95);
threshold = threshold(1);
threshindex = find(yinteg==threshold);
xline(xinteg(yinteg==threshold), '--', 'P = 0.95');

% hold on
% area(xinteg(threshindex:end),yinteg(threshindex:end),'EdgeColor','none','FaceColor','b','FaceAlpha',0.1); 
% hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
fit = plot(fittedmodel,'fit');
xfit = fit.XData;
yfit = fit.YData;
xline(xinteg(yinteg==threshold), '--', 'P = 0.95');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBPLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
fig1 = subplot(2, 1, 1);
hold on
xline(xfit(yinteg==threshold), '--');
plot(fig1, xfit, yfit)
xlim([-1 8])
% area(xfit(threshindex:end),yfit(threshindex:end),'EdgeColor','none','FaceColor','b','FaceAlpha',0.1); 
hold off
fig2 = subplot(2, 1, 2);
hold on
plot(fig2, xinteg, yinteg);
xlim([-1 8])
area(xinteg(threshindex:end),yinteg(threshindex:end),'EdgeColor','none','FaceColor','b','FaceAlpha',0.1);
xline(xinteg(yinteg==threshold), '--', 'P = 0.95');
hold off