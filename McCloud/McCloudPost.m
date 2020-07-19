
% -----------------------------------------------------------------
%  McCloudPost.m
%
%  This functions post process MC simulation data.
%
%  input:
%  n         - potency of MC samples in text ( Ns = 4^(3+n) )
%  case_name - name of simulation case
%  input     - filename with path of maerge output (data matrix)
%
% ----------------------------------------------------------------- 
%  programmer: Americo Barbosa da Cunha Junior
%
%  last update: Dec 25, 2012
% -----------------------------------------------------------------

% -----------------------------------------------------------------
function McCloudPost(n,case_name,input)

    % start time
    tic

    % convert input string to double
    N  = str2double(n);
    
    % total of samples
    Ns = 4^(3+N);
    
    disp(' ');
    disp([' *** Post with ', num2str(Ns),...
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
 
    % number of bins
    %Nbins = sqrt(Ns);
    Nbins = 1024;
 
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
	
    
    % open data file
    try
        data_file = load(input);
    catch
        disp('cannot load input file');
        return
    end
    
    % define line format
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
    nr11 = nr10 + Nbins;
    nr12 = nr11 + Nbins;
    nr13 = nr12 + Nbins;
    
    
    % read from data file
%    S_U_x1       = data_file(1,     1:nr01)';
%    S_Ut_x1      = data_file(1,nr01+1:nr02)';
%     U_t1_mean   = data_file(1,nr02+1:nr03)';
%    Ut_t1_mean   = data_file(1,nr03+1:nr04)';
     U_x1_mean   = data_file(1,nr04+1:nr05)';
    Ut_x1_mean   = data_file(1,nr05+1:nr06)';
%     U_t1_var    = data_file(1,nr06+1:nr07)';
%    Ut_t1_var    = data_file(1,nr07+1:nr08)';
     U_x1_var    = data_file(1,nr08+1:nr09)';
    Ut_x1_var    = data_file(1,nr09+1:nr10)';
     U_x1t1_bins = data_file(1,nr10+1:nr11)';
    Ut_x1t1_bins = data_file(1,nr11+1:nr12)';
     U_x1t1_freq = data_file(1,nr12+1:nr13)';
    Ut_x1t1_freq = data_file(1,nr13+1: end)';
    
%     U_t1_upp =  sqrt(U_t1_var);
%     U_t1_low = -sqrt(U_t1_var);
%    Ut_t1_upp =  sqrt(Ut_t1_var);
%    Ut_t1_low = -sqrt(Ut_t1_var);

     U_x1_upp =  U_x1_mean + sqrt(U_x1_var);
     U_x1_low =  U_x1_mean - sqrt(U_x1_var);
    Ut_x1_upp = Ut_x1_mean + sqrt(Ut_x1_var);
    Ut_x1_low = Ut_x1_mean - sqrt(Ut_x1_var);
	
	toc
	% -----------------------------------------------------------
    
    
    % save histograms data
    % -----------------------------------------------------------
    
    % open file to save results
    try
        fid=fopen(['hist_',num2str(Ns),'.csv'],'w');
    catch
        disp(' cannot open output file ');
        return
    end
    
    % define line format
    nColsOutput = 4*Nbins;
    sformat     = mat2str(repmat('%e;',1,nColsOutput));
    
    % output vector
    r = [U_x1t1_freq U_x1t1_bins Ut_x1t1_freq Ut_x1t1_bins];
    
    % save results in txt
    fprintf(fid,sformat,r);
    
    % close results file
    fclose(fid);
    % -----------------------------------------------------------
    

    % Post Precessing
    % -----------------------------------------------------------
	disp(' '); 
	disp(' --- Post Processing --- ');
	disp(' ');
	disp('    ... ');
	disp(' ');
	

% plot U(X1,T1,w) PDF
% -----------------------------------------------------------
xlab   = ' norm. displacement at $x=L$ and $t=T$';
ylab   = ' probability density function';
xmin   = -4.0;
xmax   =  4.0;
ymin   = 0.0;
ymax   = 1.0;
gname  = [num2str(case_name),'__pdf_u_x1t1'];
flag   = 'eps';
fig1a  = graph_bar1(U_x1t1_bins,U_x1t1_freq,...
                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig1a);
% -----------------------------------------------------------


% plot U(X2,T1,w) PDF
% -----------------------------------------------------------
xlab   = ' norm. displacement at $x=2L/3$ and $t=T$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_u_x2t1'];
flag   = 'eps';
% fig1b = graph_bar1(U_x2t1_bins,U_x2t1_freq,...
%                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
% close(fig1b);
% -----------------------------------------------------------


% plot U(X3,T1,w) PDF
% -----------------------------------------------------------
xlab   = ' norm. displacement at $x=L/3$ and $t=T$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_u_x3t1'];
flag   = 'eps';
% fig1c = graph_bar1(U_x3t1_bins,U_x3t1_freq,...
%                     xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
% close(fig1c);
% -----------------------------------------------------------


% plot Ut(X1,T1,w) PDF
% -----------------------------------------------------------
xlab   = ' norm. velocity at $x=L$ and $t=T$';
ylab   = ' probability density function';
xmin   = -6.0;
xmax   =  6.0;
ymin   = 0.0;
ymax   = 1.0;
gname  = [num2str(case_name),'__pdf_ut_x1t1'];
flag   = 'eps';
fig1d = graph_bar1(Ut_x1t1_bins,Ut_x1t1_freq,...
                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig1d);
% -----------------------------------------------------------


% plot Ut(X2,T1,w) PDF
% -----------------------------------------------------------
xlab   = ' norm. velocity at $x=2L/3$ and $t=T$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_ut_x2t1'];
flag   = 'eps';
% fig1e = graph_bar1(Ut_x2t1_bins,Ut_x2t1_freq,...
%                     xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
% close(fig1e);
% -----------------------------------------------------------


% plot Ut(X3,T1,w) PDF
% -----------------------------------------------------------
xlab   = ' norm. velocity at $x=L/3$ and $t=T$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_ut_x3t1'];
flag   = 'eps';
% fig1f = graph_bar1(Ut_x3t1_bins,Ut_x3t1_freq,...
%                     xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
% close(fig1f);
% -----------------------------------------------------------


% plot E(w) PDF
% -----------------------------------------------------------
xlab   = ' Elastic Modulus $(GPa)$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_E'];
flag   = 'eps';
%fig2   = graph_type1(E_supp*1.0e-9,E_pdf,...
%                     xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
%close(fig2);
% -----------------------------------------------------------


% plot U(X1,t,w) confidence interval
% -----------------------------------------------------------
leg1  = ' mean~value~~~';
leg2  = ' mean $\pm$~std. dev.~~~';
xlab  = ' time~~$(ms)$';
ylab  = ' displacement at $x=L~~(\mu m)$';
xmin  = t0*1.0e3;
xmax  = t1*1.0e3;
ymin  = -600.0;
ymax  =  600.0;
gname = [num2str(case_name),'__ci_u_x1'];
flag  = 'eps';
fig3a  = graph_ci1(time*1.0e3,U_x1_mean*1.0e6,...
                   U_x1_upp*1.0e6,U_x1_low*1.0e6,leg1,leg2,...
                   xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig3a);
% -----------------------------------------------------------


% plot Ut(X1,t,w) confidence interval
% -----------------------------------------------------------
leg1  = ' mean~value~~~';
leg2  = ' mean $\pm$~std. dev.~~~';
xlab  = ' time~~$(ms)$';
ylab  = ' velocity at $x=L~~(m/s)$';
xmin  = t0*1.0e3;
xmax  = t1*1.0e3;
ymin  = -15.0;
ymax  =  20.0;
gname = [num2str(case_name),'__ci_ut_x1'];
flag  = 'eps';
fig3b = graph_ci1(time*1.0e3,Ut_x1_mean,...
                   Ut_x1_upp,Ut_x1_low,leg1,leg2,...
                   xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig3b);
% -----------------------------------------------------------


% plot phase space at x=L
% -----------------------------------------------------------
xlab  = ' displacement at $x=L~~(\mu m)$';
ylab  = ' velocity at $x=L~~(m/s)$';
xmin  = -600.0;
xmax  =  600.0;
ymin  = -10.0;
ymax  =  15.0;
gname = [num2str(case_name),'__phase_space_x1'];
flag  = 'eps';
fig4a = graph_type1(U_x1_mean*1.0e6,Ut_x1_mean,...
                   xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig4a);
% -----------------------------------------------------------

toc
	
return
% -----------------------------------------------------------------
