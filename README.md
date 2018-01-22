
<!-- README.md is generated from README.Rmd. Please edit that file -->
HousingROE
==========

This package countains four datasets from streeteasy.com and walkscore.com:

-   `datot`: Aggregated data frame of the three datasets below and added **Return on Equity**(ROE) as the key value.

-   `datr`: Raw data of Manhattan rentals. (Source: <https://streeteasy.com/rentals>)

-   `dats`: Raw data of Manhattan sales. (Source: <https://streeteasy.com/>)

-   `ws_df`: Walk scores by Manhattan zipcode. (Source: <https://www.walkscore.com/cities-and-neighborhoods/>)

Example
-------

For more examples, call the function `vignette('HousingROE')` after installation.

Recap for Reproducible Research
-------------------------------

This data project still aims at the ROE(sale/rent index) as the proposal suggested. But for the density consideration, I narrowed down the range within Manhattan to look after the real estate as location changes.

Housing data collection came from web scraping on streeteasy.com mainly through `RSelenium` package. Similarly I gathered the Walk Score data through `rvest` package. Then I did the matching of rent and sale, also the combination of walk score and housing data through `dplyr`. Data cleaning and wrangling is accompanied all along every steps, which can be found in the R script in data\_code folder.

Last but not the least, I left some analysis and visualization in the vignette. This is for outlining the trend and giving an overview of the data, such as geo-mapping.
