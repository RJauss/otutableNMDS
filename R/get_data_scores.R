#' get_data_scores
#' 
#' Performs NMDS ordination and saves convex hulls for specified habitats in `hull.data`
#' 
#' @param OTU_Table an OTU table including sample metadata in columns 1-5
#' @param NMDS which NMDS axes to display. Must specify two, e.g. c("NMDS1", "NMDS2")
#' @param logtransform logical, should abundances be log transformed?
#' @param relative logical, should relative abundances be used?
#' @param type one of "Microhabitat" or "TreeSpecies". Returns hull data for either
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
#' relative = T, logtransform = T, type = "Microhabitat")
#' 
#' @return 
#' a dataframe containing the convex hull coordinates for the given microhabitats

get_data_scores = function(OTU_Table, NMDS = c(c("NMDS1", "NMDS2"), 
                                               c("NMDS1", "NMDS3"), 
                                               c("NMDS2", "NMDS3")), 
                           logtransform = T, relative = T, type){
  match.arg(arg = type, choices = c("TreeSpecies", "Microhabitat"))
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
  
  if(type == "Microhabitat"){
  
  # Group the samples by metadata (in this case, microhabitat and tree species)
  Group.FreshLeaves = data.scores[data.scores$Microhabitat == "Fresh Leaves",][chull(data.scores[data.scores$Microhabitat == "Fresh Leaves", NMDS]), ]
  Group.Soil = data.scores[data.scores$Microhabitat == "Soil",][chull(data.scores[data.scores$Microhabitat == "Soil", NMDS]), ]
  Group.Bark = data.scores[data.scores$Microhabitat == "Bark",][chull(data.scores[data.scores$Microhabitat == "Bark", NMDS]), ]
  Group.ArborealSoil = data.scores[data.scores$Microhabitat == "Arboreal Soil",][chull(data.scores[data.scores$Microhabitat == "Arboreal Soil", NMDS]), ]
  Group.Lichen = data.scores[data.scores$Microhabitat == "Lichen",][chull(data.scores[data.scores$Microhabitat == "Lichen", NMDS]), ]
  Group.Hypnum = data.scores[data.scores$Microhabitat == "Hypnum",][chull(data.scores[data.scores$Microhabitat == "Hypnum", NMDS]), ]
  Group.LeafLitter = data.scores[data.scores$Microhabitat == "Leaf Litter",][chull(data.scores[data.scores$Microhabitat == "Leaf Litter", NMDS]), ]
  Group.Orthotrichum = data.scores[data.scores$Microhabitat == "Orthotrichum",][chull(data.scores[data.scores$Microhabitat == "Orthotrichum", NMDS]), ]
  Group.Deadwood = data.scores[data.scores$Microhabitat == "Deadwood",][chull(data.scores[data.scores$Microhabitat == "Deadwood", NMDS]), ]
  
  # The hull-data will be needed by ggplot later to draw the polygons
  hull.data = rbind(Group.ArborealSoil, Group.Bark, Group.Deadwood, Group.FreshLeaves, Group.Hypnum, Group.LeafLitter, Group.Lichen, Group.Orthotrichum, Group.Soil)
  
  return(hull.data)
  
  }else if(type == "TreeSpecies"){
  
  Group.Tilia = data.scores[data.scores$TreeSpecies == "Tilia cordata",][chull(data.scores[data.scores$TreeSpecies == "Tilia cordata", NMDS]), ]
  Group.Quercus = data.scores[data.scores$TreeSpecies == "Quercus robur",][chull(data.scores[data.scores$TreeSpecies == "Quercus robur", NMDS]), ]
  Group.Fraxinus = data.scores[data.scores$TreeSpecies == "Fraxinus excelsior",][chull(data.scores[data.scores$TreeSpecies == "Fraxinus excelsior", NMDS]), ]
  
  hull.data_TreeSpecies = rbind(Group.Tilia, Group.Quercus, Group.Fraxinus)
  
  return(hull.data_TreeSpecies)
  
  }
}