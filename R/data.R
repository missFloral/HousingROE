#' Housing Return on Equity(ROE) with WalkScore
#'
#' A dataset that contains the calculation of ROE and walk score
#' combined by zipcode for every housing in Manhattan.
#'
#' @format A data frame with 720 rows and 8 variables:
#' \describe{
#'   \item{formatted_address}{full address with city and zipcode}
#'   \item{beds}{bed information within the unit}
#'   \item{baths}{bath information within the unit}
#'   \item{postal_code}{zipcode accompanied with address}
#'   \item{latitude}{geodata of location}
#'   \item{longitude}{geodata of location}
#'   \item{roe}{return on equity for each unit}
#'   \item{walk_score}{walk score for each unit}
#' }
"datot"

#' Rental Data with other housing information
#'
#' A dataset that collect Manhattan housing for rental, with both
#' format of text and number for unit info.
#'
#' @format A data frame with 12082 rows and 9 variables:
#' \describe{
#'   \item{street}{address with unit info}
#'   \item{rent}{rent with punctuation mark}
#'   \item{beds}{bed information within the unit}
#'   \item{baths}{bath information within the unit}
#'   \item{ftsq}{size of the unit in ft square}
#'   \item{address}{address without unit info}
#'   \item{unit}{unit info}
#'   \item{rent_p}{numeric version of rent}
#'   \item{area_ft}{numeric version of area ft}
#' }
"datr"

#' Sale Data with other housing information
#'
#' A dataset that collect Manhattan housing for sale, with both
#' format of text and number for unit info.
#'
#' @format A data frame with 12082 rows and 9 variables:
#' \describe{
#'   \item{street}{address with unit info}
#'   \item{sale}{sale with punctuation mark}
#'   \item{beds}{bed information within the unit}
#'   \item{baths}{bath information within the unit}
#'   \item{ftsq}{size of the unit in ft square}
#'   \item{address}{address without unit info}
#'   \item{unit}{unit info}
#'   \item{sale_p}{numeric version of rent}
#'   \item{area_ft}{numeric version of area ft}
#' }
"dats"

#' Walk Score Data with zipcode
#'
#' A dataset include walk score and corresponding zipcode.
#'
#' @format A data frame with 42 rows and 2 variables:
#' \describe{
#'   \item{postal_code}{zipcode}
#'   \item{walk_score}{walk score for each unit}
#' }
#'
#' For further details, see \url{https://www.walkscore.com/professional/}
#'
"ws_df"
