# 04_map_figures.R
#
# Copyright (C) 2021 Santander Meteorology Group (http://meteo.unican.es)
#
# This work is licensed under a Creative Commons Attribution 4.0 International
# License (CC BY 4.0 - http://creativecommons.org/licenses/by/4.0)

#' @title Generate map figures from ensemble NcMLs
#' @description Generate map figures from the NcMLs created 
#'   using 03_ensemble_building.R, for Atlas Product Reproducibility.
#' @author M. Iturbide

# This script builds on the climate4R framework 
# https://github.com/SantanderMetGroup/climate4R

# Climate4R package for data loading
library(loadeR)
# Climate4R package for data visualization
# <https://doi.org/10.1016/j.envsoft.2017.09.008>
library(visualizeR)
# climate 4R package for geoprocessing
library(geoprocessoR)
# Other utilities for spatial data handling and geoprocessing:
library(sp)
library(rgdal)
# Dev utilities used for source_url
library(devtools)
# Load function for latitudinal chunking 
source_url("https://github.com/SantanderMetGroup/climate4R/blob/devel/R/climate4R.chunk.R?raw=TRUE")
# Load functions for computing uncertainty (signal, signal.ens and agreement)
source("../datasets-interactive-atlas/hatching-functions/hatching-functions.R")


# USER PARAMETER SETTINGS ------------------------------------------------------

# Select number of chunks
# Note: chunking sequentially splits the task into manageable data chunks to avoid memory problems
# Chunking operates by spliting the data into a predefined number latitudinal slices (n=2 in this example).
# Further details: https://github.com/SantanderMetGroup/climate4R/tree/master/R 
n.chunks <- 100
# Index, scenario, season and reference and future period(s) of interest, e.g.:
AtlasIndex <- "meanpr"  # index (monthly mean daily precipitation)
project <- "CMIP6"
scenario <- "ssp585"  # scenario
season <- c(12, 1, 2)  # (entire year: season = 1:12; boreal winter (DJF): season = c(12, 1, 2); boreal summer (JJA): season = 6:8, and so on...)
signal.period <- 1850:1900
base.period <- 1986:2005
future.period <- 2041:2060
# Path of the shapefile of World coastlines and referece regions, e.g. 
## downloable from https://github.com/IPCC-WG1/Atlas/tree/devel/notebooks/auxiliary-material
coast.dir <- "auxiliary-material/WORLD_coastline.shp"
## downloable from https://github.com/IPCC-WG1/Atlas/tree/devel/reference-regions
regions.dir <- "../reference-regions/IPCC-WGI-reference-regions-v4.geojson"
# Source directory where the NcMLs (those created by script3_ensemble_building.R) are located
source.dir <- ""
# Output directory to save the .rda object of the computed deltas and to export the pdf of the figure
out.dir <- ""

# Color key graphical parameter:
  # n = min value
  # m = max value
  # s = cut value frequency
  # ct = Brewer color code (see 'RColorBrewer::display.brewer.all()')
if (AtlasIndex != "meanpr") {  # case of precipitation
  m <- 8
  n <- 0
  s <- 0.5
  ct <- "Reds"
  revc <- FALSE
} else {
  m <- 50
  n <- -50
  s <- 5
  ct <- "BrBG"
  revc <- FALSE
}

## LOAD DATA --------------------------------------------------------------


dataset.hist <- list.files(source.dir, pattern = paste0("historical_", AtlasIndex, ".ncml"), full.names = TRUE)
dataset.ssp <- list.files(source.dir, pattern = paste0(scenario,"_", AtlasIndex, ".ncml"), full.names = TRUE)

# Retain common members among scenarios
hist.members <- dataInventory(dataset.hist)[[AtlasIndex]][["Dimensions"]][["member"]][["Values"]]
ssp.members <- dataInventory(dataset.ssp)[[AtlasIndex]][["Dimensions"]][["member"]][["Values"]]
hist.m.ind <- which(hist.members %in% ssp.members)
ssp.m.ind <- which(ssp.members %in% hist.members)

membernames <- ssp.members[ssp.m.ind]

## Data loading and aggregation
# For convenience, the auxiliary wrapper 'aux.fun' is next defined, performing the following actions in one single step:
#  1. Performs data subsetting along the member dimension to extract the common members defined in the previous step
#  2. Computes the climatology, this is the temporal mean for the whole target period.
aux.fun <- function(grid, members) {
  climatology(
    subsetGrid(grid, members = members), clim.fun = list(FUN = mean, na.rm = TRUE)
  )
}

## A bit more complex auxiliary wrapper is aux.fun.signal, used for the historical data used for computing the signal.
#  1. Performs data subsetting along the member dimension to extract the common members defined in the previous step
#  2. Agregate the data annualy.
aux.fun.signal <- function(grid, members) {
   aggregateGrid(
      subsetGrid(grid, members = members), aggr.y = list(FUN = mean, na.rm = TRUE)
    )
}


## Historical experiment data are loaded sequentially according to the chunking definition and applying the wrapper functions defined above.
hist.s <- climate4R.chunk(n.chunks = n.chunks,
                              C4R.FUN.args = list(FUN = "aux.fun.signal",
                                                  grid = list(dataset = dataset.hist, var = AtlasIndex),
                                                  members = hist.m.ind),
                              loadGridData.args = list(years = signal.period, season = season))

