classdef safAU < ejovo.v.safVirus
    
    methods
        %au = au(pdbid, XYZ, orientation, SAF)
        function safAU = safAU(varargin)
            safAU = safAU@ejovo.v.safVirus(varargin{:});
        end
        
        %TOFULL - future release
        %TOBASE
        function au = toBase(safAU)
            au = ejovo.v.au(safAU.pdbid, safAU.coords{:,1:3}, safAU.orientation);
            au.T = safAU.T;
            au.app = safAU.app;
        end
                
        %TOSIP
        function sipAU = toSIP(safAU)
            sipAU = ejovo.v.sipAU(safAU.pdbid, safAU.coords{:,1:3}, safAU.orientation, safAU.SAF{:,:});
            sipAU.T = safAU.T;
            sipAU.app = safAU.app;
        end
    end
end