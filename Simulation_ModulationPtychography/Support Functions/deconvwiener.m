function J = deconvwiener(varargin)
% Parse inputs to verify valid function calling syntaxes and arguments
[I, PSF, ncorr, icorr, sizeI, classI, sizePSF, numNSdim] = ...
    parseInputs(varargin{:});

% Compute H so that it has the same size as I.
H = psf2otf(PSF, sizeI);

if isempty(icorr)
    % noise-to-signal power ratio is given
    S_u = ncorr;
    S_x = 1;
    
else 
    % noise & signal frequency characteristics are given
    NSD = length(numNSdim);
    
    S_u = powerSpectrumFromACF(ncorr, NSD, numNSdim, sizePSF, sizeI);
    S_x = powerSpectrumFromACF(icorr, NSD, numNSdim, sizePSF, sizeI);

end

% Compute the denominator of G in pieces.
denom = abs(H).^2;
denom = denom .* S_x;
denom = denom + S_u;
clear S_u

% Make sure that denominator is not 0 anywhere.  Note that denom at this
% point is nonnegative, so we can just add a small term without fearing a
% cancellation with a negative number in denom.
denom = max(denom, sqrt(eps));

G = conj(H) .* S_x;
clear H S_x
G = G ./ denom;
clear denom

% Apply the filter G in the frequency domain.
J = ifftn(G .* fftn(I));
clear G

% If I and PSF are both real, then any nonzero imaginary part of J is due to
% floating-point round-off error.
if isreal(I) && isreal(PSF)
    J = real(J);
end


%=====================================================================
function S = powerSpectrumFromACF(ACF, NSD, numNSdim, sizePSF, sizeI)
% Compute power spectrum from autocorrelation function.
%
% ACF - autocorrelation function
% NSD - number of nonsingleton dimensions of PSF
% NSD - nonsingleton dimensions of PSF
% sizePSF - size of the PSF
% sizeI  - size of the input image

sizeACF = size(ACF);
if (length(sizeACF)==2) && (sum(sizeACF==1)==1) && (NSD>1)
    %ACF is 1D
    % autocorrelation function and PSF has more than one non-singleton
    % dimension.Therefore, we extrapolate ACF using symmetry to all PSF
    % non-singleton dimensions & reshape it to include singletons.
    ACF = createNDfrom1D(ACF,NSD,numNSdim,sizePSF);
end

% Calculate power spectrum
S = abs(fftn(ACF,sizeI));
%---------------------------------------------------------------------

%=====================================================================
function [I, PSF, ncorr, icorr, sizeI, classI, sizePSF, numNSdim] = ...
    parseInputs(varargin)

% Defaults:
ncorr = 0;
icorr = [];

narginchk(2,4);

% First, check validity of class/real/finite for all except image at once:
% J = DECONVWNR(I,PSF,NCORR,ICORR)
input_names={'PSF','NCORR','ICORR'};
for n = 2:nargin,
    validateattributes(varargin{n},{'double' 'single'},{'real' 'finite'},...
                  mfilename,input_names{n-1},n);
end;

% Second, assign the inputs:
I = varargin{1};%        deconvwnr(A,PSF)
PSF = varargin{2};
switch nargin
  case 3,%                 deconvwnr(A,PSF,nsr)
    ncorr = varargin{3};
  case 4,%                 deconvwnr(A,PSF,ncorr,icorr)
    ncorr = varargin{3};
    icorr = varargin{4};
end

% Third, Check validity of the input parameters: 

% Input image I
sizeI = size(I);
classI = class(I);
validateattributes(I,{'uint8','uint16','int16','double','single'},{'real' ...
                    'finite'},mfilename,'I',1);
if prod(sizeI)<2,
    error(message('images:deconvwnr:mustHaveAtLeast2Elements'))
elseif ~isa(I,'double')
    I = im2double(I);
end

% PSF array
sizePSF = size(PSF);
if prod(sizePSF)<2,
    error(message('images:deconvwnr:psfMustHaveAtLeast2Elements'))
elseif all(PSF(:)==0),
    error(message('images:deconvwnr:psfMustNotBeZeroEverywhere'))
end

% NSR, NCORR, ICORR
if isempty(ncorr) && ~isempty(icorr),
    error(message('images:deconvwnr:invalidInput'))
end

% Sizes: PSF size cannot be larger than the image size in non-singleton dims
[sizeI, sizePSF, sizeNCORR] = padlength(sizeI, sizePSF, size(ncorr));
numNSdim = find(sizePSF~=1);
if any(sizeI(numNSdim) < sizePSF(numNSdim))
    error(message('images:deconvwnr:psfMustBeSmallerThanImage'))
end

if isempty(icorr) && (prod(sizeNCORR)>1) && ~isequal(sizeNCORR,sizeI)
    error(message('images:deconvwnr:nsrMustBeScalarOrArrayOfSizeA'))
end
%---------------------------------------------------------------------

%=====================================================================
%
function f = createNDfrom1D(ACF,NSD,numNSdim,sizePSF)
% create a ND-ACF from 1D-ACF assuming rotational symmetry and preserving
% singleton dimensions as in sizePSF

% First, make a 2D square ACF from the given 1D ACF. Calculate the
% quarter of the 2D square & unfold it symmetrically to the full size. 
% 1. Define grid with a half of the ACF points (assuming that ACF
% is symmetric). Grid is 2D and it values from 0 to 1.
cntr = ceil(length(ACF)/2);%location of the ACF center
vec = (0:(cntr-1))/(cntr-1);
[x,y] = meshgrid(vec,vec);% grid for the quarter
      
% 2. Calculate radius vector to each grid-point and number the points
% above the diagonal in order to use them later for ACF interpolation.
radvect = sqrt(x.^2+y.^2);
nums = [1;find(triu(radvect)~=0)];

% 3. Interpolate ACF at radius-vector distance for those points.
acf1D = ACF(cntr-1+[1:cntr cntr]);% last point is for the corner.
radvect(nums) = interp1([vec sqrt(2)],acf1D,radvect(nums));

% 4. Unfold 45 degree triangle to a square, and then the square
% quarter to a full square matrix.
radvect = triu(radvect) + triu(radvect,1).';
acf = radvect([cntr:-1:2 1:cntr],[cntr:-1:2 1:cntr]);
        
% Second, once 2D is ready, extrapolate 2D-ACF to NSD-ACF
if NSD > 2% that is create volumetric ACF
    idx0 = repmat({':'},[1 NSD]);
    nextDimACF = [];
    for n = 3:NSD% make sure not to exceed the PSF size
        numpoints = min(sizePSF(numNSdim(n)),length(ACF));
        % and take only the central portion of 1D-ACF
        vec = cntr-ceil(numpoints/2)+(1:numpoints);
        for m = 1:numpoints
            idx = [idx0(1:n-1),{m}];
            nextDimACF(idx{:}) = ACF(vec(m))*acf; %#ok<AGROW>
        end
        acf = nextDimACF;
    end
end

% Third, reshape NSD-ACF to the right dimensions to include PSF
% singletons.
idx1 = repmat({1},[1 length(sizePSF)]);
idx1(numNSdim) = repmat({':'},[1 NSD]);
f(idx1{:}) = acf;
%---------------------------------------------------------------------      

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