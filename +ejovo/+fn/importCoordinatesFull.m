function [XYZ, nAtoms] = importCoordinatesFull(pdbid)
%IMPORTCOORDINATESFULL - Convert the pdb file of a full virus into an Nx3 matrix
%
%Syntax:
%
%   [XYZ, nAtoms] = ejovo.fn.importCoordinatesFull(pdbid)
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
%The full virus coordinates must have already been extracted by the command
%ejovo.fn.buildFull in order for IMPORTCOORDINATESFULL to work properly. There
%should be a file in +ejovo/coordinates/full named xyz.full_'pdbid'.pdb.
startDir = pwd;
prefix = 'xyz.full_';
extension = '.pdb';
fileName = strcat('+ejovo/+v/coordinates/full/', prefix, pdbid, extension);
disp(strcat({'The file name is '}, fileName));

ejovo.fn.cd2parent;
XYZ = importdata(fileName);
nAtoms = length(XYZ);
cd(startDir)
end