%--------------------------------------------------------------------------
%Author: TaoLiu
%Date: 24/2/2023
%Development logs
%09/2022 improve image quality
%11/2022 try different experimental parameters
%02/2023 get stable high quality image and rewrite the whole algorithm
%04/2023 try biological sample
%09/2023 try votex beam
%02/2024 propose and add scaling gradient algorithm
%05/2024 finish data analysis for all data
%--------------------------------------------------------------------------

%%
%-------------------------------------
%Parameters definition
clear all;
addpath('Support Functions');
addpath('Data Base');
%     rng('shuffle');
%------------------------------------
%experiment setting
p. binning                                     = 1;
p. sz_fft                                      = 512./p.binning;
p. lambda                                      = 632.8e-6;
p. dis_obj2modu                                = 11.5;
p. dis_modu2ccd                                = 30;
p. dis_obj2focus                               = 0;
p. dx_dp                                       = 6.5e-3.*p.binning;
p. dx_obj                                      = p. lambda.*p.dis_modu2ccd./p.sz_fft./p.dx_dp;
p. dx_modu                                     = p. lambda.*p.dis_modu2ccd./p.sz_fft./p.dx_dp;
%units are mm
%-------------------------------------
%reconstruction setting
p. recon_iter                                  = 800;
p. upsampling                                  = 1;
p. show_results_every                          = 99999;
p. probe_update_after                          = 9999;
p. object_update_after                         = 0;
p. offset_object                               = 100;%unit px
p. modu_update_after                           = 9999;
p. pos_refine_after                            = 10;%10
p. pos_beta_update_method                      = 'Tao';% [Tao / Zhang] %different rules to update pos feedback coefficient
p. pos_feeback_coeffient                       = 100;
p. alpha_modu                                  = 0.9;
p. algswitch                                   = AlgSeqGen(p. recon_iter,'HIO-type' ,9999, 50,2, p. recon_iter-10);
p. sz_support                                  = 1.05;%valid for serial reconstruction
p. shift_support                               = [0, 0];
p. deconv_method                               = "none"; %[vwnr,lucy,combined,none]
p. deconv_iter                                 = [25,15];%the first number is the period of update kernel, the second is iterations in each update
%-------------------------------------
%assemble object position setting
p. known_pos                                   = true; %false = parallel, true = serial reconstruction
p. assemble_iter                               = 150; %valid when position is unknown
p. assemble_seq                                = 'linear'; %[random / linear] valid for ePIE and PIE
p. obj_update_method                           = 'ePIE';% [ePIE / PIE /  AVG ]
p. probe_update_method                         = 'AVG';% [ePIE / PIE /  AVG ]
p. alpha_object                                = 1;%for ePIE and PIE
p. alpha_probe                                 = 0.9;%for ePIE and PIE
p. method_gen_probe                            = 'load';% [load / support /dp_avg_ifft / ones]
p. probe_name                                  = 'Sim_probe';% only valid for load probe method
p. trans_precision                             = 5;
%-------------------------------------
%the coordinate setting is valid when position is known
p. xy_inverse                                  = false;%false
p. x_inverse                                   = true;%true
p. y_inverse                                   = true;%true
%-------------------------------------
%diffraction pattern setting
p. data_source                                 = 'SUSTech420';%[nanoMAX / SUSTech420 / I13]
p. data_location                               = 'E:\Paper_TaoLiu\Ptychography without priori position information\Figure\Figure5 2024.6.29\Simulation_ModulationPtychography\Sim Data Base\0.46471\data_raw';%'E:\RA file\Beamline_material\I13-2013July\Expt\single_shot\15245\data',E:/RA file/Beamline_material/nanoMAX_2023_11_6/Data/Code/Data base
p. data_num                                    = 31;%valid for nanoMAX 27
p. num_dp_used                                 = "all";%["all" xx]; specify the number of dp used
p. dp_trust_region                             = [1e-18,1e8];
%bounds are included
%-------------------------------------
% modulator setting if applicable
p. modu_update_method                          = 'AVG';%['AVG',PIE ePIE]
p. modulator_name                              = 'Sim_modulator';
p. method_gen_modulator                        = 'load';%[load / ones / dps_avg]
%-------------------------------------
%prepare cache
cache_cpu                                      = PrepareDP(p);
cache_cpu. modulator_guess                     = GnerateModulator(cache_cpu, p);
device                                         = gpuDevice(1);
reset(device);
[p,cache_cpu,cache_gpu]                        = PrepareCache(p,cache_cpu);
%

%-------------------------------------
%%
%reconstruction process
%--------------------------------------------------------------------------
if p. known_pos                                == false
    %-------------------------------------
    %Parallel mode
    [p,cache_cpu,cache_gpu]                    = ParallelModulationPtychography(p, cache_cpu , cache_gpu);
    %-------------------------------------
else
    %-------------------------------------
    %Serial mode
    [p,cache_cpu,cache_gpu]                    = SerialModulationPtychography(p, cache_cpu , cache_gpu);
    %-------------------------------------
end
%%
% gview(gather((abs(cache_gpu.object_guess))),1,'abs');
%  [wf_out, dx] = focus(gather(cache_gpu.object_guess(:,:,144)), p.dx_obj, 0.05, 0.05,p.lambda, 'AS');
% [wf_out, dx] = focus(gather(cache_gpu.modulator_guess), p.dx_obj, -(0), 0.05,p.lambda, 'AS');
%plot section
% ShowReconstruction(cache_gpu.probe_guess,cache_gpu.object_guess_whole);
% ShowTrajectory(cache_gpu,'error');
%%
% [wf_out, dx] = focus(gather(probe_known_pos), p.dx_obj, 1.50, 0.05,p.lambda, 'AS');

