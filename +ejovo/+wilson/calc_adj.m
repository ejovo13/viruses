function [N] = calc_adj(verts)
[m,n] = size(verts);
%verts = round(1e3*verts)/1e3;
if m == 3
    verts = verts';
end
nverts = max(size(verts));
digits = 1e4;
D = zeros(nverts);
for m = 1:nverts %Compute distances between vertices. 
    for n = (m+1):nverts
        D(m,n) = sqrt((verts(m,1) - verts(n,1))^2 + (verts(m,2) - verts(n,2))^2 + (verts(m,3) - verts(n,3))^2);
        D(n,m) = D(m,n);
    end
end
D = round(digits*D)/digits; %Eliminate non important diffs
temp = unique(D(1,:));
temp = sort(temp);
d_min = temp(2);
% Determine Adjacency
% Input: Distance Matrix
N = zeros(nverts);
for m = 1:nverts
    %p = 1;
    for n = 1:nverts
        if (D(m,n) <= d_min*1.01)
            N(m,n) = 1;
                %sym_point(p,1:3,m) = min_vpa(n,1:3);
                %p = p + 1;
        end
    end
    %slice(:,1:3)    = sym_point(:,1:3,m); %    
    %sym_vecs(1:3,m) = sum(slice,1);
end
