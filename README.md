[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3635896.svg)](https://doi.org/10.5281/zenodo.3635896)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

# AOIanalyseR

## Overview

AOIanalyseR is a R Package for creating AOI Sequence Charts (AOI = area of interest) related to eye tracking data, helping you with the evaluation of your test subjects gaze behaviour. 

AOIanalyseR requires the eye tracking data in a similar way to its "Sample.tsv"

AOIanalyseR was initially developed during my Master Thesis "Entwicklung und Evaluation einer Intervention zur Lesekompetenz von Netzwerkgrafiken" (Steve Sydow, University of applied Sciences Stralsund, 2020).

## Installation

For now please use `devtools::install_github("LordSydow/AOIanalyseR")` to install the package.

## Usage 

* Load the package
```
library(AOIanalyseR)
```

* Import Sample.tsv: 
```
data <- AOIanalyseR::importData(
  files = system.file("extdata", "Sample.tsv", package = "AOIanalyseR", mustWork = TRUE),
  name_column = "subject",
  time_column = "time",
  aoi_columns = c("title", "pic", "text")
)
```
* Import your eye tracking data:
```
data <- AOIanalyseR::importData(
  files = c("YOUR_FILE_1, YOUR_FILE_2"),
  delimiter = ";", # use "," or ";" for csv and "\t" for tsv   
  name_column = "YOUR_NAME_COL",
  time_column = "YOUR_TIME_COL",
  aoi_columns = c("YOUR_FIRST_AOI", "YOUR_SECOND_AOI", "YOUR_THIRD_AOI")
)
```
* Create "AOI Sequence Charts" with personalized title 
```
AOIanalyseR::createAOISequenceChart(
  data,
  ggplot_object = ggplot2::labs(title = "Title", x = "x-axis", y = "y-axis")
)
```
All charts are interactive. Klick on an AOI beneath the chart to select the AOI you want to look at or use the plotly functions in the top right corner. 
* Create an alternative "AOI Sequence Chart" (only one test subject per chart)
```
# Using importedData from Sample.tsv
AOIanalyseR::createAOISplitChart(data = AOIanalyseR::importedData, name = "subject1")
```
* View statistics
```
stats <- AOIanalyseR::createStats(data)
```
* Create  Bar Chart with statistics for all AOI
```
AOIanalyseR::createStatsChart(
  stats,
  ggplot_object = ggplot2::labs(title = "Title", x = "x-axis", y = "y-axis")
)
```
* Create Bar Chart for one AOI
```
AOIanalyseR::createStatsChart(
  stats,
  aoi = "YOUR_AOI", 
  ggplot_object = ggplot2::labs(title = "Title", x = "x-axis", y = "y-axis")
)
```
