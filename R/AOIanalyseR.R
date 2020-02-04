#' AOIanalyseR: Analysing eye tracking data with "AOI Sequence Charts"
#'
#' Create "AOI Sequence Charts" and other useful statistics (i.e. aoi view time)
#' related to your eye tracking data. Compare charts and get information about how
#' the subjects viewed your graphics, texts, advertisments...
#'
#' AOI = area of interest. "AOI Sequence Charts" create readable and compareable
#' timelines out of the fixations of your test subjects.
#'
#' @docType package
#' @name AOIanalyseR
"_PACKAGE"

utils::globalVariables(
  c("import", "Name", "AOI", "Time_Start", "Time_End", "Time_Total", "aoi"))
utils::globalVariables(
  c("statistics", "Time_Relative")
)
