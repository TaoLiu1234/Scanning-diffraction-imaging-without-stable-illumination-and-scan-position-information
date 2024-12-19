%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 28/2/2023
%--------------------------------------------------------------------------

function [probe]            = GenerateProbe(p,cache_cpu,cache_gpu)
    %-------------------------------------
    switch p. method_gen_probe
        case 'load'
            load(p. probe_name);
            probe           = gather( eval(p. probe_name) );
%             probe           = ones(p.sz_fft,p.sz_fft,52).*probe;
        case 'support'
            probe           = cache_gpu.support;
            
%             [temp_charp_for,temp_charp_back]      = ChirpAS(p,p. dis_obj2focus);
%             probe               = AngularSpectrumPropagation(probe,temp_charp_for);
        case 'ones'
            probe           = gpuArray.ones(p.sz_fft,'single');
        case 'dp_avg_ifft'
            temp            = sqrt(cache_cpu.dp_avg);
            max_temp        = max(max(temp));
            temp(temp<max_temp*0.1)  = 0; 
            if cache_cpu.sz_dps(1) < p.sz_fft

                temp            = PadOutCenter(temp,p.sz_fft.*p.upsampling,1);
            else
                temp            = CutoutCenter(temp,p.sz_fft.*p.upsampling);
            end

%             probe           = gpuArray(single(ifftshift(ifft2(ifftshift(temp)))));
%             [temp_charp_for,temp_charp_back]      = ChirpAS(p,p. dis_obj2focus);
%             probe               = AngularSpectrumPropagation(probe,temp_charp_for);
%             phase               = (ThinLens(p.sz_fft,p.dx_dp./p.lambda,(p.dis_obj2modu+p.dis_modu2ccd+p. dis_obj2focus)./p.lambda));
%             [temp_charp_for,temp_charp_back]      = ChirpAS(p,p.dis_obj2modu+p.dis_modu2ccd);
%             probe               = AngularSpectrumPropagation(temp.*exp(1j.*angle(phase)),temp_charp_back,1);
%             [cache_gpu]         = ChirpFresnel(p,cache_gpu,p.dx_dp./p.lambda,-p.dis_modu2ccd./p.lambda);
%             probe           = FresnelPropagation_backward(fftshift(temp.*exp(1j.*angle(phase))),cache_gpu.ChirpFresnel3,cache_gpu.ChirpFresnel4 );
%             [probe,inter_wave] = DFresnel2backward(p,temp.*exp(1j.*angle(phase)),p.dx_dp,p.dx_obj,p.dis_modu2ccd,1.3204);
%             [cache_gpu]        = ChirpDFresnel(cache_gpu,p,p.dx_obj,p.dx_dp,p.dis_modu2ccd);
%             [probe,temp_wavefront] = DFresnelPropagation_backward(fftshift(temp.*exp(-1j.*angle(phase))),cache_gpu);
            
    end
%     probe                   = gpuArray(single(PadOutCenter(probe,p.sz_fft.*p.upsampling,0)));
    %-------------------------------------
    %energy distributed
    % probe_energy            = sum(sum(abs(probe).^2));
    % amp_correct_factor      = sqrt(cache_cpu.dp_avg_energy/probe_energy);
    % probe                   = probe.*amp_correct_factor;
end
