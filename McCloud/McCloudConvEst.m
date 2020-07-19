
% -----------------------------------------------------------------
%  McCloudConvEst.m
%
%  This script 
%
% ----------------------------------------------------------------- 
%  programmer: Americo Barbosa da Cunha Junior
%
%  last update: Jan 4, 2013
% -----------------------------------------------------------------


clc
clear all
close all


% program header
% -----------------------------------------------------------
disp(' '); 
disp(' --- McCloud Convergence Estimation --- ');
disp(' ');
disp('    ... ');
disp(' ');


% start time
tic

% case name
case_name = 'case1a';

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
    data_file1 = load('cloud_16384/case1a_post.dat');
    data_file2 = load('cloud_65536/case1a_post.dat');
    data_file3 = load('cloud_262144/case1a_post.dat');
    data_file4 = load('cloud_1048576/case1a_post.dat');
catch
    disp('cannot load one or several of input files');
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
    

% read data from files
% S_U_x1__01       = data_file1(1,     1:nr01)';
% S_Ut_x1__01      = data_file1(1,nr01+1:nr02)';
% U_t1_mean__01    = data_file1(1,nr02+1:nr03)';
% Ut_t1_mean__01   = data_file1(1,nr03+1:nr04)';
U_x1_mean__01    = data_file1(1,nr04+1:nr05)';
Ut_x1_mean__01   = data_file1(1,nr05+1:nr06)';
% U_t1_var__01     = data_file1(1,nr06+1:nr07)';
% Ut_t1_var__01    = data_file1(1,nr07+1:nr08)';
U_x1_var__01     = data_file1(1,nr08+1:nr09)';
Ut_x1_var__01    = data_file1(1,nr09+1:nr10)';
U_x1t1_bins__01  = data_file1(1,nr10+1:nr11)';
Ut_x1t1_bins__01 = data_file1(1,nr11+1:nr12)';
U_x1t1_freq__01  = data_file1(1,nr12+1:nr13)';
Ut_x1t1_freq__01 = data_file1(1,nr13+1: end)';


% S_U_x1__02       = data_file2(1,     1:nr01)';
% S_Ut_x1__02      = data_file2(1,nr01+1:nr02)';
% U_t1_mean__02    = data_file2(1,nr02+1:nr03)';
% Ut_t1_mean__02   = data_file2(1,nr03+1:nr04)';
U_x1_mean__02    = data_file2(1,nr04+1:nr05)';
Ut_x1_mean__02   = data_file2(1,nr05+1:nr06)';
% U_t1_var__02     = data_file2(1,nr06+1:nr07)';
% Ut_t1_var__02    = data_file2(1,nr07+1:nr08)';
U_x1_var__02     = data_file2(1,nr08+1:nr09)';
Ut_x1_var__02    = data_file2(1,nr09+1:nr10)';
U_x1t1_bins__02  = data_file2(1,nr10+1:nr11)';
Ut_x1t1_bins__02 = data_file2(1,nr11+1:nr12)';
U_x1t1_freq__02  = data_file2(1,nr12+1:nr13)';
Ut_x1t1_freq__02 = data_file2(1,nr13+1: end)';


% S_U_x1__03       = data_file3(1,     1:nr01)';
% S_Ut_x1__03      = data_file3(1,nr01+1:nr02)';
% U_t1_mean__03    = data_file3(1,nr02+1:nr03)';
% Ut_t1_mean__03   = data_file3(1,nr03+1:nr04)';
U_x1_mean__03    = data_file3(1,nr04+1:nr05)';
Ut_x1_mean__03   = data_file3(1,nr05+1:nr06)';
% U_t1_var__03     = data_file3(1,nr06+1:nr07)';
% Ut_t1_var__03    = data_file3(1,nr07+1:nr08)';
U_x1_var__03     = data_file3(1,nr08+1:nr09)';
Ut_x1_var__03    = data_file3(1,nr09+1:nr10)';
U_x1t1_bins__03  = data_file3(1,nr10+1:nr11)';
Ut_x1t1_bins__03 = data_file3(1,nr11+1:nr12)';
U_x1t1_freq__03  = data_file3(1,nr12+1:nr13)';
Ut_x1t1_freq__03 = data_file3(1,nr13+1: end)';


