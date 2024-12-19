%--------------------------------------------------------------------------
%Author: Taoliu
%Date: 9/5/2023
%--------------------------------------------------------------------------

function cache_cpu                       = Sim_GenerateTrajectory(p,cache_cpu)
    switch p. scan_shape
        case 'mesh'
            %-------------------------------------
            %generate scan trajectory
            x_seq                        = 1:p. scan_step:p. scan_step*round(sqrt(p. num_points));
            y_seq                        = 1:p. scan_step:p. scan_step*round(sqrt(p. num_points));
            [x_px,y_px]                  = meshgrid(x_seq,y_seq);
            
            for index_column             = 1:sqrt(p.num_points)
                if mod(index_column,2)   == 0
                    temp_column          = flipud(y_px(:,index_column));
                    y_px(:,index_column) = temp_column;
                end
            end

            x_px                         = reshape(x_px,[],1);
            y_px                         = reshape(y_px,[],1);
            pos_px.shiftx                = p.sz_fft/2 + x_px;
            pos_px.shifty                = p.sz_fft/2 + y_px;
            random_x                     = rand(p.num_points,1);
            random_y                     = rand(p.num_points,1);
            %-------------------------------------
            %break the period
            pos_px.shiftx                = pos_px.shiftx + 0.1*p.scan_step*random_x;
            pos_px.shifty                = pos_px.shifty + 0.1*p.scan_step*random_y;
            
        case 'round'
            %
    end
    cache_cpu. pos_px                    = pos_px;

end
