function [cache_gpu]  = ChirpFresnel2(p,cache_gpu,dis)
    k = 2*pi/p.lambda;
    m = [-p.sz_fft/2:p.sz_fft/2-1];
    n = m';
    M = p.sz_fft;
    N = M;
    M2 = M/2;
    N2 = N/2;
    %forward
    cache_gpu.ChirpFresnel1 = exp(1j.*k/2/dis*((m.*p.dx_obj).^2 + (n.*p.dx_obj).^2));
    cache_gpu.ChirpFresnel2 = exp(1i.*k*dis)./1i.*exp(1i.*k/2/dis.*((m.*p.dx_dp).^2 + (n.*p.dx_dp).^2))./p.sz_fft;

    %backward
    dis = -dis;
    cache_gpu.ChirpFresnel3 = exp(1j.*k/2/dis*((m.*p.dx_obj).^2 + (n.*p.dx_obj).^2));
    cache_gpu.ChirpFresnel4 = exp(2i*pi/M*M2*M2 + 2i*pi/N*N2*N2).*exp(1i.*k*dis)./1i.*exp(1i.*k/2/dis.*((m.*p.dx_dp).^2 + (n.*p.dx_dp).^2)).*p.sz_fft;
end

