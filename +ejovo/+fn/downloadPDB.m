function downloadPDB(pdbid)
%DOWNLOADPDB Download the au pdb file of a virus from the viperDB.
ejovo.fn.cd2pkg;
cd +v/coordinates/pdb

%This Perl script will ONLY run if the user has the modules WWW::Mechanize
%and IO::Uncompress::Gunzip installed. To learn how to install these
%modules look up "install cpanm."
output = perl('download_pdb_from_viperDB.pl', pdbid);
disp(output)
%disp(cmdout)
%{
cmd_split = splitlines(cmdout);
zipfile_name = cmd_split{end};
delete(zipfile_name);
%}
end

