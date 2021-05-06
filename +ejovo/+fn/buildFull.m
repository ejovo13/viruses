function buildFull(pdbid)
%BUILDFULL - Build a full coordinate file when given a 'pdbid'
%
%Syntax:
%
%   ejovo.fn.buildFull(pdbid)
%
%Inputs:
%
%   pdbid - 4-digit pdbid used to locate and download viruses through the
%   VIPER database
%
%Ex:
%
%   ejovo.fn.buildFull('2ms2') - creates a coordinate file of the entire 2ms2
%   virus and moves it to the +ejovo/coordinates/full folder.
%
%
%Before you run this command, you need to download the coordinates for the
%asymmetric unit of a virus. You must unzip this (which creates a vdb file)
%and then place it in the +ejovo/coordinates/vdb folder. AU coordinates can be
%downloaded <a href="http://viperdb.scripps.edu/index.php">here</a>.
%
%Refer to the <a href=
%"https://teams.microsoft.com/l/channel/19%3adbe209ba4260495f98d1cf21aa32aa3a%40thread.tacv2/Code?groupId=4c83192e-2e3a-469f-8de7-a3c8352202b5&tenantId=e214b458-c456-45b4-961a-7852355f177a">teams</a> page for more help downloading files from the VIPER database.
%
%When instantiating a virus, the constructor will actually automatically
%build the xyz.full_'pdbid'.pdb file needed to load in the coordinates, so all
%you need to do is move the unzipped au vdb file into the vdb folder.

startDir = pwd;
ejovo.fn.cd2pkg;
cd +v/coordinates/pdb

pdbFile = strcat(pdbid, '.pdb');

% [Tnum, app] = ejovo.fn.getCapsidInfo(pdbFile);


%rotate the pdb file
perl('makeicos.pl', pdbFile);
fullFile = strcat('full_', pdbFile);
ejovo.fn.extractCoords(fullFile);

%move the file and delete the previous versions
fullFolder = "../full";

if (~exist(fullFolder, "dir")) 
    mkdir(fullFolder)
end


xyzFull = strcat('xyz.', fullFile);
movefile(xyzFull, '../full')
% delete(pdbFile)
% delete(fullFile)
cd(startDir);

end