function safCoords = rot2saf(vdbCoords)
%ROT2SAF rotates coordinates from vdb orientation to saf orientation.
%   safCoords = ROT2SAF(vdbCoords) rotates vdbCoords (an Nx3 matrix) into
%   saf orientation
%
phi = (1+sqrt(5))/2; %define the golden ratio
w1 = [0; 1; phi];    %define 5-fold axis for vdb coordinates
z = [0; 0; 1];       %desired 5-fold axis for saf coordinates
dotProduct = sum(w1.*z); 
cosineTheta = dotProduct/(norm(w1)*norm(z)); %use definition of dot product to solve for cos(theta)
th = acos(cosineTheta);                      %solve for thetat
sineTheta = sin(th);

rotx = [1, 0, 0; 0, cosineTheta, -1*sineTheta; 0, sineTheta, cosineTheta]; %Rotation matrix for theta degrees about the x-axis
rotz = [0, -1, 0; 1, 0, 0; 0, 0, 1];                                       %rotation vector for rotating 90 degrees about the z axis

MtoSAF = rotz*rotx; %rotation matrix from vdb to saf coordinates

vdbCoords = vdbCoords'; %transpose vdbCoords to facilitate rotation computation
[m, n] = size(vdbCoords);
safCoords = zeros(m, n);
for s = 1:n
    safCoords(:,s) = MtoSAF * vdbCoords(:,s);
end

safCoords = safCoords'; %transpose safCoords back into an Nx3 matrix