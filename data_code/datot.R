# This script is showing how the dataset "datot" came from, based on "dats" and "datr".

# 1. calculate ROE(return on equity) - aggregate sale and rental data

library(dplyr)
library(tidyverse)
trials <- semi_join(dats[, 3:8], datr[, 3:8], by = "address")
trialr <- semi_join(datr[, 3:8], dats[, 3:8], by = "address")
trials <- trials %>%
    unite(mline, address, beds, baths)
trialr <- trialr%>%
    unite(mline, address, beds, baths)
trial <- inner_join(trials, trialr, by = "mline")
trial <- trial %>%
    mutate(roe = sale_p / rent_p) %>%
    group_by(mline) %>%
    summarise(roe_avg = mean(roe)) %>%
    separate(mline, into = c("address", "beds", "baths"), sep = "_")

# 2. find zipcode for each housing and match the walkscore

dftot <- data.frame(formatted_address = character(length(trial$baths)),
                    postal_code = integer(length(trial$baths)),
                    latitude = integer(length(trial$baths)),
                    longitude = integer(length(trial$baths)),
                    trial, stringsAsFactors = FALSE)
for (i in 1:length(dftot$roe_avg)){
    gcurl <- paste("https://maps.googleapis.com/maps/api/geocode/json?address=",
                   gsub(pattern = " ", replacement = "+", x = trial[i,1]),
                   ",+New+York,+NY&key=AIzaSyADk8qfY1rXApRvq0WD_jbX-E3qo7ECM9Q", sep = "")
    gcls <- GET(gcurl)
    dftot[i,1] <- content(gcls)$results[[1]]$formatted_address
    dftot[i,2] <- content(gcls)$results[[1]]$address_components[[9]]$short_name
    dftot[i,3] <- content(gcls)$results[[1]]$geometry$location$lat
    dftot[i,4] <- content(gcls)$results[[1]]$geometry$location$lng
    Sys.sleep(0.1)
}
datot <- dftot %>%
    group_by(formatted_address, beds, baths, postal_code, latitude, longitude) %>%
    summarise(roe = mean(roe_avg))
datot <- left_join(datot, ws_df, by = "postal_code")
datot$walk_score <- as.integer(datot$walk_score)
