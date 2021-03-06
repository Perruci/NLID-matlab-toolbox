% sample solution for computer exercise 1, chapter 6

clear
close all

echo on

load mod3;

u = uz(:,1);

% to check for a white input, compute its autocorrelation
phi = cor;
set(phi,'order',1,'Nsides',2,'NLags',10);
phi = nlident(phi,u);
figure(1);
plot(phi);

% since the auto-correlation is essentially a spike at zero-lag, 
% the input is approximately white

% press any key to continue
pause

% to check for Gaussianity, compute a PDF

exp_pdf = pdf;
set(exp_pdf,'NBins',50,'type','density');
exp_pdf = nlident(exp_pdf,u);
figure(2)
plot(exp_pdf)
hold on

% and compare it with a Gaussian having the same mean and sdev

umean = double(mean(u));
ustd = double(std(u));
rv = randv;
set(rv,'mean',umean,'sd',ustd);
pdf_th = pdf(rv);
plot(pdf_th,'line_color','r');
hold off

legend('Histogram','Gaussian');

% Notice that the histogram largely overlaps the theoretical
% Gaussian PDF, so the input appears to be Gaussian.


% press any key to continue
pause


% now set up an empty Wiener series object

sys1 = wseries;
set(sys1,'OrderMax',2,'NLags',32);
sys1 = nlident(sys1,uz);

figure(3)
plot(sys1);


% press any key to continue
pause


% test the model
vf = vaf(sys1,uz)
% vaf returns a nldat object, change to double to see more figures,
double(vf)


% press any key to continue
pause



% extract the kernels from the model
kernels = get(sys1,'elements')
k1 = double(kernels{2});
k2 = double(kernels{3});


% Check for a LNL structure first.  If the system is not LNL, there is 
% no point testing for either Hammerstein or Wiener structures.

% Compute the marginal second-order kernel
k2m = sum(k2)';
k2ms = smo(k2m,1);

% set up the x-axis
hlen = length(k1);
Ts = get(kernels{2},'domainincr');
tau = [0:hlen-1]'*Ts;


% scale the marginal kernel to best fit the first-order kernel
gain = k2m\k1;
k2m = k2m*gain;
g2 = max(k1)/max(k2m);
k2m = g2*k2m;


figure(4)
plot(tau,[k1,k2m]);
title('Testing for the LNL structure');
xlabel('lag (sec)');
ylabel('Amplitude');
legend('1^{st} order Wiener kernel','2^{nd} order marginal kernel');


% The large negative deflection in the marginal kernel, at a lag of 0.07
% seconds, is much larger than the apparent noise level, and does not
% correspond to anyting in the first-order kernel.  This would appear to 
% eliminate the LNL cascade as a potential structure, and also eliminate the
% Wiener and Hammerstein cascades as well.


% press any key to continue
pause



% For completeness, check for the Hammerstein structure

% compare the second-order kernel diagonal to the first-order kernel
k2d = diag(k2);
k2d = k2d*std(k1)/std(k2d);
[val,pos] = max(abs(k1));
k1s = sign(k1(pos));
[val,pos] = max(abs(k2d));
k2ds = sign(k2d(pos));
k2d = k2d*k2ds*k1s;



figure(5)
plot(tau,[k1 k2d]);
title('Testing for a Hammerstein Structure');
xlabel('lag (sec.)');
legend('First-Order Kernel','Scaled 2^{nd} Order Diagonal')

% the diagonal has 2 positive peaks, whereas the first order kernel has 
% one positive and one negative deflection, in more or less corresponding
% locations.  The diagonal is clearly not proportional to the first-order
% kernel, eliminating the Hammerstein structure. 

% press any key to continue
pause

% For completeness, test for the Wiener casacde


% Compute the principal singular vector of the second-order kernel, and 
% compare it to the first-order kernel.
[uu,ss,vv] = svd(k2);
ktest = uu(:,1);
gain = ktest\k1;
ktest = ktest*gain;

figure(6)
plot(tau,[k1 ktest])
legend('first-order kernel','principal singular vector of k2');
xlabel('lag (sec)');
ylabel('Amplitude');


% The first peak in the first-order kernel is missing in the first 
% singular vector.  Thus, the two are not proportional to each other, 
% eliminating the Wiener cascade as a potential structure.

echo off

