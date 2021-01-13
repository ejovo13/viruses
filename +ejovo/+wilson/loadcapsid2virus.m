%%
%Load and split text into a cell of chars
capsidTxt = fileread('SC_load_capsids.txt');
capsidStr = convertCharsToStrings(capsidTxt);
capsidLines = splitlines(capsidTxt);

%Conver cell to string array
numL = length(capsidLines);
pdbLineIndex = contains(capsidLines, 'pdbid = ') ;
pdbLines = capsidLines(pdbLineIndex);
numViruses = length(pdbLines);
pdbStartIndex = strfind(pdbLines, 'pdbid');
c = cell(3, 0);
for ii = 1:numViruses
    thisLine = pdbLines{ii,:};
    thisLine = thisLine(pdbStartIndex{ii}:end);
    c = [c split(thisLine)];     %#ok<*AGROW>
end
PDBID = c(3, :);

for ii = 1:numViruses
    PDBID{ii} = strrep(PDBID{ii}, "'", '');
end
PDBID;
PDBID = vertcat(PDBID{:});
ccIndex = contains(PDBID, 'ccmv');
PDBID = PDBID(~ccIndex);


    
    



%Show lines and class
%disp(capsidLineStr);