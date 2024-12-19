%--------------------------------------------------------------------------
%Author: TaoLiu,Fucai Zhang
%Date: 9/5/2023
%Note: This is the simulation code for paper ""
%--------------------------------------------------------------------------
%%
%-------------------------------------
clear all;
addpath('Sim Support Functions');
addpath('Sim Data Base');
rng('shuffle');
addpath('Support Functions');
%-------------------------------------
%simulation settings
p. data_source                        = 'SUSTech420';

p. device                             = 'CPU';
p. sz_fft                             = 512*1;
p. lambda                             = Ev2mm(8000);
p. sz_pinhole                         = 1e-3;
p. shift_pinhole                      = [0 0];
p. dis_pinhole2obj                    = 0;
p. dis_obj2modu                       = 1.5;
p. dis_modu2ccd                       = 3500;
p. dx_dp                              = 75e-3;
p. dx_obj                             = p. lambda*p.dis_modu2ccd/p.sz_fft/p.dx_dp;
%units are mm
%-------------------------------------
%genrate aperture
cache_cpu                             = Sim_GenerateAperture(p);
%-------------------------------------
%generate probe
p. flux                               = 1e10;
p. method_gen_probe                   = 'load';%[ load / forward / zernike]
p. probe_name                         = 'probe_214';% valid for load mode
cache_cpu                             = Sim_GenerateProbe(p,cache_cpu);
%-------------------------------------
%generate scan trajectory
p. num_points                         = 36;
p. scan_step                          = 5; %units pixel
p. scan_shape                         = 'mesh';
p. pos_error                          = false;
p. pos_error_level                    = 1;%percentage
cache_cpu                             = Sim_GenerateTrajectory(p,cache_cpu);
%-------------------------------------
%generate object
p. obj_amp_name                       = 'peppers';
p. obj_amp_range                      = [0.3,1];
p. obj_phase_name                     = 'peppers';
p. obj_offset                         = 5; %pixel
p. obj_phase_variation                = pi/5;%rad
cache_cpu                             = Sim_GenerateObject(p,cache_cpu);
%-------------------------------------
%generate modulator
p. modulator_name                     = 'modulator_v3_mesh';
p. method_gen_modulator               = 'load';%[load / rand / ones]
p. low_pass_filter_modu               = false; %**to finish**
p. modulator_phase_variation          = 1*pi;%rad
p. low_pass_radius                    = 200;% units pixels
cache_cpu                             = Sim_GnerateModulator(p,cache_cpu);
%-------------------------------------
%post processing settings
p. probe_perturbation                 = false; %[plus/ multiply / intensity / combined / false] **to finish**
p. probe_plus_perturbation_mode       = 'rand'; %[rand]
p. probe_plus_perturbation_range      = 1;%percentage

p. probe_pos_perturbation_level       = 10;%pixel

p. probe_multiply_perturbation_mode   = 'rand'; %[rand]
p. probe_plus_perturbation_range      = 1;%percentage

p. probe_intensity_perturbation_range = 10;%percentage

p. poisson_noise                      = true;
p. quantification_noise               = false;
p. camera_bit_depth                   = 16; %valid when readout noise is true
p. camera_psf                         = false; %**to finish**
p. camera_psf_sigma                   = 0.01; %valid when psf is trues

p. gaussian_noise                     = false; %to finish
p. gaussian_variance                  = 1;%to finish
%-------------------------------------
%prepare cache
[Cache]                               = Sim_PrepareCache(p,cache_cpu);
%-------------------------------------
%% generate diffraction patterns
[Cache]                               = Sim_GenerateDP(p, Cache);
% plot section
% -------------------------------------
% plot overlap map
% p = Sim_ShowOverlap(Cache,p);

[overlap_ratio] = Forloop_Overlap(Cache.pos_px,154);
p.overlap_ratio = mean(overlap_ratio);
p. file_name                          = num2str(p.overlap_ratio);
p.overlap_ratio
%-------------------------------------
%show trajectory
ShowTrajectory(Cache,'single');
%-------------------------------------
%plot diffraction pattern
Sim_gview(gather(Cache.dp),1,'Diffraction Patterns');
%-------------------------------------
%plot scanned part of object
Sim_gview( gather( abs(Cache.part_object).*(abs(Cache.probe)./max(max(abs(Cache.probe))) +0.4)),1,'Scanned Objects');
%-------------------------------------
%plot scaning probe
Sim_gview(gather((Cache.probe)),1,'Scanning Probe','abs');
%% save files
% Sim_SaveFiles(p,Cache);