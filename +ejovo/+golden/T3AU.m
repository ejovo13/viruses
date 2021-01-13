function t3AU = T3AU()
%t3au - The pairs of spherical locations that the T3 au affine group spans
    d = ejovo.golden.path;
    load(d, 'T3AU_CONSTANT')
    t3AU = T3AU_CONSTANT;
end