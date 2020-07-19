
% -----------------------------------------------------------------
%  McCloudProcess.m
%
%  This functions runs MC simulation in a Cloud node.
%
%  input:
%  n         - potency of MC samples in text ( Ns = 4^(3+n) )
%  s         - index of seed in text
%  case_name - name of simulation case
%  output    - filename with path to save output data
%
% ----------------------------------------------------------------- 
%  programmers: Americo Barbosa da Cunha Junior
%               Rafael Nasser
%
%  last update: Dec 25, 2012
% -----------------------------------------------------------------

% -----------------------------------------------------------------
function McCloudProcess(n,s,case_name,output)
	
    % start time
    tic
	
    % convert input string to double
    N         = str2double(n);
    SeedIndex = str2double(s);
    
    % total of samples
    Ns = 4^(3+N);
    
    % number of chunks and samples in chunk
    nChunks = (4^(N-1));
    sChunks = 4^4;
    
    disp(' ');
    disp([' *** Process with ', num2str(Ns),...
                            ' samples [4^(3+', n ,')] *** ']);
    
    
    % name of the case that will be simulated
	disp(' '); 
	disp([' Case Name: ',num2str(case_name)]);
	disp(' ');
	
    
	% pre processing
	% -----------------------------------------------------------
	disp(' '); 
	disp(' --- Pre Processing --- ');
	disp(' ');
	disp('    ... ');
	disp(' ');
	
    
    % define statistical seed
    SeedStart    = 30081984;
    SeedInterval = Ns*5;        
    mySeed	     = (SeedStart+((SeedInterval*SeedIndex)));
	
	% simulation parameters
	[t0,t1,rho,E,d,A,L,c,k,kNL,m,...
	 alpha1,alpha2,sigma,nlflag,...
	 Nx,dx,xmesh,dt,time,Ndt,...
	 Nmodes,wn,phi,grad_phi,lambda] = ...
	 randbar_fixed_mass_spring__phys_param(case_name);
	
	% RNG seed
    rng_stream = RandStream('mt19937ar', 'Seed', mySeed);
    RandStream.setDefaultStream(rng_stream);
    
	if Ns > 1
    	% elastic modulus dispersion
	    delta_E = 0.1;
    	
	    % nonlinear stiffness dispersion
    	%delta_kNL = 0.01;
	
	    % random elastic modulus (Pa)
    	E = gamrnd(1.0/delta_E^2,E*delta_E^2,[Ns,1]);
    	
	    % random elastic modulus (N/m^3)
    	%kNL = gamrnd(1.0/delta_kNL^2,kNL*delta_kNL^2,[Ns,1]);
	end
	
	% normalized gaussian white noise
	WN = normrnd(0.0,1.0,[Ns Ndt]);

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
	
	% preallocate memory for u(X,t,w)
	U_x1 = zeros(sChunks,Ndt);
	% U_x2 = zeros(sChunks,Ndt);
	% U_x3 = zeros(sChunks,Ndt);
	
	% preallocate memory for ut(X,t,w)
	Ut_x1 = zeros(sChunks,Ndt);
	% Ut_x2 = zeros(sChunks,Ndt);
	% Ut_x3 = zeros(sChunks,Ndt);
	
	% preallocate memory for ux(X,t,w)
	% Ux_x1 = zeros(sChunks,Ndt);
	% Ux_x2 = zeros(sChunks,Ndt);
	% Ux_x3 = zeros(sChunks,Ndt);
	
	% preallocate memory for u(x,T,w)
	U_t1 = zeros(sChunks,Nx);
	% U_t2 = zeros(sChunks,Nx);
	
	% preallocate memory for ut(x,T,w)
	Ut_t1 = zeros(sChunks,Nx);
	% Ut_t2 = zeros(sChunks,Nx);
	
	% preallocate memory for ux(x,T,w)
	%Ux_t1 = zeros(sChunks,Nx);
	% Ux_t2 = zeros(sChunks,Nx);
	
	% preallocate memory for FFT of u(X,t,w)
	U_x1_fft = zeros(1,nfft/2);
	% U_x2_fft = zeros(1,nfft/2);
	% U_x3_fft = zeros(1,nfft/2);
	
	% preallocate memory for FFT of ut(X,t,w)
	Ut_x1_fft = zeros(1,nfft/2);
	% Ut_x2_fft = zeros(1,nfft/2);
	% Ut_x3_fft = zeros(1,nfft/2);
	
	% preallocate memory for spectral density of u(X,t,w)
	S_U_x1 = zeros(1,nfft/2);
	%S_U_x2 = zeros(1,nfft/2);
	%S_U_x3 = zeros(1,nfft/2);
	
	% preallocate memory for spectral density of ut(X,t,w)
	S_Ut_x1 = zeros(1,nfft/2);
	%S_Ut_x2 = zeros(1,nfft/2);
	%S_Ut_x3 = zeros(1,nfft/2);
	
	% iteration counter vector
    iter_vec = zeros(sChunks,1);
	
    % open file to save results
    try
        fid=fopen(output,'w');
    catch
        disp(' cannot open output file ');
        return
    end

    % define line format    
    nColsOutput = 2*(nfft/2) + 4*Nx + 4*Ndt + 2*sChunks;
    sformat     = mat2str(repmat('%e;',1,nColsOutput));
	
	toc
	% -----------------------------------------------------------
	
    
    % Monte Carlo Simulation
    % -----------------------------------------------------------
	disp(' ');
	disp(' --- Monte Carlo Simulation --- ');
	disp(' ');
	disp('    ... ');
	disp(' ');
    
    for pmc=1:1:nChunks
        
        disp([' Chunk ', num2str(pmc)]);
        disp(' Galerkin Simulation ');
        
        for imc=1:1:sChunks
            
            imc2 = (pmc-1)*sChunks + imc;
            
		    % physical parameters vector
		    %phys_param = [rho E(imc) A L k kNL(imc) alpha1 alpha2 sigma c m];
		    %phys_param = [rho E A L k kNL(imc) alpha1 alpha2 sigma c m];
		    phys_param = [rho E(imc2) A L k kNL alpha1 alpha2 sigma c m];
			
		    % Galerkin vectors and matrices
    		[M,C,K,F,U0,V0] = ...
     		randbar_fixed_mass_spring__galerkin(Nmodes,time,lambda,...
                                           		WN(imc2,:),phys_param);
            
		    % numerical integration of Galerkin ODE system
		    [Uj,Utj,~,iter_vec(imc)] = ...
		     newmark_ode_solver(M,C,K,F,U0,V0,...
                        		dt,Ndt,Nx,Nmodes,phi,nlflag,phys_param);
            
    		% compute U, Ut, and Ux from coeficients and modes
		    U_x1(imc,:) = phi(X1,:)*Uj;
			%U_x2(imc,:) = phi(X2,:)*Uj;
			%U_x3(imc,:) = phi(X3,:)*Uj;
     		
		    Ut_x1(imc,:) = phi(X1,:)*Utj;
			%Ut_x2(imc,:) = phi(X2,:)*Utj;
			%Ut_x3(imc,:) = phi(X3,:)*Utj;
    		
			%Ux_x1(imc,:) = grad_phi(X1,:)*Uj;
			%Ux_x2(imc,:) = grad_phi(X2,:)*Uj;
			%Ux_x3(imc,:) = grad_phi(X3,:)*Uj;
    		
		    U_t1(imc,:) = phi*Utj(:,T1);
			%U_t2(imc,:) = phi*Utj(:,T2);
     		
		    Ut_t1(imc,:) = phi*Utj(:,T1);
			%Ut_t2(imc,:) = phi*Utj(:,T2);
    		
			%Ux_t1(imc,:) = grad_phi*Uj(:,T1);
			%Ux_t2(imc,:) = grad_phi*Uj(:,T2);
            
            % steady state vectors
            U_x1_ss = sigproclib_sub_vector( U_x1(imc,:),Tss);
            %U_x2_ss = sigproclib_sub_vector( U_x2(imc,:),Tss);
            %U_x3_ss = sigproclib_sub_vector( U_x3(imc,:),Tss);
            Ut_x1_ss = sigproclib_sub_vector(Ut_x1(imc,:),Tss);
            %Ut_x2_ss = sigproclib_sub_vector(Ut_x2(imc,:),Tss);
            %Ut_x3_ss = sigproclib_sub_vector(Ut_x3(imc,:),Tss);
        	
		    % compute FFT of u(X,t,w)
		    U_x1_fft = ...
		    sigproclib_fft_1sided(win'.*(U_x1_ss-mean(U_x1_ss)),fs,nfft);
			%U_x2_fft = ...
			%sigproclib_fft_1sided(win'.*(U_x2_ss-mean(U_x2_ss)),fs,nfft);
			%U_x3_fft = ...
			%sigproclib_fft_1sided(win'.*(U_x3_ss-mean(U_x3_ss)),fs,nfft);
			
		    % compute FFT of ut(X,t,w)
		    Ut_x1_fft = ...
		    sigproclib_fft_1sided(win'.*(Ut_x1_ss-mean(Ut_x1_ss)),fs,nfft);
			%Ut_x2_fft = ...
			%sigproclib_fft_1sided(win'.*(Ut_x2_ss-mean(Ut_x2_ss)),fs,nfft);
			%Ut_x3_fft = ...
			%sigproclib_fft_1sided(win'.*(Ut_x3_ss-mean(Ut_x3_ss)),fs,nfft);
			
			% cumulative sum of FFT of u(X,t,w) square
		    S_U_x1 = S_U_x1 + U_x1_fft.*conj(U_x1_fft);
			%S_U_x2 = S_U_x2 + U_x2_fft.*conj(U_x2_fft);
			%S_U_x3 = S_U_x3 + U_x3_fft.*conj(U_x3_fft);
    		
		    % cumulative sum of FFT of ut(X,t,w) square
		    S_Ut_x1 = S_Ut_x1 + Ut_x1_fft.*conj(Ut_x1_fft);
			%S_Ut_x2 = S_Ut_x2 + Ut_x2_fft.*conj(Ut_x2_fft);
			%S_Ut_x3 = S_Ut_x3 + Ut_x3_fft.*conj(Ut_x3_fft);
			
        end
        
   
        disp(' Statistics ');
        
        % estimate spectral density function
		NormFactorS = 2.0*dt/nfft;
		S_U_x1      = smooth(NormFactorS*(S_U_x1/Ns))';
		%S_U_x2      = smooth(NormFactorS*( S_U_x2/Ns))';
		%S_U_x3      = smooth(NormFactorS*( S_U_x3/Ns))';
		S_Ut_x1     = smooth(NormFactorS*(S_Ut_x1/Ns))';
		%S_Ut_x2     = smooth(NormFactorS*(S_Ut_x2/Ns))';
		%S_Ut_x3     = smooth(NormFactorS*(S_Ut_x3/Ns))';  
        
        % estimate mean and square sum
        [ U_t1_mean, ~,  U_t1_M2] = sigproclib_meanvar_welford( U_t1);
        [Ut_t1_mean, ~, Ut_t1_M2] = sigproclib_meanvar_welford(Ut_t1);
        [ U_x1_mean, ~,  U_x1_M2] = sigproclib_meanvar_welford( U_x1);
        [Ut_x1_mean, ~, Ut_x1_M2] = sigproclib_meanvar_welford(Ut_x1);
        
        % sample data for PDFs
        U_x1t1  =  U_t1(:,X1)';
        Ut_x1t1 = Ut_t1(:,X1)';
        
        % output vector
        r = [S_U_x1 S_Ut_x1 U_t1_mean Ut_t1_mean U_x1_mean Ut_x1_mean ...
                    U_t1_M2 Ut_t1_M2 U_x1_M2 Ut_x1_M2 U_x1t1 Ut_x1t1];
		
        % save results in txt
        disp([' Save Chunk ', num2str(pmc), ' in file ']);
        
        fprintf(fid,sformat,r);
        
        toc
    end
    % -----------------------------------------------------------        
    
    % close results file
    fclose(fid);
    
return
% -----------------------------------------------------------------
