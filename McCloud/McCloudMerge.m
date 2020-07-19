
% -----------------------------------------------------------------
%  McCloudMerge.m
%
%  This functions computes statistics from MC simulation.
%
%  input:
%  n         - potency of MC samples in text ( Ns = 4^(3+n) )
%  case_name - name of simulation case
%  input     - filename with path of process output (data matrix)
%  output    - filename with path to save output data
%
% ----------------------------------------------------------------- 
%  programmers: Americo Barbosa da Cunha Junior
%               Rafael Nasser
%
%  last update: Dec 25, 2012
% -----------------------------------------------------------------

% -----------------------------------------------------------------
function McCloudMerge(n,case_name,input,output)

    % start time
    tic
    
    % convert input string to double
    N  = str2double(n);
    
    % total of samples
    Ns = 4^(3+N);
    
    % number of chucks and samples in chuck
    nChunks = (4^(N-1));
    sChunks = 4^4;
    
    disp(' ');
    disp([' *** Merge with ', num2str(Ns),...
                                 ' samples [4^(3+', n ,')] *** ']);                         
    
                             
    % pre processing
	% -----------------------------------------------------------
	disp(' '); 
	disp(' --- Pre Processing --- ');
	disp(' ');
	disp('    ... ');
	disp(' ');
	
    
	% simulation parameters
	[t0,t1,rho,E,d,A,L,c,k,kNL,m,...
	 alpha1,alpha2,sigma,nlflag,...
	 Nx,dx,xmesh,dt,time,Ndt,...
	 Nmodes,wn,phi,grad_phi,lambda] = ...
	 randbar_fixed_mass_spring__phys_param(case_name);
 
	% positions of interest
	X1    = floor((3/3)*Nx);
	X2    = floor((2/3)*Nx);
	X3    = floor((1/3)*Nx);

	% instants of interest
	T1    = floor((2/2)*Ndt);
	T2    = floor((1/2)*Ndt);

	% steady state instant estimation
	Tss = floor((1/5)*Ndt);
 
	% frequency domain analysis parameters
	[fs,fcut,nfft,freq,win] = sigproclib_freq_param(dt,Ndt,Tss);
    
    % preallocate memory
     U_x1t1     = zeros(1,nChunks*sChunks);
    Ut_x1t1     = zeros(1,nChunks*sChunks);
    
     S_U_x1     = zeros(1,nfft/2);
    S_Ut_x1     = zeros(1,nfft/2);
    
     U_t1_mean  = zeros(1,Nx);
    Ut_t1_mean  = zeros(1,Nx);
     U_t1_var   = zeros(1,Nx);
    Ut_t1_var   = zeros(1,Nx);
     U_t1_M2    = zeros(1,Nx);
    Ut_t1_M2    = zeros(1,Nx);
    
     U_x1_mean  = zeros(1,Ndt);
    Ut_x1_mean  = zeros(1,Ndt);
     U_x1_var   = zeros(1,Ndt);
    Ut_x1_var   = zeros(1,Ndt);
     U_x1_M2    = zeros(1,Ndt);
    Ut_x1_M2    = zeros(1,Ndt);
    
    n1 = sChunks;
    n2 = sChunks;
	
    % open file to save results
    try
        fid1 = fopen(input,'r');
    catch
        disp(' cannot load input file ');
        return
    end
    
    % define line format
    nColsOutput = 2*(nfft/2) + 4*Nx + 4*Ndt + 2*sChunks;
    sformat1    = mat2str(repmat('%e;',1,nColsOutput));
    
    nr01 = nfft/2;
    nr02 = nr01 + nfft/2;
    nr03 = nr02 + Nx;
    nr04 = nr03 + Nx;
    nr05 = nr04 + Ndt;
    nr06 = nr05 + Ndt;
    nr07 = nr06 + Nx;
    nr08 = nr07 + Nx;
    nr09 = nr08 + Ndt;
    nr10 = nr09 + Ndt;
    nr11 = nr10 + sChunks;
	
	toc
	% -----------------------------------------------------------
    
    
    % Merge Process
	% -----------------------------------------------------------
    for i=1:1:nChunks
        
        disp([' Chunk ', num2str(i)]);
        
        % read line from txt (sChunks samples)
        r            = fscanf(fid1, sformat1, [1,nColsOutput]);
        
        S_U_x1_r     = r(1,     1:nr01);
        S_Ut_x1_r    = r(1,nr01+1:nr02);
         U_t1_mean_r = r(1,nr02+1:nr03);
        Ut_t1_mean_r = r(1,nr03+1:nr04);
         U_x1_mean_r = r(1,nr04+1:nr05);
        Ut_x1_mean_r = r(1,nr05+1:nr06);
         U_t1_M2_r   = r(1,nr06+1:nr07);
        Ut_t1_M2_r   = r(1,nr07+1:nr08);
         U_x1_M2_r   = r(1,nr08+1:nr09);
        Ut_x1_M2_r   = r(1,nr09+1:nr10);
         U_x1t1_r    = r(1,nr10+1:nr11);
        Ut_x1t1_r    = r(1,nr11+1:end);
        
        % compute mean, var, and M2
        [U_t1_mean,U_t1_var,U_t1_M2] = ...
	     sigproclib_meanvar_pairwise(n1,n2,U_t1_mean,U_t1_mean_r,U_t1_M2,U_t1_M2_r);
        
        [Ut_t1_mean,Ut_t1_var,Ut_t1_M2] = ...
	     sigproclib_meanvar_pairwise(n1,n2,Ut_t1_mean,Ut_t1_mean_r,Ut_t1_M2,Ut_t1_M2_r);
        
        [U_x1_mean,U_x1_var,U_x1_M2] = ...
	     sigproclib_meanvar_pairwise(n1,n2,U_x1_mean,U_x1_mean_r,U_x1_M2,U_x1_M2_r);

        [Ut_x1_mean,Ut_x1_var,Ut_x1_M2] = ...
	     sigproclib_meanvar_pairwise(n1,n2,Ut_x1_mean,Ut_x1_mean_r,Ut_x1_M2,Ut_x1_M2_r);
     
        n1 = n1 + n2;
        n2 = sChunks;
        
        % compute spectral density function
        S_U_x1  = S_U_x1  + S_U_x1_r;
        S_Ut_x1 = S_Ut_x1 + S_Ut_x1_r;
        
        % merge PDF data
         U_x1t1(1,(i-1)*sChunks+1:(i-1)*sChunks+sChunks) =  U_x1t1_r(1,:);
        Ut_x1t1(1,(i-1)*sChunks+1:(i-1)*sChunks+sChunks) = Ut_x1t1_r(1,:);
        
    end
    
    % close output file
    fclose(fid1);
    
    % normalize spectral density function
    S_U_x1  =  S_U_x1 / nChunks;
    S_Ut_x1 = S_Ut_x1 / nChunks;
    
    
    % estimate PDFs
    %Nbins = sqrt(Ns);
    Nbins = 1024;
    
    [U_x1t1_bins,U_x1t1_freq]   = sigproclib_pdf1(U_x1t1(1,:),Nbins);
    [Ut_x1t1_bins,Ut_x1t1_freq] = sigproclib_pdf1(Ut_x1t1(1,:),Nbins);
    
    U_x1t1_bins  = U_x1t1_bins';
    Ut_x1t1_bins = Ut_x1t1_bins';

