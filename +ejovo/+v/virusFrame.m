classdef virusFrame
%A class to store the xyz coordinates of each frame of a virus movie
    properties
        XYZ
        frameNumber
    end
    
    methods
        function virusFrame = virusFrame(XYZ, frameNumber)
            virusFrame.XYZ = XYZ;
            virusFrame.frameNumber = frameNumber;
        end
    end
        
end