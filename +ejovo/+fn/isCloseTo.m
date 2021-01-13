function bool = isCloseTo(x, y, epsilon)
%ISCLOSETO - Check if a number is within EPSILON of another.
%Often after performing calculations, there will be some negligible numeric
%error introduced. We can check if two values are basically equal by
%calling isCloseTo.
%
%Syntax:
%
%   bool = ejovo.fn.isCloseTo(x, y, epsilon)
%
%Inputs:
%
%   x - the value that you want to check (can be a column or row vector)
%   y - the value you are checking against
%   epsilon - the acceptable difference. Default value is 0.001
%
%Outputs:
%
%   bool - a logical array that is true if the two values are within
%   epsilon of eachother.
%
%Example:
%
%   bool = ejovo.fn.isCloseTo(1.0004, 1)
%       -returns true
%
%   bool = ejovo.fn.isCloseTo(3.15, 3, .01)
%       -returns false
%
if nargin == 2
    epsilon = .001;
end

for ii = 1:length(x)
if abs(x(ii) - y) <= epsilon
    bool(ii) = true; %#ok<*AGROW>
else
    bool(ii) = false;
end
end
