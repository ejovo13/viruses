function t5au = T5AU()
%t5au - The pairs of spherical locations that the T5 au affine group spans
    d = ejovo.golden.path;
    load(d, 'T5AU_CONSTANT')
    t5au = T5AU_CONSTANT;
end