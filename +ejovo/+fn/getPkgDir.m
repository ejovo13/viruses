function pkgDir = getPkgDir()
%GETPKGDIR - Return the full directory of the ejovo package
    vDir = which('ejovo.v.virus');
    if ispc
        delim = '\';
    else
        delim = '/';
    end
    toReplace = strcat('+v', delim, 'virus.m');
    pkgDir = strrep(vDir, toReplace, '');
end