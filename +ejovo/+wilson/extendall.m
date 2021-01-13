function alpha = extendall(start, extension, symmetryaxes)

Size = size(symmetryaxes);
alpha = zeros(Size(1,2), 1);

for n = 1:Size(1,2)
    A = [extension, symmetryaxes(:,n)];
    b = [start];
    x = A\b;
    alpha(n, 1) = abs(x(1));
end