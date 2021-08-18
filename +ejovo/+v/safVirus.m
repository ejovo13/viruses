classdef safVirus < ejovo.v.virus
%A class that stores the coordinates and SAFs of a virus.
%
%
%Class path: ejovo.v.safVirus
%
%   vPDBID = ejovo.v.safVirus('PDBID') is the simplest way to create a virus safVirusect,
%   provided that there is a pdb coordinate file under the Coordinates
%   folder. Upon creation, a virus safVirusect will load in any normal modes
%   (if they exist) and calculate SAF radial displacements at each atom.
%   Diagnostic messages while the virus is being instantiated should provide
%   the user with real-time information about a virus's creation.
%   When creating single viruses, it is CRUCIAL that you use the naming
%   convention vPDBID in order to avoid MATLAB confusing a single virus
%   safVirusect and the +v package. Consider:
%
%   v2ms2 = ejovo.v.safVirus('2ms2')
%   v1qbe = ejovo.v.safVirus('1qbe')
%
%   Upon instantiation, a virus will convert vdb coordinates and modes into
%   saf orientation in order to facilitate decomposition.
%
%   ejovo.v.safVirus properties:
%
%       PDBID - pdbid of a virus, used to look up and download coordinates
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
%   ejovo.v.safVirus methods:
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
%       MAKEMODE - creates an array of virus safVirusects whose coordinates are
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
%       introduced when working with a full virus safVirusect
%
%


    properties
        SAF
    end

    properties %(Hidden)
        safOrientation
        frame
    end

    methods

        %Normal virus constructor
        %safVirus = safVirus(pdbid, XYZ, orientation, SAF)
        function safVirus = safVirus(varargin)
            safVirus = safVirus@ejovo.v.virus(varargin{:});
            n = length(varargin);
            if n < 4
                %Builds virus SAFs.
                disp(['Attempting to build SAFs at all ' int2str(safVirus.atoms) ' atoms']);
                safVirus = safVirus.buildVSAF;
                disp('Virus SAFs succesfull constructed');
                fprintf('\n');
            else
                safVirus = safVirus.setSAF(varargin{4});
                safVirus.safOrientation = varargin{3};
                disp('Virus SAFs properly transferred')
            end
            %normalizes the SAFs
            %safVirus = safVirus.normalizeSAFs;
            safVirus.frame = 0;
            if ~strcmp(safVirus.safOrientation, safVirus.orientation)
                safVirus = safVirus.changeSAF;
            end
            if strcmp(safVirus.orientation, 'saf')
                safVirus = safVirus.changeCoordinates;
                safVirus = safVirus.changeSAF;
            end
            fprintf('\n');
        end

        function safVirus = changeOrientation(safVirus)
        %CHANGECOORDINATES Toggles the coordinates between saf and vdb orientation
             safVirus = safVirus.changeOrientation@ejovo.v.virus;
             safVirus = safVirus.changeSAF;
        end

        function safVirus = buildVSAF(safVirus)
        %BUILDVSAF builds all the SAFs for a specific virus
            tic
            if strcmp(safVirus.orientation, 'vdb')
                safVirus = safVirus.changeCoordinates;
                disp('Had to change virus orientation to build SAFs')
            end
            vsaf = zeros(safVirus.atoms, 13);
            for ii = 1:13
                vsaf(:,ii) = safVirus.calcSAF(safVirus.DEGREE(ii));
            end
            safVirus = safVirus.setSAF(vsaf);
            toc
            safVirus.safOrientation = safVirus.orientation;
        end

        function SAFN = normalizeSAFs(safVirus)
        %NORMALIZESAFS Normalize all SAFs
            nSAF = length(safVirus.DEGREE);
            SAFN = cell(1, nSAF);
            for ii = 1:nSAF
                SAFN{:} = normalizeSAF(safVirus, safVirus.DEGREE(ii));
                %safVirus.SAF{:,ii} = normSAF;
            end
            disp('SAFs normalized');
        end

        function safN = normalizeSAF(safVirus, degree)
            index = safVirus.DEGREE == degree;
            thisSAF = safVirus.SAF{:,index};
            norm = sum(dot(thisSAF,thisSAF));
            safN =  thisSAF/sqrt(norm);
        end

        function safCart = saf2cart(safVirus, safN)
                [x,y,z] = sph2cart(safVirus.coords.TH, safVirus.coords.PH, safN);
                safCart = [x y z];
        end




        function safVirus = setSAF(safVirus, SAF)
        %SETSAF - sets the SAF table of a virus.
            varType = "double";
            repVarType = repmat(varType, [1, 13]);
            safTable = table('Size', [safVirus.atoms, 13], 'VariableTypes', repVarType, 'VariableNames', {'SAF0','SAF6', 'SAF10', 'SAF12', 'SAF16', 'SAF18', 'SAF20', 'SAF22', 'SAF24', 'SAF26', 'SAF28', 'SAF30', 'SAF31'});
            for ii = 1:13
                safTable{:,ii} = SAF(:,ii);
            end
            safVirus.SAF = safTable;
        end

        function VSAF = calcSAF(safVirus, degree)
        %VSAF - Build an SAF at every atom
            VSAF = ejovo.saf.buildSAF(degree, pi/2 - safVirus.coords.PH, safVirus.coords.TH);
        end

        function summary(safVirus)
        %SUMMARY provides a visual summary of how the data is stored
        %for a ejovo.v.safVirus
            safVirus.summary@ejovo.v.virus
            %show first ten SAFs
            disp('First 10 SAF displacements')
            fprintf('\n')
            disp(safVirus.SAF(1:10,:))
        end

        function safVirus = changeSAF(safVirus)
        %CHANGESAF Toggle the saf radial values between 'saf' and 'vdb' orientation
            if strcmp(safVirus.safOrientation, "vdb")
                safVirus = rotSAF2saf(safVirus);
            else
                safVirus = rotSAF2vdb(safVirus);
            end
        end


        %ROTSAF2SAF rotates all of a viruses SAFs to SAF allignment
        function safVirus = rotSAF2saf(safVirus)
            for ii = 1:13
                %convert radial component to cart
                [X, Y, Z] = sph2cart(safVirus.coords.TH, safVirus.coords.PH, safVirus.SAF{:,ii});
                XYZ = [X Y Z];
                XYZsaf = ejovo.saf.rot2saf(XYZ);
                [~, ~, r] = cart2sph(XYZsaf(:,1), XYZsaf(:,2), XYZsaf(:,3));
                safVirus.SAF{:,ii} = r;
            end
            safVirus.safOrientation = "saf";
            disp('SAFs rotated back to saf orientation')
            fprintf('\n');
        end

        %ROTSAF2VDB rotates all of a viruses modes to VDB allignment
        function safVirus = rotSAF2vdb(safVirus)
            for ii = 1:13
                %convert radial component to cart
                [X, Y, Z] = sph2cart(safVirus.coords.TH, safVirus.coords.PH, safVirus.SAF{:,ii});
                XYZ = [X Y Z];
                XYZsaf = ejovo.saf.rot2vdb(XYZ);
                [~, ~, r] = cart2sph(XYZsaf(:,1), XYZsaf(:,2), XYZsaf(:,3));
                safVirus.SAF{:,ii} = r;
            end
            safVirus.safOrientation = "vdb";
            disp('SAFs rotated to vdb orientation')
            fprintf('\n');
        end


        %TOAU
        function safAU = toAU(safVirus)
            auAtoms = safVirus.atoms/60;
            safAU = ejovo.v.safAU(safVirus.pdbid, safVirus.coords{1:auAtoms, 1:3}, safVirus.orientation, safVirus.SAF{1:auAtoms,:});
            safAU.T = safVirus.T;
            safAU.app = safVirus.app;
        end

        %TOBASE
        function virus = toBase(safVirus)
            virus = ejovo.v.virus(safVirus.pdbid, safVirus.coords{:,1:3}, safVirus.orientation);
            virus.T = safVirus.T;
            virus.app = safVirus.app;
        end

        %TOSIP
        function sipVirus = toSIP(safVirus)
            sipVirus = ejovo.v.sipVirus(safVirus.pdbid, safVirus.coords{:,1:3}, safVirus.orientation, safVirus.SAF{:,:});
            sipVirus.T = safVirus.T;
            sipVirus.app = safVirus.app;
        end


        function movie = makeSAFMode(safVirus, modeNum, angstromsPerFrame, numSteps)
            if nargin < 4
                numSteps = 10;
                if nargin < 3
                    angstromsPerFrame = 1;
                end
            end
            movie = ejovo.v.movieMaker.makeSAFMovie(safVirus, modeNum, angstromsPerFrame, numSteps);
        end

        function SAF = getSAF(safVirus, safDegree)
        % Get SAF radial displacement values for degree = safDegree

            SAF = safVirus.SAF{:,safDegree==safVirus.DEGREE};

        end

        function SAFN = getSAFN(safVirus, safDegree)
        % Get normalized SAF

            SAFN = safVirus.normalizeSAF(safDegree);

        end

        function safcart = getSAFcart(safVirus, safDegree)

            safcart = safVirus.saf2cart(safVirus.getSAFN(safDegree));

        end

    end
end
