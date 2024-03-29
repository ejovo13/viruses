function animateSAF(n, order, numSteps)
% ANIMATESAF Create an animation of SAF generation.
%
%   ejovo.saf.animateSAF(n) creates an animation of SAF degree n with 25 frames per
%   SAF, in the default order
%
%   ejovo.saf.animateSAF(n, 'random') creates the animation in a random order of the
%   combination of spherical harmonics. Used to create fun, interesting new
%   animations
%
%   ejovo.saf.animateSAF(n, 'random', numSteps) allows the user to define the number of frames,
%   hence the resolution of the animation.
%
%   See also BUILDHARMONICS, 
SIZE = 250;

%Setting up the resolution for graphing the harmonics
th = linspace(0,pi,SIZE);    % inclination
phi = linspace(0,2*pi,SIZE); % azimuth
[th,phi] = meshgrid(th,phi);
zero = zeros(SIZE,SIZE);

if nargin < 3
    numSteps = 25;    
    if nargin < 2
        order = 'default';
    end
end


[SAF, Y, norm] = ejovo.saf.buildSAF(n, th, phi);
q = size(Y);
largestvalue = max(max(SAF));
scale = 1/largestvalue; %Sets the largest radial component to 1
if length(q) == 2
    iterations = 1;
else
    iterations = q(3);
end

if strcmp(order, 'random')
    perms = randperm(iterations);
elseif strcmp(order, 'reverse')
    perms = flip(1:iterations);
else
    perms = 1:iterations;
end

figure('units','normalized','outerposition',[0 0 1 1])
s = surface(zero, zero, zero, zero);
colormap jet
colorbar

hold on
limit = 1.3;
axis equal manual off
axis([-limit limit -limit limit -limit limit]);
shading interp
camzoom(1.3)
view(40,30)
for jj = perms
    r = Y(:,:,jj)*norm*scale;
    [xj, yj, zj] = sph2cart(phi,pi/2-th,r);
    xj = xj/numSteps;
    yj = yj/numSteps;
    zj = zj/numSteps;
    C = r/numSteps;
    pTime = .1/numSteps/iterations;
    for ii = 1:numSteps         
        %Update XYZ coordinates to create an animation
        s.XData = s.XData + xj;
        s.YData = s.YData + yj;
        s.ZData = s.ZData + zj;
        s.CData = s.CData + C;
        pause(pTime)
    end
end


hold off