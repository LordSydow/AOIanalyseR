#' Create AOI Sequence Charts for all subjects
#'
#' @author Steve Sydow
#'
#' @param data imported data from \code{importData()}
#' @param scaling scale_x_continuous(breaks(), by = scaling)
#' @param size width of every bar
#' @param aoi_columns order of the aoi
#' @param ggplot_object additional ggplot code/settings if needed
#'
#' @return ggplotly chart
#'
#' @import dplyr
#' @import ggplot2
#' @importFrom plotly ggplotly layout
#' @export
#'
#' @examples
#' createAOISequenceChart(importedData)
createAOISequenceChart <- function(data,
                                   scaling = 100,
                                   size = 7,
                                   aoi_columns = NULL,
                                   ggplot_object = NULL){

  `%>%` <- dplyr::`%>%`

  data <- dplyr::filter(data, AOI != "")

  if(is.null(aoi_columns)){
    aoi_columns <- levels(unique(data$AOI))
  }

  charts <- plotly::ggplotly(
    ggplot2::ggplot(
      data,
      ggplot2::aes(color = factor(data$AOI, levels = aoi_columns),
          label = data$Name)) +
      ggplot2::geom_segment(
        ggplot2::aes(
          x = data$Time_Start,
          xend = data$Time_End,
          y = data$Name,
          yend = data$Name
        ),
        size = size
        ) + ggplot2::scale_x_continuous(
          breaks = seq(0, max(data$Time_End), by = scaling)) + ggplot_object
    ,tooltip = c("label")) %>%
    plotly::layout(
      legend = list(
        orientation = "h",
        xanchor = "center",
        x = 0.5,
        yanchor = "bottom",
        y = -0.2
      ))
  return(charts)
}

#' Create AOI Sequence Chart for one subject
#'
#' Generates another version of an AOI Sequence Chart for on subject
#'
#' @author Steve Sydow
#'
#' @param data imported data from \code{importData()}
#' @param name name of the subject
#' @param ggplot_object additional ggplot code/settings if needed
#'
#' @return ggplotly chart
#'
#' @import dplyr
#' @import ggplot2
#' @importFrom plotly ggplotly layout
#' @export
#'
#' @examples
#' createAOISplitChart(data = AOIanalyseR::importedData, name = "subject1")
#'
createAOISplitChart <- function(data, name, ggplot_object = NULL){

  `%>%` <- dplyr::`%>%`

  data <- dplyr::filter(data, AOI != "")

  plotly::ggplotly(
    ggplot2::ggplot(
      subset(
        data,
        Name == name),
      ggplot2::aes(color=AOI, label=(Time_End-Time_Start))) +
      ggplot2::geom_segment(
        ggplot2::aes(x=Time_Start, xend=Time_End, y=AOI, yend=AOI), size=15) +
      ggplot_object,
    tooltip = c("all")) %>%
    plotly::layout(showlegend = FALSE)
}
