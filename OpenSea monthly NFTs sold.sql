SELECT DATE_TRUNC('month', block_time),
       count(*)
FROM opensea.trades
WHERE buyer <> seller
GROUP BY 1
ORDER BY 1
