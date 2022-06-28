% Toma un template, y lo compara con distintas imagenes de ROIs extraídas de LORETA, si las imagenes son iguales
% en cada pixel para sus valores RGB, deja la ROI en ese pixel con valor de blanco absoluto.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Directorio madre.
filepath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS';
filepath = strcat(filepath, '\');

% Direccion del template.
filepath_template = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\template.bmp';

% Dirección de cada ROI.
ROIs = {
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\BA11.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\BA13.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\BA25.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\BA34.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\BA38.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\BA47.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\TPJ(BA39+40).bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\V3a.bmp'
      'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\BA40.bmp'
};

% Render de cerebro a usar.
template = imread(filepath_template);

% Directorio final donde se guardan las ROIs ya extraídas
finalpath = (strcat(filepath, 'LORETA_ROIs' , '\'));
if ~exist(finalpath, 'dir')
    mkdir(finalpath)
end

% Itera sobre cada ROI
for index = 1:length(ROIs)
    % ROI
    roi_name = extractAfter(ROIs{index}, filepath);
    roi = []; % Por si las moscas...
    roi = imread(ROIs{index});

    % Itera sobre eje Y (filas)
    for yindex = 1:size(roi,1)
        % Itera sobre eje X (columnas)
        for xindex = 1:size(roi,2)
           % Checkea en Z (RGB). Tienen que ser igual EN LOS 3 VALORES para que cuente.
           if isequal(roi(yindex, xindex, :), template(yindex, xindex, :))
               roi(yindex, xindex, :) = 255;
           end
        end
    end
    
    imwrite(roi, strcat(finalpath, roi_name));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ESTO SIRVE PARA ELIMINAR ZONAS DONDE VARIAS ROIS SE SUPERPONEN  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 
% finalpath = 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\LORETA_ROIs';
% finalpath = strcat(finalpath, '\');
% 
% ROIs = {
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\LORETA_ROIs\BA11.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\LORETA_ROIs\BA13.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\LORETA_ROIs\BA25.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\LORETA_ROIs\BA34.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\LORETA_ROIs\BA38.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\LORETA_ROIs\BA47.bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\LORETA_ROIs\TPJ(BA39+40).bmp'
%     'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\LORETA BRAIN para ROIS\LORETA_ROIs\V3a.bmp'
% };

% % No tocar, sirve para comparar.
% blank = zeros(1,1,3);
% blank(1,1,:) = [ 255 255 255 ]; 
% 
% % Itera sobre cada ROI
% for index = 1:length(ROIs)
%     % La nueva template es la ROI que abro para comparar superposiciones
%     template = [];
%     template = imread(ROIs{index});
%     template_name = extractAfter(ROIs{index}, finalpath);
%     
%     % Itera sobre la lista de ROIs (de vuelta)
%     for index2 = 1:length(ROIs)
%         roi_name = extractAfter(ROIs{index2}, finalpath);
%         
%         % Solo sigo si no son la misma ROI
%         if ~strcmp(roi_name, template_name)
%             % ROI
%             roi_name = extractAfter(ROIs{index2}, finalpath);
%             roi = []; % Por si las moscas...
%             roi = imread(ROIs{index2});
% 
%             % Itera sobre eje Y (filas)
%             for yindex = 1:size(roi,1)
%                 % Itera sobre eje X (columnas)
%                 for xindex = 1:size(roi,2)
%                    % Checkea en Z (RGB) el template. Limpia la ROI para que este en blanco en estas coordenadas.
%                    if ~isequal(template(yindex, xindex, :), blank)
%                        roi(yindex, xindex, :) = 255;
%                    end
%                 end
%             end
%             imwrite(roi, strcat(finalpath, roi_name));
%         else
%             continue
%         end
%     end
% end

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');