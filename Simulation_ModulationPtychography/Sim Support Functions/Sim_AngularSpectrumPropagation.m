%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 25/2/2023
%--------------------------------------------------------------------------

function [wavefront_rear]     = Sim_AngularSpectrumPropagation(p, wavefront_front, chirp, num_layers)
if p. device                  == 'GPU'
    wavefront_rear            = gpuArray.ones(size(wavefront_front),'single');
else
    wavefront_rear            = ones(size(wavefront_front),'single');
end
   for it                     = 1:num_layers
       wavefront_rear(:,:,it) = ifft2(fft2(wavefront_front(:,:,it)).*chirp);
   end
end

