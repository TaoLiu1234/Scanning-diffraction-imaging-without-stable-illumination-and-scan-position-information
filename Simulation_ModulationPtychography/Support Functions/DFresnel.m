
function [wf_out, wf1] = DFresnel(wf_in, dx_in, dx_out, z, pos,p)
% double step Fresnel propagator
% dx_in and dx_out are input and output sample interval
% z propagtion distance
% pos: position of intermediate plane {'between', 'outside'}

% find location of intermediate plane
% to do, merge the two steps to save some calculation and improve accuray 
if dx_out == dx_in
    dx_out = dx_out+eps;
end
    
switch pos
    case 'outside'
        z1 = dx_in/(dx_out-dx_in)*z;
        % step 1
        [wf1, px1] = Fresnel(wf_in,dx_in, -z1);
        % step 2
        [wf_out, px_out] = Fresnel(wf1,px1, (z1+z));
    case 'inside'
        z1 = dx_in/(dx_out+dx_in)*z;
        % step 1
        [wf1, px1] = Fresnel(wf_in,dx_in, z1);
        % step 2
        [wf_out, px_out] = Fresnel(wf1,px1, (z-z1));
end

end

