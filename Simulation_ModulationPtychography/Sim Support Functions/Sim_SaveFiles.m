%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 14/5/2023
%varargin denotes the variables that 
%--------------------------------------------------------------------------
function []                               = Sim_SaveFiles(p,Cache)
    %-------------------------------------
    %create files
    mkdir(['Sim Data Base/' p.file_name]);
    mkdir(['Sim Data Base/' p.file_name '/data_raw']);
    %-------------------------------------
    %copy variables
    if p.device                           == 'GPU'
        raw_dps                           = Sim_Mat2cell_fc(gather(Cache.dp));
        g.pos_readout_x                   = gather(Cache.pos_px.shiftx.*p.dx_obj);
        g.pos_readout_y                   = gather(Cache.pos_px.shifty.*p.dx_obj);
        Sim_modulator                     = gather(Cache.modulator);
        Sim_probe                         = gather(Cache.probe(:,:,1));
    else
        raw_dps                           = Sim_Mat2cell_fc((Cache.dp));
        g.pos_readout_x                   = Cache.pos_px.shiftx.*p.dx_obj;
        g.pos_readout_y                   = Cache.pos_px.shifty.*p.dx_obj;
        Sim_modulator                     = Cache.modulator;
        Sim_probe                         = Cache.probe(:,:,1);
    end
    %-------------------------------------
    %save dps
    raw_dps_file                          = ['Sim Data Base/' p.file_name '/data_raw/raw_dps_proj1'];
    save(raw_dps_file, 'raw_dps', '-v7.3');
    %-------------------------------------
    %save position info
    pos_dir                               = ['Sim Data Base/' p.file_name '/data_raw/expt_para'];
    save(pos_dir, 'g', '-v7.3');
    %-------------------------------------
    %save modulator
    save Sim_modulator Sim_modulator
    %-------------------------------------
    %save probe
    save Sim_probe Sim_probe
    
end

