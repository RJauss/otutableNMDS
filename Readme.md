Readme
================

# otutableNMDS

This package aims to assist the easy implementation of Nonmetric
Multidimensional Scaling (NMDS) plots into `ggplot`.

The package includes an example dataset from [Jauss et
al. (2020)](%22https://www.frontiersin.org/articles/10.3389/fmicb.2020.592189/%22)
- an OTU abundance table including sample metadata - and three
functions:

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

OTU_Table[1:10, 1:10]
```

    ##      SampleID TreeID        TreeSpecies  Microhabitat Stratum
    ## 1  K129_Bl_Fr   K129      Quercus robur  Fresh Leaves  Canopy
    ## 2    K129_Bor   K129      Quercus robur          Bark  Canopy
    ## 3    K129_Det   K129      Quercus robur Arboreal Soil  Canopy
    ## 4    K129_Hyp   K129      Quercus robur        Hypnum  Canopy
    ## 5   K129_Laub   K129      Quercus robur   Leaf Litter  Ground
    ## 6    K129_Oth   K129      Quercus robur  Orthotrichum  Canopy
    ## 7  K232_Bl_Fr   K232 Fraxinus excelsior  Fresh Leaves  Canopy
    ## 8    K232_Bod   K232 Fraxinus excelsior          Soil  Ground
    ## 9    K232_Bor   K232 Fraxinus excelsior          Bark  Canopy
    ## 10   K232_Det   K232 Fraxinus excelsior Arboreal Soil  Canopy
    ##    X1_Peronosporales.Peronosporaceae.Phytophthora.Phytophthora_syringae
    ## 1                                                                     1
    ## 2                                                                     0
    ## 3                                                                   121
    ## 4                                                                   382
    ## 5                                                                 19129
    ## 6                                                                   354
    ## 7                                                                     0
    ## 8                                                                 10264
    ## 9                                                                    32
    ## 10                                                                  348
    ##    X2_Lagenidiales.Lagenidiales_Family_NoHit.Lagenidiales_Genus_NoHit.Lagenidiales_Species_NoHit
    ## 1                                                                                              0
    ## 2                                                                                              0
    ## 3                                                                                             13
    ## 4                                                                                              2
    ## 5                                                                                             57
    ## 6                                                                                              2
    ## 7                                                                                             37
    ## 8                                                                                              5
    ## 9                                                                                             50
    ## 10                                                                                             5
    ##    X3_Peronosporales.Peronosporaceae.Hyaloperonospora.Hyaloperonospora_brassicae
    ## 1                                                                          31210
    ## 2                                                                            581
    ## 3                                                                              1
    ## 4                                                                            611
    ## 5                                                                              2
    ## 6                                                                            950
    ## 7                                                                           2239
    ## 8                                                                              9
    ## 9                                                                            822
    ## 10                                                                            27
    ##    X4_Pythiales.Pythiaceae.Pythiaceae_Genus_NoHit.Pythiaceae_Species_NoHit
    ## 1                                                                       12
    ## 2                                                                       18
    ## 3                                                                        0
    ## 4                                                                        0
    ## 5                                                                        0
    ## 6                                                                        1
    ## 7                                                                        5
    ## 8                                                                       10
    ## 9                                                                     5245
    ## 10                                                                      55
    ##    X5_Peronosporales.Peronosporaceae.Peronospora.Peronospora_arborescens
    ## 1                                                                   2449
    ## 2                                                                     31
    ## 3                                                                      8
    ## 4                                                                      3
    ## 5                                                                     19
    ## 6                                                                      1
    ## 7                                                                   3007
    ## 8                                                                      5
    ## 9                                                                      3
    ## 10                                                                     0

My data has the sample metadate included in columns 1-5, after that
comes the species abundance matrix. So we need to specify which columns
and which sample(-types) to use in the `get_hull_data` function:

``` r
NMDS.data <- get_NMDS_ordination(OTU_Table = OTU_Table, 
                                 SampleMetadata = c(1, 5), 
                                 k = 3)
```

    ## Run 0 stress 0.1653825 
    ## Run 1 stress 0.1655399 
    ## ... Procrustes: rmse 0.0247432  max resid 0.1282855 
    ## Run 2 stress 0.1647894 
    ## ... New best solution
    ## ... Procrustes: rmse 0.03797879  max resid 0.1743042 
    ## Run 3 stress 0.1642961 
    ## ... New best solution
    ## ... Procrustes: rmse 0.02186436  max resid 0.131603 
    ## Run 4 stress 0.1642844 
    ## ... New best solution
    ## ... Procrustes: rmse 0.004207109  max resid 0.02215058 
    ## Run 5 stress 0.1645661 
    ## ... Procrustes: rmse 0.01898738  max resid 0.1300248 
    ## Run 6 stress 0.1707196 
    ## Run 7 stress 0.1664778 
    ## Run 8 stress 0.1655034 
    ## Run 9 stress 0.1642909 
    ## ... Procrustes: rmse 0.003537814  max resid 0.0183564 
    ## Run 10 stress 0.1647397 
    ## ... Procrustes: rmse 0.0157706  max resid 0.1055709 
    ## Run 11 stress 0.1642966 
    ## ... Procrustes: rmse 0.004209604  max resid 0.02227221 
    ## Run 12 stress 0.1669712 
    ## Run 13 stress 0.1645506 
    ## ... Procrustes: rmse 0.01110971  max resid 0.07406307 
    ## Run 14 stress 0.1647292 
    ## ... Procrustes: rmse 0.02518709  max resid 0.1320249 
    ## Run 15 stress 0.1756115 
    ## Run 16 stress 0.1660159 
    ## Run 17 stress 0.1655398 
    ## Run 18 stress 0.1643987 
    ## ... Procrustes: rmse 0.04724787  max resid 0.2875859 
    ## Run 19 stress 0.1645605 
    ## ... Procrustes: rmse 0.01911693  max resid 0.1301775 
    ## Run 20 stress 0.1661363 
    ## Run 21 stress 0.164551 
    ## ... Procrustes: rmse 0.01109819  max resid 0.07394219 
    ## Run 22 stress 0.1651332 
    ## Run 23 stress 0.1660154 
    ## Run 24 stress 0.165436 
    ## Run 25 stress 0.1642819 
    ## ... New best solution
    ## ... Procrustes: rmse 0.001675449  max resid 0.006231352 
    ## ... Similar to previous best
    ## *** Solution reached

``` r
hull.data <- get_hull_data(NMDS_data = NMDS.data, 
                           SampleMetadata = OTU_Table[,1:5], 
                           NMDS = c("NMDS1", "NMDS2"), 
                           habitat = "Microhabitat", 
                           which = "all")

head(hull.data)
```

    ##         NMDS1      NMDS2       NMDS3 site  Microhabitat
    ## 3   0.4696426 -0.3043375  0.99142764    3 Arboreal Soil
    ## 16 -0.3869588 -0.1605736  0.68355376   16 Arboreal Soil
    ## 23 -0.1301914  0.4373274 -0.81448811   23 Arboreal Soil
    ## 36  0.1420357  0.6569134  0.27956598   36 Arboreal Soil
    ## 10  0.5201849  0.9100258  0.20705243   10 Arboreal Soil
    ## 35 -0.5855811 -0.3783056 -0.01978837   35          Bark

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

Let’s say we also want the hull data for the tree species, we can easily
modify the code like this:

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
