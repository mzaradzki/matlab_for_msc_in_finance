function [ output ] = getstockdata( ticker )

    stockticker = ticker;
    urlwrite(strcat('http://empfincourse.appspot.com/static/marketdata/stocks/',stockticker,'.csv'), stockticker);
	webdata = importdata(stockticker);
	prices = flipud(webdata.data(:,4));
    
    output = struct;
    
    output.ticker = ticker;
    
    output.prices = prices;
    
    output.logprices = log(prices);
    
    output.logreturns = output.logprices(2:end) - output.logprices(1:end-1);

end

