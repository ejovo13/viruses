function nameXYZ = toXYZ(XYZ, outputName, folderName, atomName)
%TOXYZ - takes an Nx3 matrix and outputs an xyz coordinate file
%
%Syntax:
%
%   nameXYZ = ejovo.fn.toXYZ(XYZ, outputName, folderName, atomName)
%
%Inputs:
%
%   XYZ        - an Nx3 matrix of XYZ coordinates
%   outputName - the name of the output file
%   folderName - the name of the folder where you want to store your xyz
%                file. If no folder is specified, defaults to the directory
%                +ejovo/vmd/xyzSteps
%   atomName   - the atom that you want the xyz file to write. Acceptable
%                values conform to the xyz file format specifications. Defaults to 'C'
%                (carbon)
%
%Output:
%
%   nameXYZ    - the name of the output xyz file (with extension .xyz)
%
%Ex:
%
%   myFile = ejovo.fn.toXYZ(XYZ, '2ms2', '+ejovo/vmd/xyzSteps/2ms2/SAF6', 'H') -
%   creates a file called '2ms2.xyz' in the directory
%   +ejovo/vmd/xyzSteps/2ms2/SAF6, whose coordinates will be represented in vmd
%   as Hydrogen atoms.
%   myFile2 = ejovo.fn.toXYZ(XYZ, 'myFile2') - creates a file called
%   'myFile2.xyz' in the default directory +ejovo/vmd/xyzSteps, whose atoms
%   will be represented in VMD as Carbon atoms
%   

if nargin < 4
    atomName = 'C';
    if nargin < 3
        parentDir = ejovo.fn.getParentDir;
        folderName = strcat(parentDir, '+ejovo/output/xyz');
        if nargin < 2
            outputName = 'default';
        end
    end
end

%XYZ is a Nx3 matrix
[N,~] = size(XYZ);
nameXYZ = strcat(outputName,'.xyz');
 
fid1 = fopen(nameXYZ,'w');
fprintf(fid1,'%d\n', N);
fprintf(fid1,'I am a comment \n');
myFormat = strcat(atomName, {' %10.7f %10.7f %10.7f \n'});
fprintf(fid1, myFormat{1}, [XYZ(:,1)'; XYZ(:,2)'; XYZ(:,3)';]);
fclose(fid1);

if ~exist(folderName, 'file') %If folder doesn't exist, make it
    mkdir(folderName)
end
movefile(nameXYZ, folderName)
%fprintf('\n')
%disp(strcat(nameXYZ, {' created in folder '}, folderName))
%fprintf('\n')