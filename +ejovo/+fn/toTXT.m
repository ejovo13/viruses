function nameTXT = toTXT(XYZ, outputName, folderName)
%TOtxt - takes an Nx3 matrix and outputs an txt coordinate file
%
%Syntax:
%
%   nameTXT = ejovo.fn.totxt(XYZ, outputName, folderName, atomName)
%
%Inputs:
%
%   XYZ        - an Nx3 matrix of XYZ coordinates
%   outputName - the name of the output file
%   folderName - the name of the folder where you want to store your txt
%                file. If no folder is specified, defaults to the directory
%                +ejovo/vmd/txtSteps
%   atomName   - the atom that you want the txt file to write. Acceptable
%                values conform to the txt file format specifications. Defaults to 'C'
%                (carbon)
%
%Output:
%
%   nametxt    - the name of the output txt file (with extension .txt)
%
%Ex:
%
%   myFile = ejovo.fn.totxt(XYZ, '2ms2', '+ejovo/vmd/txtSteps/2ms2/SAF6', 'H') -
%   creates a file called '2ms2.txt' in the directory
%   +ejovo/vmd/txtSteps/2ms2/SAF6, whose coordinates will be represented in vmd
%   as Hydrogen atoms.
%   myFile2 = ejovo.fn.totxt(XYZ, 'myFile2') - creates a file called
%   'myFile2.txt' in the default directory +ejovo/vmd/txtSteps, whose atoms
%   will be represented in VMD as Carbon atoms
%   
if nargin < 3
    parentDir = ejovo.fn.getParentDir;
    folderName = strcat(parentDir, '+ejovo/output/txt');
    if nargin < 2
        outputName = 'default';
    end
end

%XYZ is a Nx3 matrix
%[N,~] = size(XYZ);
nameTXT = strcat(outputName,'.txt');
 
fid1 = fopen(nameTXT,'w');
%fprintf(fid1,'%d\n', N);
%fprintf(fid1,'I am a comment \n');
myFormat = ' %10.7f %10.7f %10.7f \n';
fprintf(fid1, myFormat, [XYZ(:,1)'; XYZ(:,2)'; XYZ(:,3)';]);
fclose(fid1);
if ~exist(folderName, 'file') %If folder doesn't exist, make it
    mkdir(folderName)
end
movefile(nameTXT, folderName)
%fprintf('\n')
%disp(strcat(nameTXT, {' created in folder '}, folderName))
%fprintf('\n')