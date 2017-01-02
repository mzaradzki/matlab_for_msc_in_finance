function [ output ] = greeks( ticker )

    stockdata = getstockdata(ticker);

    indexdata = getstockdata('Index_SPX500');
    
    covmatrix = cov(stockdata.logreturns, indexdata.logreturns);
    
    output = struct; % a black structure to store everything
    
    output.ticker = ticker;
    
    output.beta = covmatrix(2,1) / covmatrix(2,2); % the (2,2) element is the variance !
    
    output.alpha = mean(stockdata.logreturns - output.beta * indexdata.logreturns);
    
    output.epsilons = stockdata.logreturns - output.beta * indexdata.logreturns - output.alpha;
    
    output.sigma = std(output.epsilons);

end

