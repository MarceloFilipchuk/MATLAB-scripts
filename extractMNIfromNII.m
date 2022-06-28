volumeInfo = spm_vol('E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\ROI\BA25.nii');
[intensityValues,xyzCoordinates ] = spm_read_vols(volumeInfo);
xyzCoordinates = xyzCoordinates';
final = zeros(size(xyzCoordinates,1), 4);
test = intensityValues(:);
% test = test(:) ./ max(test(:));
final(:,1) = test;
final(:,2) = xyzCoordinates(:,1);
final(:,3) = xyzCoordinates(:,2);
final(:,4) = xyzCoordinates(:,3);
final = final(final(:,1) ~= 0, :);
final = sortrows(final, 'descend');
 
writematrix(final, 'E:\Investigacion\Cefalea\Trabajos\QEEG FINAL\Connectivity maps Test\ROI25_TEST.xls'); 