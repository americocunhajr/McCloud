
% -----------------------------------------------------------------
%  graph_bar2.m
%
%  This functions plots a bar histogram with two series.
%
%  input:
%  bins1 - bins locations vector
%  freq1 - frequency counts vector
%  bins2 - bins locations vector
%  freq2 - frequency counts vector
%  leg1  - legend 1
%  leg2  - legend 2
%  xlab  - x axis label
%  ylab  - y axis label
%  xmin  - x axis minimum value
%  xmax  - x axis maximum value
%  ymin  - y axis minimum value
%  ymax  - y axis maximum value
%  gname - graph name
%  flag  - output file format (optional)
%
%  output:
%  gname.eps - output file in eps format (optional)
% ----------------------------------------------------------------- 
%  programmer: Americo Barbosa da Cunha Junior
%              americo.cunhajr@gmail.com
%
%  last update: Jan 4, 2012
% -----------------------------------------------------------------

% -----------------------------------------------------------------
function fig = graph_bar2(bins1,freq1,bins2,freq2,leg1,leg2,...
                          xlab,ylab,xmin,xmax,ymin,ymax,gname,flag)
    
    % check number of arguments
    if nargin < 13
        error('Too few inputs.')
    elseif nargin > 14
        error('Too many inputs.')
    elseif nargin == 13
        flag = 'none';
    end

    % check arguments
    if length(bins1) ~= length(freq1)
        error('bins1 and freq1 vectors must be same length')
    end
    
    if length(bins2) ~= length(freq2)
        error('bins2 and freq2 vectors must be same length')
    end
    
    if length(bins1) ~= length(bins2)
        error('bins1 and bins2 vectors must be same length')
    end
    
    fig = figure('Name',gname,'NumberTitle','off');
    hold on
    fh1 = bar(bins1,freq1,0.8);
    fh2 = bar(bins2,freq2,0.8);
    set(gcf,'color','white');
    set(gca,'position',[0.2 0.2 0.7 0.7]);
    set(gca,'Box','on');
    set(gca,'TickDir','out','TickLength',[.02 .02]);
    set(gca,'XMinorTick','on','YMinorTick','on');
    set(gca,'XGrid','off','YGrid','on');
    set(gca,'XColor',[.3 .3 .3],'YColor',[.3 .3 .3]);
    set(gca,'FontName','Helvetica');
    set(gca,'FontSize',20);
    %set(gca,'XTick',xmin:xmax);
    %set(gca,'YTick',ymin:ymax);
    %axis([xmin xmax ymin ymax]);
    
    if ( strcmp(xmin,'auto') || strcmp(xmax,'auto') )
        xlim('auto');
    else
        xlim([xmin xmax]);
    end
    
    if ( strcmp(ymin,'auto') || strcmp(ymax,'auto') )
        ylim('auto');
    else
        ylim([ymin ymax]);
    end
    
    set(fh1,'FaceColor','none');
    set(fh1,'EdgeColor','b');
    set(fh1,'LineStyle','-');
    set(fh2,'FaceColor','none');
    set(fh2,'EdgeColor','m');
    set(fh2,'LineStyle','-');
    leg = legend(leg1,leg2);
    set(leg,'FontSize',12);
    set(leg,'interpreter', 'latex');
    Xlab = xlabel(xlab,'FontSize',20,'FontName','AvantGarde');
    Ylab = ylabel(ylab,'FontSize',20,'FontName','AvantGarde');
    set(Xlab,'interpreter','latex');
    set(Ylab,'interpreter','latex');
    
    if ( strcmp(flag,'eps') )
        saveas(gcf,gname,'epsc2');
        gname = [gname, '.eps'];
        graph_fixPSlinestyle(gname,gname);
    end
    
    hold off

return
% -----------------------------------------------------------------
