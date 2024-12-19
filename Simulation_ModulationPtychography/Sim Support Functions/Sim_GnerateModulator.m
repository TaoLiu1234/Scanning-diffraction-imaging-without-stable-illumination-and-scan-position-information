%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 25/2/2023
%--------------------------------------------------------------------------

function [cache_cpu]              = Sim_GnerateModulator(p,cache_cpu)
    switch p. method_gen_modulator
        case 'load'
            load([p.modulator_name '.mat']);
            cache_cpu. modulator  = CutoutCenter(gather( eval(p.modulator_name)),ones(p.sz_fft));
            % cache_cpu. modulator  = exp(1j.*angle(cache_cpu. modulator));
        case 'rand'
            cache_cpu. modulator  = exp(1j*(p. modulator_phase_variation*rand(p.sz_fft) - p. modulator_phase_variation/2) );
        case 'ones'
            cache_cpu. modulator  = ones(p.sz_fft);
    end
    if p. low_pass_filter_modu    == true
        %
    end
end

