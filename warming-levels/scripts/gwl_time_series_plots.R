# gwl_time_series_plots.R
#
# Copyright (C) 2021 Santander Meteorology Group (http://meteo.unican.es)
#
# This work is licensed under a Creative Commons Attribution 4.0 International
# License (CC BY 4.0 - http://creativecommons.org/licenses/by/4.0)

#' @title Global Warming Level time timings displayed as multi-model time series plots
#' @description For a given CMIP project, experiment and filtering window width, produces
#' a plot of smoothed delta time series (1850-2100, w.r.t. the PI period 1850-1900)
#' for each ensemble member and draws its corresponding (central-year) warming level 
#' 
#' @author J. Bedia


library(magrittr)
library(RColorBrewer)

#
# Assume Atlas repo home as base directory
#

source("warming-levels/scripts/getGWL.R")

#
# Parameter settings (current values reproduce Fig. in the README file)
#

cmip <- "CMIP6"
gwl <- 2 # Possible values c(1.5, 2 ,3, 4)
exp <- "ssp370" # This is a CMIP-dependent parameter. See a few lines below.
window <- 20 # window width for centered moving average.
             # Default to 20 (as used in the IPCC AR6 Atlas products)

cmip <- match.arg(cmip, choices = c("CMIP5", "CMIP6"))

#
# CMIP-dependent parameters
#

exp <- if (cmip == "CMIP6") {
  match.arg(exp, choices =  c("ssp126", "ssp245", "ssp370", "ssp585"))
} else {
  match.arg(exp, choices = c("rcp26", "rcp45", "rcp85"))
}


#
# Load filenames to process
#

datadir <- sprintf("./datasets-aggregated-regionally/data/%s/%s_tas_landsea", cmip, cmip)
filelist <- list.files(datadir)
allfiles <- sprintf("%s/%s", datadir, filelist)
aux <- grep("historical", filelist, value = TRUE)
modelruns <- gsub(sprintf("%s_|_historical|\\.csv", cmip), "", aux)

# Remove run IDs to simplify the plot legend later:
gcm.names <- gsub("_r.*", "", modelruns) 

#
# Main loop
#

# First, create an empty list populated with the ensemble members.
# Models without the target rcp/ssp are discarded

l <- list()
counter <- 0L

for (i in 1:length(modelruns)) {
  
  modelfiles <- gsub("_", "_.*", modelruns[i], fixed = TRUE) %>%
    grep(allfiles, value = TRUE)
  hist <- grep("historical", modelfiles, value = TRUE) %>% world.annual.mean()
  rcp <- grep(exp, modelfiles, value = TRUE)
  
  if (length(rcp > 0L)) {
    
    counter <- counter + 1L
    message("[", Sys.time(), "] Processing ", modelruns[i])
    rcp %<>% world.annual.mean() 
    tas <- append(hist, rcp)
    
    # Fill with NAs if needed to get a continuous annual series 1850-2100
    aux <- rep(NA, length(1850:2100))
    names(aux) <- 1850:2100
    aux[which(names(aux) %in% names(tas))] <- tas
    
    # Delta change w.r.t. the PI period (1850-1900)
    baseline <- hist[1:51] %>% mean(na.rm = TRUE)
    aux <- aux - baseline
    
    # Compute GWL central year and store as attribute
    attr(aux, "GWL") <- getGWL(aux, window = window, GWL = gwl)[1]
    l[[gcm.names[i]]] <- aux
    
  }
}


#
# The final dataset is stored in tabular form as a data.frame
#

mat <- do.call("cbind.data.frame", l)

#
# Apply moving average to each ensemble member
#

filtered.mat <- apply(mat, MARGIN = 2L, FUN = "filter",
                      filter = rep(1/window, window), sides = 2)

#
# Plotting
#

# Y-axis ranges 

ylims <- range(filtered.mat, na.rm = TRUE)
ylim <- c(ylims[1] - .5, ylims[2] + .5)


# Choosing random distinct colors for each ensemble member
# NOTE: color palette may not be fully reproducible due to the random color selection in this step
# https://stackoverflow.com/questions/15282580/how-to-generate-a-number-of-most-distinctive-colors-in-r

n <- ncol(filtered.mat)
qual_col_pals <- brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector <- unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
set.seed(2)
model.colors <- sample(col_vector, n)


# Empty plot

plot(1850:2100, filtered.mat[,1], ty = 'n',
     ylim = ylim, las = 1, ylab = "Delta change w.r.t. PI period 1850-1900 (degC)", xlab = "year")
grid()
abline(h = gwl, col = "grey60")

# Add ensemble members 

for (i in 1:ncol(filtered.mat)) {
  lines(1850:2100, filtered.mat[ ,i], col = model.colors[i])
  abline(v = attr(l[[i]], "GWL"), col = model.colors[i], lty = 2)
}

# Add legend

legend(x = "topleft", 
       legend = names(mat),
       lty = 1, col = model.colors,
       cex = .7, ncol = 2, bg = "grey90")  

# Add title

title(paste(cmip, exp, "- GWL +", gwl, "degC"))
mtext(paste(window, "- year window width"), line = .25)

# Add range as a text label

rng <- sapply(l, "attr", "GWL") %>% range(na.rm = TRUE)
txt <- if (any(is.infinite(rng))) {
  paste0("+", gwl , " degC GWL not reached\n by any ensemble member") 
} else {
  paste("GWL range:", paste(rng, collapse = "-"))
}
text(1975, -0.5, txt, col = "blue")


