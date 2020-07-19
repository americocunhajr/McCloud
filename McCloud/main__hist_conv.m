


clc
clear all
close all



% open data file
try
    data_file1 = load('hist_16384.dat');
    data_file2 = load('hist_65536.dat');
    data_file3 = load('hist_262144.dat');
    data_file4 = load('hist_1048576.dat');
catch
    disp('cannot load input file');
    return
end

Nbins = 1024;

% define line format
nr01 = Nbins;
nr02 = nr01 + Nbins;
nr03 = nr02 + Nbins;
nr04 = nr03 + Nbins;


freq_u1  = data_file1(1,1:nr01);
bins_u1  = data_file1(1,nr01+1:nr02);
freq_ut1 = data_file1(1,nr02+1:nr03);
bins_ut1 = data_file1(1,nr03+1:nr04);

freq_u2  = data_file2(1,1:nr01);
bins_u2  = data_file2(1,nr01+1:nr02);
freq_ut2 = data_file2(1,nr02+1:nr03);
bins_ut2 = data_file2(1,nr03+1:nr04);

freq_u3  = data_file3(1,1:nr01);
bins_u3  = data_file3(1,nr01+1:nr02);
freq_ut3 = data_file3(1,nr02+1:nr03);
bins_ut3 = data_file3(1,nr03+1:nr04);

freq_u4  = data_file4(1,1:nr01);
bins_u4  = data_file4(1,nr01+1:nr02);
freq_ut4 = data_file4(1,nr02+1:nr03);
bins_ut4 = data_file4(1,nr03+1:nr04);


xmin = min(bins_u1);
xmax = max(bins_u1);

res_u1 = norm_L2(xmin,xmax,freq_u2-freq_u1)
res_u2 = norm_L2(xmin,xmax,freq_u3-freq_u2)
res_u3 = norm_L2(xmin,xmax,freq_u4-freq_u3)

xmin = min(bins_ut1);
xmax = max(bins_ut1);

res_ut1 = norm_L2(xmin,xmax,freq_ut2-freq_ut1)
res_ut2 = norm_L2(xmin,xmax,freq_ut3-freq_ut2)
res_ut3 = norm_L2(xmin,xmax,freq_ut4-freq_ut3)




% res_u1 PDF
% -----------------------------------------------------------
xlab   = ' norm. displacement at $x=L$ and $t=T$';
ylab   = ' residual';
xmin   = -4.0;
xmax   =  4.0;
ymin   =  0.0;
ymax   =  0.3;
gname  = 'pdf_res_u1';
flag   = 'eps';
fig1a  = graph_bar1(bins_u1,abs(freq_u2-freq_u1),...
                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig1a);
% -----------------------------------------------------------


% res_u2 PDF
% -----------------------------------------------------------
xlab   = ' norm. displacement at $x=L$ and $t=T$';
ylab   = ' residual';
xmin   = -4.0;
xmax   =  4.0;
ymin   =  0.0;
ymax   =  0.3;
gname  = 'pdf_res_u2';
flag   = 'eps';
fig1b  = graph_bar1(bins_u2,abs(freq_u3-freq_u2),...
                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig1b);
% -----------------------------------------------------------


% res_u3 PDF
% -----------------------------------------------------------
xlab   = ' norm. displacement at $x=L$ and $t=T$';
ylab   = ' residual';
xmin   = -4.0;
xmax   =  4.0;
ymin   =  0.0;
ymax   =  0.3;
gname  = 'pdf_res_u3';
flag   = 'eps';
fig1c  = graph_bar1(bins_u3,abs(freq_u4-freq_u3),...
                    xlab,ylab,xmin,xmax,ymin,ymax,gname,flag);
close(fig1c);
% -----------------------------------------------------------



