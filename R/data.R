#' importedData: Imported eye tracking dataset Sample.tsv
#'
#' Contains the necessary data to create statistics and "AOI Sequence Charts"
#'
#' @docType data
#' @format data.frame created with importData-function and the Sample.tsv:
#' \describe{
#'   \item{Name}{name of the test subject}
#'   \item{AOI}{the aoi the subject is fixating}
#'   \item{Time_Start}{start of the aoi}
#'   \item{Time_End}{end of the aoi}
#'   \item{Time_Total}{total view time}
#' }
#' @source Randomly generated
"importedData"

#' Sample.tsv: A short eye tracking dataset
#'
#' Contains the data of two subjects for creating "AOI Sequence Charts"
#'
#' @docType data
#' @format tsv with 60 rows of data:
#' \describe{
#'   \item{subject}{name of the test subjects}
#'   \item{time}{times of measurement}
#'   \item{title}{aoi1: a title; 0 - not viewed, 1 - viewed}
#'   \item{pic}{aoi2: a picture; 0 - not viewed, 1 - viewed}
#'   \item{text}{ao3: a text; 0 - not viewed, 1 - viewed}
#' }
#' @source Randomly generated
system.file("extdata", "Sample.tsv", package = "AOIanalyseR", mustWork = TRUE)

