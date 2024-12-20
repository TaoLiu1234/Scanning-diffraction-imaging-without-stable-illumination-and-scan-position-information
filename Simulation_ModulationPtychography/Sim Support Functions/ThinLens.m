%--------------------------------------------------------------------------
%Author: Fucai Zhang
%Date: 30/12/2010
%--------------------------------------------------------------------------
function L = ThinLens(sz,dx, f)
% usage: wf_out = PassThinLens (wf_in,px_in, f)
% f, px are focal length and sampling interval in unit of wavelength. 

% lens phase delay: exp{-i*k/(2f)*(x^2+y^2)}
% 
% fucai, Sheffield, 30/12/2010

M = sz(1);
N = sz(end);

M2 = floor(M/2);
N2 = floor(N/2);

dx2 = dx.^2;

m = (-M2: -M2+M-1).';
n = (-N2: -N2+N-1);

mm = m.^2;
nn = n.^2;

L = exp(-1i*pi/f*mm*dx2(end)) * exp(-1i*pi/f*nn*dx2(1));
