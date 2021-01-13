function t5 = T5()
%t5 - The pairs of spherical locations that the T5 affine group spans
    d = ejovo.golden.path;
    load(d, 'T5_CONSTANT')
    t5 = T5_CONSTANT;
end