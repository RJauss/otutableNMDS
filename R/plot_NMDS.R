#' plot_NMDS
#' 
#' Plots NMDS ordination based on convex hull data generated from `get_hull_data`
#' 
#' @param hull_data the result of the `get_hull_data` function
#' @param hull_data2 additional hull data if you want to plot several types
#' @param x first NMDS axis to display, e.g. "NMDS1"
#' @param y second NMDS axis to display, e.g. "NMDS2"
#' @param group1 which grouping variable to use, e.g. "Microhabitat"
#' @param group2 second grouping variable, e.g. "TreeSpecies"
#' 
#' @importFrom ggplot2 ggplot aes_string element_text geom_polygon theme
#' 
#' @export
#' 
#' @examples 
#' data(OTU_Table)
#' 
#' hull.data = get_hull_data(
#'   OTU_Table = OTU_Table, 
#'   SampleMetadata = c(1, 5),
#'   NMDS = c("NMDS1", "NMDS2"), 
#'   relative = TRUE, 
#'   logtransform = TRUE, 
#'   habitat = "Microhabitat", 
#'   which = "all")
#'
#' hull.data.TreeSpecies = get_hull_data(
#'   OTU_Table = OTU_Table, 
#'   SampleMetadata = c(1, 5),
#'   NMDS = c("NMDS1", "NMDS2"), 
#'   relative = TRUE, 
#'   logtransform = TRUE, 
#'   habitat = "TreeSpecies", 
#'   which = "all")
#'   
#' g = plot_NMDS(hull_data = hull.data, hull_data2 = hull.data.TreeSpecies, 
#'   x = "NMDS1", y = "NMDS2", 
#'   group1 = "Microhabitat", group2 = "TreeSpecies")
#' 
#' @return 
#' a ggplot object with the convex hull as polygons
#' 

plot_NMDS = function(hull_data, 
                     hull_data2, 
                     x, 
                     y, 
                     group1,
                     group2){
  ggplot() + 
    geom_polygon(data = hull_data, 
                 aes_string(x=x, y=y, group = group1, fill = group1), 
                 alpha = 0.9) + 
    #scale_fill_manual(limits = levels(group1), 
    #                  values = c(viridis(7, direction = -1), 
    #                             "#8e8878", "#524640")) + 
    #geom_point(data = data.scores, 
    #           aes(x = x, y = y), 
    #           size = 1.25,
    #           color = "grey10") + 
    geom_polygon(data = hull_data2, 
                 aes_string(x=x, y=y, group = group2, color = group2), 
                 alpha = 0.7, fill = NA, linetype = "dashed", size = 0.7) #+
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
    
}
  