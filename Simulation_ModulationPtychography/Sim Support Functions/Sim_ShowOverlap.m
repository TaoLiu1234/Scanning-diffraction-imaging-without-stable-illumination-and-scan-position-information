%--------------------------------------------------------------------------
%Author: Fucai Zhang, Tao Liu
%Date: 23/5/2023
%--------------------------------------------------------------------------

function [p] = Sim_ShowOverlap(Cache,p)
% d is either the size lenght/diameter 
% shape is round, rectangle 
d           = p.sz_pinhole./p.dx_obj;
L           = 570;
d2          = d/2;
d4          = d2^2;
min_pos_x   = min(Cache.pos_px.shiftx)-d2;
max_pos_x   = max(Cache.pos_px.shiftx)+d2;
max_pos_y   = max(Cache.pos_px.shifty)+d2;
min_pos_y   = min(Cache.pos_px.shifty)-d2;
rx          = linspace(min_pos_x, max_pos_x, L);
ry          = linspace(min_pos_y, max_pos_y, L);
map         = zeros(L);
for k       = 1: length(Cache.pos_px.shiftx) % all points
    x       = (rx - Cache.pos_px.shiftx(k)).^2;
    y       = (ry - Cache.pos_px.shifty(k)).^2;
    [ax,ay] = meshgrid(x,y);
    a       = (ax+ay)<d4;
    map(a)  = map(a)+1;
end
ratio       = 1-sum(sum(map>0))/sum(sum(map));
p.overlap_ratio = ratio*100;
figure(1);
imshow(map,[]);
title(['Overlap map:',num2str(ratio*100,'.%1f') '%']);
end
