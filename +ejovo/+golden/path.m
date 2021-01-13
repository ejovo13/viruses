function dir = path()
%path - Return the full directory to the ejovo.golden.constants mat file
pkgDir = ejovo.fn.getPkgDir;
if ispc
    delim = '\';
else
    delim = '/';
end
dir = strcat(pkgDir, '+golden', delim, 'constants.mat');
end
