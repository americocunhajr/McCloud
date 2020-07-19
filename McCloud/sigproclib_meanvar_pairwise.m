
% -----------------------------------------------------------------
%  sigproclib_meanvar_pairwise.m
%
%  This functions computes mean, variance and
%  square difference sum of a data set given mean
%  and square difference sum of two data partitions.
%
%  Refs.:
%  Chan, T. F.; Golub, G. H.; LeVeque, R. J. (1979)
%  "Updating Formulae and a Pairwise Algorithm
%  for Computing Sample Variances".
%  Technical Report STAN-CS-79-773
%  Department of Computer Science
%  Stanford University
%
%  Bennett, J.; Peblay, P.; Roe, D.; Thompson, D. (2009)
%  "Numerical Stable, Single-Pass, 
%  Parallel Statistics Algorithms"
%  IEEE International Conference on 
%  Cluster Computing and Workshops
%
%  input:
%  n1    - ensemble 1 size 
%  n2    - ensemble 2 size
%  mean1 - ensemble 1 mean
%  mean2 - ensemble 2 mean
%  M2_1  - ensemble 1 square difference sum
%  M2_2  - ensemble 2 square difference sum
%  
%  output:
%  mean - combined data mean
%  var  - combined data variance
%  M2   - combined data square difference sum
%
% ----------------------------------------------------------------- 
%  programmer: Americo Barbosa da Cunha Junior
%
%  last update: Sep 4, 2012
% -----------------------------------------------------------------

% -----------------------------------------------------------------
function [mean_pair, var_pair, M2_pair] = ...
          sigproclib_meanvar_pairwise(n1,n2,mean1,mean2,M2_1,M2_2)
    
    % check number of arguments
    if nargin < 6
        error('Too few inputs.')
    elseif nargin > 6
        error('Too many inputs.')
    end
    
    % check input arguments
    if ( isinteger(n1) || isinteger(n2) )
       error('n1 and n2 must be integer numbers.')
    end
    
    if ( n1 <= 0 || n2 <= 0 )
        error('n1 and n2 must be positive.')
    end
    
    if ( size(mean1) ~= size(mean2) )
        error('mean matrices must have same dimension.')
    end
    
    if ( size(mean1) ~= size(mean2) )
        error('M2 matrices must have same dimension.')
    end
    
    if ( size(mean1) ~= size(M2_1) )
        error('mean and M2 matrices must have same dimension.')
    end
    
    
	% ensembles means difference
    delta21 = mean2 - mean1;

    % combined mean
    if ( floor(max(n1,n2)/min(n1,n2)) < 2 && max(n1,n2) > 1000 )
	    mean_pair = (n1/n)*mean1 + (n2/(n1 + n2))*mean2;
    else
    	mean_pair = mean1 + (n2/(n1 + n2))*delta21;
    end

    % combined square sum
    M2_pair = M2_1 + M2_2 + (n1*n2/(n1 + n2))*(delta21.^2);
    
    % combined variance estimatior
    var_pair = M2_pair / (n1 + n2 - 1);

return
% -----------------------------------------------------------------
