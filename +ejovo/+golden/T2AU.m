function t2AU = T2AU()
%t2AU - The pairs of spherical locations that the T2 au affine group spans
    d = ejovo.golden.path;
    load(d, 'T2AU_CONSTANT')
    t2AU = T2AU_CONSTANT;
end