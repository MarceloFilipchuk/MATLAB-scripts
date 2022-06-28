load respuestas_grupos
power = ["6Hz", "8Hz", "10Hz", "12Hz", "14Hz", "16Hz","18Hz", "20Hz", "22Hz", "24Hz"];
x = [6:2:24];

% Standar deviation 
STDcontrolN = std(controlN);
STD_control_N(1, :) = AVGcontrolN + STDcontrolN;
STD_control_N(2, :) = AVGcontrolN - STDcontrolN;

STDcontrolH = std(controlH);
STD_control_H(1, :) = AVGcontrolH + STDcontrolH;
STD_control_H(2, :) = AVGcontrolH - STDcontrolH;

STDinterictalN = std(interictalN);
STD_interictalN(1, :) = AVGinterictalN + STDinterictalN;
STD_interictalN(2, :) =  AVGinterictalN - STDinterictalN;

STDinterictalH = std(interictalH);
STD_interictalH(1, :) = AVGinterictalH + STDinterictalH;
STD_interictalH(2, :) =  AVGinterictalH - STDinterictalH;

STDictalN = std(ictalN);
STD_ictalN(1, :) = AVGictalN + STDictalN;
STD_ictalN(2, :) =  AVGictalN - STDictalN;

STDictalH = std(ictalH);
STD_ictalH(1, :) = AVGictalH + STDictalH;
STD_ictalH(2, :) =  AVGictalH - STDictalH;

% Plot area(STD_interictalN(1), STD_interictalN(2))
hold on
plot(x, controlN, '--k')
plot(x,AVGcontrolN, 'k', 'LineWidth', 2)

plot(x,interictalN, '--b')
plot(x,AVGinterictalH, 'b', 'LineWidth', 2)

plot(x,ictalN, '--r')
plot(x,AVGictalH, 'r', 'LineWidth', 2)

hold off

% -- N y linea gruesa H todo promedio
hold on

plot(x, AVGcontrolN, '--k')

plot(x,AVGcontrolH, 'k', 'LineWidth', 2)

plot(x,AVGinterictalN, '--b')

plot(x,AVGinterictalH, 'b', 'LineWidth', 2)

plot(x,AVGictalN, '--r')

plot(x,AVGictalH, 'r', 'LineWidth', 2)

hold off

legend('AVG Control N', 'AVG Control H', 'AVG Interictal N', 'AVG Interictal H', 'AVG Ictal N', 'AVG Ictal H')
xticklabels(power)
xlabel('Photic stimulation frequency');
ylabel('Power');

% -- N y linea gruesa H todo promedio con barras de error
hold on

errorbar(x, AVGcontrolN, STDcontrolN,'--k')

errorbar(x, AVGcontrolH, STDcontrolH, 'k', 'LineWidth', 2)

errorbar(x,AVGinterictalN, STDinterictalN, '--b')

errorbar(x,AVGinterictalH, STDinterictalH, 'b', 'LineWidth', 2)

errorbar(x,AVGictalN, STDictalN, '--r')

errorbar(x,AVGictalH, STDictalH, 'r', 'LineWidth', 2)

hold off

legend('AVG Control N', 'AVG Control H', 'AVG Interictal N', 'AVG Interictal H', 'AVG Ictal N', 'AVG Ictal H')
xticklabels(power)
xlabel('Photic stimulation frequency');
ylabel('Power');