%--------------------------------------------------------------------------
%Author: Fucai Zhang
%Date: 28/1/2015
%--------------------------------------------------------------------------

function [ dp_cell ] = Sim_Mat2cell_fc( dpm )
% to convert a 3d array into a cell along the 3rd dimension 
% the data may be the diffraction pattern in my experiment 
% e.g a [512x512x30] dp will be converted to a array of 30 element each is
% a 512 x512 matrix. 
% fucai 
dp_cell              = num2cell(dpm, [1,2]);
dp_cell              = squeeze(dp_cell);

end

