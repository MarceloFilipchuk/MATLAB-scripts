template = 'E:\\Investigacion\\Cefalea\\Trabajos\\QEEG FINAL\\phAmp-CrossFreq\\t-statistic\\Cronicos vs Controles\\Cronicos vs Controles ROI %d-%d.txt';
% res = readmatrix('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\phAmp-CrossFreq\t-statistic\Interictales vs Controles\Interictales vs Controles ROI 3-3.txt');
results = zeros(45, 45, 9);
titles = cell(1, 9);

% Carga datos.
counter = 1;
for index1 = 1:3
    
    for index2 = 1:3
%         res = readmatrix(sprintf(template, index1, index2));
        tmpdir = (sprintf(template, index1, index2));
        results(:, :, counter) = readmatrix(tmpdir);
        titles(counter) = extractBetween(tmpdir, 'Cronicos vs Controles ', '.txt'); 
        counter = counter+1;

    end
end

counter = 1;
% Ploteo final
% f = figure;
for index1 = 1:3
    for index2 = 1:3
        tmp = results(:, :, counter);
        if index1 == index2
            tmp(tmp == 0) = NaN;
        end
        suptresh = ((tmp >= 2.011) | (tmp <= -2.011)); % Uncorrected p-threshold
%         suptresh = ((tmp >= 4.4) | (tmp <= -4.4)); % Corrected p-threshold
        tmp(~suptresh & ~isnan(tmp)) = 0;
        
        % Sublplot
%         subplot(3, 3 , counter)
f = figure;
        h = heatmap(tmp, 'ColorbarVisible', 'off');
%         h.Title = titles{counter};
        h.ColorLimits = [-5, 5];
        h.XDisplayLabels = nan(size(h.XDisplayData));
        h.YDisplayLabels = nan(size(h.YDisplayData));
        colormap  jet
        exportgraphics(h, strcat(extractBefore(tmpdir, 'Cronicos vs Controles ROI '), titles{counter}, '.png'), 'BackgroundColor','none','Resolution',600 );
        
        counter = counter+1;
    end
end

% BAJO TESTEO
% h = heatmap(tmp, 'ColorbarVisible', 'off');
% h.ColorLimits = [-5, 5];
% h.XDisplayLabels = nan(size(h.XDisplayData));
% h.YDisplayLabels = nan(size(h.YDisplayData));
% colormap  jet
% 
% colorbar
% axs = struct(gca);
% bar = axs.Colorbar;
% set(bar, 'YTick', [-5, -2.011, 0, 2.011, 5], ...
%     'YTickLabel', {'-5', '-2.011 p<0.05', ' 0', ' 2.011 p<0.05', ' 5'})
% 

% ESTO FUNCIONA
% test = surf(tmp);
% colormap jet
% bar = colorbar();
% caxis([-5 5])
% set(bar, 'YTick', [-5, -2.011, 0, 2.011, 5], ...
%     'YTickLabel', {'-5', '-2.011 p<0.05', '0', '2.011 p<0.05', '5'})

% CUSTOM COLORMAP
% cmap = [
%     0 0 0
%     0 0 0
%     0 0 0
%     0 0 0
%     0 0 0
%     0 0 0
%     0 0 0
%     0 0 0
%     0 0 0
%     0 0 0
%     0 0 0
%     0 0 0];
% colormap(cmap);
% caxis([-5.0275 6.033])
% colormapeditor

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');
