library("AOIanalyseR")
context("Import")

test_that("import works properly", {
  # Create test object
  filePath <- system.file(
    "extdata","Sample.tsv",package = "AOIanalyseR",mustWork = TRUE)

  # function throws an error while getting no files or no columns
  expect_error(importData(), "Error in importData()")
  expect_error(importData(filePath))
  expect_error(importData(filePath, "\t", "subject", "time"))
  expect_error(importData(filePath, "\t", "subject", "time", "text"))

  # test object equals actual output
  expect_equal(
    importData(files = filePath,
               name_column = "subject",
               time_column = "time",
               aoi_columns = c("pic", "title", "text")),
    AOIanalyseR::importedData
  )
})
