
% -----------------------------------------------------------------
%  graph_typeN.m
%
%  This functions plots a graph with N curves.
%
%  input:
%  x1    - x data matrix
%  y1    - y data matrix
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
%  last update: Sep 9, 2012
% -----------------------------------------------------------------

% -----------------------------------------------------------------
function fig = graph_typeN(x1,y1,...
                           xlab,ylab,xmin,xmax,ymin,ymax,gname,flag)
    
    % check number of arguments
    if nargin < 9
        error('Too few inputs.')
    elseif nargin > 10
        error('Too many inputs.')
    elseif nargin == 9
        flag = 'none';
    end

    % check arguments
    if length(x1) ~= length(y1)
        error('x1 and y1 matrices must be same length')
    end
    
    fig = figure('Name',gname,'NumberTitle','off');
    fh = plot(x1,y1);
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
    
    set(fh,'LineWidth',0.25);
    set(fh,'MarkerSize',2.0);
    set(fh,'MarkerFaceColor','w');
    set(fh,'MarkerEdgeColor','k');
    labX = xlabel(xlab,'FontSize',20,'FontName','AvantGarde');
    labY = ylabel(ylab,'FontSize',20,'FontName','AvantGarde');
    set(labX,'interpreter','latex');
    set(labY,'interpreter','latex');
    
    if ( strcmp(flag,'eps') )
        saveas(gcf,gname,'epsc2');
        gname = [gname, '.eps'];
        graph_fixPSlinestyle(gname,gname);
    end

return
% -----------------------------------------------------------------
