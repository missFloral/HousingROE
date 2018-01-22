# walkscore data
# This is the code for "ws_df" dataset.

## 1. Manhattan zipcode
zipcode <- c("10282", "10281", "10075", "10069", "10065", "10040", "10031", "10026", "10027",
             "10030", "10037", "10039", "10001", "10011", "10018", "10019", "10020", "10036",
             "10029", "10035", "10010", "10016", "10017", "10022", "10012", "10013", "10014",
             "10004", "10005", "10006", "10007", "10038", "10280", "10002", "10003", "10009",
             "10021", "10028", "10044", "10065", "10075", "10128", "10023", "10024", "10025")
## 2. web scraping
library(rvest)
ws_url <- "https://www.walkscore.com/NY/New_York/"
ws_tbl <- data.frame(Name = integer(), Walk.Score = integer())
for (i in 1:length(zipcode)){
    ws_req <- read_html(paste(ws_url, zipcode[i], sep = ""))
    ws_info <- ws_req %>%
      html_nodes(css = ".tablesorter") %>%
      html_table(header = TRUE) %>%
      as.data.frame()
    ws_pt <- ws_info[, 2:3]
    ws_tbl <- rbind(ws_tbl, ws_pt)
}
ws_df <- unique(ws_tbl[ws_tbl$Name %in% zipcode, ])
colnames(ws_df) <- c("postal_code", "walk_score")
ws_df <- data_frame(ws_df$postal_code, ws_df$walk_score)
