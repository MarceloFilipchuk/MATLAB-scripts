% Direcciones para revisar.
brainpath = {

'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\Render\Interictales vs Controles';
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\Render\Ictales vs Interictales';
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\Render\Ictales vs Controles';
'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\Render\Cronicos vs Ictales';
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
        brain = imread(brains{bindex});
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % No tocar. Acomoda las imagenes y elimina las etiquetas no deseadas. %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        LHLV = brain(2:260,1:260,:);
        LHLV(:,1,:) = 255;
        LHLV(:,260,:) = 255;
        LHLV(1,:,:) = 255;
        LHLV(259:260,:,:) = 255;
        LHLV(225:259,4:50,:) = 255;
        LHLV(225:259, 51:99,:) = 255;

        % crear nuevo
        LHRV = brain(1:260,261:520,:);
        LHRV(:,1,:) = 255;
        LHRV(:,260,:) = 255;
        LHRV(1,:,:) = 255;
        LHRV(259:260,:,:) = 255;
        LHRV(225:259,4:50,:) = 255;
        LHRV(225:259, 51:99,:) = 255;

        % Acomoda LHRV
        brainLHRV = LHRV(48:167, 27:198, :);
        LHRV(48:167, 27:198, :) = 255;
        newLHRV = LHRV;
        newLHRV(48:167, 239-171:239, :) = brainLHRV;
        LHRV = newLHRV;

        % Mueve todo 1px hacia arriba
        RHRV = brain(1:260,521:780,:);
        RHRV(:,1,:) = 255;
        RHRV(:,260,:) = 255;
        RHRV(1,:,:) = 255;
        RHRV(259:260,:,:) = 255;
        RHRV(225:259,4:50,:) = 255;
        RHRV(225:259, 51:99,:) = 255;
        newRHRV = RHRV(2:end,:,:);
        newRHRV(260,:,:) = 255;
        RHRV = newRHRV;


        % Crear nuevo
        RHLV = brain(1:260,781:1040,:);
        RHLV(:,1,:) = 255;
        RHLV(:,260,:) = 255;
        RHLV(1,:,:) = 255;
        RHLV(259:260,:,:) = 255;
        RHLV(225:259,4:50,:) = 255;
        RHLV(225:259, 51:99,:) = 255;

        % Acomodoa RHLV
        brainRHLV = RHLV(47:172, 61:228, :);
        RHLV(47:172, 61:228, :) = 255;
        newRHLV = RHLV;
        newRHLV(47:172, 22:22+167, :) = brainRHLV;
        RHLV = newRHLV;

        BHBV = brain(1:260,1041:1300,:);
        BHBV(:,1,:) = 255;
        BHBV(:,260,:) = 255;
        BHBV(1,:,:) = 255;
        BHBV(259:260,:,:) = 255;
        BHBV(225:259,4:50,:) = 255;
        BHBV(225:259, 51:99,:) = 255;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Matriz con las imagenes finales en el orden y posicion en las que las quiero.
        final = [LHLV, RHRV; LHRV, RHLV];

        % Escribe la imagen final con las 4 vistas (2 para cada hemisferio).
        final = imresize(final, 0.7);
        imwrite(final, strcat(finalpath, brains{bindex}));
    end
end
cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');