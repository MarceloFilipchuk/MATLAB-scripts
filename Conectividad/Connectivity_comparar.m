match = {
    '46707761.edf'
'45347521.edf'
'44828207.edf'
'43272306.edf'
'43136471.edf'
'43132578.edf'
'41088886.edf'
'43361091.edf'
'43130218.edf'
'42217829.edf'
'42385042.edf'
'41481729.edf'
'41322619.edf'
'41736145.edf'
'39622056.edf'
'39623876.edf'
'40750520.edf'
'39620184.edf'
'39623688.edf'
'38736951.edf'
'36357088.edf'
'35347104.edf'
'33639383.edf'
'36232087.edf'
'34601430.edf'
'31769226.edf'
'34188566.edf'
'33598751.edf'
'31219115.edf'
'31105839.edf'
'33380758.edf'
'33303993.edf'
'29963925.edf'
'29714464.edf'
'31055689.edf'
'27303699.edf'
'28432926.edf'
'27550318.edf'
'27652980.edf'
'26672197.edf'
'27076906.edf'
'24463852.edf'
'27549509.edf'
'22808531.edf'
'23089919.edf'
'24992919.edf'
'24615679.edf'
'22221330.edf'
'23198334.edf'
'20998802.edf'
'21395196.edf'
'22996280.edf'
'21390696.edf'
'20700634.edf'
'20073257.edf'
'20224517.edf'
'17530412.edf'
'20381885.edf'
'18017224.edf'
'18498243.edf'
'16742233.edf'
'16740814.edf'
'16157868.edf'
'16293599.edf'
'1700391.edf'
'14339047.edf'
'11558391.edf'
'5951564.edf'
'16833028.edf'
'16445692.edf'
'10171493.edf'
'41712730.edf'
'33701475.edf'
'36447393.edf'
'30648088.edf'
'28432439.edf'
'28104626.edf'
'25758828.edf'
};


cd('E:\Investigacion\EEG\NORMALES - CONTROL\CONNECTIVITY\EEG')
procesados = dir('*.edf');
procesados = {procesados.name}';
% for index = 1:length(procesados)
%     procesados{index} = strcat(extractBefore(procesados{index}, '.set'), '.edf');
% end

final = setdiff(match, procesados)
% final = match;
% target = 'E:\Investigacion\EEG\NORMALES - CONTROL\CONNECTIVITY\EEG\CONECTIVIDAD\Definitivos';
% source = 'E:\Investigacion\EEG\NORMALES - CONTROL\CONNECTIVITY\EEG\CONECTIVIDAD';
% for index = 1:length(final)
%     set = strcat(extractBefore(final{index}, '.edf'),'.set');
%     fdt = strcat(extractBefore(final{index}, '.edf'),'.fdt');
%     try
%         movefile(set, target);
%         movefile(fdt, target);
%     catch Me
%     end
% end
% 
