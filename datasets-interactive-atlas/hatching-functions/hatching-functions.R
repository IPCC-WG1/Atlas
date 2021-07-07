#     hatching-functions.R Functions for computing different two different
#     uncertainty measures (signal and agreement) for Atlas Product Reproducibility.
#
#     Copyright (C) 2020 Santander Meteorology Group (http://www.meteo.unican.es)
#
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.



# (1) Signal --------

# Auxiliary function applying the formula defined by IPCC-WGI to calculate the sigma 
# of the historical reference (x is a vector of a temporal series). 
# The output is used to subsecuently calculate 
# the presence/absence of signal in the projected future delta changes (see 
# function signal in this script).

hist.sigma <- function(x) {
  (sqrt(2) * 1.645 * sd(x))/sqrt(20) 
}

# Function for calculating the presence/absence of signal in the projected
# delta changes (d is the C4R grid of the delta change) with reference to 
# the historical baseline (h is the C4R grid of the historical reference). 
# Function hist.sigma is used internally.

signal <- function(h, d) {
  h.sd <- climatology(h, clim.fun = list(FUN = hist.sigma))
  d$Data <- abs(d$Data)
  sig <- gridArithmetics(d, h.sd, operator = "-")
  binaryGrid(sig, condition = "GT", threshold = 0, values = c(0, 1))
}

# Auxiliary function for calculating the multi-model signal based on a minimum 
# threshold percentage (th) of presence of signal in the multi-model ensemble 
# (x is the vector of the presence/absence of signal of each model). 

signal.ens <- function(x, th = 66) {
  as.numeric((sum(x)/length(x)*100) > th)
}

# (2) Agreement -----

# Auxiliary function for calculating the uncertainty given by the percentage (th) 
# of multi-model agreement on the sign of the change (positive/negative) w.r.t the ensemble 
# mean delta change (x is the vector of the delta change of each model). 

agreement <- function(x, th = 80) {
  mp <- mean(x, na.rm = TRUE)
  if (is.na(mp)) {
    1
  } else {
    if (mp > 0) {
      as.numeric(sum(as.numeric(x > 0), na.rm = TRUE) > as.integer(length(x) * th / 100))
    } else if (mp < 0) {
      as.numeric(sum(as.numeric(x < 0), na.rm = TRUE) > as.integer(length(x) * th / 100))
    } else if (mp == 0){
      1
    }
  }
}

