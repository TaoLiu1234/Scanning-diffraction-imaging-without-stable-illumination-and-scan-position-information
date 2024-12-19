%--------------------------------------------------------------------------
%Author: Tao Liu
%Date: 13/06/2023
%--------------------------------------------------------------------------

function [cal_dps_amp,conv_kernel]           = CalculateDpsAmp(original_wavefront,cal_dps_amp,conv_kernel,dp_amp,deconv_method,deconv_iter,it,upsampling,sz_fft,num_layers)
    if deconv_method                         == "none"
        cal_dps_amp                          = abs(original_wavefront);
        temp_cal_dps_amp                     = gpuArray.ones(sz_fft,sz_fft,num_layers,'single');
        if upsampling                        ~= 1
            for layers                       = 1:num_layers
                temp                         = conv2(cal_dps_amp(:,:,layers), ones(upsampling),'same');
                temp_cal_dps_amp(:,:,layers) = temp(1:upsampling:end, 1:upsampling:end);
            end
            cal_dps_amp                      = temp_cal_dps_amp;
        end
        
    elseif mod(it,deconv_iter(1))            ~= 0
        original_dp                          = abs(original_wavefront).^2;
        for layers = 1:num_layers 
            cal_dps_amp(:,:,layers)          = sqrt(abs(ifft2(fft2(original_dp(:,:,layers)).*fft2(conv_kernel))));
        end
    else
        %-------------------------------------
        %calculate original diffraction pattern
        original_dp                          = gather(double(abs(original_wavefront).^2));
        dp_measured                          = gather(double((dp_amp+eps).^2));
        %-------------------------------------
        %deconvolution
        for layers                           = 1:num_layers
            %
            switch deconv_method
                case 'vwnr'
                    %
                case 'lucy'
                    conv_kernel              = abs(deconvwl_tandem(fftshift(dp_measured(:,:,layers)),fftshift(original_dp(:,:,layers)),deconv_iter(2)));
                case 'combined'
                    conv_kernel              = abs(deconvwl_tandem(fftshift(dp_measured(:,:,layers)),fftshift(original_dp(:,:,layers)),deconv_iter(2)));
%                     conv_kernel             = conv_kernel/sum(conv_kernel(:));
%                     

            end
            conv_kernel                      = fftshift(conv_kernel/sum((conv_kernel(:))));
            cal_dps_amp(:,:,layers)          = sqrt(abs(ifft2(fft2(original_dp(:,:,layers)).*fft2(conv_kernel))));
        end
    end
    
end

