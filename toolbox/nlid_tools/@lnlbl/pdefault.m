function IOut = pdefault(IIn);
% set default parameters for lnlbl

% Copyright 2003, Robert E Kearney and David T Westwick
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see ../copying.txt and ../gpl.txt 

p=get(IIn,'parameters');
method = get(IIn,'Method');
% Method is initially set in lnlbl/mklnlbl to be 'kernels'.  The first line
% sets p(1) to contain method, and it defaults to whatever it used to be.
% the idea is to estabish the help, type and limits properties.

j=size(p);
p(1)=param('name','Method','default',method,'help',...
    'Iterative method used to refine initial estimate',...
   'type','select','limits', {'hk', 'init'});
if j < 6
  p(2)= param('name','Initialization','default','order1','help',...
      'Initial identification method','type','select',...
      'limits',{'kernels','self','order1'});
  p(3)=param('name','NLags1','default',NaN,...
      'help','Number of lags in first linear element' ,...
      'type','number','limits', {0 1000});
  p(4)=param('name','OrderMax','default',2,...
      'help','Maximum order for polynomisl nonlinearity' ,...
      'type','number','limits', {0 10});
  p(5)=param('name','NLags2','default',NaN,...
      'help','Number of lags in second linear element' ,...
      'type','number','limits', {0 1000});
  p(6)=param('name','Mode','default','full','help',...
    'pseudo-inverse order selection mode ','type','select',...
    'limits',{'full','auto','manual'});
end

switch lower(method)
  case 'init'
    % no additional parameters
    p = p(1:6);
  case 'hk'
    % parameters for Hunter-Korenberg Iteration
    p(7) = param('name','Tolerance','default',0.01,'help',...
	'Improvement required to continue iteration','type','number',...
	'limits', {0 100});
    p(8) = param('name','MaxIts','default',20,'help',...
	'Maximum number of iterations','type','number',...
	'limits',{1 1000});
    p(9) = param('name','InnerLoop','default',10,'help',...
	'Maximum number of iterations between Hammerstein updates',...
	'type','number','limits',{1 100});
    p(10)=param('name','accel','default',0.8,'help',...
	'ridge multiplied by decel after unsuccessful update',...
	'type','number','limits', {0.001 0.999});
    p(11)=param('name','decel','default',2,'help',...
	'ridge size multipled by accel after successful update',...
	'type','number','limits', {1.0001 inf});
    p(12)=param('name','step','default',10,'help',...
       'initial stepsize','type','number',...
       'limits',{0 inf});
    p = p(1:12);
  otherwise
       error(['lnlbl objects do not support method: ' method]);
end




IOut=IIn;
set(IOut,'Parameters',p);
