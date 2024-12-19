%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 25/2/2023
%--------------------------------------------------------------------------

function [modulator]            = GnerateModulator(cache_cpu, p)
    switch p. method_gen_modulator
        case 'load'
            load([p.modulator_name '.mat']);
            modulator           = CutoutCenter(gather( eval(p.modulator_name)),ones(p.sz_fft));
            modulator           = exp(1j.*angle(modulator));
%             modulator = modulator(:,:,1);
        case 'ones'
            modulator           = ones(p.sz_fft);
        case 'dps_avg'
            modulator           = ifftshift(ifft2(fftshift(sqrt(cache_cpu.dp_avg))));
    end
%     modulator = circshift(modulator,  [12, 105]);
%     modulator                   = PadOutCenter(modulator,p.sz_fft.*p.upsampling,1);
    
end

