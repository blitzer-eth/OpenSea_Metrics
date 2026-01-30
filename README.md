# 📊 OpenSea Metrics

**[View Dashboard on Dune](https://dune.com/blitzer/opensea)**

This dashboard provides a deep-dive technical and financial analysis of **OpenSea's** cross-chain trading activity, revenue performance, and user engagement. It aggregates raw on-chain data from Ethereum, Solana, and 8 other EVM chains to transform complex transaction logs into actionable business intelligence.

The dashboard is designed to track OpenSea’s evolution from a single-market NFT platform into a multi-asset, multi-chain trading powerhouse using four core analytical modules.

## 🔍 Query Breakdown

### 1. Multi-Chain Trading Volume & Revenue

Consolidates trading volume and platform income across all OpenSea product lines, including Token Trading and the NFT Marketplace.

* **Asset Coverage:** Automatically aggregates token swaps, cross-chain trades, and SeaDrop minting activities on EVM chains and Solana.
* **Financial Logic:** Standardizes platform fees and trading amounts into USD across disparate data sources.
* **Optimization:** Utilizes a `UNION ALL` architecture instead of complex cross-table joins to maximize query speed when processing OpenSea's massive historical datasets.

### 2. Rolling Financial Metrics (30-Day / 30-Month)

Provides dynamic monitoring of financial health, including volume trends and annualized revenue projections.

* **Momentum Tracking:** Calculates the rolling 30-day volume for specific asset types (NFT vs. Token) to identify market shifts.
* **Revenue Analysis:** Projects annualized revenue based on rolling windows to help assess long-term platform profitability.
* **Data Scaling:** Automatically scales raw numbers into "Billions" or "Millions" formats for enhanced chart readability.

### 3. Daily Active Users (DAU) & Engagement

Tracks actual market participation by filtering out noise such as wash trading.

* **Clean Data:** Only includes transactions where `buyer <> seller` to ensure metrics reflect genuine user behavior.
* **User Identity:** Merges unique buyer and seller addresses via `UNION` logic to accurately count daily and monthly active users.
* **Time Range:** Features high-precision daily tracking for the last 3 months and monthly trend analysis for the platform's entire history.

### 4. Cumulative Ecosystem Growth

Visualizes the expansion of the OpenSea ecosystem since its inception.

* **Lifetime Metrics:** Real-time calculation of total volume and cumulative platform fees earned.
* **Growth Visualization:** Uses Window Functions to generate cumulative growth curves, demonstrating platform expansion through various market cycles.
