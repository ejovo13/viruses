classdef au < ejovo.v.virus
    
    methods
        %au = au(pdbid, XYZ, orientation)
        function au = au(varargin)
            au = au@ejovo.v.virus(varargin{:});
        end
        
        %TOFULL - future release
        
        %TOSAF
        function safAU = toSAF(au)
            safAU = ejovo.v.safAU(au.pdbid, au.coords{:,1:3}, au.orientation);
            safAU.T = au.T;
            safAU.app = au.app;
        end
        
        %TOSIP
        function sipAU = toSIP(au)
            safAU = au.toSAF;
            sipAU = safAU.toSIP;
        end 
        
        function au = franken(au)
            
            [results, admissible, values] = ejovo.v.fn_frankencode(au);
            au.franken_results = results;
            au.franken_admissible = admissible;
            au.franken_output = values;
                    
        end

        function output_pa(au, pa_list)

            for ii = pa_list

                paN3 = au.franken_results(ii).tpa_shunt';
                [~] = fn_output_pa2pdb(paN3,ii,au.pdbid,'pa');
                file_name = strcat(au.pdbid,'_pa_',num2str(ii),'.pdb');

                ejovo_dir = ejovo.fn.getPkgDir;
                perl_dir = strcat(ejovo_dir, "+v/coordinates/pdb");
                full_file_name = strcat("full_", file_name);

                if( exist("vpa_output", 'dir')) 

                    W = what("vpa_output");
                    fprintf(strcat("Outputting ", full_file_name, " to ", W.path, "/", full_file_name, "\n"))
                    vpa_output_plus_file_path = strcat(W.path, "/", full_file_name);

                else

                    fprintf("vpa_output path not found...\n")
                    vpa_output_plus_file_path = strcat(cur_dir, "/vpa_output/", full_file_name);

                end

                movefile(file_name, strcat(perl_dir, "/", file_name));
                
                cur_dir = pwd;
                cd(perl_dir);
                
                system(strcat("perl makeicos.pl ", file_name));
                % display(output)
                delete(file_name);



                movefile(full_file_name, vpa_output_plus_file_path)
                
                cd(cur_dir);


            end 
        end 
        
    end
end