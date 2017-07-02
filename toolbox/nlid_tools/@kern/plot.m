function hh = plot ( C )
% Overloaded plot function for kernel objects

% Copyright 1991-2003, Robert E Kearney and David T Westwick
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see ../copying.txt and ../gpl.txt 

assign(C.Parameters);
Ts = get(C,'domainincr');
c=get(C,'data');
t=domain(C);
tlim=[ min(t) max(t)];
switch Order
  case 0
     handle = stem(c,'filled');
     set(gca,'xticklabel',[]);
     ylabel('zero-order kernel');
   case 1
     handle = plot (t,c);
     set(gca,'xlim',tlim);
     ylabel(get(C,'name'));
     xlabel(get(C,'domainname'));
     title(get(C,'comment'));
   case 2 
   handle = surface (t,t,c); view (45,30);
    set (gca,'xlim',tlim,'ylim',tlim);
    colormap('jet');caxis('auto');
    shading ('interp');
     zlabel('second-order kernel');
     xlabel('lag (sec.)');
     ylabel('lag (sec.)');
  case 3
    [xx,yy,zz] = meshgrid(t,t,t);
    hlen = length(t);
    zslices = t([1,floor(hlen/3),floor(2*hlen/3),hlen]);
    xslice = t(ceil(hlen/2));

    handle = slice(xx,yy,zz,c,[],[],zslices);
    set(handle,'edgecolor','none','facecolor','interp',...
	'facealpha','interp');
    alpha('color');
    alphamap('default');
    alphamap('increase',0.1);
    caxis('auto');
    colormap('jet'); 
    
    axis tight
     xlabel('lag (sec.)');
     ylabel('lag (sec.)');
     zlabel('lag (sec.)');
    
    cb = colorbar('vert');
    axes(cb)
    ylabel('third-order kernel');
    
end

if nargout == 1
  hh = handle;
end


return
