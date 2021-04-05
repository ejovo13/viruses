classdef saf
%SAF - Symmetry Adapted Functions are a linear combinations of spherical harmonics
% That exhibit icosahedral symmetry. This class is used to generate and manipulate these 
% objects
    
properties

    degree
    gridSize    % The size of the mesh grid used to compute the spherical harmonic
    
end 

properties (Hidden)
    
    Y       % The combination of Laplacian spherical harmonics
    th
    phi

end

properties (Access = private)

    shouldBuild

end 

methods 

    function obj = saf(degree, gridSize)

        switch nargin

        case 1
            gridSize = 250;
        case 2

        end

        obj.shouldBuild = true;
        obj.gridSize = gridSize;
        
        
        obj.degree = degree;
    end 
    
    function plot(this, visible)

        if nargin == 1
            visible = true;
        end
        
        [x,y,z] = sph2cart(this.phi,pi/2-this.th,this.Y);
        s = surf(x,y,z,this.Y);
        axis equal
        axis square
        shading interp
        colormap jet
        title(string(this.degree))
        if ~visible
            set(gca, 'visible', 'off');
        end
    end 
    
    function plotPos(this, visible)
        
        if nargin == 1
            visible = true;
        end
        
        posY = this.getPos;
        
        [x,y,z] = sph2cart(this.phi,pi/2-this.th,posY);
        s = surf(x,y,z,this.Y);
        axis equal
        axis square
        shading interp
        colormap jet
        title("Positive")
        if ~visible
            set(gca, 'visible', 'off');
        end      
        
    end 
    
    
    function plotNeg(this, visible)
        
        if nargin == 1
            visible = true;
        end
        
        negY = this.getNeg;
        
        [x,y,z] = sph2cart(this.phi,pi/2-this.th,negY);
        s = surf(x,y,z,this.Y);
        axis equal
        axis square
        shading interp
        colormap jet
        title("Negative")
        if ~visible
            set(gca, 'visible', 'off');
        end        
    end 
    
    function plotAll(this, visible)
       
        if nargin == 1
            visible = true;
        end
        
        tiledlayout(1,3)
        nexttile 
        this.plotPos(visible)
        nexttile
        this.plotNeg(visible)
        nexttile
        this.plot(visible)
        
        
    end

    function plotSymmetries(this, visible)

        if nargin == 1 
            visible = true;
        end

        t = tiledlayout(1,4);
        f = gcf;
        name = string(this.degree);
        set(f, "Name", strcat("SAF", name));
        nexttile
        this.plot(visible)
        title("5-fold")
        ejovo.saf.five
        nexttile
        this.plot(visible)
        title("3-fold")
        ejovo.saf.three
        nexttile
        this.plot(visible)
        title("2-fold")
        ejovo.saf.two
        nexttile
        this.plot

    end 

    
    function obj = normalize(obj)



    end 

    function p = norm(obj)

        p = norm(obj.Y);

    end
    
    function posY = getPos(obj)
        
        posY = obj.Y;
        posY(posY < 0) = 0;
        
    end
    
    function negY = getNeg(obj)
        
        negY = obj.Y;
        negY(negY> 0) = 0;
        
    end 
    
    
    
    % Getter and setter methods
    
    
    function obj = set.degree(obj, newDegree)
        
        if obj.shouldBuild 
            th = linspace(0,pi,obj.gridSize);    % azimuth
            phi = linspace(0,2*pi,obj.gridSize); % inclination
            [obj.th,obj.phi] = meshgrid(th,phi);
            obj.Y = ejovo.saf.buildSAF(newDegree, obj.th, obj.phi);
            obj.shouldBuild = false;
        end
        obj.degree = newDegree;
        
    end 

    % function obj = set.gridSize(obj, newGridSize)

    %     obj.gridSize = newGridSize
    %     disp("Grid sized changed but SAF was NOT recalculated")

    % end

    % OPERATORS %%%%%%%%%%%%%%%%%%%%%%
       
    function obj1 = plus(obj1, obj2)
        
        test = obj1.gridSize == obj2.gridSize;
        assert(test, "SAFs are not the same size")

        obj1.degree = strcat(num2str(obj1.degree), " + " ,num2str(obj2.degree));
        obj1.Y = obj1.Y + obj2.Y;
        
    end

    function obj = uminus(obj)

        obj.degree = strcat("-", string(obj.degree));
        obj.Y = -obj.Y;

    end

    function obj1 = minus(obj1, obj2)

        obj1 = obj1 + -obj2;

    end 
    

    


end 

methods (Static)

    function L = degrees
        L = [0, 6, 10, 12, 15, 16, 18, 20, 22, 24, 26, 28, 30, 31];
    end 

    function [all, t] = plotAllSAF

        L = [0, 6, 10, 12, 16, 18, 20, 22, 24, 26, 28, 30, 31];
        numToBuild = length(L);



        all = ejovo.v.saf.empty(numToBuild,0);

        t = tiledlayout(2,7);
        for ii = 1:numToBuild            
            all(ii) = ejovo.v.saf(L(ii));
            nexttile
            all(ii).plot;
            title(string(all(ii).degree))
        end 







    end 

end

end