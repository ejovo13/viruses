function shellToXYZ(shell, r, outputName, folderName, atomName)
%SHELLTOXYZ - Create an xyz file from a point array shell 
%
%   ejovo.fn.shellToXYZ(shell, r, outputName, folderName, atomName)
%
%Inputs:
%
%   shell      - a pair of spherical coordinates [TH, PH] that spans all
%               the points an a sphere that pointArrays can touch
%   r          - the radial component you would like to add to a shell
%               defaults to 1.05 for visual purposes
%   outputName - the name of the output file
%   folderName - the name of the output folder
%   atomName   - the atom you would like to create 
%
% "Shells" are pairs of the spherical coordinates theta and phi, where
% theta represents the azimuth angle and phi is the elevation. These pairs
% represent all the points on a sphere that a given point array affine
% group touches.
if nargin < 2
    r = 1.05;
end


 %add r
 n = length(shell);
 r = zeros(n, 1) + r;  
 %change to cart
 [X, Y, Z] = sph2cart(shell(:,1), shell(:,2), r);
 XYZ = [X, Y, Z];
 %output to xyz
 
 if nargin < 4
     ejovo.fn.toXYZ(XYZ, outputName)
 elseif nargin < 5
     ejovo.fn.toXYZ(XYZ, outputName, folderName)
 else
     ejovo.fn.toXYZ(XYZ, outputeName, folderName, atomName)
 end
 
 
 
 
 
 
 