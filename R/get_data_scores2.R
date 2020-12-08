#' get_data_scores2
#' 
#' Performs NMDS ordination and saves convex hulls for specified habitats in `hull.data`
#' 
#' @param OTU_Table an OTU table including sample metadata in columns 1-5
#' @param NMDS which NMDS axes to display. Must specify two, e.g. c("NMDS1", "NMDS2")
#' @param logtransform logical, should abundances be log transformed?
#' @param relative logical, should relative abundances be used?
#' @param habitat which sample type to draw hull data from. Must be a column name in the sample metadata
#' @param which which samples to use. Must be "all" or vector of specified habitats (see details)
#' 
#' @importFrom funrar make_relative
#' @importFrom vegan vegdist metaMDS scores
#' @importFrom grDevices chull
#' 
#' @export
#' 
#' @examples 
#' 
#' data(OTU_Table)
#' get_data_scores(OTU_Table = OTU_Table, NMDS = c("NMDS1", "NMDS2"), 
#' relative = T, logtransform = T, habitat = "Microhabitat", which = "all")
#' 
#' @return 
#' a dataframe containing the convex hull coordinates for the given habitats

get_data_scores2 = function(OTU_Table, NMDS = c(c("NMDS1", "NMDS2"), 
                                               c("NMDS1", "NMDS3"), 
                                               c("NMDS2", "NMDS3")), 
                           logtransform = T, relative = T, 
                           habitat = c("Microhabitat", "TreeSpecies"),
                           which = c("all", c("Habitat1", "Habitat2", "..."))){
  #match.arg(arg = type, choices = c("TreeSpecies", "Microhabitat"))
  # extract species matrix and sample metadata from OTU_Table
  species = OTU_Table[,6:ncol(OTU_Table)]
  species_mat = as.matrix(species)
  if(relative == T){
    species_mat = make_relative(species_mat)
  }
  if(logtransform == T){
    species_mat = log(species_mat +1)
  }
  SampleMetadata = as.data.frame(OTU_Table[,1:5])
  
  # calculate distance matrix with vegdist
  Dist = vegdist(species_mat, 
                 diag = T, 
                 na.rm = T)
  
  # perform Non-metric Multidimensional Scaling
  OTU.NMDS.bray = metaMDS(Dist, # The distance matrix
                          k=3, # How many dimensions/axes to display 
                          trymax=100, # max number of iterations
                          wascores=TRUE, # Weighted species scores
                          trace=TRUE,
                          zerodist="add") # What to do with 0's after sqrt transformation
  
  # Get the sample scores and add the metadata
  data.scores = as.data.frame(scores(OTU.NMDS.bray))
  data.scores$site = rownames(data.scores)
  data.scores$Microhabitat = SampleMetadata$Microhabitat
  data.scores$Stratum = SampleMetadata$Stratum
  data.scores$TreeSpecies = SampleMetadata$TreeSpecies
  
  # calculate hull data for specified habitats
  if(which == "all"){
    habitatvector = levels(OTU_Table[,habitat])
  } else{
    habitatvector = which
  }
  
  for(Microhabitat in habitatvector){
    Microhabitat_String = gsub(" ", "_", Microhabitat)
    assign(paste0("Group.", Microhabitat_String), 
           data.scores[data.scores[habitat] == Microhabitat,][chull(data.scores[data.scores[habitat] == Microhabitat, NMDS]), ])
  }
  
  
  # The hull-data will be needed by ggplot later to draw the polygons
  i = 1
  for(Group in ls(pattern = "Group")){
    if(i == 1){
      Group = get(Group)
      hull.data = Group
      i = i + 1
    } else{
      Group = get(Group)
      hull.data = rbind(hull.data, Group)
      i = i + 1
    }
  }
  #hull.data = rbind(Group.ArborealSoil, Group.Bark, Group.Deadwood, Group.FreshLeaves, Group.Hypnum, Group.LeafLitter, Group.Lichen, Group.Orthotrichum, Group.Soil)
  
  return(hull.data)
  
}
