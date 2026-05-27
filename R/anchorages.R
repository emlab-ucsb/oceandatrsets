#' Anchorages data from Global Fishing Watch
#'
#' Data is from Global Fishing Watch and identifies anchorages as anywhere
#' vessels with AIS remain stationary for 12 hours or more.
#'
#' Intended for use by `oceandatr::get_dist()` with argument `dist_to =
#' "anchorages_all"`.
#'
#' See `data-raw/gfw_anchorages.R` for data preparation code.
#'
#' @format ## `anchorages_all` A data frame with 166,496 rows and 2 columns:
#' \describe{
#'   \item{x}{x coordinate}
#'   \item{y}{y coordinate}
#' }
#' @source <https://globalfishingwatch.org/datasets-and-code-anchorages/>

"anchorages_all"

#' Grouped anchorages data from Global Fishing Watch
#'
#' Data is from Global Fishing Watch and identifies anchorages as anywhere
#' vessels with AIS remain stationary for 12 hours or more.  Anchorages close
#' together have the same names, so to reduce the number of anchorages, they
#' were aggregated by iso3 code (country code) and label (name) and the mean
#' longitude and latitude coordinates obtained to get one anchorage point per
#' name in each country.
#'
#' Anchorages that fall on land (`on_land` column value is TRUE) were defined by
#' points that fall within the Natural Earth land boundaries, buffered by 10km
#' inland so as to avoid cutting off coastal anchorages that fall within the
#' land boundary, due to inaccuracies in the Natural Earth land boundaries, e.g.
#' for islands and other small scale coastlines. This further reduces the number
#' of anchorages by removing any that are along rivers and so not relevant to
#' most ocean based data work.
#'
#' Intended for use by `oceandatr::get_dist()` with argument `dist_to =
#' "anchorages_grouped"` or `dist_to = "anchorages_land_masked"`.
#'
#' See `data-raw/gfw_anchorages.R` for data preparation code.
#'
#' @format ## `anchorages_grouped` A data frame with 166,496 rows and 2 columns:
#' \describe{
#'   \item{on_land}{`logical` specifying if point is on land (TRUE) or not (FALSE)}
#'   \item{x}{x coordinate}
#'   \item{y}{y coordinate}
#' }
#' @source <https://globalfishingwatch.org/datasets-and-code-anchorages/>

"anchorages_grouped"
