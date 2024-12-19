function [overlap_ratio] = Forloop_Overlap(pos,diameter)
    overlap_ratio = zeros(length(pos.shiftx)-1,1);
    for index = 1:(length(pos.shiftx)-1)
        %
        r = diameter/2;
        pos2.x(1) = pos.shiftx(index);
        pos2.y(1) = pos.shifty(index);

        pos2.x(2) = pos.shiftx(index+1);
        pos2.y(2) = pos.shifty(index+1);
        
        d = sqrt((pos2.x(1) - pos2.x(2)).^2  +(pos2.y(1) - pos2.y(2)).^2 );
        theta1 = acos((r.^2+d.^2-r.^2)./(2.*r.*d));
        S_s1 = 2*theta1/2/pi*pi*r.^2;
        S_triangle1 = 1/2*r.^2*sin(2*theta1);

        s_overlap = 2*(S_s1 - S_triangle1);
        s_total = 2*pi*r.^2-s_overlap;

        %
        
        % overlap_ratio3 = (acos(sqrt((pos2.x(1) - pos2.x(2)).^2  +(pos2.y(1) - pos2.y(2)).^2 )./2./r) - 1/2*sin(2*acos(sqrt((pos2.x(1) - pos2.x(2)).^2  +(pos2.y(1) - pos2.y(2)).^2 )./2./r)))./(pi-acos(sqrt((pos2.x(1) - pos2.x(2)).^2  +(pos2.y(1) - pos2.y(2)).^2 )./2./r) + 1/2*sin(2*acos(sqrt((pos2.x(1) - pos2.x(2)).^2  +(pos2.y(1) - pos2.y(2)).^2 )./2./r)));
        overlap_ratio(index) = s_overlap./s_total;
%         [map, rx, ry, overlap_ratio(index)] = OverlapMap(pos2, diameter, shape);


    end
    
end