% kernel smooth density estimation
%    N_supp = 4*sqrt(Ns);    
%    [U_x1t1_pdf,U_x1t1_supp] = ...
%     ksdensity(sigproclib_norm_randvar(U_x1t1(1,:)),'npoints',N_supp);
%    [Ut_x1t1_pdf,Ut_x1t1_supp] = ...
%     ksdensity(sigproclib_norm_randvar(Ut_x1t1(1,:)),'npoints',N_supp);
    
    
    % save output data
    m = [S_U_x1 S_Ut_x1 U_t1_mean Ut_t1_mean U_x1_mean Ut_x1_mean ...
                U_t1_var Ut_t1_var U_x1_var Ut_x1_var ...
                U_x1t1_bins Ut_x1t1_bins U_x1t1_freq Ut_x1t1_freq];

% kernel smooth density output
%     m = [S_U_x1 S_Ut_x1 U_t1_mean Ut_t1_mean U_x1_mean Ut_x1_mean ...
%                 U_t1_var Ut_t1_var U_x1_var Ut_x1_var ...
%                 U_x1t1_supp Ut_x1t1_supp U_x1t1_pdf Ut_x1t1_pdf];
    
    % open output file
    fid2     = fopen(output,'w');    
    sformat2 = mat2str(repmat('%e;',size(m)));
    
    % save output data into a file
    fprintf(fid2,sformat2,m);
    
    % close output file
    fclose(fid2);
    % -----------------------------------------------------------
    
     
    toc
    
return
% -----------------------------------------------------------------
