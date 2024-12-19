%--------------------------------------------------------------------------
%Author: Taoliu, Fucai Zhang
%Date: 15/4/2024
%--------------------------------------------------------------------------
% formular: int{wf_in *exp(ik*(x^2+y^2)/z)*exp(-2i*pi*(x*x'+y*y'))dxdy } <--
% obeys to the convention of Goodman's book 
% fast version with fftshift implemented by matrix mulitiplication. 

% note, wrong doc of fft in Matlab. 
% fft is with kernal exp(-2ipi*n*k)

% fucai, Sheffield, 30/12/2010
function [cache_gpu]  = ChirpFresnel(p,cache_gpu,dx,dis)
M = p.sz_fft;
N = M;
M2 = floor(M/2);
N2 = floor(N/2);

px = dx;
px(1) = dis /dx(1)/N;
px(end) = dis /dx(end)/M;

dx2 = dx.^2;
px2 = px.^2;

m = (-M2: -M2+M-1).';
n = (-N2: -N2+N-1);

mm = m.^2;
nn = n.^2;

%for positive propagation
    H_in = exp(-1i*pi/dis*mm*dx2(end)+2i*pi*(m+M2)*M2/M) * ...
        exp(-1i*pi/dis*nn*dx2(1)+2i*pi*(n+N2)*N2/N);
    
    H_out = exp(-1i*pi/dis*mm*px2(end) + 2i*pi*(m+M2)*M2/M) * ...
        exp(-1i*pi/dis*nn*px2(1) + 2i*pi*(n+N2)*N2/N);
    K = exp(2i*pi/M*M2*M2 + 2i*pi/N*N2*N2);
    
    cache_gpu. ChirpFresnel1 = gpuArray(single(H_in));
    cache_gpu. ChirpFresnel2 = gpuArray(single(-1i*K*H_out/sqrt(M*N)));

%for negative propagation
    H_in = exp(-1i*pi/dis*mm*dx2(end)-2i*pi*(m+M2)*M2/M) * ...
        exp(-1i*pi/dis*nn*dx2(1)-2i*pi*(n+N2)*N2/N);
    
    H_out = exp(-1i*pi/dis*mm*px2(end) - 2i*pi*(m+M2)*M2/M) * ...
        exp(-1i*pi/dis*nn*px2(1) - 2i*pi*(n+N2)*N2/N);
    K = exp(-2i*pi/M*M2*M2 - 2i*pi/N*N2*N2);
    
    cache_gpu. ChirpFresnel3 = gpuArray(single(H_in));
    cache_gpu. ChirpFresnel4 = gpuArray(single(1i*K*H_out*sqrt(M*N)));


end

