%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 27/4/2024
%--------------------------------------------------------------------------
function [wf_out] = ComplexConstraint(support,wf,alpha1,alpha2)
    wf_out = gpuArray(ones(size(wf)));
    for i = 1:size(wf,3)
        C_avg         = sum(sum(log(abs(wf(:,:,i))+1)./angle(wf(:,:,i)).*support))./sum(sum(support));
        wf_out_abs    = exp((1-alpha1).*log(abs(wf(:,:,i))+1) + alpha1.*C_avg.*angle(wf(:,:,i)));
        wf_out_angle  = (1-alpha2).*angle(wf(:,:,i)) + alpha2./C_avg.*log(abs(wf(:,:,i))+1);
        wf_temp        = wf_out_abs.*exp(1j.*wf_out_angle);
        wf_out(:,:,i) = wf_temp;
    end
end

