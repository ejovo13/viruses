function s = plotSAF(degree)
%Visualize the icosahedral SAF of degree m
th = linspace(0,pi,250);    % azimuth
phi = linspace(0,2*pi,250); % inclination
[th,phi] = meshgrid(th,phi);

SAF = ejovo.saf.buildSAF(degree, th, phi);
r=abs(SAF);
%[X,Y,Z] = sph2cart(phi,pi/2-th,SAF);
[x,y,z] = sph2cart(phi,pi/2-th,r);
s = surf(x,y,z,r);
axis equal
shading interp

end
