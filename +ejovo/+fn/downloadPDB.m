function [Tnum, app] = downloadPDB(pdbid)
%DOWNLOADPDB Download the au pdb file of a virus from the viperDB.
ejovo.fn.cd2pkg;
cd +v/coordinates/pdb

%This Perl script will ONLY run if the user has the modules WWW::Mechanize
%and IO::Uncompress::Gunzip installed. To learn how to install these
%modules look up "install cpanm."

% Check if the au coordinates have already been downloaded

full_coords_file = strcat("../../pdb/full/full_", pdbid, ".pdb");
au_coords_file = strcat("../../pdb/au/", pdbid, ".pdb");

if (~exist(full_coords_file, 'file'))
    % If the full_coordinates file doesn't already exist
    output = system(strcat("perl download_pdb_from_viperDB.pl ", pdbid));
    au_pdb = strcat(pdbid, ".pdb");
    full_pdb = strcat("full_", au_pdb);
    
    ejovo.fn.callMakeIcos(au_pdb);
    
    full_pdbs_dir = "../../pdb/full";
    au_pdbs_dir = "../../pdb/au";
    
    if (~exist(full_pdbs_dir, 'dir'))
        mkdir(full_pdbs_dir)
    end
    
    if (~exist(au_pdbs_dir, 'dir'))
        mkdir(au_pdbs_dir)
    end

    ejovo.fn.buildAU(pdbid)
    ejovo.fn.buildFull(pdbid)

    movefile(full_pdb, full_coords_file)
    copyfile(au_pdb, au_coords_file)

end

[Tnum, app] = ejovo.fn.getCapsidInfo(au_coords_file);









% disp(output)
%disp(cmdout)
%{
cmd_split = splitlines(cmdout);
zipfile_name = cmd_split{end};
delete(zipfile_name);
%}
end

