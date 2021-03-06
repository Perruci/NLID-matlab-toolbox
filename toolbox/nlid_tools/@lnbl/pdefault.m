function IOut = pdefault(IIn);
% set default parameters for lnbl

% Copyright 2003, Robert E Kearney and David T Westwick
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see ../copying.txt and ../gpl.txt 

p=get(IIn,'parameters');
method = get(IIn,'Method');
% Method is initially set in lnbl/mklnbl to be 'bussgang'.  The first line
% sets p(1) to contain method, and it defaults to whatever it used to be.
% the idea is to estabish the help, type and limits properties.
j=size(p);
p(1)=param('name','Method','default',method,'help',...
    'Iterative method used to refine initial estimate',...
   'type','select','limits', {'bussgang', 'hk', 'phk', 'lm'});
if j < 5
  p(2)= param('name','Initialization','default','fil','help',...
      'Initial identification method','type','select',...
      'limits',{'correl','fil','slice2','slice3','eigen','gen_eigen'});
  p(3)=param('name','OrderMax','default',5,'help',...
      'Maximum order for nonlinearities' ,'type','number','limits', {0 20});
  p(4)=param('name','NLags','default',NaN,'help',...
      'Number of lags in each kernel' ,'type','number','limits', {0 1000}); 
  p(5)=param('name','Mode','default','full','help',...
    'pseudo-inverse order selection mode ','type','select',...
    'limits',{'full','auto','manual'});
end


switch lower(method)

  case 'bussgang'
    % no other parameters.
  case 'hk'
    p(6) = param('name','Tolerance','default',0.01,'help',...
	'Improvement required to continue iteration','type','number',...
	'limits', {0 100});
    p(7) = param('name','MaxIts','default',20,'help',...
	'Maximum number of iterations','type','number',...
	'limits',{1 1000});
    p = p(1:7);
  case 'phk'
    p(6) = param('name','Tolerance','default',0.01,'help',...
	'Improvement required to continue iteration','type','number',...
	'limits', {0 100});
    p(7) = param('name','MaxIts','default',20,'help',...
	'Maximum number of iterations','type','number',...
	'limits',{1 1000});
    p(8) = param('name','Gain','default',1,'help',...
	'Gain applied to error in update (alpha)', 'type','number',...
	'limits',{0  1});
    p = p(1:8);
  case 'lm'
    p(6)=param('name','MaxIts','default',20,'help',...
	'Maximum number of iterations','type','number','limits',{1 1000}); 
    p(7)=param('name','Threshold','default',.01,'help',...
	'NMSE for success','type','number','limits',{0 1});
    p(8)=param('name','accel','default',.8,'help',...
	'ridge multiplied by accell after successful update',...
	'type','number','limits', {0.001 0.999});
    p(9)=param('name','decel','default',2,'help',...
	'ridge multipled by devel after unsuccessful update',...
	'type','number','limits', {1.0001 inf});
   p(10)=param('name','delta','default',10,'help',...
       'initial size of ridge added to Hessian','type','number',...
       'limits',{0 inf});
   p = p(1:10);
 otherwise
   error(['lnbl objects do not support method: ' method]);
end


IOut=IIn;
set(IOut,'Parameters',p);
