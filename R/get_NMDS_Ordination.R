#' get_NMDS_ordination
#' 
#' Performs NMDS ordination and saves it in a dataframe
#' 
#' @param OTU_Table an OTU table with or without sample metadata (see
#' "SampleMetadata" for details)
#' @param SampleMetadata the Metadata for the samples. Can be separate table or 
#' specified which columns in the OTU table should be used (start and end, e.g. c(1, 5)). 
#' Must be in beginning of OTU table. If specifying a separate table, the 
#' OTU table must not contain metadata. See "Examples"
#' @param logtransform logical, should abundances be log transformed?
#' @param relative logical, should relative abundances be used?
#' @param k number of axes to display. See \code{\link[vegan]{metaMDS}}
#' @param trymax max number of iterations. See \code{\link[vegan]{metaMDS}}
#' @param ... arguments passed to \code{\link[vegan]{metaMDS}}
#' 
#' @importFrom funrar make_relative
#' @importFrom vegan vegdist metaMDS scores
#' @importFrom checkmate expect_numeric
#' 
#' @export
#' 
#' @examples 
#' # Specifying SampleMetadata columns in OTU Table
#' NMDS.data = get_NMDS_ordination(
#'   OTU_Table = OTU_Table, 
#'   SampleMetadata = c(1, 5),
#'   relative = TRUE, 
#'   logtransform = TRUE, 
#'   k = 3, 
#'   trymax = 100)
#'   
#' # Specifying SampleMetadata as separate table
#' NMDS.data = get_NMDS_ordination(
#'   OTU_Table = OTU_Table[,6:ncol(OTU_Table)], 
#'   SampleMetadata = OTU_Table[,1:5],
#'   relative = TRUE, 
#'   logtransform = TRUE, 
#'   k = 3, 
#'   trymax = 100)
#' 
#' @return 
#' a list of class `metaMNDS` containing NMDS ordination

get_NMDS_ordination = function(OTU_Table, 
                         SampleMetadata,
                         logtransform = T, 
                         relative = T,
                         k = 3, 
                         trymax = 100, 
                         ...){
  
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
  
  # check for numeric OTU table. If not, it probably contains metadata
  expect_numeric(species_mat[,1], 
                 info = "species matrix contains characters. Does it still include metadata? see `?get_NMDS_ordination`")
  
  # make relative if specified
  if(relative == T){
    species_mat = make_relative(species_mat)
  }
  
  # log transform if specified
  if(logtransform == T){
    species_mat = log(species_mat +1)
  }
  
  # perform NMDS ordination
  OTU.NMDS = metaMDS(species_mat,
                          k = k, 
                          trymax = trymax, 
                          ...)

  return(OTU.NMDS)
  }