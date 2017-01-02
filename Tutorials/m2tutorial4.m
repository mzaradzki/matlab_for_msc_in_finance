%% MATLAB Tutorial 4 - Mathieu ZARADZKI
%  Lets try again important questions from Tutorial 3


%% QUESTION 1 - Tracking the index
%  NOTE: This was question #6 in the previous tutorial.
%  Select 5 US stocks and foom a matrix of their logreturns.
%  Try different (random) weights to find a long only portfolio that tracks
%  the best the SPX index.
%  TIP: You are encourage to re-use and modify the "getstockdata" and "greeksoup" 
%  functions from the 2nd tutorial


IBMdata = getstockdata('IBM'); % IBM
JPMdata = getstockdata('JPM'); % JP Morgan
WMTdata = getstockdata('WMT'); % Walmart
MMMdata = getstockdata('MMM'); % 3M
XOMdata = getstockdata('XOM'); % Exxon Mobile

SPXdata = getstockdata('Index_SPX500');

stockmatrix = [IBMdata.logreturns, JPMdata.logreturns, WMTdata.logreturns, MMMdata.logreturns, XOMdata.logreturns];

NbSims = 10000;

BESTCORRELATION = -2; % something so BAD that even the FIRST will improve it

for i = 1 : NbSims
    weights = rand(5,1);
    weights = weights / sum(weights);
    
    PTFLlogreturns = stockmatrix * weights;
    
    correlation = corr(PTFLlogreturns, SPXdata.logreturns);
    
    if (correlation > BESTCORRELATION)
        i
        BESTCORRELATION = correlation
        BESTWEIGTHS = weights;
    end % remember to END your IF statement
end % remember to END your FOR loop


%% QUESTION 2 - Portfolio algebra (ask help with the math if necessary)
%  NOTE: This was question #8 in the previous tutorial.
%  Lets assume that:
%  a) for 5 different stocks the previous "Alpha and Beta" equation holds, and that
%  b) for two different stocks the Epsilon' are independant from each other.
%  Can you use the different Beta' and Sigma' to build a "model" covariance matrix?

betas = nan(5,1);
alphas = nan(5,1);
sigmas = nan(5,1);

for i=1:5
    covmatrix = cov(stockmatrix(:,i), SPXdata.logreturns);
    
    betas(i) = covmatrix(2,1) / covmatrix(2,2); % the (2,2) element is the variance !
    
    alphas(i) = mean(stockmatrix(:,i) - betas(i) * SPXdata.logreturns);
    
    epsilons = stockmatrix(:,i) - betas(i) * SPXdata.logreturns - alphas(i);
    
    sigmas(i) = std(epsilons);
end

capmcovmat = (betas * betas') * var(SPXdata.logreturns) + diag(sigmas.^2)

realcovmat = cov(stockmatrix) % to check the quality of our approximation


%% QUESTION 3 - Working as a Quant Analyst
%  NOTE: This is an *extension* of question #9 in the previous tutorial.
%  In the case of a 3 stocks portfolio allocation, can you optimize the
%  weights using a function maximization of the Sharpe ratio?
%  Remember that visually you could only optimize between 2 stocks.
%  TIP: you can use "fminsearch" function
%  TIP: if you have 3 stocks you only have 2 variables as their sum is 100%


%% QUESTION 4 - Boosting your Matlab with a Data API
%  Computing is about standing between Input and Output.
%  So without any Input it gets really dull.
%  Save the +Quandl folder from this page with your other Matlab files and
%  test the following line "data = Quandl.get('NSE/OIL');"
%  LINK: https://github.com/quandl/Matlab

Quandl.auth('8aVZ3CksqJmfEozdFNbB'); % my own key, please get yours

JPNCPI = Quandl.get('FRED/JPNCPIBLS'); % Japan Consumer Price Index

plot(JPNCPI.data);


%% QUESTION 5 - Checking the statistics tables are correct
%  No need to do a difficult math to check if the statisticians who built
%  the t-distribution and the chi-square-distribution are correct.
%  Consider a ChiSquare with 2 components.
%  Simulate its random output by using is definition as Chi2: X1^2 + X2^2
%  where X1 and X2 are Normal random variables.
%  Using 10000 simulations (please don't print on the screen) compute the
%  90-percentile of your simpulated sample and compare with critial values
%  from the tables.

X1 = randn(10000, 1); % a 1st normal law simulation
X2 = randn(10000, 1); % a 2nd normal law simulation

CHI2SIMS = X1.^2 + X2.^2; % we get the ChiSquare(2) using its definition

prctile(CHI2SIMS, 90) % the builtin percentile function

chi2inv(0.90, 2) % the converse (inverse) of the CDF function


%%  QUESTION 6 - Writing a function from #5
%  The calculations you did for question #5 are usefull so lets turn this
%  into a function so that:
%      a) the user can specify the number of components
%      b) the user get the list of 5, 10, 15, ..., 90, 95 percentiles as ouput

NbChi2Comp = 5; % change this value for more/less components

CHI2SIMS = zeros(10000, 1);

for i = 1 : NbChi2Comp

    Xs = randn(10000, 1); % another normal law simulation
    
    CHI2SIMS = CHI2SIMS + Xs.^2;
    
end

prctile(CHI2SIMS, 90)

chi2inv(0.90, NbChi2Comp)


%%  QUESTION 7 - What about Jarque Berra accuracy? (DIFFICULT)
%  In reality the Jarque Bera test (jbtest in Matlab) we have studied is an
%  approximation.
%  In reallity the JB statistics is not a Chi Square.
%  Can you use random simulations and the jbtest function to get a sample
%  of the JBstat distribution.
%  You are free to use a loop.
%  Then compare with QQplot the jbtest with the ChiSquare distribution.


