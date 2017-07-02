function bl  = nlident (bl, z, varargin)
% Identify a lnlbl

% Copyright 2003, Robert E Kearney and David T Westwick
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see ../copying.txt and ../gpl.txt 

if nargin > 2
   set (bl,varargin);
end


if isa(z,'nldat') | isa(z,'double')

  
  % if numlags is undefined, for either block, set a sensible default.
  numlags=get(bl,'NLags1');
  if isnan(numlags'),
    numlags= max(32,length(z)/100);
    set(bl,'nlags1',numlags);
  end
  
  numlags=get(bl,'NLags2');
  if isnan(numlags'),
    numlags= max(32,length(z)/100);
    set(bl,'nlags2',numlags);
  end
  
  
  

  if isa(z,'nldat')
    Ts=get(z,'DomainIncr');
  else  
    subsys = get(bl,'elements');
    f1 = subsys{1};
    Ts = get(f1,'domainincr');
    z = nldat(z,'domainincr',Ts);
  end   
  
  subsys = get(bl,'elements');
  g = subsys{1};  % First IRF
  p = subsys{2};  % Polynomial
  h = subsys{3};  % Second IRF

  glen = get(bl,'NLags1');
  hlen = get(bl,'NLags2');
  mode = get(bl,'mode');
  set(g,'NLags',glen,'mode',mode);
  set(h,'NLags',hlen,'mode',mode);
  order = get(bl,'OrderMax');
  set(p,'OrderMax', order);
  set(bl,'elements',{g p h});
  
  
  x=z(:,1);
  y=z(:,2);
  switch lower(get(bl,'initialization'))
    case 'kernels'
      bl = kernel_init(bl,z);
    case 'self'
      % do nothing
    case 'order1'
      bl = hk_init(bl,z);
    otherwise
      error('Unsupported Initialization Method');
  end

  
  switch lower(get(bl,'method'))
    case 'init'
      set(bl,'Comment','Initial LNL Model estimate');
    case 'hk'
      bl = hk_ident(bl,z);
    otherwise
      error('Unsupported Refinement Method');
  end
  

else
  error('conversions to models of class lnbl not yet implemented');
end


return