hist <- climate4R.chunk(n.chunks = n.chunks,
                        C4R.FUN.args = list(FUN = "aux.fun",
                                            grid = list(dataset = dataset.hist, var = AtlasIndex),
                                            members = hist.m.ind),
                        loadGridData.args = list(years = base.period, season = season))

# redim is a helper function to ensure array structure consistency among the different models
hist.s <- redim(hist.s, drop = TRUE); hist.s <- redim(hist.s)
hist <- redim(hist, drop = TRUE); hist <- redim(hist)

## RCP/SSP experiment future data are loaded sequentially according to the chunking definition and applying the wrapper function defined above.

ssp <- climate4R.chunk(n.chunks = n.chunks,
                        C4R.FUN.args = list(FUN = "aux.fun",
                                            grid = list(dataset = dataset.ssp, var = AtlasIndex),
                                            members = ssp.m.ind),
                        loadGridData.args = list(years = future.period, season = season))

# redim is a helper function to ensure array structure consistency among the different models
ssp <- redim(ssp, drop = TRUE); ssp <- redim(ssp)


## CALCULATE DELTAS ------------------------------------------------------------
# Deltas are the arithmetic difference between future and historical time slices
# NOTE: Relative deltas are calculated in the case of precipitation (i.e.: future / historical, in %)

delta <- gridArithmetics(climatology(ssp), climatology(hist), operator = "-")
rel.delta <- gridArithmetics(aggregateGrid(delta, aggr.mem = list(FUN = mean, na.rm = T)), 
                             aggregateGrid(climatology(hist), aggr.mem = list(FUN = mean, na.rm = T)), 
                             100, 
                             operator = c("/", "*"))


# The default projection of the data is WGS84, but the Robinson projection is usually preferred, the nex lines 
# reprojects the grids to Robinson

attr(delta$xyCoords, "projection") <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
attr(rel.delta$xyCoords, "projection") <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
delta.rob <- warpGrid(delta, new.CRS = "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")
rel.delta.rob <- warpGrid(rel.delta, new.CRS = "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

# The intermediate object can be optionally stored as a R data object:
# save(delta, file = paste0(out.dir, "delta_", AtlasIndex, "_", scenario, "_",  paste(season, collapse = "-"),".rda"))
# load(paste0(out.dir, "delta_", AtlasIndex, "_", scenario, "_",  paste(season, collapse = "-"),".rda"), verbose = TRUE)

# CALCULATE UNCERTAINTY AND PRODUCE HATCHING ---------------------------------------------------

# Next uncertainty is calculated (check "../datasets-interactive-atlas/hatching-functions/hatching-functions.R"
# for further details on the uncertainty calculation). The outputs are binary C4R grids (0 = uncertain, 1 = certain)
# run e.g. spatialPlot(uncer2) to check the uncertainty areas.

# (1) signal
signal.grid <- signal(hist.s, delta)
uncer1 <- aggregateGrid(signal.grid, aggr.mem = list(FUN = signal.ens, th = 66))

# (2) agreement
uncer2 <- aggregateGrid(delta, aggr.mem = list(FUN = agreement, th = 80))

# The uncertainty is illustrated in the final figure with hatched areas. To create the hatches
# first the grids are reprojected to Robinson

attr(uncer1$xyCoords, "projection") <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
attr(uncer2$xyCoords, "projection") <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
uncer1.rob <- warpGrid(uncer1, new.CRS = "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")
uncer2.rob <- warpGrid(uncer2, new.CRS = "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")

# Hatches are created. The outputs are a list containing a SpatialLines object (form package sp)
# together with other graphical parameters. This list is later passed to the plotting function. 

uncer1.hatch <- map.hatching(clim = climatology(uncer1.rob), threshold = "0.5", angle = "45",
                             condition = "LT", density = 4,  lwd = 0.6,
                             upscaling.aggr.fun = list(FUN = mean))
uncer2.hatch <- map.hatching(clim = climatology(uncer2.rob), threshold = "0.5", angle = "-45",
                             condition = "LT", density = 4,  lwd = 0.6,
                             upscaling.aggr.fun = list(FUN = mean))

# LOAD AND PROJECT ADDITIONAL MAP LINES ---------------------------------------
coast <- readOGR(coast.dir)
coast.rob <- spTransform(coast, CRSobj = CRS("+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"))

regions <- readOGR(regions.dir)
regions.rob <- spTransform(regions, CRSobj = CRS("+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"))

# PLOT MAP --------------------------------------------------------------------

# Calculate the ensemble mean (or use the relative delta)
out <- rel.delta.rob
#out <- aggregateGrid(delta.rob, aggr.mem = list(FUN = mean))

pl <- spatialPlot(out, 
            color.theme = ct, 
            rev.colors = revc, 
            at = seq(n, m, s), 
            set.max = m, set.min = n,
            main = list(paste0(AtlasIndex, " mean delta change"), cex = 0.8),
            xlab = list(paste0("Period: ", paste(range(future.period), collapse = "-"), ", Season: ", paste(month.abb[season], collapse = "-")), cex = 0.8),
            sp.layout = list(uncer1.hatch, uncer2.hatch, list(coast.rob, col = "purple4", first = FALSE), list(regions.rob, col = "black", first = FALSE)),
            par.settings = list(axis.line = list(col = 'transparent')))

pl

# Export the figure as PDF file
pdf(paste0(out.dir, "/Delta_", AtlasIndex, "_", scenario, "_",  paste(range(future.period), collapse = "-"), "_", paste(month.abb[season], collapse = "-"),".pdf"), width = 10, height = 10)
pl
dev.off()

