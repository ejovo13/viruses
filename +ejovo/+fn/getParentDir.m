function pkgDir = getParentDir()
%GETPARENTDIR - Return the full parent directory of the ejovo package
    vDir = which('ejovo.v.virus');
    if ispc
        delim = '\';
    else
        delim = '/';
    end
    toReplace = strcat('+ejovo', delim, '+v', delim, 'virus.m');
    pkgDir = strrep(vDir, toReplace, '');
end