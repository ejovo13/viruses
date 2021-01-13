%GETCAPSIDINFO - Process the T-number and number of atoms per protein from a vdb file

function [Tnum, app] = getCapsidInfo(pdbFile)
output = perl('pdb_info.pl', pdbFile);
tIndex = strfind(output, 'Tnum');
lastLine = output(tIndex:end);

lastLine = strrep(lastLine, '\', ''); %fix last line on windows

semiCol = strfind(lastLine, ';');
tStart = strfind(lastLine, 'Tnum');
aStart = strfind(lastLine, 'app');

Tnum = lastLine(tStart:semiCol(1)); %set Tnum command
app = lastLine(aStart:semiCol(2)); %set app command
eval(Tnum); %DEFINES THE TNUM
eval(app); %DEFINES THE APP
disp('Capsid info extracted');
