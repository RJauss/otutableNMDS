#' get_NMDS_ordination
#' 
#' Performs NMDS ordination and saves it in a dataframe
#' 
#' @param OTU_Table an OTU table with or without sample metadata
#' @param SampleMetadata the Metadata for the samples. Can be separate table or 
#' specified which columns in the OTU table should be used (start and end, e.g. c(1, 5)). 
#' Must be in beginning of OTU table
#' @param logtransform logical, should abundances be log transformed?
#' @param relative logical, should relative abundances be used?
#' 
#' @importFrom funrar make_relative
#' @importFrom vegan vegdist metaMDS scores
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
#' @return 
#' a dataframe containing NMDS ordination

get_NMDS_ordination = function(OTU_Table, 
                         SampleMetadata,
                         logtransform = T, 
                         relative = T){
  
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
  #assert_true(habitat %in% colnames(SampleMetadata))
  
  # make relative if specified
  if(relative == T){
    species_mat = make_relative(species_mat)
  }
  
  # log transform if specified
  if(logtransform == T){
    species_mat = log(species_mat +1)
  }
  
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

  return(OTU.NMDS.bray)
  }