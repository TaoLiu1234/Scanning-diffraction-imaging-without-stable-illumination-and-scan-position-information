%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 9/5/2023
%--------------------------------------------------------------------------

function [Cache]                   = Sim_GenerateDP(p,Cache)
    %-------------------------------------
    %copy variables
    probe                          = Cache.probe;
    part_object                    = Cache.part_object;
    object                         = Cache.object;
    modulator                      = Cache.modulator;
    ASChirp_forward                = Cache.ASChirp_forward;
    pos_px                         = Cache.pos_px;
    dp                             = Cache.dp;
    %-------------------------------------
    %generate shift
    integer_shifty                 = round(pos_px.shifty);
    integer_shiftx                 = round(pos_px.shiftx);
    fraction_shifty                = pos_px.shifty - integer_shifty;
    fraction_shiftx                = pos_px.shiftx - integer_shiftx;
    %-------------------------------------
    %calculate diffraction pattern
    for index_dp                   = 1:p.num_points
        %-------------------------------------
        %index part of the object 
        %integer shift
        part_object(:,:,index_dp)  = object(integer_shifty(index_dp) - p.sz_fft/2 : integer_shifty(index_dp) + p.sz_fft/2 - 1 , integer_shiftx(index_dp) - p.sz_fft/2 : integer_shiftx(index_dp) + p.sz_fft/2 - 1 );
        %-------------------------------------
        %fractional shift
        part_object(:,:,index_dp)  = CircshiftFFT(part_object(:,:,index_dp),-[fraction_shifty(index_dp) fraction_shiftx(index_dp)]);
        %-------------------------------------
        %calculate exit wave
        exit_wave                  = part_object(:,:,index_dp).*probe(:,:,index_dp);
        %-------------------------------------
        %propagate to modulator plane
        exit_wave_modu_front       = Sim_AngularSpectrumPropagation(p,exit_wave,ASChirp_forward,1);
        %-------------------------------------
        %apply modulation
        exit_wave_modu_rear        = exit_wave_modu_front.*modulator;
        %-------------------------------------
        %propagate to detector plane
        dp(:,:,index_dp)           = abs(fftshift(fft2(exit_wave_modu_rear))./p.sz_fft).^2;
    end
    %-------------------------------------
    %pos-pocessing
    for index_dp                   = 1:p.num_points
        if p.camera_psf            == true
            %**to finish**
        end

        if p.poisson_noise         == true
            dp(:,:,index_dp)       = imnoise(dp(:,:,index_dp)*1e-6,'poisson')*1e6;
        end
        
        if p.gaussian_noise        == false
            %**to finish**
        end
        
        if p. quantification_noise == true
            Max                    = max(max(dp(:,:,index_dp)));
            dp(:,:,index_dp)       = double( round(dp(:,:,index_dp)/Max*2^p.camera_bit_depth).*Max/2^p.camera_bit_depth  );
        end
    end
    %-------------------------------------
    %copy variables
    Cache.part_object              = part_object;
    Cache.probe                    = probe;
    Cache.object                   = object;
    Cache.pos_px                   = pos_px;
    Cache.dp                       = dp;

end