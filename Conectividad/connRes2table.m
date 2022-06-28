% varNames = ["Frequency"            "1vs1 "            "1vs2 "            "1vs3 "            "1vs4 "            "1vs5 "            "1vs6 "            "2vs1 "            "2vs2 "            "2vs3 "            "2vs4 "            "2vs5 "            "2vs6 "            "3vs1 "            "3vs2 "            "3vs3 "            "3vs4 "            "3vs5 "            "3vs6 "            "4vs1 "            "4vs2 "            "4vs3 "            "4vs4 "            "4vs5 "            "4vs6 "            "5vs1 "            "5vs2 "            "5vs3 "            "5vs4 "            "5vs5 "            "5vs6 "            "6vs1 "            "6vs2 "            "6vs3 "            "6vs4 "            "6vs5 "            "6vs6 "];
freq =  [1.17190000000000;1.56250000000000;1.95310000000000;2.34380000000000;2.73440000000000;3.12500000000000;3.51560000000000;3.90630000000000;4.29690000000000;4.68750000000000;5.07810000000000;5.46880000000000;5.85940000000000;6.25000000000000;6.64060000000000;7.03130000000000;7.42190000000000;7.81250000000000;8.20310000000000;8.59380000000000;8.98440000000000;9.37500000000000;9.76560000000000;10.1563000000000;10.5469000000000;10.9375000000000;11.3281000000000;11.7188000000000;12.1094000000000;12.5000000000000;12.8906000000000;13.2813000000000;13.6719000000000;14.0625000000000;14.4531000000000;14.8438000000000;15.2344000000000;15.6250000000000;16.0156000000000;16.4063000000000;16.7969000000000;17.1875000000000;17.5781000000000;17.9688000000000;18.3594000000000;18.7500000000000;19.1406000000000;19.5313000000000;19.9219000000000;20.3125000000000;20.7031000000000;21.0938000000000;21.4844000000000;21.8750000000000;22.2656000000000;22.6563000000000;23.0469000000000;23.4375000000000;23.8281000000000;24.2188000000000;24.6094000000000;25;25.3906000000000;25.7813000000000;26.1719000000000;26.5625000000000;26.9531000000000;27.3438000000000;27.7344000000000;28.1250000000000;28.5156000000000;28.9063000000000;29.2969000000000;29.6875000000000;30.0781000000000;30.4688000000000;30.8594000000000;31.2500000000000;31.6406000000000;32.0313000000000;32.4219000000000;32.8125000000000;33.2031000000000;33.5938000000000;33.9844000000000;34.3750000000000;34.7656000000000;35.1563000000000;35.5469000000000;35.9375000000000;36.3281000000000;36.7188000000000;37.1094000000000;37.5000000000000;37.8906000000000;38.2813000000000;38.6719000000000;39.0625000000000;39.4531000000000;39.8438000000000;40.2344000000000;40.6250000000000;41.0156000000000;41.4063000000000;41.7969000000000;42.1875000000000;42.5781000000000;42.9688000000000;43.3594000000000;43.7500000000000;44.1406000000000;44.5313000000000;44.9219000000000];
% sz = [113 37];
% varTypes = [repmat("double",1, 37)];
% finaltable = table('Size', sz, 'VariableNames', varNames, 'VariableType', varTypes);
% finaltable.Frequency(:) = freq;

tmptable = readtable('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\3ROI\t-statistic\Interictales vs Controles.txt');

tmp1 = table2array(tmptable);
tmp1 = tmp1(tmp1 >= 2.01);
tmp2 = table2array(tmptable);
tmp2 = tmp1(tmp1 >= 2.01);

% finaltable(:,2:end) = tmptable;
% writetable(finaltable, 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\iCoh\t-statistic\Cronicos vs Controles.xls');
% for index = 1:36 
%     figure
    % Single graphic
    % x = table2array( finaltable(:,1) );
    x = freq;
    y = table2array( tmptable(:,4) );

    red = y;
    red(red < 2.01) = NaN;

    blue = y;
    blue(blue > -2.01) = NaN;

    % Negro
    hold on
    plot (x, y, '-k', 'LineWidth', 1); 

    % Rojo
    plot(x, red, '.-r' , 'MarkerSize', 10, 'LineWidth', 5);
    redfreq = {}; 
    redfreq =  freq(red >=2.01) ; % Frecuencias de rojo
%     for idx = 1:length(redfreq)
%         redfreq{idx} = sprintf('%.2f', redfreq{idx});
%     end
    redfreq
%     text(freq(red >=2.01), red(red >=2.01), redfreq)
    % if redfreq
    %     legend(redfreq)
    % end

    % Azul
    plot(x, blue, '.-b', 'MarkerSize', 10, 'LineWidth', 5); 
    bluefreq = {};
    bluefreq =  freq(blue <=2.01) ; % Frecuencias de azul
%     for idx = 1:length(bluefreq)
%         bluefreq{idx} = sprintf('%.2f', bluefreq{idx});
%     end
    bluefreq 
%     text(freq(blue <=2.01), blue(blue <=2.01), {freq(blue <=2.01)})
    % if bluefreq
    %     legend(bluefreq)
    % end


    % plot( table2array( finaltable(:,1) ) ,  table2array( finaltable(:,3) ), '-k'  );

    % xticks([8 18 28 74 113]);
    % xticklabels({'3.9063', '7.8125', '11.7188´','29.6875', '44.9219'});

    % xticks([ 3.9063 7.8125 11.7188 29.6875 44.9219 ]);
    xticks([]);
    xlim([1.1719 44.9219]);
    xline(finaltable.Frequency(8));
    xline(finaltable.Frequency(18));
    xline(finaltable.Frequency(28));
    xline(finaltable.Frequency(74));
    xline(finaltable.Frequency(113));
    hold off
% end