function J = deconvwl_tandem(varargin)

if length(varargin) == 3
    fmcfw= abs(deconvwiener(varargin{1}.^2,gather((varargin{2}))));
    fmcfw(fmcfw<0)=0;
    fmcfw=single(fmcfw/sum(sum(fmcfw)));
    varargin{4} = fmcfw;   
end

% Parse inputs to verify valid function calling syntaxes and arguments
[J,PSF,NUMIT,WEIGHT,sizeI,classI,numNSdim]=parse_inputs(varargin{:});

% 1. Prepare PSF. PSF's OTF could take care of it:
sizeOTF = sizeI;
sizeOTF(numNSdim) = sizeI(numNSdim);
H = psf2otf(gather(PSF),sizeOTF);

% 2. Prepare parameters for iterations
idx = repmat({':'},[1 length(sizeI)]);
for k = numNSdim % index replicates for non-singleton PSF sizes only
    idx{k} = reshape(repmat(1:sizeI(k),[1 1]),[1*sizeI(k) 1]);
end

wI = max(J{1},0);% at this point  - positivity constraint
J{2} = J{2}(idx{:});
scale = real(ifftn(conj(H).*fftn(WEIGHT(idx{:})))) + sqrt(eps);

% 3. L_R Iterations
lambda = 2*any(J{4}(:)~=0);
for k = lambda + (1:NUMIT)
    
    % 3.a Make an image predictions for the next iteration
    if k > 2
        lambda = (J{4}(:,1).'*J{4}(:,2))/(J{4}(:,2).'*J{4}(:,2) +eps);
        lambda = max(min(lambda,1),0);% stability enforcement
    end
    fmcf=varargin{4};
    Y = max(J{2} +lambda*(J{2} - J{3}),0);

    % 3.b  Make core for the LR estimation
    CC = corelucy(Y,H,wI,idx);
    
    % 3.c Determine next iteration image & apply positivity constraint
    J{3} = J{2};
    w=0.1 - 0.01*(k-1)/(NUMIT-1);
%     w=0;
    J{2} = (1-w)*max(Y.*real(ifftn(conj(H).*CC))./scale,0)+w*fmcf;
     
    clear CC;
    J{4} = [J{2}(:)-Y(:) J{4}(:,1)];
end
clear wI H scale Y;

% 4. Convert the right array  to the original image class & output whole thing
num = 1 + strcmp(classI{1},'notcell');

if num==2 % the input & output is NOT a cell
    J = J{2};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Function: parse_inputs
function [J,PSF,NUMIT,WEIGHT,sizeI,classI,numNSdim] = ...
    parse_inputs(varargin)

NUMIT = varargin{3};% Number of  iterations, usually produces good

% First, assign the inputs starting with the image
%
if iscell(varargin{1})% input cell is used to resume interrupted iterations
    classI{1} = 'cell';% or interrupt the iteration to resume it later
    J = varargin{1};
else % no-cell array is used to do a single set of iterations
    classI{1} = 'notcell';
    J{1} = varargin{1};% create a cell array in order to do the iterations
end

% check the Image, which is the first array of the cell
classI{2} = class(J{1});

validateattributes(J{1},{'uint8' 'uint16' 'double' 'int16','single'},...
    {'real' 'nonempty' 'finite'},mfilename,'I',1);

if length(J{1})<2
    error(message('images:deconvlucy:inputImagesMustHaveAtLeast2Elements'))
elseif ~isa(J{1},'double')
    J{1} = im2double(J{1});
end

% now since the image is OK&double, we assign the rest of the J cell
len = length(J);
if len == 1 % J = {I} will be reassigned to J = {I,I,0,0}
    J{2} = varargin{4};
    J{3} = 0;
elseif len ~= 4 % J = {I,J,Jm1,gk} has to have 4 or 1 arrays
    error(message('images:deconvlucy:inputCellMustHave1or4Elements'));
else % check if J,Jm1,gk are double in the input cell
    if ~all([isa(J{2},'double'),isa(J{3},'double'),isa(J{4},'double')])
        error(message('images:deconvlucy:inputImageCellElementsMustBeDouble'))
    end
end

% Second, Assign the rest of the inputs:
%
PSF = varargin{2};%      deconvlucy(I,PSF)

% PSF array
[sizeI, sizePSF] = padlength(size(J{1}), size(PSF));
WEIGHT=ones(sizeI);
numNSdim = find(sizePSF~=1);

if length(J)==3 % assign the 4-th element of input cell now
    J{4}(prod(sizeI)*1^length(numNSdim),2) = 0;
end


function f = corelucy(Y,H,wI,idx)

ReBlurred = real(ifftn(H.*fftn(Y)));

% An Estimate for the next step
ReBlurred(ReBlurred == 0) = eps;
AnEstim = wI./ReBlurred + eps;
ImRatio = AnEstim(idx{:});
f = fftn(ImRatio);

function varargout = padlength(varargin)
 
% Find longest size vector.  Call its length "numDims".
numDims = zeros(nargin, 1);
for k = 1:nargin
    numDims(k) = length(varargin{k});
end
numDims = max(numDims);

% Append ones to input vectors so that they all have the same length;
% assign the results to the output arguments.
limit = max(1,nargout);
varargout = cell(1,limit);
for k = 1 : limit
    varargout{k} = [varargin{k} ones(1,numDims-length(varargin{k}))];
end
