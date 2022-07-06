load patients.mat
load commands.mat
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% for index = 2%:1%length(patients)
[STUDY ALLEEG] = std_editset( STUDY, [], 'name','Respuesta H STUDY',...
    'commands',...
    commands,'updatedat','off','rmclust','on' );
% end
[STUDY ALLEEG] = std_checkset(STUDY, ALLEEG);
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
eeglab redraw

% Acomoda cada IC a cada cluster. ESTE ES PARA TODOS H VS TODOS N PICO BETA
% for index = 1:length(patients)
%     if strcmp(patients(index).condition, 'Beta peak') 
%         if strcmp(patients(index).response, 'H') % Es componente H.
%             % H Left
%             if ~isempty(patients(index).component_L)
%             STUDY.cluster(2).sets = [STUDY.cluster(2).sets index]; 
%             STUDY.cluster(2).comps = [STUDY.cluster(2).comps patients(index).component_L];
%             end
%             % H Right
%             if ~isempty(patients(index).component_R)
%             STUDY.cluster(3).sets = [STUDY.cluster(3).sets index]; 
%             STUDY.cluster(3).comps =[STUDY.cluster(3).comps patients(index).component_R];
%             end
%         else % Es componente N.
%             % N Left.
%             if ~isempty(patients(index).component_L)
%             STUDY.cluster(4).sets = [STUDY.cluster(4).sets index]; 
%             STUDY.cluster(4).comps = [STUDY.cluster(4).comps patients(index).component_L];
%             end
%             % N Right.
%             if ~isempty(patients(index).component_R)
%             STUDY.cluster(5).sets = [STUDY.cluster(5).sets index]; 
%             STUDY.cluster(5).comps = [STUDY.cluster(5).comps patients(index).component_R];
%             end
%         end
%     end
% end

% cluster_empty = STUDY.cluster;
% cluster_HvsN_beta_peak = STUDY.cluster;
% save('clusters.mat', 'cluster_HvsN_beta_peak', 'cluster_empty') 