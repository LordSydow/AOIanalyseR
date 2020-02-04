library("AOIanalyseR")
context("Charts")

test_that("charts can be printed", {
  # createAOISequenceCharts works properly ---------------------------------
  expect_error(print(AOIanalyseR::createAOISequenceChart(importedData)), NA)

  # createSplitChart works properly ----------------------------------------
  expect_error(
    print(AOIanalyseR::createAOISplitChart(importedData, "subject1")), NA)

  # createStatsChart works properly ----------------------------------------
  expect_warning(
    print(createStatsChart(createStats(importedData))),
    "Ignoring unknown parameters: binwidth, bins, pad")

  expect_warning(
    print(AOIanalyseR::createStatsChart(
      createStats(importedData),
      aoi = "title")),
    "Ignoring unknown parameters: binwidth, bins, pad")

  expect_warning(
    print(AOIanalyseR::createStatsChart(
      createStats(importedData),
      ggplot_object = ggplot2::labs(title ="TEST"))),
    "Ignoring unknown parameters: binwidth, bins, pad")
})
