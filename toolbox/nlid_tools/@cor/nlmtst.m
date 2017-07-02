function i=nlmtst(i)
% Test of cor objects


% Copyright 2003, Robert E Kearney and David T Westwick
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see ../copying.txt and ../gpl.txt 

nx=2;ny=2;
z=nlid_sim ('L1');
C=cor;
set(C,'nlags',33);
cxx=cor(C,z(:,1));
subplot (nx,ny,1);
plot(cxx);
cxy=cor(C, z);
subplot (nx,ny,2);
plot (cxy);
cxxx=cor(C,z(:,1),'Order',2);
subplot (nx,ny,3);
plot (cxxx);
z(:,2)=double(z(:,2)).^2;
cxxy=cor(C,z,'Order',2);
subplot (nx,ny,4);
plot (cxxy);

