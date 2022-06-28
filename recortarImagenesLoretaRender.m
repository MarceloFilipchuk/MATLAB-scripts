% Direcciones para revisar.
brainpath = {

'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\Renders paleta extendida\Cronicos vs Controles';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\Renders paleta extendida\Cronicos vs Ictales';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\Renders paleta extendida\Cronicos vs Interictales';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\Renders paleta extendida\Ictales vs Controles';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\Renders paleta extendida\Ictales vs Interictales';
'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Resultados LORETA\Renders paleta extendida\Interictales vs Controles';
};
 
% Itera sobre cada carpeta.
for pindex = 1:length(brainpath)
    
    finalpath = strcat(brainpath{pindex}, '\LORETA BRAIN\');
    if ~exist(finalpath, 'dir')
        mkdir(finalpath);
    end
    % Crea una lista de las imagenes dentro de la carpeta.
    cd(brainpath{pindex})
    brains = dir('*.bmp');
    brains = {brains.name}';
    
    % Itera sobre cada imagen.
    for bindex = 1:length(brains)
        [LHLV, LHRV, RHLV, RHRV] = deal([]);
        brain = imread(brains{bindex});
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % No tocar. Acomoda las imagenes y elimina las etiquetas no deseadas. %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Para render Colin inflado.
        LHLV = brain(2:260,1:260,:);
        LHLV(:,1,:) = 255;
        LHLV(:,260,:) = 255;
        LHLV(1,:,:) = 255;
        LHLV(259:260,:,:) = 255;
        LHLV(225:259,4:50,:) = 255;
        LHLV(225:259, 51:99,:) = 255;
        LHLV(1:50,:,:) = 255;
        LHLV(225:end,1:200,:) = 255;
        LHLV(254:end,:,:) = []; % Elimina espacio en blanco por debajo de etiqueta.
        LHLV(200:241,:,:) = []; % Elimina espacio en blanco hasta etiqueta.
        LHLV(1:50,:,:) = []; % Elimina espacio en blanco hasta render.
        LHLV(:,1:25,:) = []; % Elimina espacio en blanco hasta render.
        
        
        % crear nuevo
        LHRV = brain(1:260,261:520,:);
        LHRV(:,1,:) = 255;
        LHRV(:,260,:) = 255;
        LHRV(1,:,:) = 255;
        LHRV(259:260,:,:) = 255;
        LHRV(1:50,:,:) = 255;
        LHRV(225:end,1:200,:) = 255;
        LHRV(254:end,:,:) = []; % Elimina espacio en blanco por debajo de etiqueta.
        LHRV(200:241,:,:) = []; % Elimina espacio en blanco hasta etiqueta.
        LHRV(1:50,:,:) = []; % Elimina espacio en blanco hasta render.
        LHRV(:,1:25,:) = []; % Elimina espacio en blanco hasta render.

        % Mueve todo 1px hacia arriba
        RHRV = brain(1:260,521:780,:);
        RHRV(:,1,:) = 255;
        RHRV(:,260,:) = 255;
        RHRV(1,:,:) = 255;
        RHRV(259:260,:,:) = 255;
        RHRV(225:259,4:50,:) = 255;
        RHRV(225:259, 51:99,:) = 255;
        RHRV(1:50,:,:) = 255;
        RHRV(225:end,1:200,:) = 255;
        RHRV(254:end,:,:) = []; % Elimina espacio en blanco por debajo de etiqueta.
        RHRV(200:241,:,:) = []; % Elimina espacio en blanco hasta etiqueta.
        RHRV(1:50,:,:) = []; % Elimina espacio en blanco hasta render.
        RHRV(:,1:25,:) = []; % Elimina espacio en blanco hasta render.
        
        % Crear nuevo
        RHLV = brain(1:260,781:1040,:);
        RHLV(:,1,:) = 255;
        RHLV(:,260,:) = 255;
        RHLV(1,:,:) = 255;
        RHLV(259:260,:,:) = 255;
        RHLV(225:259,4:50,:) = 255;
        RHLV(225:259, 51:99,:) = 255;
        RHLV(1:50,:,:) = 255;
        RHLV(225:end,1:200,:) = 255;
        RHLV(254:end,:,:) = []; % Elimina espacio en blanco por debajo de etiqueta.
        RHLV(200:241,:,:) = []; % Elimina espacio en blanco hasta etiqueta.
        RHLV(1:50,:,:) = []; % Elimina espacio en blanco hasta render.
        RHLV(:,1:25,:) = []; % Elimina espacio en blanco hasta render.
        
        BHBV = brain(1:260,1041:1300,:);
        BHBV(:,1,:) = 255;
        BHBV(:,260,:) = 255;
        BHBV(1,:,:) = 255;
        BHBV(259:260,:,:) = 255;
        BHBV(225:259,4:50,:) = 255;
        BHBV(225:259, 51:99,:) = 255;
%         BHBV(1:25,:,:) = 255;
%         BHBV(225:end,1:200,:) = 255;
%         BHBV(254:end,:,:) = []; % Elimina espacio en blanco por debajo de etiqueta.
%         BHBV(200:241,:,:) = []; % Elimina espacio en blanco hasta etiqueta.
%         BHBV(1:50,:,:) = []; % Elimina espacio en blanco hasta render.
%         BHBV(:,1:25,:) = []; % Elimina espacio en blanco hasta render.
        
        % Elimina etiquetas
        LHLV(140:end,180:end,1:end) = 255;
        LHRV(140:end,180:end,1:end) = 255;
        RHLV(140:end,180:end,1:end) = 255;
        RHRV(140:end,180:end,1:end) = 255;
        BHBV(1:25,:,:) = 255;
        BHBV(225:end,1:end,:) = 255;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Para render Colin normal.
%         LHLV = brain(2:260,1:260,:);
%         LHLV(:,1,:) = 255;
%         LHLV(:,260,:) = 255;
%         LHLV(1,:,:) = 255;
%         LHLV(259:260,:,:) = 255;
%         LHLV(225:259,4:50,:) = 255;
%         LHLV(225:259, 51:99,:) = 255;
%         
%         % crear nuevo
%         LHRV = brain(1:260,261:520,:);
%         LHRV(:,1,:) = 255;
%         LHRV(:,260,:) = 255;
%         LHRV(1,:,:) = 255;
%         LHRV(259:260,:,:) = 255;
%         LHRV(225:259,4:50,:) = 255;
%         LHRV(225:259, 51:99,:) = 255;
% 
%         % Acomoda LHRV
%         brainLHRV = LHRV(48:167, 27:198, :);
%         LHRV(48:167, 27:198, :) = 255;
%         newLHRV = LHRV;
%         newLHRV(48:167, 239-171:239, :) = brainLHRV;
%         LHRV = newLHRV;
% 
%         % Mueve todo 1px hacia arriba
%         RHRV = brain(1:260,521:780,:);
%         RHRV(:,1,:) = 255;
%         RHRV(:,260,:) = 255;
%         RHRV(1,:,:) = 255;
%         RHRV(259:260,:,:) = 255;
%         RHRV(225:259,4:50,:) = 255;
%         RHRV(225:259, 51:99,:) = 255;
%         newRHRV = RHRV(2:end,:,:);
%         newRHRV(260,:,:) = 255;
%         RHRV = newRHRV;
% 
% 
%         % Crear nuevo
%         RHLV = brain(1:260,781:1040,:);
%         RHLV(:,1,:) = 255;
%         RHLV(:,260,:) = 255;
%         RHLV(1,:,:) = 255;
%         RHLV(259:260,:,:) = 255;
%         RHLV(225:259,4:50,:) = 255;
%         RHLV(225:259, 51:99,:) = 255;
% 
%         % Acomodoa RHLV
%         brainRHLV = RHLV(47:172, 61:228, :);
%         RHLV(47:172, 61:228, :) = 255;
%         newRHLV = RHLV;
%         newRHLV(47:172, 22:22+167, :) = brainRHLV;
%         RHLV = newRHLV;
% 
%         BHBV = brain(1:260,1041:1300,:);
%         BHBV(:,1,:) = 255;
%         BHBV(:,260,:) = 255;
%         BHBV(1,:,:) = 255;
%         BHBV(259:260,:,:) = 255;
%         BHBV(225:259,4:50,:) = 255;
%         BHBV(225:259, 51:99,:) = 255;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Matriz con las imagenes finales en el orden y posicion en las que las quiero.
        final = [LHLV, RHRV; LHRV, RHLV];

        % Escribe la imagen final con las 4 vistas (2 para cada hemisferio).
%         final = imresize(final, 0.8); % Disminuye el tamaño de la imagen y la deja al 80% de su tamaño original.
        imwrite(final, strcat(finalpath, brains{bindex}));
    end
end
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');