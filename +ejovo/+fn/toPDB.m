function namePDB = toPDB(XYZ, outputName, folderName)
%TOPDB - takes an Nx3 matrix and outputs a pdb coordinate file
%
%Syntax:
%
%   namePDB = ejovo.fn.toPDB(XYZ, outputName, folderName, atomName)
%
%Inputs:
%
%   XYZ        - an Nx3 matrix of XYZ coordinates
%   outputName - the name of the output file
%   folderName - the name of the folder where you want to store your pdb
%                file. If no folder is specified, defaults to the directory
%                +ejovo/vmd/pdb
%   atomName   - the atom that you want the pdb file to write. Acceptable
%                values conform to the pdb file format specifications. Defaults to 'C'
%                (carbon)
%
%Output:
%
%   namePDB    - the name of the output pdb file (with extension .pdb)
%
%Ex:
%
%   myFile = ejovo.fn.toPDB(XYZ, '2ms2', '+ejovo/vmd/pdb/2ms2/SAF6', 'H') -
%   creates a file called '2ms2.pdb' in the directory
%   +ejovo/vmd/pdb/2ms2/SAF6, whose coordinates will be represented in vmd
%   as Hydrogen atoms.
%   myFile2 = ejovo.fn.toPDB(XYZ, 'myFile2') - creates a file called
%   'myFile2.pdb' in the default directory +ejovo/vmd/pdb, whose atoms
%   will be represented in VMD as Carbon atoms
%   
if nargin < 3
    parentDir = ejovo.fn.getParentDir;
    folderName = strcat(parentDir, '+ejovo/output/pdb');
    if nargin < 2
        outputName = 'default';
    end
end

%XYZ is a Nx3 matrix
%[N,~] = size(XYZ);
namePDB = strcat(outputName,'.pdb');
 
fid1 = fopen(namePDB,'w');
%fprintf(fid1,'%d\n', N);
%fprintf(fid1,'I am a comment \n');
myFormat = ' %10.7f %10.7f %10.7f \n';
fprintf(fid1, myFormat, [XYZ(:,1)'; XYZ(:,2)'; XYZ(:,3)';]);
fclose(fid1);
if ~exist(folderName, 'file') %If folder doesn't exist, make it
    mkdir(folderName)
end
movefile(namePDB, folderName)
fprintf('\n')
disp(char(strcat(namePDB, {' created in folder '}, folderName)))
fprintf('\n')