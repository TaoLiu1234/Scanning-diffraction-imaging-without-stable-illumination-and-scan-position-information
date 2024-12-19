function [wf_out, px] = Fresnel_2024(wf_in,dx, dis)
% usage: [wf_out, px_out] = FresnelProp(wf_in,px_in, dis)
% dis, px_in, px_out are propagation distance and sampling intervals in unit of
% wavelength. 

% formular: int{wf_in *exp(ik*(x^2+y^2)/z)*exp(-2i*pi*(x*x'+y*y'))dxdy } <--
% obeys to the convention of Goodman's book 
% fast version with fftshift implemented by matrix mulitiplication. 

% note, wrong doc of fft in Matlab. 
% fft is with kernal exp(-2ipi*n*k)

% fucai, Sheffield, 30/12/2010

%% fast code 
[M,N]= size(wf_in);
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

if dis == 0
    wf_out = wf_in;
    px = dx;
elseif dis > 0
    H_in = exp(1i*pi/dis*mm*dx2(end)+2i*pi*(m+M2)*M2/M) * ...
        exp(1i*pi/dis*nn*dx2(1)+2i*pi*(n+N2)*N2/N);
    
    H_out = exp(1i*pi/dis*mm*px2(end) + 2i*pi*(m+M2)*M2/M) * ...
        exp(1i*pi/dis*nn*px2(1) + 2i*pi*(n+N2)*N2/N);
    K = exp(2i*pi/M*M2*M2 + 2i*pi/N*N2*N2);
    
    wf_out = -1i*K*H_out.*fft2(H_in.*wf_in)/sqrt(M*N);
else
    H_in = exp(1i*pi/dis*mm*dx2(end)-2i*pi*(m+M2)*M2/M) * ...
        exp(1i*pi/dis*nn*dx2(1)-2i*pi*(n+N2)*N2/N);
    
    H_out = exp(1i*pi/dis*mm*px2(end) - 2i*pi*(m+M2)*M2/M) * ...
        exp(1i*pi/dis*nn*px2(1) - 2i*pi*(n+N2)*N2/N);
    K = exp(-2i*pi/M*M2*M2 - 2i*pi/N*N2*N2);
    
    wf_out = 1i*K* H_out.*ifft2(H_in.*wf_in)*sqrt(M*N);
end
px = abs(px);
end
