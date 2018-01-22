# Web Scraping on streeteasy.com
# This coding lists out the process of collecting raw data through web scraping and coming up
# the "dats" and "datr" seperately after first-off cleaning and combination of datasets.

## 1. SETUP RSelenium
library(RSelenium)
library(httr)
rD <- rsDriver()
remDr <- rD[["client"]]
# open the setup server
remDr$open(silent = TRUE)
# check the status of the server
remDr$getStatus()
# later for closing the server
remDr$close()
rD[["server"]]$stop()

## 2. Manhattan housing - 1+ beds - rental(stored as "df1r") 703 - sale(stored as "df1s") 473
n <- 473
url <- "https://streeteasy.com/for-sale/manhattan/beds%3E=1?page="
df1s <- data.frame(street = character(), sale = character(), beds = character(),
                   baths = character(), ftsq = character())
address <- character(length = 14)
sale <- character(length = 14)
bed <- character(length = 14)
bath <- character(length = 28)
sqft <- character(length = 14)
for (page in 1:n){
    urlp <- paste(url, as.character(page), sep = "")
    remDr$navigate(urlp)
    webElem <- remDr$findElements(using = 'class', value = "details-title")
    for (i in 1:length(webElem)){
        address[i] <- webElem[[i]]$getElementText()[[1]]
    }
    webElem <- remDr$findElements(using = 'class', value = "price")
    for (i in 1:length(webElem)){
        sale[i] <- webElem[[i]]$getElementText()[[1]]
    }
    webElem <- remDr$findElements(using = 'class', value = "first_detail_cell")
    for (i in 1:length(webElem)){
        bed[i] <- webElem[[i]]$getElementText()[[1]]
    }
    webElem <- remDr$findElements(using = 'class', value = "detail_cell")
    for (i in 1:length(webElem)){
        bath[i] <- webElem[[i]]$getElementText()[[1]]
    }
    webElem <- remDr$findElements(using = 'class', value = "last_detail_cell")
    for (i in 1:length(webElem)){
        sqft[i] <- webElem[[i]]$getElementText()[[1]]
    }
    dftemp <- data.frame(address, sale, bed, sqft, stringsAsFactors = FALSE)
    j = 0
    ftsq <- character(length = 14)
    for (i in 1:length(sale)){
        if (dftemp[i,3] == "Furnished"){
            j = j + 1
            dftemp[i,3] <- bath[j]
            if (str_detect(string = dftemp[i,4], pattern = "ft") == TRUE){
                ftsq[i] <- dftemp[i,4]
                j = j + 1
                dftemp[i,4] <- bath[j]
            }else{
                ftsq[i] <- ""
            }
        }else{
            if (str_detect(string = dftemp[i,4], pattern = "ft") == TRUE){
                ftsq[i] <- dftemp[i,4]
                j = j + 1
                dftemp[i,4] <- bath[j]
            }else{
                ftsq[i] <- ""
            }
        }
    }
    dftemp$ftsq <- ftsq
    colnames(dftemp) <- c("street", "sale", "beds", "baths", "ftsq")
    df1s <- rbind(df1s, dftemp) # same process for rent dataset "df1r" by changing "sale" into "rent"
    Sys.sleep(0.5)
}

## 3. Manhattan housing - studio - rent(stored as "df0r") 161, sale(stored as "df0s") 44
n <- 44
url <- "https://streeteasy.com/for-sale/manhattan/beds%3C1?page="
df0s <- data.frame(street = character(), sale = character(), beds = character(),
                   baths = character(), ftsq = character())
