SELECT MONTH,
       count(*)
FROM
  (SELECT DATE_TRUNC('month', block_time) AS MONTH,
          buyer
   FROM opensea.trades
   WHERE buyer <> seller
   UNION SELECT DATE_TRUNC('month', block_time),
                seller
   FROM opensea.trades
   WHERE buyer <> seller) a
GROUP BY 1
ORDER BY 1
