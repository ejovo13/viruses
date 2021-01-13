function [radii_vpa3N] = calc_radii(vpa3N, digits)
if exist('digits','var') == 0
    digits = 1e4;
end

[m,nvpa3N] = (size(vpa3N));
%[m,n] = size(vpa3N);
if m ~= 3
    vpa3N = vpa3N';
    [m,nvpa3N] = (size(vpa3N));
end

for i = 1:nvpa3N
    radii_vpa3N(i) = sqrt(vpa3N(1,i)^2 + vpa3N(2,i)^2 + vpa3N(3,i)^2);
end

radii_vpa3N = round(digits*radii_vpa3N)/digits;
% [sort_radii_vpa,index_radii_vpa] = sort(radii_vpa,'ascend');
% sort_vpa = vpa(index_radii_vpa,1:3);
% unique_vpa_radii = unique(sort_radii_vpa);
% nshells = numel(unique_vpa_radii);