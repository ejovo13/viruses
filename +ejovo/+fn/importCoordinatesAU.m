function [XYZ, nAtoms] = importCoordinatesAU(pdbid)
%IMPORTCOORDINATESAU - Convert the pdb file of a virus AU into an Nx3 matrix
%
%Syntax:
%
%   [XYZ, nAtoms] = ejovo.fn.importCoordinatesAU(pdbid)
%
%Inputs:
%
%   pdbid - 4 digit pdbid 
%
%Outputs:
%
%   XYZ - Nx3 XYZ coordinate matrix
%   nAtoms - length of XYZ
%
%
%

%The au coordinates must have already been extracted by the command
%ejovo.fn.buildAU in order for IMPORTCOORDINATESAU to work properly. There
%should be a file in +ejovo/coordinates/au named xyz.'pdbid'.pdb. 
%
startDir = pwd;
prefix = 'xyz.';
extension = '.pdb';
fileName = strcat('+ejovo/+v/coordinates/au/', prefix, pdbid, extension);

fprintf(strcat("The file name is: ", fileName, "\n"))

ejovo.fn.cd2parent;
XYZ = importdata(fileName);
nAtoms = length(XYZ);
cd(startDir)

end