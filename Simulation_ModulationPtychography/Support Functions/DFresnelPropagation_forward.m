%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 15/4/2024
%--------------------------------------------------------------------------
function [propagated_wavefront,temp_wavefront] = DFresnelPropagation_forward(wavefront, cache_gpu)
    temp_wavefront                             = cache_gpu. Dfresnel_chirp2.*ifft2(wavefront.*cache_gpu. Dfresnel_chirp1);
    propagated_wavefront                       = fftshift((cache_gpu. Dfresnel_chirp4).*fft2(temp_wavefront.*cache_gpu. Dfresnel_chirp3));
end

