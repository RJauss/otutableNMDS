#' plot_NMDS
#' 
#' Plots NMDS ordination based on convex hull data generated from `get_hull_data`
#' 
#' @param hull_data the result of the \code{\link[otutableNMDS]{get_hull_data}} function
#' @param hull_data2 optional additional hull data if you want to plot several types
#' @param NMDS_data the result of the \code{\link[otutableNMDS]{get_NMDS_ordination}} function
#' @param x first NMDS axis to display, e.g. "NMDS1"
#' @param y second NMDS axis to display, e.g. "NMDS2"
#' @param habitat which grouping variable to use, e.g. "Microhabitat". 
#' Must be the same habitat used in the \code{\link[otutableNMDS]{get_hull_data}} function
#' @param habitat2 optional second grouping variable, e.g. "TreeSpecies"
#' 
#' @importFrom ggplot2 ggplot aes aes_string element_text geom_polygon theme coord_equal geom_point geom_text
#' @importFrom vegan scores
#' 
#' 
#' @export
#' 
#' @examples 
#' data(OTU_Table)
#' 
#' NMDS.data = get_NMDS_ordination(
#'   OTU_Table = OTU_Table, 
#'   SampleMetadata = c(1, 5),
#'   relative = TRUE, 
#'   logtransform = TRUE, 
#'   k = 3, 
#'   trymax = 100)
#' 
#' hull.data = get_hull_data(
#'   NMDS_data = NMDS.data, 
#'   SampleMetadata = OTU_Table[,1:5],
#'   NMDS = c("NMDS1", "NMDS2"), 
#'   habitat = "Microhabitat", 
#'   which = "all")
#'
#' hull.data.TreeSpecies = get_hull_data(
#'   NMDS_data = NMDS.data, 
#'   SampleMetadata = OTU_Table[,1:5],
#'   NMDS = c("NMDS1", "NMDS2"), 
#'   habitat = "TreeSpecies", 
#'   which = "all")
#'   
#' g = plot_NMDS(
#'   hull_data = hull.data, 
#'   hull_data2 = hull.data.TreeSpecies, 
#'   NMDS_data = NMDS.data,
#'   x = "NMDS1", 
#'   y = "NMDS2", 
#'   habitat = "Microhabitat", 
#'   habitat2 = "TreeSpecies")
#' 
#' @return 
#' a ggplot object with the convex hull as polygons
#' 

plot_NMDS = function(hull_data, 
                     hull_data2 = NULL, 
                     NMDS_data, 
                     x, 
                     y, 
                     habitat,
                     habitat2 = NULL){
  
  data.scores = as.data.frame(scores(NMDS_data))
  
  g = ggplot() + 
    geom_polygon(data = hull_data, 
                 aes_string(x=x, y=y, group = habitat, fill = habitat), 
                 alpha = 0.9) + 
    #scale_fill_manual(limits = levels(group1), 
    #                  values = c(viridis(7, direction = -1), 
    #                             "#8e8878", "#524640")) + 
    geom_point(data = data.scores, 
               aes_string(x = x, y = y), 
               size = 1.25,
               color = "grey10") + 
    geom_text(aes(x = min(data.scores[, x]), 
                  y = min(data.scores[, y]), 
                  hjust = 0, 
                  label = as.character(paste0(NMDS_data$ndim, "D Stress: ", 
                                              round(as.numeric(NMDS_data$stress), 
                                                    digits = 4)))), 
              parse = F, color = "#5d5f66", size = 4) +
    coord_equal()
  
  if(!is.null(habitat2)){
    g = g + 
      geom_polygon(data = hull_data2, 
                   aes_string(x=x, y=y, group = habitat2, color = habitat2), 
                   alpha = 0.7, fill = NA, linetype = "dashed", size = 0.7)
  }

    #scale_color_manual(values = c("#c2b2b4", "#53687e", "#6b4e71"), 
    #                   labels = levels(group2)) +
    #geom_text(aes(x = 0.25, y = -0.6, label = as.character(paste0(OTU.NMDS.bray$ndim, "D Stress: ", round(as.numeric(OTU.NMDS.bray$stress), digits = 4)))), parse = F, color = "#5d5f66", size = 4) +
    #labs(title = "Oomycota") +
    #theme(axis.text=element_text(size=12), 
    #      axis.title=element_text(size=14, face = "bold"), 
    #      legend.text = element_text(size = 12), 
    #      legend.text.align = 0, 
    #      legend.title = element_text(size = 14, face = "bold"), 
    #      plot.title = element_text(size = 20, face = "bold", hjust = 0.5))
    
  return(g)
}
  