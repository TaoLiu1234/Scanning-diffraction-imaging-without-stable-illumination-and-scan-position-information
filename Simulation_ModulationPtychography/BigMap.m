function [bigmap] = BigMap(obj_guess)
    bigmap = ones(128*12,128*12);
    num_pic = size(obj_guess,3);
    index_pic = 1;
    for row = 1:128:12*128
        for column = 1:128:12*128
            if index_pic <= num_pic
                bigmap(row:row+127,column:column+127) = CutoutCenter(circshift(obj_guess(:,:,index_pic),[4,10]),128);
                index_pic = index_pic +1;
            else
                %
            end
        end
    end
end

