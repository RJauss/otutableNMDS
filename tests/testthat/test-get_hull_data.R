test_that("output is a dataframe", {
  NMDS.data = get_NMDS_ordination(
    OTU_Table = OTU_Table, 
    SampleMetadata = c(1, 5),
    relative = TRUE, 
    logtransform = TRUE)
  
  hull.data <- get_hull_data(NMDS_data = NMDS.data, 
                             SampleMetadata = OTU_Table[,1:5], 
                             NMDS = c("NMDS1", "NMDS2"), 
                             habitat = "Microhabitat", 
                             which = "all")
  expect_s3_class(hull.data, "data.frame")
})

test_that("Error with false input", {
  NMDS.data = get_NMDS_ordination(
    OTU_Table = OTU_Table, 
    SampleMetadata = c(1, 5),
    relative = TRUE, 
    logtransform = TRUE)
  
  expect_error(object = get_hull_data(NMDS_data = NMDS.data, 
                                      SampleMetadata = OTU_Table[,1:5], 
                                      NMDS = "NMDS1", 
                                      habitat = "Microhabitat", 
                                      which = "all"))
})