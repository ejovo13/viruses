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
        
    end
end