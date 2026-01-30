WITH all_trades AS (
    SELECT
        DATE_TRUNC('DAY', block_time) AS day_,
        'Token Trading' AS assetType,
        amount_usd AS amountUsd,
        amount_usd * 0.00825 AS platformFeeUsd
    FROM dune.opensea_team.result_evm_token_trades
    WHERE block_time >= CURRENT_DATE - INTERVAL '3' MONTH

    UNION ALL
    SELECT
        DATE_TRUNC('DAY', block_time),
        'Token Trading',
        amountUsd,
        amountUsd * 0.00825
    FROM dune.opensea_team.result_crosschain_trades_evm_source
    WHERE block_time >= CURRENT_DATE - INTERVAL '3' MONTH

    UNION ALL
    SELECT
        DATE_TRUNC('DAY', block_time),
        'Token Trading',
        amount_usd,
        amount_usd * 0.00825
    FROM dune.opensea_team.result_solana_token_trades
    WHERE block_time >= CURRENT_DATE - INTERVAL '3' MONTH

    UNION ALL
    SELECT
        DATE_TRUNC('DAY', block_time),
        'Token Trading',
        amountUsd,
        amountUsd * 0.00825
    FROM dune.opensea_team.result_crosschain_trades_solana_source
    WHERE block_time >= CURRENT_DATE - INTERVAL '3' MONTH

    UNION ALL
    SELECT
        block_date,
        'NFT Marketplace',
        amount_usd,
        platform_fee_amount_usd
    FROM opensea.trades
    WHERE block_date >= CURRENT_DATE - INTERVAL '3' MONTH

    UNION ALL
    SELECT
        DATE_TRUNC('DAY', block_time),
        'NFT Marketplace',
        paymentAmountUsd,
        platformFeeUsd
    FROM dune.opensea_team.result_nft_trades_for_8_chains
    WHERE block_time >= CURRENT_DATE - INTERVAL '3' MONTH

    UNION ALL
    SELECT
        DATE_TRUNC('DAY', block_time),
        'NFT Marketplace',
        paidAmountInUSD,
        paidFeeAmountInUSD
    FROM dune.opensea_team.result_sea_drop_mints
    WHERE block_time >= CURRENT_DATE - INTERVAL '3' MONTH
),

daily AS (
    SELECT
        DATE_TRUNC('DAY', day_) AS day,
        assetType,
        SUM(amountUsd) AS volumeByAssetType,
        SUM(platformFeeUsd) AS platformFeesByAssetType
    FROM all_trades
    GROUP BY 1, 2
)

SELECT
    day,
    assetType,
    volumeByAssetType,
    platformFeesByAssetType,

    SUM(volumeByAssetType) OVER () / 1e9 AS totalVolumeInBillions,
    SUM(platformFeesByAssetType) OVER () / 1e6 AS totalFeesInMillions,

    SUM(volumeByAssetType) OVER (
        ORDER BY day
        RANGE BETWEEN INTERVAL '29' DAY PRECEDING AND CURRENT ROW
    ) / 1e9 AS last30DayVolumeInBillions,

    SUM(platformFeesByAssetType) OVER (
        ORDER BY day
        RANGE BETWEEN INTERVAL '29' DAY PRECEDING AND CURRENT ROW
    ) / 1e6 AS last30DayRevenueInMillions,

    SUM(CASE WHEN assetType = 'Token Trading' THEN volumeByAssetType ELSE 0 END)
    OVER (
        ORDER BY day
        RANGE BETWEEN INTERVAL '29' DAY PRECEDING AND CURRENT ROW
    ) / 1e6 AS last30DayVolumeTokenTradingInMillions

FROM daily
ORDER BY day DESC;
