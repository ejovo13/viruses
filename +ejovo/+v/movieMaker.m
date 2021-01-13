classdef movieMaker
%MOVIEMAKER - Handles the creation of vmd movies 

    properties
        coords
        mode
        radial   
        scale
        scaledMode
        angstromPerFrame
    end
    
    methods 
        
        function MM = movieMaker(coords, mode, angstromPerFrame)            
            MM.coords = coords;
            MM.mode = mode;
            MM.angstromPerFrame = angstromPerFrame;
            [~, n] = size(mode);
            if n == 1
                MM.radial = true;
            else
                MM.radial = false;
            end
            MM = MM.findScalingFactor;
            MM = MM.convertMode2XYZ;
            MM = MM.scaleMode;
        end   
        
        function MM = findScalingFactor(MM)
            [~, n] = size(MM.mode);
            if n == 1
                radialMode = true;
            else
                radialMode = false;
            end
            if radialMode
                maxDisplacement = max(MM.mode);
            else
                modeSquared = MM.mode.*MM.mode;
                displacement = sqrt(modeSquared(:,1) + modeSquared(:, 2) + modeSquared(:,3));
                maxDisplacement = max(displacement);
            end
            MM.scale = MM.angstromPerFrame/maxDisplacement;
        end
        
        function MM = convertMode2XYZ(MM)
            if MM.radial
                [X, Y, Z] = sph2cart(MM.coords(:,4), MM.coords(:,5), MM.mode);
                MM.mode = [X Y Z];
                MM.radial = false;
            end
        end
        
        function MM = scaleMode(MM)
            MM.scaledMode = MM.mode * MM.scale;
        end       
        
        function frames = makeLoop(MM, numSteps)
            numFrames = numSteps*2;
            frames = ejovo.v.virusFrame.empty(0, numFrames);
            frames(1) = ejovo.v.virusFrame(MM.coords(:,1:3), 0);
            
            for ii = 1:numSteps
                nextPos = frames(ii).XYZ + MM.scaledMode;
                frames(ii + 1) = ejovo.v.virusFrame(nextPos, ii);
            end
            reverseFrames = flip(2:numSteps);
            frames = [frames, frames(reverseFrames)];            
        end
        
        function movie = makeMovie(MM, pdbid, modeType, modeNum, angstromPerFrame, numSteps)
            frames = MM.makeLoop(numSteps);
            movie = ejovo.v.movie(frames, pdbid, modeType, modeNum, angstromPerFrame);
        end
        
        
        
        
        
        
    end
    
    methods (Static)
        
        function SAFMovie = makeSAFMovie(safVirus, modeNum, angstromPerFrame, numSteps)
            index = safVirus.DEGREE == modeNum;
            MM = ejovo.v.movieMaker(safVirus.coords{:,:}, safVirus.SAF{:,index}, angstromPerFrame);
            SAFMovie = MM.makeMovie(safVirus, 'SAF', modeNum, angstromPerFrame, numSteps);
        end
        
        function SAFMovie = makeHMovie(sipVirus, modeNum, angstromPerFrame, numSteps)
            MM = ejovo.v.movieMaker(sipVirus.coords{:,:}, sipVirus.Hammond{modeNum}, angstromPerFrame);
            SAFMovie = MM.makeMovie(sipVirus, 'H', modeNum, angstromPerFrame, numSteps);
        end
        
        function SAFMovie = makeRMovie(sipVirus, modeNum, angstromPerFrame, numSteps)
            MM = ejovo.v.movieMaker(sipVirus.coords{:,:}, sipVirus.Rizzolo{modeNum}, angstromPerFrame);
            SAFMovie = MM.makeMovie(sipVirus, 'R', modeNum, angstromPerFrame, numSteps);
        end
        
       
        
    end
    
    
end
