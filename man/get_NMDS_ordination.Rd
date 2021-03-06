% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_NMDS_Ordination.R
\name{get_NMDS_ordination}
\alias{get_NMDS_ordination}
\title{get_NMDS_ordination}
\usage{
get_NMDS_ordination(OTU_Table, SampleMetadata, logtransform = T,
  relative = T, k = 3, trymax = 100, ...)
}
\arguments{
\item{OTU_Table}{an OTU table with or without sample metadata (see
"SampleMetadata" for details)}

\item{SampleMetadata}{the Metadata for the samples. Can be separate table or
specified which columns in the OTU table should be used (start and end, e.g. c(1, 5)).
Must be in beginning of OTU table. If specifying a separate table, the
OTU table must not contain metadata. See "Examples"}

\item{logtransform}{logical, should abundances be log transformed?}

\item{relative}{logical, should relative abundances be used?}

\item{k}{number of axes to display. See \code{\link[vegan]{metaMDS}}}

\item{trymax}{max number of iterations. See \code{\link[vegan]{metaMDS}}}

\item{...}{arguments passed to \code{\link[vegan]{metaMDS}}}
}
\value{
a list of class \code{metaMNDS} containing NMDS ordination
}
\description{
Performs NMDS ordination and saves it in a dataframe
}
\examples{
# Specifying SampleMetadata columns in OTU Table
NMDS.data = get_NMDS_ordination(
  OTU_Table = OTU_Table, 
  SampleMetadata = c(1, 5),
  relative = TRUE, 
  logtransform = TRUE, 
  k = 3, 
  trymax = 100)
  
# Specifying SampleMetadata as separate table
NMDS.data = get_NMDS_ordination(
  OTU_Table = OTU_Table[,6:ncol(OTU_Table)], 
  SampleMetadata = OTU_Table[,1:5],
  relative = TRUE, 
  logtransform = TRUE, 
  k = 3, 
  trymax = 100)

}
