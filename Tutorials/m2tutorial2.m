%% MATLAB Tutorial 2 - Mathieu ZARADZKI


%% QUESTION 1 - Portfolio optimization 101
%  During the first class we build the mean and variance of Portfolio made
%  of "w" XLI and "1-w" XLF for any weight "w" between 0% and 100%
%  a) Re-using these can you inspect the results you had with a chart?
%  b) Can you suggest an optimal choice for "w" ?

%% ANSWER TO #1
%  First you get the range of portfolio means as we did in the first class
%  wrange = 0 : 0.01 : 1;
%  meanrange = wrange * mean(DXLI) + (1-wrange) * mean(DXLF);
%  Then you get the plot with
%  plot(meanrange, '*g'); % g for green and * for the data marker

%% QUESTION 2 - When MATLAB is in Nice it goes surfing ... the web
%  The four following lines are showing one possible way to load a timeserie from the internet
%  In this example if will load CISCO price history
%  stockticker = 'CSCO';
%  urlwrite(strcat('http://empfincourse.appspot.com/static/marketdata/stocks/',stockticker,'.csv'), stockticker);
%  webdata = importdata(stockticker);
%  prices = flipud(webdata.data(:,4));
%  Can you use this example to build a function that:
%  a) takes a stock ticker (e.g. CSCO, MCD, KO, MSFT) as an argument
%  b) returns a "structure" holding together the ticker, the prices, the
%  returns and the number of observations in the timeserie


%% ANSWER TO #2 - explanations
%  First of all to create your own function click on "New" (the + button) and then
%  "Function" so that you get the template.
%  You need to specify a name that makes sense, for example "getstockdata"
%  Then you "save" your file using the SAME name that is "getstockdata.m"
%  Then you give a name to the function argument (input) such as "ticker"
%  The only thing you need to change to get the required data is to replace
%  the name 'CSCO' from the example by your generic input name that is
%  ticker
%  You will be grouping your result in a struct, lets call it "output" and
%  lets specify this will be the output by modifying the first line
%  Lets ask for results to store the prices : output.prices = prices
%  Lets get the log(prices) as : output.logprices = log(prices)


%% ANSWER TO #2 - final function code to save under "getstockdata.m"
%   function [ output ] = getstockdata( ticker )
% 
%   stockticker = ticker;
%   urlwrite(strcat('http://empfincourse.appspot.com/static/marketdata/stocks/',stockticker,'.csv'), stockticker);
%   webdata = importdata(stockticker); prices = flipud(webdata.data(:,4));
%     
%   output = struct; % a blanck structure to store everything
%
%   output.ticker = ticker;
%
%   output.prices = prices;
%     
%   output.logprices = log(prices);
%     
%   output.logreturns = output.logprices(2:end) - output.logprices(1:end-1);
% 
%   end


%% QUESTION 3 - BETA
%  Consider the following linear model for stock returns:
%  DStockPrices = Alpha + Beta * DIndexPrices + Epsilon (an error term)
%  Can you compute Beta using (only) the following:
%  a) the above function to load data (use 'CSCO' and 'Index_SPX500')
%  b) some minor algebra (i.e. a piece of paper and a pen)
%  c) the cov function we used during the 1st class
%  d) everything else that is 100% necessary but that I forgot to list


%% ANSWER TO #3 - explanations
%  First of all as this function requires data we are simply going to call
%  our previous function.
%  The point of functions is to separate tasks so as to re-use them.
%  We click on the "new" button (+) and then "function"
%  First we specify the same, for example "greeks" and save the m-file
%  under "greeks.m"
%  Remember that the beta is just cov(dstock, dindex)/var(dindex)
%  Also remember that Matlab "cov" function returns a full matrix


