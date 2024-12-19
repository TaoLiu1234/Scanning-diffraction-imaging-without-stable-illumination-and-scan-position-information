%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 25/2/2023
%--------------------------------------------------------------------------

function [propagated_wavefront]     = FraunhoferPropagation_forward(wavefront,sz_fft,num)
    propagated_wavefront = gpuArray(ones(sz_fft,sz_fft,num,'single'));
    for i = 1:num
        propagated_wavefront(:,:,i) = (fft2(wavefront(:,:,i)))./sz_fft;
    end

%     propagated_wavefront2            = fftshift(fftshift(fft2(wavefront),1),2)./sz_fft;
end
