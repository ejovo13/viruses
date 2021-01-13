function extend(start, extension, symmetry)

A = [extension, symmetry];
b = [start];
x = A\b;
alpha = abs(x(1))
