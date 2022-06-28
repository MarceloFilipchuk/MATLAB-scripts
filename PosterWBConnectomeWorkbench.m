filepath = 'E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\';
cd(filepath);
niis = dir('*.nii');
niis = {niis.name}';

surf_path = 'E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\Surfaces\';
cd(surf_path);
surfs = dir('*.gii');
surfs = {surfs.name}';

wb_path = 'E:\Investigacion\Programas\Connectome Workbench\bin_windows64';

finalcommands = {};
cd(wb_path);
for index = 1:length(niis)
    tmpnii = strcat(filepath, niis{index});
    tmpniifinal = strcat(filepath, extractBefore(niis{index}, '.nii'), '.shape.gii');
    tmpsurf = surfs{2};
    disp(sprintf('!wb_command -volume-to-surface-mapping %s %s %s -trilinear', tmpnii, strcat(surf_path, tmpsurf), tmpniifinal));
end

Lv3a = load_nii('E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3a_LH.nii');
Lv3a.img = [Lv3a.img ./ max(Lv3a.img(:))];
save_nii(Lv3a, 'E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3a_LHnorm.nii')

Rv3a = load_nii('E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3a_RH.nii');
Rv3a.img = [Rv3a.img ./ max(Rv3a.img(:))];
save_nii(Rv3a, 'E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3a_RHnorm.nii')


V3a = Lv3a;
V3a.img = [V3a.img + Rv3a.img];
save_nii(V3a, 'E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3a_BH.nii');


volumeInfo = spm_vol('E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3a_RH.nii');
[intensityValues,xyzCoordinates ] = spm_read_vols(volumeInfo);
xyzCoordinates = xyzCoordinates';
Rfinal = zeros(size(xyzCoordinates,1), 4);
test = intensityValues(:);
% test = test(:) ./ max(test(:));
Rfinal(:,1) = test;
Rfinal(:,2) = xyzCoordinates(:,1);
Rfinal(:,3) = xyzCoordinates(:,2);
Rfinal(:,4) = xyzCoordinates(:,3);
Rfinal = Rfinal(Rfinal(:,1) ~= 0, :);
Rfinal = sortrows(Rfinal, 'descend');
Rfinal = Rfinal(1:250,:);
% writematrix(Rfinal, 'E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3aRIGHT_coordinates.xls');



volumeInfo = spm_vol('E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3a_LH.nii');
[intensityValues,xyzCoordinates ] = spm_read_vols(volumeInfo);
xyzCoordinates = xyzCoordinates';
Lfinal = zeros(size(xyzCoordinates,1), 4);
test = intensityValues(:);
% test = test(:) ./ max(test(:));
Lfinal(:,1) = test;
Lfinal(:,2) = xyzCoordinates(:,1);
Lfinal(:,3) = xyzCoordinates(:,2);
Lfinal(:,4) = xyzCoordinates(:,3);
Lfinal = Lfinal(Lfinal(:,1) ~= 0, :);
Lfinal = sortrows(Lfinal, 'descend');
Lfinal = Lfinal(1:250,:);
% writematrix(Lfinal, 'E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3aLEFT_coordinates.xls');
final = [Lfinal ; Rfinal];
writematrix(final, 'E:\Investigacion\Cefalea\Trabajos\Congresos\Sociedad_Argentina_Neurociencias\POSTER_LORETA\ROIS_WB\V3aBH_coordinates.xls');
