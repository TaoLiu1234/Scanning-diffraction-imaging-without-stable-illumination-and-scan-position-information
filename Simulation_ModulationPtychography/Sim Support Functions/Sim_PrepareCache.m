%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 9/5/2023
%--------------------------------------------------------------------------

function [Cache]                              = Sim_PrepareCache(p,cache_cpu)

    if p. device                              == 'GPU'
        Cache. probe                          = gpuArray.ones(p. sz_fft,p. sz_fft,p. num_points,'single');

        if p. probe_perturbation              == false
            for index_probe                   = 1: p.num_points
                Cache. probe(:,:,index_probe) = single(gpuArray(cache_cpu.probe));
            end
        else
            %**to finish**
            
        end
        Cache.part_object                     = gpuArray.ones(size(Cache.probe),'single');
        Cache. object                         = single(gpuArray(cache_cpu.object));
        Cache. modulator                      = single(gpuArray(cache_cpu.modulator));
        Cache. pos_px. shiftx                 = gpuArray(cache_cpu.pos_px.shiftx);
        Cache. pos_px. shifty                 = gpuArray(cache_cpu.pos_px.shifty);
        Cache. dp                             = single(gpuArray.ones(p. sz_fft,p. sz_fft,p. num_points));
        [Cache. ASChirp_forward, Cache. ASChirp_backward] = Sim_ChirpAS(p,p.dis_obj2modu);
        Cache. ASChirp_forward                = single(gpuArray(Cache. ASChirp_forward));
        Cache. ASChirp_backward               = single(gpuArray(Cache. ASChirp_backward));
    else

        Cache. probe                          = ones(p. sz_fft,p. sz_fft,p. num_points,'single');

        if p. probe_perturbation              == false
            for index_probe                   = 1: p.num_points
                Cache. probe(:,:,index_probe) = single(cache_cpu.probe);
            end
        else
            %**to finish**

        end
        Cache.part_object                     = ones(size(Cache.probe),'single');
        Cache. object                         = single(cache_cpu.object);
        Cache. modulator                      = single(cache_cpu.modulator);
        Cache. pos_px. shiftx                 = cache_cpu.pos_px.shiftx;
        Cache. pos_px. shifty                 = cache_cpu.pos_px.shifty;
        Cache. dp                             = ones(p. sz_fft,p. sz_fft,p. num_points,'single');
        [Cache. ASChirp_forward, Cache. ASChirp_forward] = Sim_ChirpAS(p,p.dis_obj2modu);
    end
    
end

