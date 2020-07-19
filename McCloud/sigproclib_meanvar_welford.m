
% -----------------------------------------------------------------
%  sigproclib_meanvar_welford.m
%
%  This functions computes mean and variance of a given 
%  data sample using Welford-Knuth algorithm.
%
%  Ref.:
%  D. E. Knuth (1998)
%  The Art of Computer Programming,
%  volume 2: Seminumerical Algorithms
%  3rd ed., Addison-Wesley.
%   
%  B. P. Welford (1962)
%  "Note on a method for calculating 
%  corrected sums of squares and products".
%  Technometrics 4(3):419-420
%
%  input:
%  data - data matrix
%  
%  output:
%  mean - data mean
%  var  - data variance
%  M2   - data square difference sum
%
% ----------------------------------------------------------------- 
%  programmer: Americo Barbosa da Cunha Junior
%
%  last update: Sep 4, 2012
% -----------------------------------------------------------------

% -----------------------------------------------------------------
function [mean, var, M2] = sigproclib_meanvar_welford(data)

    % check number of arguments
    if nargin < 1
        error('Too few inputs.')
    elseif nargin > 1
        error('Too many inputs.')
    end
    
    [Nlin,Ncol] = size(data);
    
    % preallocate memory for mean and square sum vectors
    mean = zeros(1,Ncol);
    M2   = zeros(1,Ncol);
    
    % compute mean and square sum recursively
    for n=1:1:Nlin
    	
        delta = data(n,:) - mean;
        mean  = mean + delta / n;
        M2    = M2 + delta.*(data(n,:) - mean);
        
    end
    
    % variance estimatior
    var = M2 / (n - 1);

return
% -----------------------------------------------------------------
