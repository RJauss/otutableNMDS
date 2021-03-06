test_that("output is a ggplot object", {
  data(OTU_Table)
  
  NMDS.data = get_NMDS_ordination(
    OTU_Table = OTU_Table, 
    SampleMetadata = c(1, 5),
    relative = TRUE, 
    logtransform = TRUE, 
    k = 3, 
    trymax = 100)
  
  hull.data <- get_hull_data(NMDS_data = NMDS.data, 
                             SampleMetadata = OTU_Table[,1:5], 
                             NMDS = c("NMDS1", "NMDS2"), 
                             habitat = "Microhabitat", 
                             which = "all")
  
  hull.data.TreeSpecies <- get_hull_data(NMDS_data = NMDS.data, 
                             SampleMetadata = OTU_Table[,1:5], 
                             NMDS = c("NMDS1", "NMDS2"), 
                             habitat = "TreeSpecies", 
                             which = "all")
  
  g = plot_NMDS(hull_data = hull.data, 
                hull_data2 = hull.data.TreeSpecies, 
                NMDS_data = NMDS.data, 
                x = "NMDS1", 
                y = "NMDS2",
                habitat = "Microhabitat", 
                habitat2 = "TreeSpecies")
  
  expect_s3_class(g, "ggplot")
})