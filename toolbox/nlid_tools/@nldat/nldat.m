function d = nldat (z,varargin)
% nldat - data object for nlid toolbox
%         Parent: nltop

% Copyright 1999-2003, Robert E Kearney
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see copying.txt and gpl.txt 

d=mknldat;
if nargin ==0,
   % Generate an empty nldat variable
   d=mknldat;
   return;
elseif isa (z,'nldat');
   d =z;
   if nargin > 1,
   	set (d,varargin);
	end

elseif isa(z,'double');
   d=mknldat;
	[nsamp,nchan]=size(z);
   if (nsamp == 1) & (nchan >10),
      warning('Row vector. Transposing');
      z=z';
   end
   d.Data=z;
   [nsamp,nchan,nreal]=size(z);
   d.Size=size(z);
   for i=1:nchan,
      names{i} = [inputname(1) int2str(i) ];
   end
   d.ChanNames=names;
   if nargin > 1,
   	set (d,varargin);
   end
   
elseif isa (z,'randv');
   d=randv2nldat(z);
  if nargin > 1,
      set (d,varargin);
   end
   elseif isa (z,'signalv');
   d=signalv2nldat(z);
  if nargin > 1,
      set (d,varargin);
   end
 elseif isa (z,'iddata');
     xin=z.InputData;
     xout=z.OutputData;
     d=cat(2,xin,xout);
     d=nldat(d);
     set (d,'domainincr',z.Ts,'domainstart',z.Tstart);
elseif isa (z,'ms');
    M= full(z);
    mbyz=M.MbyZ{1};
    domainStart=mbyz(1);
    if length(mbyz)>1,
      domainIncr=mbyz(2)-mbyz(1);
    else
         domainIncr=nan;
    end
    d=nldat(M.Intensity{1},'domainStart',domainStart','domainIncr', ...
    domainIncr, 'domainName','Da', 'comment',get(M,'comment'));
    
else
    error(['nldat not implement for class:' class(z)]);

   
end
function d = mknldat
d.ChanNames = {'x1' };
d.ChanUnits = NaN;
d.DomainIncr=1;
d.DomainName ='Time (s)';
d.DomainStart= 0;
d.DomainValues =NaN;
d.Data = NaN;
d.Size = NaN;
N=nltop;
d=class(d,'nldat',N);
return

