SELECT 
    date_trunc('day', day_) as day,  
    
    assetType
    , SUM(amountUsd) AS volumeByAssetType
    , SUM(platformFeeUsd) AS platformFeesByAssetType
    , (SUM(SUM(amountUsd)) OVER()) AS totalVolumeInBillions
    , (SUM(SUM(platformFeeUsd)) OVER()) AS totalFeesInMillions
    ,(SUM(SUM(amountUsd)) OVER(ORDER BY date_trunc('day', day_) RANGE BETWEEN INTERVAL '29' DAY PRECEDING AND CURRENT ROW))/POW(10,9) AS last30DayVolumeInBillions
    ,(SUM(SUM(platformFeeUsd)) OVER(ORDER BY date_trunc('day', day_) RANGE BETWEEN INTERVAL '29' DAY PRECEDING AND CURRENT ROW))/POW(10,6) AS last30DayRevenueInMillions
    ,(SUM(SUM(CASE WHEN assetType = 'Token Trading' THEN amountUsd ELSE 0 END)) OVER(ORDER BY date_trunc('day', day_) RANGE BETWEEN INTERVAL '29' DAY PRECEDING AND CURRENT ROW))/POW(10,6) AS last30DayVolumeTokenTradingInMillions

    FROM (
        SELECT
        DATE_TRUNC('DAY', block_time) AS day_, 'Token Trading' AS assetType
        , amount_usd AS amountUsd
        , amount_usd * 0.00825 AS platformFeeUsd
        FROM dune.opensea_team.result_evm_token_trades
        
        UNION ALL
        
        SELECT
        DATE_TRUNC('DAY', block_time) AS day_,  'Token Trading' AS assetType
        , amountUsd
        , amountUsd * 0.00825 AS platformFeeUsd
        FROM dune.opensea_team.result_crosschain_trades_evm_source
        
        UNION ALL
        
        SELECT
        DATE_TRUNC('DAY', block_time) AS day_, 'Token Trading' AS assetType
        , amount_usd AS amountUsd
        , amount_usd *  0.00825 AS platformFeeUsd
        FROM dune.opensea_team.result_solana_token_trades
        
        UNION ALL
        
        SELECT 
        DATE_TRUNC('DAY', block_time) AS day_, 'Token Trading' AS assetType
        , amountUsd 
        , amountUsd * 0.00825 AS platformFeeUsd
        FROM dune.opensea_team.result_crosschain_trades_solana_source
        
        UNION ALL
    
        SELECT 
        block_date AS day_, 'NFT Marketplace' AS assetType
        , amount_usd AS amountUsd
        , platform_fee_amount_usd AS platformFeeUsd
        FROM opensea.trades
    
        UNION ALL
        
        SELECT
        DATE_TRUNC('DAY', block_time) AS day_ , 'NFT Marketplace' AS assetType
        , paymentAmountUsd AS amountUsd
        , platformFeeUsd
        FROM dune.opensea_team.result_nft_trades_for_8_chains
    
    
        UNION ALL
    
        SELECT 
        DATE_TRUNC('DAY', block_time) AS day_, 'NFT Marketplace' AS assetType
        , paidAmountInUSD AS amountUsd
        , paidFeeAmountInUSD AS platformFeeUsd
        FROM dune.opensea_team.result_sea_drop_mints
        )
    GROUP BY 1, 2
    ORDER BY 1 DESC
