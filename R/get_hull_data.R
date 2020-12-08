#' get_hull_data
#' 
#' Saves convex hulls for specified habitats for plotting with ggplot
#' 
#' @param NMDS_data result from the `get_NMDS_Ordination` function
#' @param SampleMetadata the Metadata for the samples. Can be separate table or 
#' specified which columns in the OTU table should be used (start and end, e.g. c(1, 5)). 
#' Must be in beginning of OTU table
#' @param NMDS which NMDS axes to display. 
#' Must specify two, e.g. c("NMDS1", "NMDS2")
#' @param logtransform logical, should abundances be log transformed?
#' @param relative logical, should relative abundances be used?
#' @param habitat which sample type to draw hull data from. 
#' Must be a column name in the sample metadata
#' @param which which samples to use. 
#' Must be "all" or vector of specified habitats (see details)
#' 
#' @importFrom vegan scores
#' @importFrom grDevices chull
#' @importFrom checkmate assert_vector assert_true
#' 
#' @export
#' 
#' @examples 
#' 
#' data(OTU_Table)
#' 
#' NMDS.data = get_NMDS_ordination(
#'   OTU_Table = OTU_Table, 
#'   SampleMetadata = c(1, 5),
#'   relative = TRUE, 
#'   logtransform = TRUE)
#'   
#' hull.data = get_hull_data(
#'   NMDS_data = NMDS.data, 
#'   SampleMetadata = OTU_Table[,1:5],
#'   NMDS = c("NMDS1", "NMDS2"), 
#'   habitat = "Microhabitat", 
#'   which = "all")
#' 
#' @return 
#' a dataframe containing the convex hull coordinates for the given habitats

get_hull_data = function(NMDS_data,
                         SampleMetadata, 
                         NMDS = c(c("NMDS1", "NMDS2"), 
                                  c("NMDS1", "NMDS3"), 
                                  c("NMDS2", "NMDS3")), 
                         habitat = c("Microhabitat", "TreeSpecies"),
                         which = c("all", c("Habitat1", "Habitat2", "..."))){
  
  # check for correct number of axes specified
  assert_vector(x = NMDS, len = 2)
  
  # extract species matrix and sample metadata from OTU_Table
  # if SampleMetadata is specified as column numbers, use these
  if(is.numeric(SampleMetadata)){
    SampleMetadataColumns = SampleMetadata
    SampleMetadata = 
      as.data.frame(OTU_Table[,min(SampleMetadataColumns):max(SampleMetadataColumns)])
    species_mat = 
      as.matrix(OTU_Table[,(max(SampleMetadataColumns) + 1):ncol(OTU_Table)])
  } else{
    SampleMetadata = as.data.frame(SampleMetadata)
    species_mat = as.matrix(OTU_Table)
  }
  
  # check for correct sample specification (must be a column in the metadata)
  assert_true(habitat %in% colnames(SampleMetadata))
  
  # Get the sample scores and add the metadata
  data.scores = as.data.frame(scores(NMDS_data))
  data.scores$site = rownames(data.scores)
  data.scores$Microhabitat = SampleMetadata$Microhabitat
  data.scores$Stratum = SampleMetadata$Stratum
  data.scores$TreeSpecies = SampleMetadata$TreeSpecies
  
  # use all samples or only specified ones
  if(length(which) == 1 && which == "all"){
    habitatvector = levels(OTU_Table[,habitat])
  } else{
    habitatvector = which
  }
  
  # calculate hull data for specified habitats
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
  
  return(hull.data)
  
}
