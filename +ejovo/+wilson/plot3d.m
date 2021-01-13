function plot3d(A,lc)
[m,n] = size(A);

if m == 3
    X = A(1,:);
    Y = A(2,:);
    Z = A(3,:);
else
    X = A(:,1);
    Y = A(:,2);
    Z = A(:,3);
end
[csty, msty] = gplotGetRightLineStyle(gca,lc);   
plot3(X,Y,Z,lc)
%function [lsty, csty, msty] = gplotGetRightLineStyle(ax, lc)
function [csty, msty] = gplotGetRightLineStyle(ax, lc)
%  gplotGetRightLineStyle
%    Helper function which correctly sets the color, line style, and marker
%    style when plotting the data above.  This style makes sure that the
%    plot is as conformant as possible to gplot from previous versions of
%    MATLAB, even when the coordinates array is not a floating point type.
co = get(ax,'ColorOrder');
lo = get(ax,'LineStyleOrder');
holdstyle = getappdata(gca,'PlotHoldStyle');
if isempty(holdstyle)
    holdstyle = 0;
end
lind = getappdata(gca,'PlotLineStyleIndex');
if isempty(lind) || holdstyle ~= 1
    lind = 1;
end
cind = getappdata(gca,'PlotColorIndex');
if isempty(cind) || holdstyle ~= 1
    cind = 1;
end
nlsty = lo(lind);
ncsty = co(cind,:);
nmsty = 'none';
%  Get the linespec requested by the user.
[lsty,csty,msty] = colstyle(lc);
if isempty(lsty)
    lsty = nlsty;
end
if isempty(csty)
    csty = ncsty;
end
if isempty(msty)
    msty = nmsty;
end
