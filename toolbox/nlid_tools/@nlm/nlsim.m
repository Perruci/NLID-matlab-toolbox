function y = nlsim ( sys, x )
% Simulate response of nlm object to input data set
subsys = sys.Elements;
[nparallel, nseries]=size(subsys);
y=x(:,1)*0;
for i=1:nparallel,
   xin=x;
   for j=1:nseries,
      ss=subsys{i,j};
      xin = nlsim(ss,xin(:,1));
   end
   y=y+xin;
end
% nlm/nlsim


% Copyright 1999-2003, Robert E Kearney
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see copying.txt and gpl.txt 
