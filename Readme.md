Readme
================

# otutableNMDS

This package aims to assist the easy implementation of Nonmetric
Multidimensional Scaling (NMDS) plots into `ggplot`.

The package includes an example dataset from [Jauss et
al. (2020)](%22https://www.frontiersin.org/articles/10.3389/fmicb.2020.592189/%22)
(an OTU abundance table including sample metadata) and three functions:

  - `get_NMDS_ordination`: The function takes the OTU table (with or
    without metadata) and performs the NMDS ordination. The resulting
    object is needed for the next step:
  - `get_hull_data`: It returns a dataframe containing the coordinates
    for the convex hull data used for the drawing of polygons in the
    next function. The user can specify any sample type which the
    polygons should be drawn around
  - `plot_NMDS`: This is a simple function pasting the hull data to
    `ggplot2` and drawing polygons around the specified samples or
    habitats

## Installation

You can easily install this package with `devtools` like this:

``` r
devtools::install_github('RJauss/otutableNMDS', ref = "HEAD")
```

## Usage

Here is a simple example of how the package works. Let’s first have a
look at the example data:

``` r
library(otutableNMDS)
data("OTU_Table")

tibble::as_tibble(OTU_Table[1:10, 1:10])
```

    ## # A tibble: 10 x 10
    ##    SampleID TreeID TreeSpecies Microhabitat Stratum X1_Peronosporal…
    ##    <fct>    <fct>  <fct>       <fct>        <fct>              <dbl>
    ##  1 K129_Bl… K129   Quercus ro… Fresh Leaves Canopy                 1
    ##  2 K129_Bor K129   Quercus ro… Bark         Canopy                 0
    ##  3 K129_Det K129   Quercus ro… Arboreal So… Canopy               121
    ##  4 K129_Hyp K129   Quercus ro… Hypnum       Canopy               382
    ##  5 K129_La… K129   Quercus ro… Leaf Litter  Ground             19129
    ##  6 K129_Oth K129   Quercus ro… Orthotrichum Canopy               354
    ##  7 K232_Bl… K232   Fraxinus e… Fresh Leaves Canopy                 0
    ##  8 K232_Bod K232   Fraxinus e… Soil         Ground             10264
    ##  9 K232_Bor K232   Fraxinus e… Bark         Canopy                32
    ## 10 K232_Det K232   Fraxinus e… Arboreal So… Canopy               348
    ## # … with 4 more variables:
    ## #   X2_Lagenidiales.Lagenidiales_Family_NoHit.Lagenidiales_Genus_NoHit.Lagenidiales_Species_NoHit <dbl>,
    ## #   X3_Peronosporales.Peronosporaceae.Hyaloperonospora.Hyaloperonospora_brassicae <dbl>,
    ## #   X4_Pythiales.Pythiaceae.Pythiaceae_Genus_NoHit.Pythiaceae_Species_NoHit <dbl>,
    ## #   X5_Peronosporales.Peronosporaceae.Peronospora.Peronospora_arborescens <dbl>

My data has the sample metadata included in columns 1-5, after that
comes the species abundance matrix. So we need to specify which columns
and which sample(-types) to use in the `get_hull_data` function. But
first we run the `get_NMDS_ordination` function which uses the `metaMDS`
function from `vegan`:

``` r
NMDS.data <- get_NMDS_ordination(OTU_Table = OTU_Table, 
                                 SampleMetadata = c(1, 5), 
                                 logtransform = T, 
                                 relative = T, 
                                 k = 3)
# Note that you can specify further arguments which will be passes
# to metaMDS(), for example "distance = 'jaccard'" etc
```

``` r
hull.data <- get_hull_data(NMDS_data = NMDS.data, 
                           SampleMetadata = OTU_Table[,1:5], 
                           NMDS = c("NMDS1", "NMDS2"), 
                           habitat = "Microhabitat", 
                           which = "all")

head(hull.data)
```

    ##         NMDS1      NMDS2      NMDS3 site  Microhabitat
    ## 10  0.5158977 -0.9071205 -0.2233777   10 Arboreal Soil
    ## 36  0.1411887 -0.6528387 -0.2759070   36 Arboreal Soil
    ## 23 -0.1286047 -0.4363612  0.8141746   23 Arboreal Soil
    ## 16 -0.3790621  0.1012418 -0.7022891   16 Arboreal Soil
    ## 3   0.4699488  0.4264151 -0.9427250    3 Arboreal Soil
    ## 49  0.0241093 -0.2087880  0.1625382   49          Bark

The function returns the dataframe with the coordinates neccessary for
the polygons to draw around the microhabitats.

## Plot NMDS

The dataframe will now be parsed into the third function, `plot_NMDS`:

``` r
g <- plot_NMDS(hull_data = hull.data, 
               NMDS_data = NMDS.data, 
               x = "NMDS1", y = "NMDS2", 
               habitat = "Microhabitat")

g
```

![](Readme_files/figure-gfm/Plot%20NMDS-1.png)<!-- -->

## Plot additional NMDS on top

Let’s say we also want the hull data for the tree species, we can easily
modify the code like this and plot a second ordination on top:

``` r
hull.data.TreeSpecies <- get_hull_data(NMDS_data = NMDS.data, 
                                       SampleMetadata = OTU_Table[,1:5],
                                       NMDS = c("NMDS1", "NMDS2"), 
                                       habitat = "TreeSpecies", 
                                       which = "all")
```

Now call the `plot_NMDS` again and specify both hull.datas. The second
one will be plotted on top with non-filled polygons:

``` r
g <- plot_NMDS(hull_data = hull.data, 
               hull_data2 = hull.data.TreeSpecies, 
               NMDS_data = NMDS.data, 
               x = "NMDS1", y = "NMDS2", 
               habitat = "Microhabitat", 
               habitat2 = "TreeSpecies")

g
```

![](Readme_files/figure-gfm/Plot%20NMDS%20two%20dataframes-1.png)<!-- -->

This is now a very basic ggplot NMDS which can be easily modified and
appended with the ggplot syntax, e.g. “scale\_fill\_manual”
