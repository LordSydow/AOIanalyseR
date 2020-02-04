[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3635896.svg)](https://doi.org/10.5281/zenodo.3635896)

# AOIanalyseR

## Overview

AOIanalyseR is a R Package for creating AOI Sequence Charts (AOI = area of interest) related to eye tracking data, helping you with the evaluation of your test subjects gaze behaviour. 

AOIanalyseR requires the eye tracking data in a similar way to its "Sample.tsv"

AOIanalyseR was initially developed during my Master Thesis "Entwicklung und Evaluation einer Intervention zur Lesekompetenz von Netzwerkgrafiken" (Steve Sydow, University of applied Sciences Stralsund, 2020).

## Installation

For now please use `devtools::install_github("LordSydow/AOIanalyseR")` to install the package.

## Usage 

Getting started (importing Sample.tsv and creating charts):

* Import your eye tracking data: 
```
data <- AOIanalyseR::importData(
  files = system.file("extdata", "Sample.tsv", package = "AOIanalyseR", mustWork = TRUE),
  name_column = "subject",
  time_column = "time",
  aoi_columns = c("title", "pic", "text")
)
```
* Create "AOI Sequence Charts"  
`AOIanalyseR::createAOISequenceChart(data)`
* Create an alternative "AOI Sequence Chart" (only one test subject per chart)
`AOIanalyseR::createAOISplitChart(data = AOIanalyseR::importedData, name = "subject1")`
* View statistics
`createStats(data)`
