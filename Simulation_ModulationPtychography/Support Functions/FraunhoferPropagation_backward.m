%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 25/2/2023
%--------------------------------------------------------------------------

function [propagated_wavefront]     = FraunhoferPropagation_backward(wavefront ,sz_fft,num)
    propagated_wavefront = gpuArray(ones(sz_fft,sz_fft,num,'single'));
    for i = 1:num
        propagated_wavefront(:,:,i) = ifft2((wavefront(:,:,i))).*sz_fft;
    end
%      propagated_wavefront2           = ifft2(ifftshift(ifftshift(wavefront,2),1)).*sz_fft;
end
