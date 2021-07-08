# varInventoryTable.R
#
# Copyright (C) 2019 Santander Meteorology Group (http://www.meteo.unican.es)
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

#' @title Variable inventory table
#' @description Retrieves inventory of variables available at the User Data
#'   Gateway, e.g. for CMIP and CORDEX projects and dumps them in CSV format
#' @author M. Iturbide

varInventoryTable <- function(datasets, output.file = NULL, plot = FALSE) {
  require(abind)
  require(lattice)
  di <- lapply(datasets, function(x) {
    print(x)
    dataInventory(x)
  })
  names(di) <- datasets
  divar <- lapply(di, function(x) names(x))
  divers <- lapply(di, function(x) unlist(lapply(x, function(v) v[["Version"]])))
  divarc <- unique(unname(do.call("abind", divar)))
  dilevel <- list()
  for(i in 1:length(di)) {
    dilevel[[i]] <- lapply(divarc, function(x) di[[i]][[x]][["Dimensions"]][["level"]][["Values"]])
  }
  names(dilevel) <- names(di)
  levels <- unique(unlist(dilevel))
  df <- array(dim = c(length(divar), length(divarc)), dimnames = list(names(divar), divarc))
  for (i in 1:length(divarc)) {
    df[,i] <- unlist(
      lapply(1:length(divar), function(x) {
        logi <- divarc[i] %in% divar[[x]]
        if (isTRUE(logi)) {
          divers[[x]][[divarc[i]]]
        } else {
          logi
        } 
      })
    )
  }
  dd <- lapply(dilevel, function(l) unlist(l))
  dflevels <- array(dim = c(length(di), length(levels)), dimnames = list(names(di), levels))
  for (i in 1:length(levels)) {
    dflevels[,i] <- unlist(lapply(dd, function(x) levels[i] %in% x))
  }
  df <- cbind(df, dflevels)
  if (!is.null(output.file)) write.csv(df, file = output.file)
  if (plot) {
  dfpl <- levelplot(t(df), scales=list(x=list(alternating=2, rot=90, cex = 0.5),
                                       y=list(cex = 0.5)),
                    border = "red", bw = 10, ylab = NULL, colorkey = FALSE,
                    col.regions = rev(gray.colors(16, start = 0.5, end = 1)),
                    xlab = list("gray = available      white = not available", cex = 0.8))
  return(list("data" = df, "plot" = dfpl))
  } else {
  return(df)
  }
}

library(loadeR)
loginUDG("username","password")
pattern <- "CMIP6"
destfile <- "CMIP6_inventory.csv"
datasets <- UDG.datasets(pattern)$CMIP6
varInventoryTable(datasets, output.file = destfile)
