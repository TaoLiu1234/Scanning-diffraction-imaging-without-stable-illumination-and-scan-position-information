%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 15/4/2024
%--------------------------------------------------------------------------
function [wavefront_rear]        = FresnelPropagation_forward(wavefront_front, chirp1,chirp2)
wavefront_rear = (chirp2.*fft2(wavefront_front.*chirp1));
%    wavefront_rear                = fftshift(chirp2.*fftshift(fft2(chirp1.*wavefront_front),3));
end

