%--------------------------------------------------------------------------
%Author: Taoliu, Fucai Zhang
%Date: 9/5/2023
%--------------------------------------------------------------------------

function cache_cpu                         = Sim_GenerateProbe(p,cache_cpu)
    switch p. method_gen_probe
        case 'forward'
            %-------------------------------------
            %generate AS chirp
            [Chirp_forward,Chirp_backward] = Sim_ChirpAS(p,p.dis_pinhole2obj);
            %-------------------------------------
            %propagate to get probe
            temp_device                    = p. device;
            p. device                      = 'CPU';
            cache_cpu. probe               = Sim_AngularSpectrumPropagation(p, cache_cpu. aperture, Chirp_forward, 1);
            p. device                      = temp_device;
            
        case 'load'
            load(p. probe_name);
            temp                           = gather( eval(p. probe_name) );
            cache_cpu.probe                = single(temp);


    end
    %-------------------------------------
    %distribute energy
    probe_energy                           = sum(sum(abs(cache_cpu.probe).^2));
    cache_cpu.probe                        = cache_cpu.probe.*sqrt(p. flux./probe_energy);

end
