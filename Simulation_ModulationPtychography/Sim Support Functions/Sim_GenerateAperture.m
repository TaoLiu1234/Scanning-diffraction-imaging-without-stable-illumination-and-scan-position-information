%--------------------------------------------------------------------------
%Author: Taoliu, Fucai Zhang
%Date: 9/5/2023
%--------------------------------------------------------------------------

function cache_cpu               = Sim_GenerateAperture(p)

    sz_probe                     = ((p. dx_obj.*p. sz_fft)^2)./pi./(p. sz_pinhole/2)^2;
    aperture                     = single(hardprobe(p. sz_fft,sz_probe));
    aperture                     = CircshiftFFT(aperture,p. shift_pinhole);
    aperture(find(aperture>0.5)) = 1;
    aperture(find(aperture<0.5)) = 0;
    cache_cpu.aperture           = aperture;

end


function y                       = hardprobe(M, beta)
y                                = softprobe(M,1e9,beta) > 0.5;
end

function y                       = softprobe(M,sharpness,beta)
y                                = zeros(M);
for m                            = 1-M/2:M/2
    for n                        = 1-M/2:M/2
        a                        = 1/sqrt(beta)*M/2;
        r                        = sqrt(m^2+n^2);
        y(m+M/2,n+M/2)           = atan(sharpness*(r + a)) - atan(sharpness*(r - a));
    end
end
y                                = y/max(y(:));
end