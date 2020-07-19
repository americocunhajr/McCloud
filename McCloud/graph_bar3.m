
% -----------------------------------------------------------------
%  graph_bar3.m
%
%  This functions plots a bar histogram with three series.
%
%  input:
%  bins1 - bins locations vector 1
%  freq1 - frequency counts vector 1
%  bins2 - bins locations vector 2
%  freq2 - frequency counts vector 2
%  bins3 - bins locations vector 3
%  freq3 - frequency counts vector 3
%  leg1  - legend 1
%  leg2  - legend 2
%  leg3  - legend 3
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
function fig = graph_bar3(bins1,freq1,bins2,freq2,bins3,freq3,...
                          leg1,leg2,leg3,...
                          xlab,ylab,xmin,xmax,ymin,ymax,gname,flag)
    
    % check number of arguments
    if nargin < 16
        error('Too few inputs.')
    elseif nargin > 17
        error('Too many inputs.')
    elseif nargin == 16
        flag = 'none';
    end

    % check arguments
    if length(bins1) ~= length(freq1)
        error('bins1 and freq1 vectors must be same length')
    end
    
    if length(bins2) ~= length(freq2)
        error('bins2 and freq2 vectors must be same length')
    end
    
    if length(bins3) ~= length(freq3)
        error('bins3 and freq3 vectors must be same length')
    end
    
    if length(bins1) ~= length(bins2) || ...
         length(bins1) ~= length(bins3) || ...
           length(bins2) ~= length(bins3)
        error('bins1, bins2 and bins3 vectors must be same length')
    end
    
    
    fig = figure('Name',gname,'NumberTitle','off');
    hold on
    fh1 = bar(bins1,freq1,0.8);
    fh2 = bar(bins2,freq2,0.8);
    fh3 = bar(bins3,freq3,0.8);
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
    set(fh3,'FaceColor','none');
    set(fh3,'EdgeColor','g');
    set(fh3,'LineStyle','-');
    leg = legend(leg1,leg2,leg3);
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