%% ANSWER TO #3 - final function code to save under "greeks.m"
%   function [ output ] = greeks( ticker )
%
%   stockdata = getstockdata(ticker);
%
%   indexdata = getstockdata('Index_SPX500');
%    
%   covmatrix = cov(stockdata.logreturns, indexdata.logreturns);
%    
%   output = struct; % a blanck structure to store everything
%    
%   output.ticker = ticker;
%    
%   output.beta = covmatrix(2,1) / covmatrix(2,2); % the (2,2) element is the variance !
%
%   end


%% QUESTION 4 - ALPHA too
%  If you did not do it already answer to Q3 by building a function
%  Can you modify this function so that it returns BOTH the Alpha and Beta?


%% ANSWER TO #4 - explanations
%  Here we carry on working on the same function, lets not have different
%  functions to do similar things as we can simply group everything with a
%  structure !
%  As we have the equation beta and as the mean of "epsilon" is 0 it is
%  easy to deduce the alpha

%% ANSWER TO #4 - final function code to save under "greeks.m"
%   function [ output ] = greeks( ticker )
%
%   stockdata = getstockdata(ticker);
%
%   indexdata = getstockdata('Index_SPX500');
%    
%   covmatrix = cov(stockdata.logreturns, indexdata.logreturns);
%    
%   output = struct; % a black structure to store everything
%    
%   output.ticker = ticker;
%    
%   output.beta = covmatrix(2,1) / covmatrix(2,2); % the (2,2) element is the variance !
%    
%   output.alpha = mean(stockdata.logreturns - output.beta * indexdata.logreturns);
%
%   end

%% QUESTION 5 - Greek soup
%  Can you modify again the function from Q3 and Q4 so that it returns a
%  structure holding together the Alpha, the Beta, the Epsilon and the
%  Sigma of Epsilon?
%  Remark: the sigma is another way of refering to the standard deviation


%% ANSWER TO #5 - explanations
%  We carry on deducing the equation pieces from the previous calculations
%  We have beta and alpha, we get the errors (an array) by difference


%% ANSWER TO #5 - final function code to save under "greeks.m"
%   function [ output ] = greeks( ticker )
%
%   stockdata = getstockdata(ticker);
%
%   indexdata = getstockdata('Index_SPX500');
%    
%   covmatrix = cov(stockdata.logreturns, indexdata.logreturns);
%    
%   output = struct; % a black structure to store everything
%    
%   output.ticker = ticker;
%    
%   output.beta = covmatrix(2,1) / covmatrix(2,2); % the (2,2) element is the variance !
%    
%   output.alpha = mean(stockdata.logreturns - output.beta * indexdata.logreturns);
%    
%   output.epsilons = stockdata.logreturns - output.beta * indexdata.logreturns - output.alpha;
%    
%   output.sigma = std(output.epsilons);
%
%   end


%% QUESTION 6 - TS Chart
%  Using Q5 function and the stock ticker of your choice can you plot a
%  timeserie of the 'standardized' Epsilon?


%% ANSWER TO #6 - simple commands to run from main window
%   msftgreeks = greeks('MSFT');
%   plot(msftgreeks.epsilons / msftgreeks.sigma, '.g')


%% QUESTION 7 - PDF Chart
%  a) Using Q6 function and the 'probplot' can you compare the standardized
%  Epsilon of a stock with a normal distribution pdf'?
%  b) Can you do this for several stock ticker and try to find one where
%  the chart is very different from normal and one where it is much closer
%  to this 'perfect' distribution?


%% QUESTION 8 - A simple question (for once)
%  What is the standard deviation of the SPX500 returns?


%% ANSWER TO #8 - simple commands to run from main window
%   indexdata = getstockdata('Index_SPX500');
%   std(indexdata.logreturns)


%% QUESTION 9 - A difficult question
%  Lets assume that:
%  a) for 5 different stocks the previous "Alpha and Beta" equation holds, and that
%  b) for two different stocks the Epsilon' are independant from each other.
%  Can you use the different Beta' and Sigma' to build a Covariance matrix?


%% QUESTION 10 - Conclusion
%  Review everything we did and find a way to see if the above assumption
%  (Q9) is consistent with the data?