address <- character(length = 14)
sale <- character(length = 14)
bed <- rep("studio", 14)
bath <- character(length = 14)
ow <- character(length = 14)
sqft <- character(length = 14)
for (page in 1:n){
    urlp <- paste(url, as.character(page), sep = "")
    remDr$navigate(urlp)
    webElem <- remDr$findElements(using = 'class', value = "details-title")
    for (i in 1:length(webElem)){
        address[i] <- webElem[[i]]$getElementText()[[1]]
    }
    webElem <- remDr$findElements(using = 'class', value = "price")
    for (i in 1:length(webElem)){
        sale[i] <- webElem[[i]]$getElementText()[[1]]
    }
    webElem <- remDr$findElements(using = 'class', value = "first_detail_cell")
    for (i in 1:length(webElem)){
        bath[i] <- webElem[[i]]$getElementText()[[1]]
    }
    webElem <- remDr$findElements(using = 'class', value = "detail_cell")
    if (length(webElem) != 0){
        for (i in 1:length(webElem)){
          ow[i] <- webElem[[i]]$getElementText()[[1]]
        }
    }
    webElem <- remDr$findElements(using = 'class', value = "last_detail_cell")
    for (i in 1:length(webElem)){
          sqft[i] <- webElem[[i]]$getElementText()[[1]]
    }

    dftemp <- data.frame(address, sale, bed, bath, sqft, stringsAsFactors = FALSE)
    j = 0

    for (i in 1:length(sale)){
        if (dftemp[i,4] == "Furnished"){
            j = j + 1
            dftemp[i,4] <- ow[j]
            if (str_detect(string = dftemp[i,5], pattern = "bath") == TRUE){
               dftemp[i,4] <- dftemp[i,5]
               dftemp[i,5] <- ""
            }
        }
    }
    colnames(dftemp) <- c("street", "sale", "beds", "baths", "ftsq")
    df0s <- rbind(df0s, dftemp)# same process for rent dataset "df0r" by changing "sale" into "rent"
    Sys.sleep(0.5)
}
## 4. clean up studio data
for (i in 1:length(df0s$baths)){
    if (df0s[i,4] == "studio"){
        df0s[i,4] <- "1 bath"
    }
    if (str_detect(string = df0s[i,5], pattern = "bath") == TRUE){
        df0s[i,5] <- ""
    }
}
for (i in 1:length(df0r$baths)){
    if (df0r[i,4] == "studio"){
        df0r[i,4] <- "1 bath"
    }
    if (df0r[i,5] == "1 bath" & is.na(df0r[i,5]) == FALSE){
        df0r[i,5] <- ""
    }
    if (is.na(df0r[i,5]) == TRUE){
        df0r[i,5] <- ""
    }
}

## 5. initial aggregation
datr <- rbind(df0r, df1r)
dats <- rbind(df0s, df1s)

## 6. transform variables into raw data for rent and sale
dats <- data.frame(dats, address = character(length(dats$baths)),
                   unit = character(length(dats$baths)),
                   sale_p = numeric(length(dats$baths)),
                   area_ft = numeric(length(dats$baths)), stringsAsFactors = FALSE)
for (i in 1:length(dats$baths)){
    dats[i,6] <- str_split(dats[i,1], pattern = " #")[[1]][1]
    dats[i,7] <- str_split(dats[i,1], pattern = " #")[[1]][2]
    dats[i,8] <- as.numeric(gsub(pattern = ",", replacement = "", x = substring(dats[i,2],2)))
    dats[i,9] <- as.numeric(gsub(pattern = ",", replacement = "", x = str_split(dats[1,5], pattern = " ft²")[[1]][1]))
}
datr <- data.frame(datr, address = character(length(datr$baths)),
                   unit = character(length(datr$baths)),
                   rent_p = numeric(length(datr$baths)),
                   area_ft = numeric(length(datr$baths)), stringsAsFactors = FALSE)
for (i in 1:length(datr$baths)){
    datr[i,6] <- str_split(datr[i,1], pattern = " #")[[1]][1]
    datr[i,7] <- str_split(datr[i,1], pattern = " #")[[1]][2]
    datr[i,8] <- as.numeric(gsub(pattern = ",", replacement = "", x = substring(datr[i,2],2)))
    datr[i,9] <- as.numeric(gsub(pattern = ",", replacement = "", x = str_split(datr[1,5], pattern = " ft²")[[1]][1]))
}
