%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 9/5/2023
%--------------------------------------------------------------------------
function [cache_cpu]        = Sim_GenerateObject(p,cache_cpu)
    %-------------------------------------
    %calculate the range of object
    sz_obj_x_max            = round(max(cache_cpu.pos_px.shiftx) - min(cache_cpu.pos_px.shiftx)) + p. sz_fft + p. obj_offset;
    sz_obj_y_max            = round(max(cache_cpu.pos_px.shifty) - min(cache_cpu.pos_px.shifty)) + p. sz_fft + p. obj_offset;
    sz_obj                  = max(sz_obj_y_max,sz_obj_x_max);
    cache_cpu.object        = ones(sz_obj,'single');
    % G10_7 = single(rgb2gray(imread('G10_7.jpg')));
    % G10_7 = G10_7./max(max(G10_7));
    load('obj_unknown_pos_63.mat');
%     load('modulator_20240424.mat')
    cache_cpu.object        = imresize(gather(obj_unknown_pos_63),[round(sz_obj*0.68) round(sz_obj*0.68)]);
%     cache_cpu.object        = imresize(modulator_20240424(590:1083,580:1071),[round(sz_obj*0.71) round(sz_obj*0.71)]);
    % cache_cpu.object        = imresize(G10(191:519,1:336),[round(sz_obj*0.71) round(sz_obj*0.71)]);
    cache_cpu.object        = PadOutCenter(cache_cpu.object,sz_obj,1);
    %-------------------------------------
%     %load the amplitude an phase of object
%     load(p. obj_amp_name);
%     load(p. obj_phase_name);
%     obj_amp                 = ( eval(p. obj_amp_name) );
%     obj_phase               = ( eval(p. obj_phase_name));
%     if size(obj_amp,3)>1
%         obj_amp             = rgb2gray(obj_amp);
%     end
%     if size(obj_phase,3)>1
%         obj_phase           = rgb2gray(obj_phase);
%     end
%     %-------------------------------------
%     %adjust range and size of the amplitude and object
%     obj_amp                 = single(imresize(obj_amp,[sz_obj sz_obj]));
%     obj_phase               = single(imresize(obj_phase,[sz_obj sz_obj]));
%     %-------------------------------------
%     obj_amp                 = obj_amp./max(max(obj_amp))*(p. obj_amp_range(2) - p. obj_amp_range(1)) + p. obj_amp_range(1);
%     obj_phase               = obj_phase./max(max(obj_phase)) - 0.5;
    %-------------------------------------
%     cache_cpu. object       = obj_amp.*exp(1j.*p. obj_phase_variation.*obj_phase);
end

