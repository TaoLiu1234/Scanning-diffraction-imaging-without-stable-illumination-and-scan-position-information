%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 15/4/2024
%--------------------------------------------------------------------------
function [propagated_wavefront,temp_wavefront] = DFresnelPropagation_backward(wavefront,cache_gpu)
    temp_wavefront = (cache_gpu. Dfresnel_chirp6).*ifft2(ifftshift(wavefront).*cache_gpu. Dfresnel_chirp5);
    propagated_wavefront = ((cache_gpu. Dfresnel_chirp8).*fft2(temp_wavefront.*cache_gpu. Dfresnel_chirp7));
end

