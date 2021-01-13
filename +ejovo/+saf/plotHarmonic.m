function plotHarmonic(n,m)
%PLOTHARMONIC - Visialize a Laplacian spherical harmonic of degree n and order m
th = linspace(0,pi,250);    % inclination
phi = linspace(0,2*pi,250); % azimuth
[th,phi] = meshgrid(th,phi);
% compute spherical harmonic of degree 3 and order 1
Y = ejovo.saf.harmonicY(n,m,th,phi);
% plot the magnitude
r = abs(Y);
[x,y,z] = sph2cart(phi,pi/2-th,r);
surf(x,y,z,r);
axis equal
shading interp


