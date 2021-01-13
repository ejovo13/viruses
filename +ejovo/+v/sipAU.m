classdef sipAU < ejovo.v.sipVirus
    
    properties
        decomp   
    end        
    
    methods
        %au = au(pdbid, XYZ, orientation)
        function sipAU = sipAU(varargin)
            sipAU = sipAU@ejovo.v.sipVirus(varargin{:});
            sipAU = sipAU.analyzeAllModes;
        end        
        
        %TOEXCEL creates excel files that contains the decomposition of all modes 
        function toExcel(sipAU)            
            %Create and open text document for old modes         
            if sipAU.existH
                folderName = strcat('+ejovo/v.output/excel/', sipAU.pdbid);
                C = ejovo.fn.table2fullcell(sipAU.decomp.Hammond);
                fileName = strcat(sipAU.pdbid, '_Hammond.xlsx');
                writecell(C, fileName);        
                if ~exist(folderName, 'file')
                    mkdir(folderName)
                end
                movefile(fileName, folderName)
                newFileName = strcat(folderName, '/', fileName);   
                open(newFileName);
            end
            %Create and open text document for new modes          
            if sipAU.existR
                folderName = strcat('+ejovo/v.output/excel/', sipAU.pdbid);
                C = ejovo.fn.table2fullcell(sipAU.decomp.Rizzolo);
                fileName = strcat(sipAU.pdbid, '_Rizzolo.xlsx');
                writecell(C, fileName);  
                if ~exist(folderName, 'file')
                    mkdir(folderName)
                end
                movefile(fileName, folderName)
                newFileName = strcat(folderName, '/', fileName);   
                open(newFileName);
            end
            fclose('all');
        end     
        
        function showDecomp(sipAU)
            h = sipAU.decomp.Hammond;
            r = sipAU.decomp.Rizzolo;
            if sipAU.existH
                fprintf('\n')
                disp(strcat({'Hammond mode decomposition for '}, sipAU.pdbid, ':'))
                fprintf('\n')
                disp(h)
            end
            if sipAU.existR
                fprintf('\n')
                disp(strcat({'Rizzolo mode decomposition for '}, sipAU.pdbid, ':'))
                fprintf('\n')
                disp(r)
            end
        end
        
        function sipAU = extractSigma(sipAU)
        %extractSigma - decomposes a virus normal modes and writes the results to an excel file
            sipAU = analyzeAllModes(sipAU);
            sToExcel(sipAU);
        end             
        
        function sipAU = setDecomp(sipAU, S_O, S_N)
        %SETDECOMP - sets the decomposition table of a virus
            S = S_N;            
            n = length(S);
            type = "double";
            repTypes = repmat(type, [1, n]);
            varNames = cell(1, n);
            Tn = table('Size', [13, n], 'VariableTypes', repTypes);
            if n > 0                
                for ii = 1:n
                    varNames{ii} = strcat('M', num2str(ii));
                    Tn{:,ii} = S{ii}';
                end
            end
            Tn.Properties.VariableNames = varNames;
            Tn.Properties.RowNames = {'SAF0','SAF6', 'SAF10', 'SAF12', 'SAF16', 'SAF18', 'SAF20', 'SAF22', 'SAF24', 'SAF26', 'SAF28', 'SAF30', 'SAF31'};


            S = S_O;
            n = length(S);
            type = "double";
            repTypes = repmat(type, [1, n]);
            varNames = cell(1, n);
            To = table('Size', [13, n], 'VariableTypes', repTypes);
            if n > 0                
                for ii = 1:n
                    varNames{ii} = strcat('M', num2str(ii));
                    To{:,ii} = S{ii}';
                end
            end
            To.Properties.VariableNames = varNames;
            To.Properties.RowNames = {'SAF0','SAF6', 'SAF10', 'SAF12', 'SAF16', 'SAF18', 'SAF20', 'SAF22', 'SAF24', 'SAF26', 'SAF28', 'SAF30', 'SAF31'};

            sipAU.decomp = table(To, Tn, 'VariableNames', {'Hammond', 'Rizzolo'}, 'RowNames', {'SAF0','SAF6', 'SAF10', 'SAF12', 'SAF16', 'SAF18', 'SAF20', 'SAF22', 'SAF24', 'SAF26', 'SAF28', 'SAF30', 'SAF31'});
        end
        
        %SIGMA outputs the dot product value of a single viruses mode with
        %a single saf
        function s = sigma(sipAU, mode, safDegree, typeOfMode)
            safN = sipAU.normalizeSAF(safDegree);
            safcart = sipAU.saf2cart(safN);
            if strcmp(typeOfMode, 'old')
                m = sipAU.Hammond{mode};
                dp = dot(m,safcart);
            end
            if strcmp(typeOfMode, 'new')
                m = sipAU.Rizzolo{mode};
                dp = dot(m,safcart);
            end
            s = sum(dp);
        end
        
        %DECOMPOSEMODE takes the dot product of a mode and all normalized SAFs in order to
        %determine the amount that each SAF contributes to the overall
        %motion
        function s = decomposeMode(sipAU, mode, typeOfMode)
            L = [0, 6, 10, 12, 16, 18, 20, 22, 24, 26, 28, 30, 31];
            iterations = width(sipAU.SAF);
            s = zeros(1, iterations);            
            for ii = 1:iterations
                s(ii) = sigma(sipAU, mode, L(ii), typeOfMode);
            end
            %maxValue = max(abs(s));
        end
        
        %ANALYZEALLMODES decomposes all of a virus' modes
        function sipAU = analyzeAllModes(sipAU)
            h = sipAU.numHModes;
            r = sipAU.numRModes;
            S_O = cell(h, 1);
            S_N = cell(r, 1);
            if strcmp(sipAU.orientation, 'vdb')
                sipAU = sipAU.changeOrientation;
            end            
            sipAU = sipAU.buildVSAF;
            if sipAU.existH
                disp('Hammond modes are being processed');
                for ii = 1:h
                    S_O{ii} = decomposeMode(sipAU, ii, 'old');
                end
            end            
            if sipAU.existR
                disp('Rizzolo modes are being processed');
                for ii = 1:r
                    S_N{ii} = decomposeMode(sipAU, ii, 'new');
                end
            end                  
            sipAU = setDecomp(sipAU, S_O, S_N);
        end
        
        function summary(sipAU)
            summary@ejovo.v.sipVirus(sipAU);            
            sipAU.showDecomp;
        end
        
        %TOFULL - future realease   
        
        %TOBASE        
        function au = toBase(sipAU)
            au = ejovo.v.au(sipAU.pdbid, sipAU.coords{:,1:3}, sipAU.orientation);
            au.T = sipAU.T;
            au.app = sipAU.app;
        end       
        
        %TOSAF
        function safAU = toSAF(sipAU)
            safAU = ejovo.v.safAU(sipAU.pdbid, sipAU.coords{:,1:3}, sipAU.orientation, sipAU.SAF{:,:});
            safAU.T = sipAU.T;
            safAU.app = sipAU.app;
        end
        
    end
end