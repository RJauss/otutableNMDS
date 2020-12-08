test_that("output is a ggplot object", {
  data(OTU_Table)
  
  hull.data = get_hull_data(
    OTU_Table = OTU_Table, 
    SampleMetadata = c(1, 5),
    NMDS = c("NMDS1", "NMDS2"), 
    relative = TRUE, 
    logtransform = TRUE, 
    habitat = "Microhabitat", 
    which = "all")
  
  hull.data.TreeSpecies = get_hull_data(
    OTU_Table = OTU_Table, 
    SampleMetadata = c(1, 5),
    NMDS = c("NMDS1", "NMDS2"), 
    relative = TRUE, 
    logtransform = TRUE, 
    habitat = "TreeSpecies", 
    which = "all")
  
  g = plot_NMDS(hull_data = hull.data, hull_data2 = hull.data.TreeSpecies, 
                x = "NMDS1", y = "NMDS2", 
                group1 = "Microhabitat", group2 = "TreeSpecies")
  
  expect_s3_class(g, "ggplot")
})