% S_U_x1__04       = data_file4(1,     1:nr01)';
% S_Ut_x1__04      = data_file4(1,nr01+1:nr02)';
% U_t1_mean__04    = data_file4(1,nr02+1:nr03)';
% Ut_t1_mean__04   = data_file4(1,nr03+1:nr04)';
U_x1_mean__04    = data_file4(1,nr04+1:nr05)';
Ut_x1_mean__04   = data_file4(1,nr05+1:nr06)';
% U_t1_var__04     = data_file4(1,nr06+1:nr07)';
% Ut_t1_var__04    = data_file4(1,nr07+1:nr08)';
U_x1_var__04     = data_file4(1,nr08+1:nr09)';
Ut_x1_var__04    = data_file4(1,nr09+1:nr10)';
U_x1t1_bins__04  = data_file4(1,nr10+1:nr11)';
Ut_x1t1_bins__04 = data_file4(1,nr11+1:nr12)';
U_x1t1_freq__04  = data_file4(1,nr12+1:nr13)';
Ut_x1t1_freq__04 = data_file4(1,nr13+1: end)';



% compute convergence metrics
res1_mean_disp_x1 = abs(U_x1_mean__02 - U_x1_mean__01);
res2_mean_disp_x1 = abs(U_x1_mean__03 - U_x1_mean__02);
res3_mean_disp_x1 = abs(U_x1_mean__04 - U_x1_mean__03);

res1_mean_velo_x1 = abs(Ut_x1_mean__02 - Ut_x1_mean__01);
res2_mean_velo_x1 = abs(Ut_x1_mean__03 - Ut_x1_mean__02);
res3_mean_velo_x1 = abs(Ut_x1_mean__04 - Ut_x1_mean__03);

res1_std_disp_x1 = abs(sqrt(U_x1_var__02) - sqrt(U_x1_var__01));
res2_std_disp_x1 = abs(sqrt(U_x1_var__03) - sqrt(U_x1_var__02));
res3_std_disp_x1 = abs(sqrt(U_x1_var__04) - sqrt(U_x1_var__03));

res1_std_velo_x1 = abs(sqrt(Ut_x1_var__02) - sqrt(Ut_x1_var__01));
res2_std_velo_x1 = abs(sqrt(Ut_x1_var__03) - sqrt(Ut_x1_var__02));
res3_std_velo_x1 = abs(sqrt(Ut_x1_var__04) - sqrt(Ut_x1_var__03));

res1_pdf_disp_x1t1 = abs(U_x1t1_freq__02 - U_x1t1_freq__01);
res2_pdf_disp_x1t1 = abs(U_x1t1_freq__03 - U_x1t1_freq__02);
res3_pdf_disp_x1t1 = abs(U_x1t1_freq__04 - U_x1t1_freq__03);

res1_pdf_velo_x1t1 = abs(Ut_x1t1_freq__02 - Ut_x1t1_freq__01);
res2_pdf_velo_x1t1 = abs(Ut_x1t1_freq__03 - Ut_x1t1_freq__02);
res3_pdf_velo_x1t1 = abs(Ut_x1t1_freq__04 - Ut_x1t1_freq__03);





% plot residue for U(X1,t,w) mean
% -----------------------------------------------------------
leg1  = ' ~~~~~65~536~';
leg2  = ' ~~~262~144~';
leg3  = ' 1~048~576~';
xlab  = ' time~~$(ms)$';
ylab  = ' residue of disp. mean';
xmin  = t0*1.0e3;
xmax  = t1*1.0e3;
ymin  = 'auto';
ymax  = 'auto';
gname = 'res_mean_disp_x1';
flag  = 'eps';
fig1a  = graph_semilogy3(time*1.0e3,res1_mean_disp_x1,...
                         time*1.0e3,res2_mean_disp_x1,...
                         time*1.0e3,res3_mean_disp_x1,...
                         leg1,leg2,leg3,...
                         xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig1a);
% -----------------------------------------------------------


% plot residue for Ut(X1,t,w) mean
% -----------------------------------------------------------
leg1  = ' ~~~~~65~536~';
leg2  = ' ~~~262~144~';
leg3  = ' 1~048~576~';
xlab  = ' time~~$(ms)$';
ylab  = ' residue of veloc. mean';
xmin  = t0*1.0e3;
xmax  = t1*1.0e3;
ymin  = 'auto';
ymax  = 'auto';
gname = 'res_mean_velo_x1';
flag  = 'eps';
fig1b  = graph_semilogy3(time*1.0e3,res1_mean_velo_x1,...
                         time*1.0e3,res2_mean_velo_x1,...
                         time*1.0e3,res3_mean_velo_x1,...
                         leg1,leg2,leg3,...
                         xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig1b);
