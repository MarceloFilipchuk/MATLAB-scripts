% Direcciones para revisar.
mripath = {
    'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\MRI\Cronicos vs Ictales';
    'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\MRI\Ictales vs Controles';
    'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\MRI\Ictales vs Interictales';
    'E:\Investigacion\Cefalea\Investigacion\QEEG FINAL\Resultados LORETA\MRI\Interictales vs Controles';  
};

% Itera sobre cada carpeta.
for pindex = 1:length(mripath)
    
    % Crea una lista de las imagenes dentro de la carpeta.
    cd(mripath{pindex})
    mris = dir('*.bmp');
    mris = {mris.name}';
    
    % Itera sobre cada imagen.
    for mindex = 1:length(mris)
        
        mri = imread(mris{mindex});
        %%%%%%%%%%%%
        % Metodo 1 %
        %%%%%%%%%%%%
%         axial = mri(12:228,12:192,:); 
%         sagital = mri(43:223,242:458,:);
%         sag_padding = zeros(18, 217, 3);
%         sag_padding(:,:,:) = 255;
%         cor_padding = zeros(18, 181, 3);
%         cor_padding(:,:,:) = 255;
%         sagital = [sag_padding ; sagital ; sag_padding];
%         coronario = mri(43:223,509:689,:);
%         coronario = [cor_padding ; coronario ; cor_padding];
        %%%%%%%%%%%%
        % Metodo 2 %
        %%%%%%%%%%%%
        axial = mri(11:229,11:193,:); 
        sagital = mri(42:224,242:459,:);
        sag_padding = zeros(18, 218, 3);
        sag_padding(:,:,:) = 255;
        sagital = [sag_padding ; sagital ; sag_padding];
        coronario = mri(42:224,509:690,:);
        cor_padding = zeros(18, 182, 3);
        cor_padding(:,:,:) = 255;
        coronario = [cor_padding ; coronario ; cor_padding];

        final = [axial, sagital, coronario];
%         final = imresize(final, 0.7);
        finalpath = strcat(mripath{pindex}, '\LORETA MRI\');
        if ~exist(finalpath, 'dir')
            mkdir(finalpath);
        end
        imwrite(final, strcat(finalpath, mris{mindex}));
    end
end

cd(extractBefore(mfilename('fullpath'), mfilename))
disp('> > > > > > > > > > TERMINADO < < < < < < < < < <');