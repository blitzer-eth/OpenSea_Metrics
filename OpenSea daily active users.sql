SELECT DAY,
       count(*)
FROM
  (SELECT DATE_TRUNC('day', block_time) AS DAY,
          buyer
   FROM opensea.trades
   WHERE buyer <> seller
   AND block_time > CURRENT_TIMESTAMP - INTERVAL '3' MONTH
   UNION SELECT DATE_TRUNC('day', block_time),
                seller
   FROM opensea.trades
   WHERE buyer <> seller
   AND block_time > CURRENT_TIMESTAMP - INTERVAL '3' MONTH) a
GROUP BY 1
ORDER BY 1
