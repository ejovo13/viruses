function s = plotSAF(degree, sizeGrid)
%Visualize the icosahedral SAF of degree m
if nargin == 1
    sizeGrid = 250;
end

th = linspace(0,pi,sizeGrid);    % azimuth
phi = linspace(0,2*pi,sizeGrid); % inclination
[th,phi] = meshgrid(th,phi);

SAF = ejovo.saf.buildSAF(degree, th, phi);
r=abs(SAF);
%[X,Y,Z] = sph2cart(phi,pi/2-th,SAF);
[x,y,z] = sph2cart(phi,pi/2-th,SAF);
s = surf(x,y,z,SAF);
axis equal
shading interp
colormap jet
set(gca, 'visible', 'off');
end
