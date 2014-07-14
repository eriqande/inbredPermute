

#' Read in the R_xy values from KinGroup
#' 
#' This assumes that the output is the lower triangle
#' of the values, in tab-delimited format, with the 
#' diagonal and upper triangular values present in the 
#' file (i.e. the TABS are there) but simply nothings, or 
#' single spaces.
#' @param file  The KinGroup output file.
#' @param ...   Other options to pass to read.table.  One possibility would
#' be \code{dec = ","} for dealing with European number styles that use a 
#' comma for the decimal point.
#' @export
#' @examples
#' rxy <- read_kingroup(system.file("data_files/MKHM_rxy.txt", package="inbredPermute", mustWork = T), dec=",")
read_kingroup <- function(file, ...) {
  x <- read.table(file, 
                  header = T, 
                  row.names = 1, 
                  sep="\t", 
                  na.strings = c("", " ", "  "), 
                  stringsAsFactors = F,
                  ...)
  
  x[1, 1] <- NA  # get rid of the hoaky "r" that kingroup seems to put there.
  
  # turn the first column into numbers after changing commas to "." if necessary
  x[, 1] <- as.numeric(gsub(",", ".", x[,1]))  
  
  x <- as.matrix(x)
  
  # now make it a symmetric matrix
  x[upper.tri(x)] <- t(x)[upper.tri(x)]
  
  x
}