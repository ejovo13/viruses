function addVertices(scale)
%ADDVERTICES - Add SAF vertices to the current plot
%
%   ejovo.saf.addVertices(SCALE) adds SAF vertices to the current plot whose outer
%   most radius is SCALE.
%
%   See also rot2saf, rot2vdb, plotSAF
%
function [u, v, w] = loadVertices()
    parent = ejovo.fn.getParentDir;
    fileName = strcat(parent, '+ejovo/+saf/vertices.mat');
    load(fileName, 'U', 'W', 'V')
    u = U;
    v = V;
    w = W;
    disp('Vertices loaded')
end

[u, vVert, w] = loadVertices();

Urot = ejovo.saf.rot2saf(u);
Vrot = ejovo.saf.rot2saf(vVert);
Wrot = ejovo.saf.rot2saf(w);

hold on
ejovo.wilson.plot3d(scale/norm(w(1,:))*Wrot,'r*')
ejovo.wilson.plot3d(scale/norm(vVert(1,:))*Vrot,'m*')
ejovo.wilson.plot3d(scale/norm(u(1,:))*Urot,'g*')
hold off

axis equal
view(3)
end

