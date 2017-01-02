

tickers = {'XOM','IBM', 'MCD'};

for i = 1 : length(tickers)
  gr = greeks(tickers{i});
  gr.beta
end


