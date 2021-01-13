function t2 = T2()
%t2 - The pairs of spherical locations that the T2 affine group spans
    d = ejovo.golden.path;
    load(d, 'T2_CONSTANT')
    t2 = T2_CONSTANT;
end