# getGWL.R
#
# Copyright (C) 2021 Santander Meteorology Group (http://meteo.unican.es)
#
# This work is licensed under a Creative Commons Attribution 4.0 International
# License (CC BY 4.0 - http://creativecommons.org/licenses/by/4.0)

#' @title Global Warming Level timing calculation
#' @description Atomic function to compute the timing of a user-defined Global Warming Level.
#' @param data
#'   A named numeric vector of mean global annual temperature projections.
#'   Names are years.
#' @param base.period
#'   Integer vector of length two, indicating the star/end year of the
#'   pre-industrial baseline period. Default to \code{c(1850, 1900)}
#' @param proj.period Same as \code{base.period}, but for the projected period.
#' @param window Integer. Moving window width (in years). Default to 20.
#' @param GWL Floating point number indicating the global warming level (degrees)
#' @return The central year of the interval for which the specified GWL is
#'   reached. NA if the GWL is not reached within the projected period.  In
#'   addition, an attribute (\code{"interval"}) provides the closed interval
#'   boundaries.
#' @importFrom stats filter
#' @references Nikulin, G. et al., 2018. The effects of 1.5 and 2 degrees of global warming on Africa in the CORDEX ensemble. Environ. Res. Lett. 13, 065003. https://doi.org/10.1088/1748-9326/aab1b1
#' @author J. Bedia

getGWL <- function(data, base.period = c(1850, 1900), proj.period = c(1971, 2100), window = 20, GWL = 2) {
    if (length(base.period) != 2) stop("\'base.period\' argument must be of length two")
    if (base.period[1] >= base.period[2]) stop("\'base.period\' must indicate the start/end year, in this order")
    f <- rep(1/window, window)
    yrs <- as.integer(names(data))
    ind.pi <- which(yrs > base.period[1] & yrs < base.period[2])
    ind.rcp <- which(yrs > proj.period[1] & yrs < proj.period[2])
    ref <- mean(data[ind.pi], na.rm = TRUE)
    anom <- filter(data[ind.rcp], sides = 2, filter = f) - ref
    aux <- anom - GWL
    ret <- yrs[ind.rcp[head(which(aux > 0),1)]]
    if (length(ret) == 0) ret <- NA
    interval <- if (window %% 2 == 0) {
        c(ret - ((window/2) - 1), ret + (window/2)) 
    } else {
        c(ret - window %/% 2, ret + window %/% 2) 
    }
    attr(ret, "interval") <- interval
    return(ret)
}



# world.annual.mean.R
#
# Copyright (C) 2021 Santander Meteorology Group (http://meteo.unican.es)
#
# This work is licensed under a Creative Commons Attribution 4.0 International
# License (CC BY 4.0 - http://creativecommons.org/licenses/by/4.0)

#' @title Compute global annual average from regionally aggregated Atlas data
#' @description Utility function to simplify the code of the 'warming-levels/scripts'
#'  directory of the IPCC-WG1 Atlas GitHub repository
#' @param csvfile Full path to the standard csv files containing the regionally 
#' aggregated data
#' @return Named numeric vector of Global annual mean data (names are years)
#' @importFrom magrittr %>% 
#' @importFrom utils read.table
#' @author J. Fernández
 
world.annual.mean <- function(csvfile) {
    csvdata <- read.table(csvfile, header = TRUE, sep = ",")
    rval <- subset(csvdata, select = "world", drop = TRUE)
    yrs <- subset(csvdata, select = "date", drop = TRUE) %>%
        gsub("-.*", "", .) %>% as.integer()
    rval <- tapply(rval, INDEX = yrs, FUN = "mean", na.rm = TRUE)
    names(rval) <- unique(yrs)
    return(rval)
}
