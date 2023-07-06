# CMIP6_CO2_data_operations.R
#
# Copyright (C) 2021 Santander Meteorology Group (http://meteo.unican.es)
#
# This work is licensed under a Creative Commons Attribution 4.0 International
# License (CC BY 4.0 - http://creativecommons.org/licenses/by/4.0)

#' @title Script for getting total CO2 emissions
#' @description This script creates annual data from the CO2 data provided by Chp.6
#' (se folder data-sources). It performs de following operations:
#'  - Converts monthly data (units: "kg m-2 s-1") to yearly data (units : "kg m-2 yr-1")
#'  - Sums emissions from all sources and atmospheric levels to get the TOTAL CO2
#' @details The result is a NetCDF of the TOTAL CO2 for each of the years of the following decadal 
#' sequence: 2015 2020 2030 2040 2050 2060 2070 2080 2090 2100. These data are interpolated at a later 
#' stage to obtain the complete annual series.  
#' @author M. Iturbide

## PACKAGES -------------------------------------------------------------------------

# to load data:
library(loadeR)
# to transform the data:
library(loadeR.2nc)
# to write the transformed data:
library(transformeR)

# PARAMETERS ------------------------------------------------------------------------

# Path to the output directory
out.dir <- ""

# Selection of the scenario and definiton of the year sequence
scenario <- "ssp585"; years <- c(2015, seq(2020, 2100, 10))
# scenario <- "historical"; years <- 1851:2014

# Datasets (ncml-s) of CO2 input data provided by WGI-Chp.6 (anthropogenic AIR emissions, i.e. aircrafts, and anthropogenic emissions from all other sectors) 
d <- list.files("/.../IPCC-ATLAS/C02_emissions/ncml/",  pattern = scenario, full.names = T)
air <- d[grep("AIR-", d)] # ncml of AIR emissions
sec <- d[grep("AIR-", d, invert = TRUE)] # ncml of rest emissions

# Create the filename template of the output data
namecomps <-  strsplit(sec, "_")[[1]]
out.dir2 <- paste0(out.dir, namecomps[3], "/", scenario, "/")
if (!dir.exists(out.dir2)) dir.create(out.dir2, recursive = T)
fname <- paste0(out.dir2, "/CMIP6_",namecomps[3], "_", scenario, "_",  namecomps[5], "_co2_annual_")

# Extract the names of the "level" dimension (atmospheric levels)
di <- lapply(d, dataInventory)
le1 <- di[[1]]$CO2_em_AIR_anthro$Dimensions$level$Values
le2 <- di[[2]]$CO2_em_anthro$Dimensions$level$Values

# Check the units: "kg m-2 s-1":
di[[1]]$CO2_em_AIR_anthro$Units
di[[2]]$CO2_em_AIR_anthro$Units


# OPERATION ------------------------------------------------------------------

# Loop for DATA LOADING, CONVERSION TO "kg m-2 yr-1", SUM OF THE TOTAL EMISSIONS and NetCDF writing.
# Loop for each year
g <- lapply(years, function(y) {
  print(paste0("---------------- ",  "----------- ", y))
  # Loop for each level of AIR emissions (flights)
  g1 <- lapply(le1, function(l) {
    g10 <- loadGridData(air, var = paste0("CO2_em_AIR_anthro@", l), years = y)
    g10$Data <- g10$Data * 86400 * 30.436 # from emission flux to kg/m2
    g10
  })
  # Loop for each level of the emissions of the other sectors
  g2 <- lapply(le2, function(l) {
    g20 <- loadGridData(sec, var = paste0("CO2_em_anthro@", l), years = y)
    g20$Data <- g20$Data * 86400 * 30.436 # from emission flux to kg/m2
    g20
  })
  # get TOTAL emission (sum AIR emissions to the rest and sum all levels):
  z <- do.call("gridArithmetics", c(g1, g2, operator = "+"))
  # get yearly values (from monthly)
  zy <- aggregateGrid(z, aggr.y = list(FUN = "sum", na.rm = TRUE)) 
  # write new NetCDF
  zy$Variable$varName <- "co2"
  zy$Variable$level <- NA
  attr(zy$Variable, "units") <- "kg m-2 yr-1"
  attr(zy$Variable, "description") <- "CO2 Total Anthropogenic Emissions"
  attr(zy$Variable, "longname") <- "CO2_em_TOTAL_anthro"
  grid2nc(zy, NetCDFOutFile = paste0(fname, y, ".nc4"))
})

# The result is a NetCDF of the TOTAL CO2 for each of the years of the following decadal 
# sequence: 2015 2020 2030 2040 2050 2060 2070 2080 2090 2100. These data are interpolated at a later 
# stage to obtain the complete annual series.  

