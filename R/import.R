#' Import eye tracking data
#'
#' Imports and Optimizes data for generating aoi sequence charts
#'
#' @author Steve Sydow
#'
#' @param files a Vector containing the file name/names
#' @param delimiter sets delimiter (i.e. \code{"\t"} for tab-seperated values)
#' @param name_column name of the column containing the subjects name
#' @param time_column name of the column containing the times of measurement
#' @param aoi_columns names (2 or more) of the columns containing aoi data
#'
#' @return \code{Data.Frame}
#'
#' @import readr
#' @import dplyr
#' @export
#'
#' @examples
#' \dontrun{importData(files = system.file("extdata",
#'                                         "Sample.tsv",
#'                                         package = "AOIanalyseR",
#'                                         mustWork = TRUE),
#'                     name_column = "subject",
#'                     time_column = "time",
#'                     aoi_columns = c("title", "pic", "text"))}
#'
importData <- function(files = "",
                       delimiter = "\t",
                       name_column = "",
                       time_column = "",
                       aoi_columns = ""){

  `%>%` <- dplyr::`%>%`

  if(length(files)==0){
    stop("Error in importData(): files is empty")  }
  if(name_column=="" || time_column==""){
    stop("Error in importData(): name_column or time_column is empty")}
  if(length(aoi_columns)<2){
    stop("Error in importData(): aoi_columns: please select two or more")}

  columns <- c(name_column, time_column, aoi_columns)
  columns <- factor(columns, levels=columns)
  data <- do.call("rbind", lapply(files, function(fn)
    data.frame(
      Filename = fn,
      readr::read_delim(file = fn, delim = delimiter) %>%
        dplyr::mutate_if(is.numeric, ~ replace(., is.na(.), 0)) %>%
        dplyr::mutate_if(is.character, ~ replace(., is.na(.), "0")) %>%
        dplyr::select(levels(columns))
    )))
  return(rleAOIData(oneAOIColumn(data, aoi_columns)))
}

#' Unite aoi columns into one column
#'
#' Create a column containing all the viewed aoi
#'
#' @author Steve Sydow
#'
#' @param data imported data from \code{importData()}
#' @param aoi_columns names of the columns containing aoi data
#'
#' @return \code{Data.Frame}
#'
#' @import dplyr
#' @import tidyr
oneAOIColumn <- function(data, aoi_columns){

  `%>%` <- dplyr::`%>%`

  input_aoi <- data %>%
    dplyr::select(aoi_columns)

  aoi_one_col <- data %>%
    dplyr::select(aoi_columns) %>%
    dplyr::mutate(
      aoi = dplyr::case_when(
        input_aoi[,1]=="1" ~ as.character(aoi_columns[1]), TRUE ~ ""
      )
    )  %>%
    dplyr::select(aoi)

  i <- 2
  repeat{
    new_aoi_data <- input_aoi %>%
      dplyr::mutate(
        new_aoi_data = dplyr::case_when(
          input_aoi[,i]=="1" ~ as.character(aoi_columns[i]),
          TRUE ~ ""
        )
      )  %>%
      dplyr::select(new_aoi_data)

    aoi_one_col <- cbind(aoi_one_col, new_aoi_data)
    aoi_one_col <- tidyr::unite(
      aoi_one_col,"AOI", 1:2, sep = "", remove = TRUE
    )
    i <- i + 1
    if(i>length(aoi_columns)){
      rm(i)
      break
    }
  }

  output <- data.frame(
    "Name" = data[,2],
    "Time_End" = data[,3],
    "AOI" = aoi_one_col,
    stringsAsFactors=FALSE
  )
  Time_Start <- c(0, output$Time_End)
  Time_Start <- Time_Start[-length(Time_Start)]
  output <- cbind(output, Time_Start, stringsAsFactors=FALSE)

  return(output)
}

#' Run length encoding (rle)
#'
#' rle the aoi data
#'
#' @author Steve Sydow
#'
#' @param data optimized data from \code{oneAOIColumn()}
#'
#' @return \code{Data.Frame}
#'
#' @import dplyr
rleAOIData <- function(data){

  `%>%` <- dplyr::`%>%`

  number_of_subjects <- as.numeric(dplyr::n_distinct(data$Name))

  output <- data.frame()
  j <- 1
  repeat{

    new_subject <- data %>%
      dplyr::filter(Name == dplyr::first(data$Name))

    data <- dplyr::setdiff(data, new_subject)

    new_subject <- new_subject[-1,]

    subject_total_time <- dplyr::last(new_subject$Time_End)

    i <- 1
    aoi_start_pointer <- 1
    last_viewed_aoi <- new_subject$AOI[i]
    subject_number_of_data_rows <- as.numeric(base::length(new_subject$Name))

    repeat{
      if(i > subject_number_of_data_rows ||
         last_viewed_aoi != new_subject$AOI[i]){
        newRow <- data.frame(
          "Name" = new_subject$Name[i-1],
          "AOI" = last_viewed_aoi,
          "Time_Start" = new_subject$Time_Start[aoi_start_pointer],
          "Time_End" = new_subject$Time_End[i-1],
          stringsAsFactors=FALSE
        )
        new_subject <- rbind(new_subject, newRow)

        if(i > subject_number_of_data_rows){
          # Unkodierte Zeilen löschen
          new_subject <- new_subject[-(1:subject_number_of_data_rows),]
          rm(i)
          rm(aoi_start_pointer)
          rm(last_viewed_aoi)
          break
        }

        last_viewed_aoi <- new_subject$AOI[i]
        aoi_start_pointer <- i
      }
      i <- i + 1
    }

    new_subject <- cbind(
      new_subject,
      "Time_Total" = rep(subject_total_time, length(new_subject$Name))
    )

    output <- rbind(output, new_subject)

    j <- j + 1
    if(j > number_of_subjects){
      rm(j)
      break
    }
  }

  # changing format if nessecary
  output$AOI <- factor(output$AOI)
  output$Time_Start <- as.numeric(gsub(",", ".", output$Time_Start))
  output$Time_End <- as.numeric(gsub(",", ".", output$Time_End))

  return(output %>%
           dplyr::select(Name, AOI, Time_Start, Time_End, Time_Total)
  )
}
