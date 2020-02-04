#' Create statistics for the subjects
#'
#' Shows absolute and relative aoi times
#'
#' @author Steve Sydow
#'
#' @param data imported data from \code{importData()}
#'
#' @return \code{Data.Frame}
#'
#' @import dplyr
#' @importFrom stats aggregate
#' @export
#'
#' @examples
#' createStats(importedData)
#'
createStats <- function(data){

  stats <- stats::aggregate((data$Time_End-data$Time_Start),
                     by=list(AOI=data$AOI,
                             Subject=factor(data$Name)), FUN=sum)

  subject_length <- stats::aggregate((stats$x),
                        by=list(Subject=stats$Subject,
                                AOI=rep("Gesamt",
                                        times=length(stats$Subject))),
                        FUN=sum)

  stats <- rbind(subject_length, stats)
  stats <- cbind(stats, stats$x)

  # Renaming Time Columns for readability
  names(stats)[names(stats) == 'x'] <- 'Time_Absolut'
  names(stats)[names(stats) == 'stats$x'] <- 'Time_Relative'

  stats <- stats[order(stats$Subject),]

  # Calculating relative view times per AOI
  i <- 1
  max_length <- stats$Time_Absolut[i]
  stats$Time_Relative[i] <- (stats$Time_Relative[i]/max_length)
  repeat{
    i <- i + 1
    if(i>length(stats[,1])){
      break
    }
    # first row per name equals total view time
    if(as.character(stats$Subject[i-1]) != as.character(stats$Subject[i])){
      max_length <- stats$Time_Absolut[i]
    }
    stats$Time_Relative[i] <- (stats$Time_Relative[i]/max_length)
  }

  return(dplyr::filter(stats, Time_Relative < 1))
}

#' Create Bar Chart for aoi view times
#'
#' @author Steve Sydow
#'
#' @param stats data from \code{createStats()}
#' @param aoi showing all aoi at ones (default) or only one aoi
#' @param ggplot_object optional, additional ggplot code/settings
#'
#' @return ggplotly chart
#'
#' @import dplyr
#' @import ggplot2
#' @importFrom plotly ggplotly
#' @export
#'
#' @examples
#' createStatsChart(createStats(importedData))
#' createStatsChart(createStats(importedData), aoi = "title")
#' createStatsChart(createStats(importedData),
#'                  ggplot_object = ggplot2::labs(title =""))
#'
createStatsChart <- function(stats,
                             aoi = "all",
                             ggplot_object = NULL){

  if(aoi != "all"){
    stats <- dplyr::filter(stats, AOI == aoi)
  }

  return(
    plotly::ggplotly(
      ggplot2::ggplot(
        ggplot2::aes(
          y = stats$Time_Relative,
          x = stats$Subject,
          fill = stats$AOI),
        data = stats
      ) + ggplot2::geom_histogram(
        stat = "identity",
        position = ggplot2::position_stack()
      ) + ggplot_object
    )
  )
}
