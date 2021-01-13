function shell = SHELL()
%shell - The pairs of spherical locations that all point arrays span
    d = ejovo.golden.path;
    load(d, 'SHELL_CONSTANT')
    shell = SHELL_CONSTANT;
end