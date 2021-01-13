function [N] = fn_calc_adj_NN(ptsN3,x)
digits = 1e4;
[nverts,y] = size(ptsN3);

D = zeros(nverts);
for m = 1:nverts %Compute distances between vertices. 
    for n = (m+1):nverts
        D(m,n) = sqrt((ptsN3(m,1) - ptsN3(n,1))^2 + (ptsN3(m,2) - ptsN3(n,2))^2 + (ptsN3(m,3) - ptsN3(n,3))^2);
        D(n,m) = D(m,n);
    end
end
D = round(digits*D)/digits; %Eliminate non important diffs
% Determine Adjacency
N = zeros(nverts);
for m = 1:nverts
    dall = D(m,:); dall = sort(dall);
    dmin = dall(x);
    for n = 1:nverts
        if (D(m,n) <= dmin*1.05) && m ~= n
            N(m,n) = 1;
        end
    end
end