% -----------------------------------------------------------


% plot residue for U(X1,t,w) std
% -----------------------------------------------------------
leg1  = ' ~~~~~65~536~';
leg2  = ' ~~~262~144~';
leg3  = ' 1~048~576~';
xlab  = ' time~~$(ms)$';
ylab  = ' residue of disp. std. dev.';
xmin  = t0*1.0e3;
xmax  = t1*1.0e3;
ymin  = 'auto';
ymax  = 'auto';
gname = 'res_std_disp_x1';
flag  = 'eps';
fig2a  = graph_semilogy3(time*1.0e3,res1_std_disp_x1,...
                         time*1.0e3,res2_std_disp_x1,...
                         time*1.0e3,res3_std_disp_x1,...
                         leg1,leg2,leg3,...
                         xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig2a);
% -----------------------------------------------------------


% plot residue for Ut(X1,t,w) std
% -----------------------------------------------------------
leg1  = ' ~~~~~65~536~';
leg2  = ' ~~~262~144~';
leg3  = ' 1~048~576~';
xlab  = ' time~~$(ms)$';
ylab  = ' residue of veloc. std. dev.';
xmin  = t0*1.0e3;
xmax  = t1*1.0e3;
ymin  = 'auto';
ymax  = 'auto';
gname = 'res_std_velo_x1';
flag  = 'eps';
fig2b  = graph_semilogy3(time*1.0e3,res1_std_velo_x1,...
                         time*1.0e3,res2_std_velo_x1,...
                         time*1.0e3,res3_std_velo_x1,...
                         leg1,leg2,leg3,...
                         xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig2b);
% -----------------------------------------------------------


% plot residue for U(X1,T1,w) PDF
% -----------------------------------------------------------
leg1  = ' ~~~~~65~536~';
leg2  = ' ~~~262~144~';
leg3  = ' 1~048~576~';
xlab   = ' norm. disp. at $x=L$ and $t=T$';
ylab   = ' residue of displ. PDF';
xmin   = -4.0;
xmax   =  4.0;
ymin   =  0.0;
ymax   =  0.3;
gname  = 'res_pdf_displ_x1t1';
flag   = 'eps';
fig3a  = graph_bar3(U_x1t1_bins__01,res1_pdf_disp_x1t1,...
                    U_x1t1_bins__01,res2_pdf_disp_x1t1,...
                    U_x1t1_bins__01,res3_pdf_disp_x1t1,...
                    leg1,leg2,leg3,...
                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig3a);
% -----------------------------------------------------------


% plot residue of Ut(X1,T1,w) PDF
% -----------------------------------------------------------
leg1  = ' ~~~~~65~536~';
leg2  = ' ~~~262~144~';
leg3  = ' 1~048~576~';
xlab   = ' norm. veloc. at $x=L$ and $t=T$';
ylab   = ' residue of veloc. PDF';
xmin   = -6.0;
xmax   =  6.0;
ymin   =  0.0;
ymax   =  0.3;
gname  = 'res_pdf_velo_x1t1';
flag   = 'eps';
fig3b  = graph_bar3(Ut_x1t1_bins__01,res1_pdf_velo_x1t1,...
                    Ut_x1t1_bins__01,res2_pdf_velo_x1t1,...
                    Ut_x1t1_bins__01,res3_pdf_velo_x1t1,...
                    leg1,leg2,leg3,...
                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig3b);
% -----------------------------------------------------------



% compute L2 norm of PDF residuals
% -----------------------------------------------------------
xmin = min(U_x1t1_bins__01);
xmax = max(U_x1t1_bins__01);

L2norm_res1_pdf_disp_x1t1 = norm_L2(xmin,xmax,res1_pdf_disp_x1t1)
L2norm_res2_pdf_disp_x1t1 = norm_L2(xmin,xmax,res2_pdf_disp_x1t1)
L2norm_res3_pdf_disp_x1t1 = norm_L2(xmin,xmax,res3_pdf_disp_x1t1)

xmin = min(Ut_x1t1_bins__01);
xmax = max(Ut_x1t1_bins__01);

L2norm_res1_pdf_velo_x1t1 = norm_L2(xmin,xmax,res1_pdf_velo_x1t1)
L2norm_res2_pdf_velo_x1t1 = norm_L2(xmin,xmax,res2_pdf_velo_x1t1)
L2norm_res3_pdf_velo_x1t1 = norm_L2(xmin,xmax,res3_pdf_velo_x1t1)
% -----------------------------------------------------------





