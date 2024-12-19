function [gradient] = ScalingGradient(input_image)
        f_image         = fftshift(fft2(input_image));
    cut_f_image     = imresize(f_image, [(length(input_image)-2),(length(input_image)-2)] ,"lanczos2"); %8 for all simulation
    scaled_image    = (PadOutCenter(ifft2(ifftshift(cut_f_image)).*(length(input_image)/(length(input_image)-2)),length(input_image),0));

    gradient        = (scaled_image) - input_image;

end

