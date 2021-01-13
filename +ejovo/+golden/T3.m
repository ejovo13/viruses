function t3 = T3()
%t3 - The pairs of spherical locations that the T3 affine group spans
    d = ejovo.golden.path;
    load(d, 'T3_CONSTANT')
    t3 = T3_CONSTANT;
end