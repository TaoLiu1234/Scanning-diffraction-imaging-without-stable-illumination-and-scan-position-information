function [wf_out, px] = AngularSpectrum(wf_in, px, dis)
% usage: wf_out = AngularSpectrum(wf_in,dis, px)
% dis and px are propagation distance and sampling interval in unit of
% wavelength.
% Attention: probelm using single precision if dis is large; H oscillate
% too rapid. Try to use double precision instead

% fucai, Sheffield, 30/12/2010

[m,n]=size(wf_in);
m2 = ceil(m/2);
n2 = ceil(n/2);
u = [0:m2-1 m2-m:-1]/px/m;
v = [0:n2-1 n2-n:-1]/px/n;
[fx,fy] = meshgrid(u,v);
Arg = dis*sqrt(1-fx.^2-fy.^2);
H = exp(-2i*pi*Arg);
wf_out = ifft2(H.*fft2(wf_in));

end