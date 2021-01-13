classdef movie
%A class to store the frames of a virus mode movie
    
    properties
        frames
        pdbid
        mode
        totalDisplacement
        numFrames
        orientation
    end    
    
    properties (Hidden)
        fullDirectory
        modeType
        modeNum
    end
        
    methods
        
        function movie = movie(frames, virus, modeType, modeNum, angstromPerFrame)
            movie.frames = frames;
            movie.numFrames = length(frames);
            movie.pdbid = virus.pdbid;
            movie.modeType = modeType;
            movie.modeNum = modeNum;
            movie.mode = char([modeType num2str(modeNum)]);
            movie.totalDisplacement = angstromPerFrame*(movie.numFrames/2);  
            parent = ejovo.fn.getParentDir;
            movie.orientation = virus.orientation;
            if isau(virus)
                mDir = strcat('+ejovo/v_output/movies/', virus.pdbid, '_au/', modeType, int2str(modeNum), '_', num2str(movie.totalDisplacement), 'A');
            else
                mDir = strcat('+ejovo/v_output/movies/', virus.pdbid, '/', modeType, int2str(modeNum), '_', num2str(movie.totalDisplacement), 'A');
            end
            movie.fullDirectory = strcat(parent, mDir);
        end
        
        function plot(movie)
        %SHOWMODE - creates an animation in matlab of an SAF mode            
            figure
            XYZ = movie.frames.XYZ;
            s = plot3(XYZ(:,1), XYZ(:,2), XYZ(:,3), '.');
            axis off manual
            
            while size(findobj(s))>0
                for ii = 1:movie.numFrames    
                    if ~(size(findobj(s))>0)
                        break
                    end
                    s.XData = movie.frames(ii).XYZ(:,1);
                    s.YData = movie.frames(ii).XYZ(:,2);
                    s.ZData = movie.frames(ii).XYZ(:,3);                                         
                    pause(.02)
                end        
            end
            
        end
        
        function vmdcommand = toXYZ(movie, frameIndices)
            if nargin == 1
                frameIndices = 1:movie.numFrames;
            end
            vmdcommand = '';
            for ii = frameIndices
                frameName = strcat(movie.pdbid, '.', num2str(movie.modeNum), '.', num2str(ii));
                outputName = ejovo.fn.toXYZ(movie.frames(ii).XYZ, frameName, movie.fullDirectory);
                outputName = char(outputName);
                vmdcommand = [vmdcommand ' ' outputName]; %#ok<AGROW>
            end
            vmdcommand = strcat(vmdcommand);
            disp(strcat("Movie made in folder: ", movie.fullDirectory))
        end
        
        function toTXT(movie, frameIndices)
            if nargin == 1
                frameIndices = 1:movie.numFrames;
            end
            vmdcommand = '';
            for ii = frameIndices
                frameName = strcat(movie.pdbid, '.', num2str(movie.modeNum), '.', num2str(ii));
                outputName = ejovo.fn.toTXT(movie.frames(ii).XYZ, frameName, movie.fullDirectory);
                outputName = char(outputName);
                vmdcommand = [vmdcommand ' ' outputName]; %#ok<AGROW>
            end
            vmdcommand = strcat(vmdcommand);
            disp(strcat("Movie made in folder: ", movie.fullDirectory))
        end      
        
        function toBatch(movie)
            pkgDir = ejovo.fn.getPkgDir;
            endfolder = strcat(pkgDir, 'output/windowsBatchFiles/', movie.pdbid);
            if ~exist(endfolder, 'dir')
                mkdir(endfolder);
                disp('Destination folder created')
            end    
            name = strcat(movie.pdbid, '_', movie.mode, '_', num2str(movie.totalDisplacement), 'A', '.bat');   
            command = movie.toXYZ;
            if ispc
                disp('Using pc, creating batch file now')
                fileID = fopen(name, 'w');
                fprintf(fileID, 'ECHO OFF\n');
                xyzWin = strrep(movie.fullDirectory, '\', '/');
                xyzWin = strrep(xyzWin, '/', '\\');                
                fprintf(fileID, char(strcat({'cd '}, xyzWin, {'\n'})));    
                fprintf(fileID,['vmd -f', command]);   
                fclose(fileID);   
                disp([movie.mode ' batch file created']);
                movefile(name, endfolder)
            end
        end
        
        function movie = toSAF(movie)
            nFrames = length(movie.frames);
            for ii = 1:nFrames
                oldXYZ = movie.frames(ii).XYZ;
                newXYZ = ejovo.saf.rot2saf(oldXYZ);
                movie.frames(ii).XYZ = newXYZ;
            end
            movie.orientation = 'saf';
        end
        
        function movie = toVDB(movie)
            nFrames = length(movie.frames);
            for ii = 1:nFrames
                oldXYZ = movie.frames(ii).XYZ;
                newXYZ = ejovo.saf.rot2vdb(oldXYZ);
                movie.frames(ii).XYZ = newXYZ;
            end
            movie.orientation = 'vdb';
        end
        
        function movie = changeOrientation(movie)
            if strcmp(movie.orientation, 'saf')
                movie = movie.toVDB;
            else
                movie = movie.toSAF;
            end           
        end
    end
end    

        
        
        
        
        