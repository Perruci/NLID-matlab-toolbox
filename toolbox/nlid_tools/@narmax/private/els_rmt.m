function RM = els_rmt (N, X)
% build a regression matrix for a els estimation
% X must be inout matrix with columns (: , [U Z E]); 

% Copyright 2000, Robert E Kearney
% This file is part of the nlid toolbox, and is released under the GNU 
% General Public License For details, see ../copying.txt and ../gpl.txt 

[nsamp,nchan]=size(X);
nelement=size(N);
RM=zeros(nsamp,nelement); 
index=1:nsamp;
for j=1:nelement,
   terms=N.Terms{j};
   [nterm,nval]=size(terms);
   yterm=1;
   for k=1:nterm,
      var=terms(k,1);
      if var > 2,
         var=var-1;
      end
      
      power=terms(k,3);
      lag=index-terms(k,2);
      lag=max(1,lag);
      yterm=yterm.*(X(lag,var).^power);
   end
   RM(:,j)=yterm;
end

