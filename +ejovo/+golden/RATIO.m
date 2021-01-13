function phi = RATIO()
%RATIO - golden ratio
    d = ejovo.golden.path;
    load(d, 'RATIO_CONSTANT')
    phi = RATIO_CONSTANT;
end