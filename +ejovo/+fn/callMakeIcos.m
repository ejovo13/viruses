function callMakeIcos(inputFile)

old_dir = pwd;
ejovo.fn.cd2pkg;
cd +v/coordinates/pdb


output = system(strcat("perl makeicos.pl ", inputFile));

display(output)

cd(old_dir)


end



