% wb_path = 'E:\Investigacion\Programas\Connectome Workbench\bin_windows64';
% D:\test\ictal.nii 
% D:\test\cortex_20484.surf.gii
% D:\test\ictal.shape.gii
% !wb_command -volume-to-surface-mapping D:\test\ictal.nii D:\test\cortex_20484.surf.gii D:\test\ictal.shape.gii -trilinear

parahippocampal = load_nii('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\Mascaras IHC2021\Parahippocampal.nii');
subcallosal = load_nii('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\Mascaras IHC2021\Subcallosal.nii');
% v3a = load_nii('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\V3a.nii');
precuneus = load_nii('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\Mascaras IHC2021\Precuneus.nii');


final = subcallosal;
final.img = [];
final.img = [parahippocampal.img + subcallosal.img + precuneus.img];  
% final.img(final.img > 1) = 1; 
% max(final.img(:))

save_nii(final, 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\Mascaras IHC2021\final.nii');
!wb_command -volume-to-surface-mapping D:\test\final.nii D:\test\cortex_20484.surf.gii D:\test\final.shape.gii -trilinear

ictal = load_nii('D:\test\ictal.nii');
ictal.img = [ictal.img .* final.img];
save_nii(ictal, 'D:\test\ictal_masked.nii');
!wb_command -volume-to-surface-mapping D:\test\ictal_masked.nii D:\test\cortex_20484.surf.gii D:\test\ictal_masked.shape.gii -trilinear