test_that("output is a dataframe", {
  hull.data <- get_hull_data(OTU_Table = OTU_Table, SampleMetadata = c(1, 5), 
                             NMDS = c("NMDS1", "NMDS2"), 
                             habitat = "Microhabitat", 
                             which = "all")
  expect_s3_class(hull.data, "data.frame")
})

test_that("Error with false input", {
  expect_error(object = get_hull_data(OTU_Table = OTU_Table, SampleMetadata = c(1, 5), 
                                      NMDS = "NMDS1", 
                                      habitat = "Microhabitat", 
                                      which = "all"))
})