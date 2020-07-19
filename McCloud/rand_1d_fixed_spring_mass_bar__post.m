
% ----------------------------------------------------------------- 
%  rand_1d_fixed_spring_mass_bar__post.m
%
%  This script post process the data that comes from the
%  simulation of a random 1D fixed-mass-spring bar system.
% ----------------------------------------------------------------- 
%  programmer: Americo Barbosa da Cunha Junior
%              americo.cunhajr@gmail.com
%
%  last update: Aug 22, 2012
% -----------------------------------------------------------------



% plot U(X1,T1,w) histogram
% -----------------------------------------------------------
xlab   = ' normalized displacement at $x=L$ and $t=T$';
ylab   = ' probability density function';
xmin   = -4.0;
xmax   =  4.0;
ymin   = 0.0;
ymax   = 1.0;
gname  = [num2str(case_name),'__pdf_u_x1t1'];
flag   = 'eps';
fig1a  = graph_type1(U_x1t1_supp,U_x1t1_pdf,...
                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig1a);
% -----------------------------------------------------------


% plot U(X2,T1,w) histogram
% -----------------------------------------------------------
xlab   = ' normalized displacement at $x=2L/3$ and $t=T$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_u_x2t1'];
flag   = 'eps';
% fig1b = graph_type1(U_x2t1_supp,U_x2t1_pdf,...
%                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
% close(fig1b);
% -----------------------------------------------------------


% plot U(X3,T1,w) histogram
% -----------------------------------------------------------
xlab   = ' normalized displacement at $x=L/3$ and $t=T$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_u_x3t1'];
flag   = 'eps';
% fig1c = graph_type1(U_x3t1_supp,U_x3t1_pdf,...
%                     xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
% close(fig1c);
% -----------------------------------------------------------


% plot Ut(X1,T1,w) histogram
% -----------------------------------------------------------
xlab   = ' normalized velocity at $x=L$ and $t=T$';
ylab   = ' probability density function';
xmin   = -6.0;
xmax   =  6.0;
ymin   = 0.0;
ymax   = 1.0;
gname  = [num2str(case_name),'__pdf_ut_x1t1'];
flag   = 'eps';
fig1d = graph_type1(Ut_x1t1_supp,Ut_x1t1_pdf,...
                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig1d);
% -----------------------------------------------------------


% plot Ut(X2,T1,w) histogram
% -----------------------------------------------------------
xlab   = ' normalized velocity at $x=2L/3$ and $t=T$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_ut_x2t1'];
flag   = 'eps';
% fig1e = graph_type1(Ut_x2t1_supp,Ut_x2t1_pdf,...
%                     xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
% close(fig1e);
% -----------------------------------------------------------


% plot Ut(X3,T1,w) histogram
% -----------------------------------------------------------
xlab   = ' normalized velocity at $x=L/3$ and $t=T$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_ut_x3t1'];
flag   = 'eps';
% fig1f = graph_type1(Ut_x3t1_supp,Ut_x3t1_pdf,...
%                     xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
% close(fig1f);
% -----------------------------------------------------------


% plot E(w) histogram
% -----------------------------------------------------------
xlab   = ' Elastic Modulus $(GPa)$';
ylab   = ' probability density function';
xmin   = 'auto';
xmax   = 'auto';
ymin   = 'auto';
ymax   = 'auto';
gname  = [num2str(case_name),'__pdf_E'];
flag   = 'eps';
fig2   = graph_type1(E_supp*1.0e-9,E_pdf,...
                     xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig2);
% -----------------------------------------------------------


% plot U(X1,t,w) confidence interval
% -----------------------------------------------------------
leg1  = ' mean~value~~~';
leg2  = [' ',num2str(p),'\%~prob.~~~'];
xlab  = ' $t~~(ms)$';
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
leg2  = [' ',num2str(p),'\%~prob.~~~'];
xlab  = ' $t~~(ms)$';
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
