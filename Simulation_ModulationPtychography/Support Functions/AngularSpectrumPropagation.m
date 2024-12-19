%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 25/2/2023
%--------------------------------------------------------------------------

function [wavefront_rear]     = AngularSpectrumPropagation(wavefront_front, chirp)

%     wavefront_rear            = gpuArray(single(ones(sz_fft,sz_fft,num)));
%     for i = 1:num
%         wavefront_rear(:,:,i) = ifft2(fft2(wavefront_front(:,:,i)).*chirp);
%     end
   wavefront_rear             = ifft2(fft2(wavefront_front).*chirp);

end

