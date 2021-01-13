function shellAU = SHELLAU()
%shellAU - The pairs of spherical locations that all au point arrays span
    d = ejovo.golden.path;
    load(d, 'SHELLAU_CONSTANT')
    shellAU = SHELLAU_CONSTANT;
end