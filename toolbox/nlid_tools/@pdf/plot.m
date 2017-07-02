function plot ( C,varargin )
% Overload plot function for PDF objects

% Copyright 2003, Robert E Kearney and David T Westwick
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see ../copying.txt and ../gpl.txt 

options={ {'help_flag' 0 'display help (0=No/1=yes)'} ...
          {'line_color' '' 'Line color'} ...
    };
if isstr(C),
    arg_help('nldat/plt',options);
    return
end
if arg_parse(options,varargin);
    return
end

assign(C.Parameters);
dx = get(C,'domainincr');
c=get(C,'data');
c = c(:);

x = get(C,'domainvalues');
if isnan(x)
  disp('creating domain');
  x = [BinMin:dx:BinMax]';
end
x = x(:);

nlc = length(line_color);
if nlc == 0 
  line_color = 'b';
end


if strcmp(lower(Type),'analytical')
  % C is an analytical PDF -- plot it normally
  plot(x,c,line_color);
  ylabel('probability density');
else
    % C is an experimental PDF -- plot it like a histogram
    x2 = [x];
    c2 = [c];
    stairs(x2,c2,line_color);
    set (gca,'xlim',[ min(x)-dx max(x)+dx],'ylim',[ 0 1.1]);  
    ylabel(lower(Type))
end

xlabel('value')

return