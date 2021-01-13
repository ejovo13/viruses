classdef sipVirus < ejovo.v.safVirus
%A class that stores the coordinates and calculated normal modes of a virus.
%
%
%Class path: ejovo.virus
%
%   vPDBID = ejovo.virus('PDBID') is the simplest way to create a virus sipVirusect,
%   provided that there is a pdb coordinate file under the Coordinates
%   folder. Upon creation, a virus sipVirusect will load in any normal modes 
%   (if they exist) and calculate SAF radial displacements at each atom. 
%   Diagnostic messages while the virus is being instantiated should provide
%   the user with real-time information about a virus's creation.
%   When creating single viruses, it is CRUCIAL that you use the naming
%   convention vPDBID in order to avoid MATLAB confusing a single virus
%   sipVirusect and the +ejovo package. Consider:
%
%   v2ms2 = ejovo.virus('2ms2')
%   v1qbe = ejovo.virus('1qbe')
%
%   Upon instantiation, a virus will convert vdb coordinates and modes into
%   saf orientation in order to facilitate decomposition.
%
%   ejovo.VIRUS properties:
%
%       NAME - pdbid of a virus, used to look up and download coordinates
%       through the VIPER database
%
%       ORIENTATION - the orientation of a virus's coordinates. 'vdb'
%       indicates the <a
%       href="http://viperdb.scripps.edu/main.php">standard arrangement</a> found on the VIPER database.
%       'saf' refers to the orientation that SAFs are calculated in. That
%       is, with the 5-fold axis aligned with the positive z-axis. 'saf'
%       orientation can be visualized using the command PLOTSAF. Refer to
%       the <a href="https://teams.microsoft.com/l/channel/19%3adbe209ba4260495f98d1cf21aa32aa3a%40thread.tacv2/Code?groupId=4c83192e-2e3a-469f-8de7-a3c8352202b5&tenantId=e214b458-c456-45b4-961a-7852355f177a">notes page</a> under the code channel of our virus group to see a 
%       comparison of vdb and saf orienation. 
%       See also ejovo.SAF.PLOTSAF 
%
%       COORDS - a Nx6 table that stores cartesian and spherical
%       coordinates of a virus.
%
%       MODES - a table that stores Hammond and Rizzolo modes
%   
%   ejovo.VIRUS methods:
%
%       CHANGECOORDINATES - changes coordinate system between saf and vdb
%       orientation. Vdb orientation is the standard arrangement of viruses 
%       found on the VIPER database, where the 2-fold axes are found on the
%       x, y, and z axes. SAF orientation is the orientation that SAFs are
%       calculated in, where the 5-fold axis is aligned with the positive z
%       axis.
%       BUILDVSAF - calculates the SAF predicted radial displacement at
%       every single atom of the virus and then stores this information in
%       the property 'SAF'
%       ADDHARMONIC - adds the radial displacement of a specified SAF to
%       each atom in order to simulate a normal mode
%       ADDMULTIPLEHARMONICS - adds the radial displacement of a specified
%       SAF to each atom multiple times in order to visualize multiple
%       steps of a normal mode
%       MAKEMODE - creates an array of virus sipVirusects whose coordinates are
%       displaced according to the directions of a specified SAF. Used in
%       the creation of animations for 'artificial' SAF modes.
%       MAKEXYZ - takes an array of displaced viruses and outputs xyz files
%       to be loaded into vmd
%       NORMALIZEHARMONICS - normalizes the SAF radial displacement
%       calculated at each atom in order to facilitate normal mode
%       decomposition
%       PLOT - plots the virus in MATLAB
%       SIGMA - outputs the dot product of a single virus normal mode with
%       a single SAF. 
%       DECOMPOSEMODE - decomposes a single normal mode into all 13 SAFs
%       ANALYZEALLMODES - decomposes all Hammond and Rizzolo modes (if they
%       exist) into the 13 SAFs and then stores the result in the property
%       'decomp'
%       INSTALLMODES - searches in the modes folder for both Hammond and
%       Rizzolo modes and then stores them in the property 'modes'
%       STOEXCEL - creates and opens a text file containing the
%       decomposition weights for each normal mode in order to easily copy
%       and paste the data into excel (if you desire)
%       SHOWDECOMP - displays the decomposition table to the console
%       EXTRACTAU - extracts the assymetric unit of the virus, which
%       represents the first 1/60th atoms. The AU is much more useful for
%       normal mode decomposition as significant numeric error is
%       introduced when working with a full virus sipVirusect
%
%


    properties 
        Hammond
        Rizzolo
        NMFF
    end   
    
    properties %(Hidden)
        modeOrientation
    end
    
    properties (Hidden)    
        numRModes
        numHModes
        existH 
        existR  
    end
        
    methods            
        %Normal virus constructor        
        %sipVirus = sipVirus(pdbid, XYZ, orientation, SAF, Hmodes, Rmodes)
        function sipVirus = sipVirus(varargin) 
            sipVirus = sipVirus@ejovo.v.safVirus(varargin{:}); 
            n = length(varargin);
            if n < 5
                %adds modes (if they exist)
                sipVirus = installModes(sipVirus);            
                sipVirus = normalizeModes(sipVirus); 
                if ~strcmp(sipVirus.orientation, sipVirus.modeOrientation)
                    sipVirus = sipVirus.changeModes;
                end                
            else
                sipVirus.modeOrientation = varargin{3};
                sipVirus.numHModes = length(varargin{5});
                sipVirus.numRModes = length(varargin{6});
                if sipVirus.numHModes == 0
                    sipVirus.existH = false;
                else
                    sipVirus.existH = true;
                end
                if sipVirus.numRModes == 0
                    sipVirus.existR = false;
                else
                    sipVirus.existR = true;
                end
                sipVirus = sipVirus.setModes(varargin{5}, varargin{6});  
            end            
        end 
        
              
        function sipVirus = changeOrientation(sipVirus)
        %CHANGECOORDINATES Toggles the coordinates between saf and vdb orientation
            sipVirus = changeOrientation@ejovo.v.safVirus(sipVirus);
            sipVirus = changeModes(sipVirus);
        end
        
        %NORMALIZMODES normalizes the calculated eigenmodes and stores
        %them in the cell property MODES
        function sipVirus = normalizeModes(sipVirus)
            for ii = 1:length(sipVirus.Hammond)
                dp = sum(dot(sipVirus.Hammond{ii}, sipVirus.Hammond{ii}));
                sipVirus.Hammond{ii} = sipVirus.Hammond{ii}/sqrt(dp);
                sum(dot(sipVirus.Hammond{ii}, sipVirus.Hammond{ii}));
            end
            for ii = 1:length(sipVirus.Rizzolo)
                dp = sum(dot(sipVirus.Rizzolo{ii}, sipVirus.Rizzolo{ii}));
                sipVirus.Rizzolo{ii} = sipVirus.Rizzolo{ii}/sqrt(dp);
                sum(dot(sipVirus.Rizzolo{ii}, sipVirus.Rizzolo{ii}));
            end
            disp("Modes normalized");
        end             
        
        %INSTALLMODES creates a cell of normalized modes that can be used
        %during the initiliazing step.
        function sipVirus = installModes(sipVirus, oldModesDirectory, newModesDirectory)
            %nAtoms = height(sipVirus.coords);
            startDir = pwd;
            sipVirus.convertModesToText;
            hModes = cell(0, 1);
            rModes = cell(0, 1);
            range = strcat('1:', num2str(sipVirus.atoms));
            if nargin == 1
                %find the modes
                oldPathName = strcat('+ejovo/+v/modes/hammond/', sipVirus.pdbid);
                new500PathName = strcat('+ejovo/+v/modes/rizzolo/', sipVirus.pdbid, '_aa500');
                new300PathName = strcat('+ejovo/+v/modes/rizzolo/', sipVirus.pdbid, '_aa300');
                disp(strcat({'Hammond mode directory is: '}, oldPathName));
                disp(strcat({'Rizzolo mode directories are: '}, new500PathName, {' and '}, new300PathName))
                fprintf('\n');
            else
                %find the modes
                oldPathName = strcat(oldModesDirectory, sipVirus.pdbid);
                new500PathName = strcat(newModesDirectory, sipVirus.pdbid, '_aa500');
                new300PathName = strcat(newModesDirectory, sipVirus.pdbid, '_aa300');
                disp(strcat({'Hammond mode directory is: '}, oldPathName));
                disp(strcat({'Rizzolo mode directories are: '}, new500PathName, {' and '}, new300PathName))
                fprintf('\n');
            end
            
            %pull each mode and place it into a cell, going only for as
            %many files are there are
            tic
            modeNum = 1;
            %Loads the old modes, if they exist
            mode = strcat(oldPathName, '/', 'modes1.txt');
            ejovo.fn.cd2parent;
            if exist(mode, 'file')
                disp('Hammond modes exist - building now...')
                om_exist = true;                
            else
                om_exist = false;
                disp('Hammond modes not found')
                fprintf('\n');
            end
            while exist(mode, 'file')==2
                thisMode = readmatrix(mode, 'Range', range);
                hModes{modeNum} = thisMode;
                modeNum = modeNum + 1;
                mode = strcat(oldPathName, '/', 'modes', int2str(modeNum), '.txt');
            end
            if om_exist
            disp([int2str(length(hModes)) ' Hammond modes successfully loaded']);
            toc
            fprintf('\n');
            end
            modeNum = 1;
            %Loads the new 500 modes, if they exist
            mode = strcat(new500PathName, '/', 'modes1.txt');
            tic
            if exist(mode, 'file')
                disp("Rizzolo 500 modes exist, importing now...")
                nm5_exist = true;
            else 
                nm5_exist = false;
            end
            while exist(mode, 'file')==2
                thisMode = readmatrix(mode, 'Range', range);
                rModes{modeNum} = thisMode;
                modeNum = modeNum + 1;
                mode = strcat(new500PathName, '/', 'modes', int2str(modeNum), '.txt');
            end
            %Loads the new 300 modes, if they exist
            mode = strcat(new300PathName, '/', 'modes1.txt');
            if exist(mode, 'file')
                disp("Rizzolo 300 modes exist, importing now...")
                nm3_exist = true;
            else 
                nm3_exist = false;
            end
            while exist(mode, 'file')
                thisMode = readmatrix(mode, 'Range', range);
                rModes{modeNum} = thisMode;
                modeNum = modeNum + 1;
                mode = strcat(new300PathName, '/', 'modes', int2str(modeNum), '.txt');
            end
            if or(nm5_exist, nm3_exist)
                disp([int2str(length(rModes)) ' Rizzolo modes successfully loaded']);
                toc
                fprintf('\n');
            else
                disp('Rizzolo modes not found');
                fprintf('\n');
            end            
            sipVirus.existH = om_exist;
            sipVirus.existR = or(nm5_exist, nm3_exist);
            sipVirus.numHModes = length(hModes);
            sipVirus.numRModes = length(rModes);
            sipVirus = setModes(sipVirus, hModes, rModes); 
            sipVirus.modeOrientation = "vdb";
            cd(startDir);
        end
        
        function sipVirus = changeModes(sipVirus)
            if strcmp(sipVirus.modeOrientation, "vdb")
                sipVirus = rotMod2saf(sipVirus);
            else
                sipVirus = rotMod2vdb(sipVirus);
            end
        end        
        
        %ROTMOD2SAF rotates all of a viruses modes to SAF allignment
        function sipVirus = rotMod2saf(sipVirus)            
            for ii = 1:sipVirus.numHModes
                sipVirus.Hammond{ii} = ejovo.saf.rot2saf(sipVirus.Hammond{ii});
            end            
            for ii = 1:sipVirus.numRModes
                sipVirus.Rizzolo{ii} = ejovo.saf.rot2saf(sipVirus.Rizzolo{ii});
            end   
            sipVirus.modeOrientation = "saf";
            disp('Modes rotated to saf orientation')
            fprintf('\n');
        end
        
        %ROTMOD2VDB rotates all of a viruses modes to VDB allignment
        function sipVirus = rotMod2vdb(sipVirus)
            
            for ii = 1:sipVirus.numHModes
                sipVirus.Hammond{ii} = ejovo.saf.rot2vdb(sipVirus.Hammond{ii});
            end
            for ii = 1:sipVirus.numRModes
                sipVirus.Rizzolo{ii} = ejovo.saf.rot2vdb(sipVirus.Rizzolo{ii});
            end                        
            sipVirus.modeOrientation = "vdb";            
            disp('Modes rotated to vdb orientation')
            fprintf('\n');            
        end
        
        function sipVirus = setModes(sipVirus, hModes, rModes)
        %setModes - sets the modes of a virus
            if sipVirus.existH 
                sipVirus.Hammond = hModes;
            end
            if sipVirus.existR
                sipVirus.Rizzolo = rModes;
            end
        end
        
        
        function summary(sipVirus)
        %SUMMARY provides a visual summary of how the data is stored
        %for a ejovo.v.virus
            summary@ejovo.v.safVirus(sipVirus)  
            disp(char(strcat(num2str(sipVirus.numHModes), {' Hammond modes installed.'})))
            disp(char(strcat(num2str(sipVirus.numRModes), {' Rizzolo modes installed.'})))
        end 
        
        function convertModesToText(sipVirus)
            startDir = pwd;
            modesDir = cell(1,3);
            modesDir{1} = strcat('+ejovo/+v/modes/hammond/', sipVirus.pdbid);
            modesDir{2} = strcat('+ejovo/+v/modes/rizzolo/', sipVirus.pdbid, '_aa500');
            modesDir{3} = strcat('+ejovo/+v/modes/rizzolo/', sipVirus.pdbid, '_aa300');
            count = 0;
            nFiles = 0;
            ejovo.fn.cd2parent;
            for ii = 1:3
                if exist(modesDir{ii}, 'file')                    
                    cd(modesDir{ii})
                    d = dir;
                    nFiles = length(d) - 2;
                end
                for jj = 1:nFiles
                    file2convert = strcat('modes.', num2str(jj));
                    txtConversion = strcat('modes', num2str(jj), '.txt');
                    if exist(file2convert, 'file')
                        movefile(file2convert, txtConversion);
                        count = count + 1;
                    end
                end
                cd(startDir);
            end
            disp(strcat(char(int2str(count)), ' mode(s) converted to .txt files'))
            cd(startDir);
        end
        
        %TOAU
        function sipAU = toAU(sipVirus)
            auAtoms = sipVirus.atoms/60;
            %reduce the hammond modes 
            hModes = sipVirus.Hammond;
            for ii = 1:sipVirus.numHModes
                thisMode = hModes{ii};
                thisMode = thisMode(1:auAtoms,:);
                hModes{ii} = thisMode;
            end
            %reduce the rizzolo modes
            rModes = sipVirus.Rizzolo;
            for jj = 1:sipVirus.numRModes
                thisMode = rModes{jj};
                thisMode = thisMode(1:auAtoms,:);
                rModes{jj} = thisMode;
            end
            %call sipAU constructor
            sipAU = ejovo.v.sipAU(sipVirus.pdbid, sipVirus.coords{1:auAtoms, 1:3}, sipVirus.orientation, sipVirus.SAF{1:auAtoms,:}, hModes, rModes);
            sipAU.T = sipVirus.T;
            sipAU.app = sipVirus.app;
        end        
        
        %TOBASE        
        function virus = toBase(sipVirus)
            virus = ejovo.v.virus(sipVirus.pdbid, sipVirus.coords{:,1:3}, sipVirus.orientation);
            virus.T = sipVirus.T;
            virus.app = sipVirus.app;
        end       
        
        %TOSAF
        function safVirus = toSAF(sipVirus)
            safVirus = ejovo.v.safVirus(sipVirus.pdbid, sipVirus.coords{:,1:3}, sipVirus.orientation, sipVirus.SAF{:,:});
            safVirus.T = sipVirus.T;
            safVirus.app = sipVirus.app;
        end
        
        function sipVirus = fixModes(sipVirus)
            %set true mode number
            nH = 0;
            nR = 0;
            hcell = sipVirus.modes.Hammond';
            rcell = sipVirus.modes.Rizzolo';
            lenH = length(hcell);
            lenR = length(rcell);
            for ii = 1:lenH
                if ~isempty(hcell{ii})
                    nH = nH + 1;
                end
            end
            for jj = 1:lenR
                if ~isempty(rcell{jj})
                    nR = nR + 1;
                end
            end
            
            realH = hcell(1:nH);
            realR = rcell(1:nR);
            sipVirus.numHModes = nH;
            sipVirus.numRModes = nR;
            if sipVirus.numHModes == 0
                sipVirus.existH = 0;
                sipVirus.Hammond = [];
            else
                sipVirus.existH = 1;
                sipVirus.Hammond = realH;
            end
            if sipVirus.numRModes == 0
                sipVirus.existR = 0;
                sipVirus.Rizzolo = [];
            else
                sipVirus.existR = 1;
                sipVirus.Rizzolo = realR;
            end
        end
        
        
        function movie = makeHMode(sipVirus, modeNum, angstromsPerFrame, numSteps)
            if nargin < 4                 
                numSteps = 10;  
                if nargin < 3                  
                    angstromsPerFrame = 1;
                end
            end
            movie = ejovo.v.movieMaker.makeHMovie(sipVirus, modeNum, angstromsPerFrame, numSteps);
        end
        
        function movie = makeRMode(sipVirus, modeNum, angstromsPerFrame, numSteps)
            if nargin < 4                 
                numSteps = 10;  
                if nargin < 3                  
                    angstromsPerFrame = 1;
                end
            end
            movie = ejovo.v.movieMaker.makeRMovie(sipVirus, modeNum, angstromsPerFrame, numSteps);
        end
        
        
        
        
    end
end
