classdef virus
%A class that stores the coordinates and orientation of a full virus.
%
%
%Class path: ejovo.v.virus
%
%   vPDBID = ejovo.v.virus('PDBID') is the simplest way to create a virus object,
%   provided that there is a vdb coordinate file of the au under the
%   +ejovo/+v/coordinates/vdb folder. These can be downloaded at the VIPDER
%   database.
%
%   v2ms2 = ejovo.v.virus('2ms2')
%   v1qbe = ejovo.v.virus('1qbe')
%
%   ejovo.v.VIRUS properties:
%
%       pdbid - pdbid of a virus, used to look up and download coordinates
%       through the VIPER database%
%       ORIENTATION - the orientation of a virus's coordinates. 'vdb'
%       indicates the <a
%       href="http://viperdb.scripps.edu/main.php">standard arrangement</a> found on the VIPER database.
%       'saf' refers to the orientation that SAFs are calculated in. That
%       is, with the 5-fold axis aligned with the positive z-axis. 'saf'
%       orientation can be visualized using the command PLOTSAF. Refer to
%       the <a href="https://teams.microsoft.com/l/channel/19%3adbe209ba4260495f98d1cf21aa32aa3a%40thread.tacv2/Code?groupId=4c83192e-2e3a-469f-8de7-a3c8352202b5&tenantId=e214b458-c456-45b4-961a-7852355f177a">notes page</a> under the code channel of our virus group to see a 
%       comparison of vdb and saf orienation. 
%       See also ejovo.SAF.PLOTSAF 
%       COORDS - a Nx6 table that stores cartesian and spherical
%       coordinates of a virus.
%       T - Tnumber
%       APP - Atoms per protein 
%   
%   ejovo.v.VIRUS methods:
%
%       CHANGEOrientation - changes coordinate system between saf and vdb
%       orientation. Vdb orientation is the standard arrangement of viruses 
%       found on the VIPER database, where the 2-fold axes are found on the
%       x, y, and z axes. SAF orientation is the orientation that SAFs are
%       calculated in, where the 5-fold axis is aligned with the positive z
%       axis.       
%       PLOT - plots the virus in MATLAB         
%       TOAU - extracts in the assymetric unit of the virus, which
%       represents the first 1/60th atoms. The AU is much more useful for
%       normal mode decomposition as significant numeric error is
%       introduced when working with a full virus object
%       TOSAF - Convert between virus and safVirus objects
%       TOSIP - Convert between virun and sipVirus objects
%       TOTXT - Output the coordinates to a column major txt file
%       TOXYZ - Output the coordinates to a column major xyz coordinates
%       file, to be used for visualization in vmd.
%       getVirus - Return the desired virus (by pdbid) in a virus array
%
%
%
%       
%
%
%
%
%
%
%

    properties
                               %PDB id    
        coords         
        orientation
        pdbid
        T
        app
    end   
    
    properties (Hidden)               
       atoms
       franken_results
       franken_admissible
       franken_output
    end
    
    properties (Hidden, Constant)
        DEGREE = [0, 6, 10, 12, 16, 18, 20, 22, 24, 26, 28, 30, 31];
    end        
        
    methods
        %Normal virus constructor    
        %virus = virus(pdbid, XYZ, orientation)
        function virus = virus(varargin) 
            fprintf('\n');  
            disp(strcat(['Building ', class(virus), ' object.']))
            fprintf('\n');
            n = length(varargin);        
            %DEFAULT VALUES BASED ON CONDITIONS               
            orientation = "vdb";
            if n > 1
                XYZ = varargin{2};
                loadCoordinates = false;
                if n > 2
                    orientation = varargin{3};  
                end
            else
               loadCoordinates = true;
            end    
            
            %Set pdbid
            virus.pdbid = convertCharsToStrings(varargin{1});   


            working_directory = pwd;
            %Load coordinates 
            if loadCoordinates 
                %Download pdb
                [Tnum, app] = ejovo.fn.downloadPDB(virus.pdbid);
                if isau(virus)
                    % disp('Building AU coordinates')                    
                    % [Tnum, app] = ejovo.fn.buildAU(virus.pdbid);
                    disp('Attempting to import AU coordinates...');
                    [XYZ, numAtoms] = ejovo.fn.importCoordinatesAU(virus.pdbid);
                else
                    % disp('Building full coordinates')
                    % [Tnum, app] = ejovo.fn.buildFull(virus.pdbid);
                    disp('Attempting to import full virus coordinates...');
                    [XYZ, numAtoms] = ejovo.fn.importCoordinatesFull(virus.pdbid);
                end
                virus.T = Tnum;
                virus.app = app;
                disp([int2str(numAtoms) ' Atoms loaded successfully']);                
            end              
            cd(working_directory);
            
            %sets coordinates            
            virus = virus.setCoords(XYZ);          
            virus.orientation = orientation; 
            virus.atoms = length(XYZ);
            disp('Coordinates set'); 
            fprintf('\n');      
            
            %Changes coordinates to default 'vdb'
            if strcmp(virus.orientation, "saf")
                virus = changeCoordinates(virus);
            end     
        end 
        %
        function virus = changeOrientation(virus)
        %CHANGEORIENTATION Toggles the coordinates between saf and vdb orientation
            virus = changeCoordinates(virus);
        end
        
        %PLOT plots the XYZ coordinates of a virus in 3D space
        function p = plot(virus)
            p = plot3(virus.coords.X, virus.coords.Y, virus.coords.Z, '.');
            %addvertices(virus.R(1));
        end               
                
        % --------------Helper Functions------------------ %        
        function virus = setCoords(virus, XYZ)
        %setCoords - sets the coordinate property of a virus
            X = XYZ(:,1);
            Y = XYZ(:,2);
            Z = XYZ(:,3);
            [TH, PH, R] = cart2sph(X, Y, Z);
            virus.coords = table(X, Y, Z, TH, PH, R);            
        end        
        
        function index = findVirus(virus, pdbid)
        %FINDVIRUS - returns the index of a virus that is stored in an array of Viruses
            pdbid = convertCharsToStrings(pdbid);
            pdbids = vertcat(virus.pdbid);
            index = find(strcmp(pdbids, pdbid));
            
        end    
        
        function index = findAU(virus, pdbid)
        %FINDAU - returns the index of an AU contained in an array of AUs
            auid = strcat(pdbid, "_au");
            names = vertcat(virus.pdbid);
            index = find(strcmp(names, auid));
        end
                
        function virus = getVirus(virus, pdbid)
        %getVirus returns a virus that is stored in a virus array
            vIndex = findVirus(virus, pdbid);
            auIndex = findAU(virus, pdbid);
            if and(isempty(vIndex), isempty(auIndex))
                error(strcat({'No virus with pdbid: '}, pdbid, {' found.'}))
            elseif isempty(vIndex)
                index = auIndex;
            else 
                index = vIndex;
            end
            virus = virus(index);
        end
            
        function fileName = toXYZ(virus, atom, destinationFolder)
        %toXYZ takes the coordinates of a virus.base and outputs them as an xyz file
        %toXYZ(virus, atom)
            if nargin <3
                if nargin < 2
                    atom = 'C';
                end
                parentDir = ejovo.fn.getParentDir;
                if isau(virus)
                    destinationFolder = strcat(parentDir, '+ejovo/v_output/xyz/', virus.pdbid, '_au');
                else
                    destinationFolder = strcat(parentDir, '+ejovo/v_output/xyz/', virus.pdbid);
                end
            end 
            fileName = ejovo.fn.toXYZ(virus.coords{:,1:3}, virus.pdbid, destinationFolder, atom);
        end
        
        function fileName = toTXT(virus, destinationFolder)
            if nargin < 2
                parentDir = ejovo.fn.getParentDir;
                if isau(virus)
                    destinationFolder = strcat(parentDir, '+ejovo/v_output/txt/', virus.pdbid, '_au');
                else
                    destinationFolder = strcat(parentDir, '+ejovo/v_output/txt/', virus.pdbid);
                end
            end
            fileName = ejovo.fn.toTXT(virus.coords{:,1:3}, virus.pdbid, destinationFolder);
        end
        
        function vmd(virus)
            fileName = virus.toXYZ;
            parentDir = ejovo.fn.getParentDir;
            if isau(virus)
                    destinationFolder = strcat(parentDir, '+ejovo/v_output/xyz/', virus.pdbid, '_au');
                else
                    destinationFolder = strcat(parentDir, '+ejovo/v_output/xyz/', virus.pdbid);
            end
            cd(destinationFolder)
            cmd = strcat("vmd ", fileName);
            system(cmd);
            cd(parentDir)
        end
        
        
        function summary(virus)
        %SUMMARY provides a visual summary of how the data is stored
        %for a virus.base
            %Print virus pdbid
            clc
            type = class(virus);
            type = strrep(type, 'ejovo.v.', '');
            fprintf('\n')
            disp('--------------------------------------------------------')
            disp(strcat({'Summary of virus with pdbid: '}, virus.pdbid))
            disp(char(strcat({'Number of atoms: '}, num2str(virus.atoms)))) %fuck MATLAB... I need to convert a cell to a string to a character just to print a god damn space...
            disp(char(strcat({'Virus type: '}, type)))
            disp('--------------------------------------------------------')
            fprintf('\n')
            %show first ten coordinates
            disp('First 10 coordinates')
            fprintf('\n')
            disp(virus.coords(1:10,:))            
        end        
        
        function virus = rotCoords2SAF(virus)
            XYZ = virus.coords{:,1:3};               %get coordinates
            XYZ = ejovo.saf.rot2saf(XYZ);                %rotate to saf
            virus = virus.setCoords(XYZ);               %reset the coords
            disp('Coordinates rotated to saf orientation')
            virus.orientation = "saf";
        end
        
        function virus = rotCoords2VDB(virus)
            XYZ = virus.coords{:,1:3};               %get coordinates
            XYZ = ejovo.saf.rot2vdb(XYZ);                %rotate to saf
            virus = virus.setCoords(XYZ);            %reset the coords
            disp('Coordinates rotated to vdb orientation')
            virus.orientation = "vdb";
        end
        
        function virus = changeCoordinates(virus)
            if strcmp(virus.orientation, 'vdb')
                virus = rotCoords2SAF(virus);
            else
                virus = rotCoords2VDB(virus);
            end
        end                
        
        function TF = isau(virus)
            c = class(virus);
            TF = or(contains(c, 'au'), contains(c, 'AU'));
        end
                
        %TOAU
        function au = toAU(virus)
            auAtoms = virus.atoms/60;
            au = ejovo.v.au(virus.pdbid, virus.coords{1:auAtoms,1:3}, virus.orientation);
            au.T = virus.T;
            au.app = virus.app;
        end
        
        %TOSAF
        function safVirus = toSAF(virus)
            safVirus = ejovo.v.safVirus(virus.pdbid, virus.coords{:,1:3}, virus.orientation);
            safVirus.T = virus.T;
            safVirus.app = virus.app;
        end
        
        %TOSIP
        function sipVirus = toSIP(virus)
            safVirus = virus.toSAF;
            sipVirus = safVirus.toSIP;
        end        
        
        function [admissible, values] = franken(virus)
            
                    
        end
        
    end
    
end
