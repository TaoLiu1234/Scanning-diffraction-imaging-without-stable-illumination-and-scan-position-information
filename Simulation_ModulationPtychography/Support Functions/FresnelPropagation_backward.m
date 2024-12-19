%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 15/4/2024
%--------------------------------------------------------------------------
function [wavefront_rear]        = FresnelPropagation_backward(wavefront_front, chirp1,chirp2)
    wavefront_rear              = chirp2.*ifft2(wavefront_front.*chirp1);
%     wavefront_rear               = chirp2.*(ifft2(chirp1.*ifftshift(ifftshift(wavefront_front,1),2)));
%     wavefront_rear               = chirp2.*(ifft2(ifftshift(chirp1.*wavefront_front,3))).*sz_fft;
end

