%% MATLAB Tutorial 1 - Mathieu ZARADZKI


%% Data set description
%  You are being provided with a set of stock sub-index prices
%  They correspond to the 9 different sector classification of listed
%  companies: industry, technology, financial, ...
%  For more information you can read this webpage: http://www.sectorspdr.com/sectorspdr/


%% Importing the data
%  Use MATLAB to open data_m2lab1.csv
%  Use the *Import* button and see the new variables in the Workspace
%  Note that Comma Separated Value files are common way to share data


%% QUESTION 1 - Single vector manipulation
%  For DXLK compute:
%  # the dimension
%  # the sum and the average
%  # the variance and standard deviation

size(DXLK) % generic function
nbobs = length(DXLK) % for a 1 dimensional array
mxlk = sum(DXLK)/nbobs % the mean of DXLK
vxlk = sum(DXLK.^2)/nbobs - mxlk^2 % the variance of DXLK - BEWARE the .^ !!!
sxlk = sqrt(vxlk) % the std. deviation of DXLK

%% QUESTION 2 - Multiple vector manipulation
%  For the pair of variables DXLK and DXLI compute:
%  # the covariance
%  # the correlation


%% QUESTION 3 - Using Matlab statistic functions
%  Use the "cov" function to get the matrix for DXLK, DXLI, DXLF, DXLU
%  Is it consistent with your previous results?

cov([DXLK, DXLI, DXLF, DXLU]) % bear in mind the diagonal is for variances
corr([DXLK, DXLI, DXLF, DXLU])

%% QUESTION 4 - Integral calculation
%  Using a discrete approximation of the f(x)=exp(-x^2) function, compute
%  the area under the curve representing f for 0 < x < 3

dX = 0.001; % a small increment do split the interval into
Xs = 0 : dX : 3; % a range of values from 0 to 1 by steps of 0.001
Ys = exp(-Xs.*Xs); % BEWARE the .* !!!
area = sum(Ys)*dX % this is so simple it hurts


%% QUESTION 5 - Using matrix products
%  You are considering a 70% vs 30% allocation between XLI and XLF
%  Compute the mean of such combination
%  Compute the variance of such combination

DPTF = 0.70 * DXLI + 0.30 * DXLF; % dont print this on screen as quite long !!

mptf = mean(DPTF)
vptf = var(DPTF)

%% QUESTION 6 - Calculating over a range of values (vector)
%  You are now considering any W vs (1-W) allocation between XLI and XLF
%  Compute the possible range of portfolio mean

Ws = 0 : 0.01 : 1; % please use ; to avoid printing this !!!
rangeofmeans = Ws * mean(DXLI) + (1-Ws) * mean(DXLF);

min(rangeofmeans)
max(rangeofmeans)

%% QUESTION 7 - Calculating over a range of values (matrix)
%  You are now considering any W vs (1-W) allocation between XLI and XLF
%  Compute the possible range of portfolio stdandard deviation

covmatrix = cov([DXLI, DXLF]);
covXLIXLF = covmatrix(1,2); % to extract the value of interest in the matrix
rangeofvariances = (Ws.^2) * var(DXLI) + ((1-Ws).^2) * var(DXLF) + 2 * Ws .* (1-Ws) * covXLIXLF; % BEWARE the .^ and .* !!!
min(rangeofvariances)
max(rangeofvariances)


%% QUESTION 8 - Auto-correlation
%  Compute the auto-correlation of DXLK

corr( DXLK(2:end), DXLK(1:end-1) ) % note that Matlab has an "autocorr" function

%% QUESTION 9 - Numerical integration
%  Compute the previous integral using Matlab "integral" function

somefunction = @(x) exp(-x.^2);
integral(somefunction, 0, 3) % this is really for those who dont want "to think" like Matlab


%% QUESTION 10 - Mixing several methods
%  In the previous case of a 70% vs 30% allocation, compute the THIRD
%  moment of the portfolio distribution
%  We remind you the THIRD moment is the E(X^3)
%  Can you suggest two different ways of doing this?

mean( DPTF.^3 ) % that is a possible answer but not so interesting
mean( (DPTF-mptf).^3 ) % slightly better answer (centralized data)
mean( ((DPTF-mptf)/std(DPTF)).^3 ) % (centralized and scaled data)


