function extractCoords(fileName)
%EXTRACTCOORDS Run the perl script to extract a virus's xyz coordinates
%
%Syntax:
%
%   ejovo.fn.extractCoords(fileName)
%
%Inputs:
%   
%   fileName - a .pdb file in the form of either xyz.full_'pdbid'.pdb (for
%   a full virus) or xyz.'pdbid'.pdb (for the au). 
%
%Ex:
%
%   ejovo.fn.extractCoords('xyz.full_2ms2.pdb') - extracts the coordinates for
%   a full 2ms2 virus.
%
%   ejovo.fn.extractCoords('xyz.2ms2.pdb') - extracts the au coordinates
%   for 2ms2
%
%
%If you get an error, you should ensure that you have perl enabled.
    numAtoms = perl('extract_coords.pl', fileName);
    disp(numAtoms)
end
