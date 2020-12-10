#' get_hull_data
#' 
#' Saves convex hulls for specified habitats for plotting with ggplot
#' 
#' @param NMDS_data result from the \code{\link[otutableNMDS]{get_NMDS_ordination}} function
#' @param SampleMetadata the Metadata for the samples. Must be separate table
#' @param NMDS which NMDS axes to display. 
#' Must specify two, e.g. c("NMDS1", "NMDS2")
#' @param habitat which sample type to draw hull data from. 
#' Must be a column name in the sample metadata
#' @param which which samples to use. 
#' Must be "all" or vector of specified habitats (see details)
#' 
#' @importFrom vegan scores
#' @importFrom grDevices chull
#' @importFrom checkmate expect_atomic_vector
#' @importFrom testthat expect_true
#' 
#' @export
#' 
#' @examples 
#' 
#' data(OTU_Table)
#' 
#' NMDS.data = get_NMDS_ordination(
#'   OTU_Table = OTU_Table, 
#'   SampleMetadata = c(1, 5))
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
  expect_atomic_vector(x = NMDS, len = 2, 
                       info = "Please specify two NMDS axes to display")
  
  # extract species matrix and sample metadata from OTU_Table
  # if SampleMetadata is specified as column numbers, use these
  SampleMetadata = as.data.frame(SampleMetadata)
  
  # check for correct sample specification (must be a column in the metadata)
  expect_true(habitat %in% colnames(SampleMetadata), 
              info = "Your specified habitat must be a column name in your metadata")
  
  # Get the sample scores and add the metadata
  data.scores = as.data.frame(scores(NMDS_data))
  data.scores$site = rownames(data.scores)
  data.scores[, habitat] = SampleMetadata[, habitat]
  
  # use all samples or only specified ones
  if(length(which) == 1 && which == "all"){
    habitatvector = levels(SampleMetadata[,habitat])
  } else if(length(which) > 1 && "all" %in% which){
    stop("Please specify which = 'all' or which = c('Habitat1', 'Habitat2', etc)")
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
