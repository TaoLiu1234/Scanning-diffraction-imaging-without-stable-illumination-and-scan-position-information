function [total_error,mean_error,std_error] = cal_error(pos1,pos2)
            pos1.shiftx                 = pos1.shiftx - pos1.shiftx(1);
            pos1.shifty                 = pos1.shifty - pos1.shifty(1);
            pos2.shiftx                 = pos2.shiftx - pos2.shiftx(1);
            pos2.shifty                 = pos2.shifty - pos2.shifty(1);

            %calculate error
            error_x = abs(pos1.shiftx - pos2.shiftx);
            error_y = abs(pos1.shifty - pos2.shifty);
            total_error = [error_x;error_y];
            mean_error = mean(total_error);
            std_error = std(total_error);
end

