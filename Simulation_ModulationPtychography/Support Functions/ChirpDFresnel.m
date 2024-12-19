%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 15/4/2024
%--------------------------------------------------------------------------
function [cache_gpu]                = ChirpDFresnel(cache_gpu,p,dx_in,dx_out,dis)
    dis_intermidiate_plane          = dx_in/(dx_out-dx_in)*dis;
    dx_intermidate_plane            = p.lambda.*dis_intermidiate_plane./p.sz_fft./p.dx_obj;
    k                               = 2*pi/p.lambda;
    m                               = (-p.sz_fft/2:p.sz_fft/2-1).';
    n                               = (-p.sz_fft/2:p.sz_fft/2-1);
    M                               = p.sz_fft.*p. upsampling;
    N                               = M;
    M2                              = floor(M/2);
    N2                              = M2;
    
    %forward first step
    %from dx_obj-> dx_intermidate_plane negative propagation
    dis_intermidiate_plane          = -dis_intermidiate_plane;
    
    cache_gpu. Dfresnel_chirp1      = gpuArray(single( exp(-1i.*k/2/dis_intermidiate_plane.*((m*dx_in).^2 + (n*dx_in).^2)-2i*pi*(m+M2)*M2/M-2i*pi*(n+N2)*N2/N)));
    cache_gpu. Dfresnel_chirp2      = gpuArray(single( 1i*exp(-2i*pi/M*M2*M2 - 2i*pi/N*N2*N2).*exp(-1i.*k./2/dis_intermidiate_plane.*((m*dx_intermidate_plane).^2 + (n*dx_intermidate_plane).^2)- 2i*pi*(m+M2)*M2/M- 2i*pi*(n+N2)*N2/N).*p.sz_fft));
%     wf_inter = (chirp2).*ifft2(wf_in.*chirp1);
    
    %forward second step
    %from intermidiate -> ccd positive propagation
    %from dx_intermidate_plane-> dx_out negative propagation
    dis_intermidiate_plane          = -dis_intermidiate_plane;
    dis_intermidiate2ccd            = dis_intermidiate_plane + dis;
    
    cache_gpu. Dfresnel_chirp3      = gpuArray(single( exp(-1i.*k/2/dis_intermidiate2ccd.*((m*dx_intermidate_plane).^2 + (n*dx_intermidate_plane).^2)+2i*pi*(m+M2)*M2/M+2i*pi*(n+N2)*N2/N)));
    cache_gpu. Dfresnel_chirp4      = gpuArray(single( -1i*exp(2i*pi/M*M2*M2 + 2i*pi/N*N2*N2).*exp(-1i.*k./2/dis_intermidiate2ccd.*((m*dx_out).^2 + (n*dx_out).^2) + 2i*pi*(m+M2)*M2/M + 2i*pi*(n+N2)*N2/N)./p.sz_fft));
%     wf_inter2 = fftshift((chirp4).*fft2(wf_inter.*chirp3));
    
    %backward first step
    %from ccd_plan-> intermidiate_plan negative propagation
    %from px_out -> dx_intermidate_plane
    dis_intermidiate2ccd            = -dis_intermidiate2ccd;

    cache_gpu. Dfresnel_chirp5      = gpuArray(single( exp(-1i.*k/2/dis_intermidiate2ccd.*((m*dx_out).^2 + (n*dx_out).^2)-2i*pi*(m+M2)*M2/M-2i*pi*(n+N2)*N2/N)));
    cache_gpu. Dfresnel_chirp6      = gpuArray(single( 1i*exp(-2i*pi/M*M2*M2 - 2i*pi/N*N2*N2).*exp(-1i.*k./2/dis_intermidiate2ccd.*((m*dx_intermidate_plane).^2 + (n*dx_intermidate_plane).^2)- 2i*pi*(m+M2)*M2/M- 2i*pi*(n+N2)*N2/N).*p.sz_fft));
%     wf_inter3 = (chirp6).*ifft2(ifftshift(wf_inter2).*chirp5);
    
    %backward second step
    %from intermidiate_plan-> obj_plan positive propagation
    %from dx_intermidate_plane -> px_in
    cache_gpu. Dfresnel_chirp7      = gpuArray(single( exp(-1i.*k/2/dis_intermidiate_plane.*((m*dx_intermidate_plane).^2 + (n*dx_intermidate_plane).^2)+2i*pi*(m+M2)*M2/M+2i*pi*(n+N2)*N2/N)));
    cache_gpu. Dfresnel_chirp8      = gpuArray(single( -1i*exp(2i*pi/M*M2*M2 + 2i*pi/N*N2*N2).*exp(-1i.*k./2/dis_intermidiate_plane.*((m*dx_in).^2 + (n*dx_in).^2) + 2i*pi*(m+M2)*M2/M + 2i*pi*(n+N2)*N2/N)./p.sz_fft));
%     wf_out = ((chirp8).*fft2(wf_inter3.*chirp7));

end

