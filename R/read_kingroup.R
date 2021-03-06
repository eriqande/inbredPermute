




#' Read in kingroup results from the raw kingroup CSV format
#' 
#' This assumes that the file is just a CSV file that Kingroup produced
#' of Rxy values.
#' @param file  The Kingroup CSV output file.   Note: you cannot have spaces in individual
#' IDs and expect this to work.
#' @param ItalianCommas  Logical.  True if we need to convert decimal commas to decimal periods. 
#' Named this in honor of our delightful Italian visitor David who had crazy commas in his numbers!
#' @export
#' @examples
#' rxy <- read_kingroup_csv(system.file("data_files/MKHM_kingroup_output.csv", package="inbredPermute", mustWork = T), ItalianCommas = TRUE)
read_kingroup_csv <- function(file, ItalianCommas = FALSE)  {
  L <- readLines(file)
  
  topline <- grep("RELATEDNESS estimator of Queller \\& Goodnight", L)  # below this is where the half-matrix starts
  if(length(topline)==0) stop(paste("Didn't find line saying \"RELATEDNESS estimator of Queller & Goodnight\" in the file", file))
  
  # now just pick out the lines we need:
  L <- L[(topline+1):length(L)]
  
  # now, deal with the Italian Commas!  Note that we don't do this to the first line because
  # if the Name of the individual ends with a 0 it screws things up.
  if(ItalianCommas == TRUE) {
    L[-1] <- gsub("-0, ", "-0ReplaceAsComma ", L[-1])  # these are crazy hacks because Kingroup sometimes reports things as identically 0  
    L[-1] <- gsub(" 0, ", " 0ReplaceAsComma ", L[-1])   # so we can't pull the commas off after those, because they are real...
    L[-1] <- gsub("-0,", "-0.", L[-1])  
    L[-1] <- gsub(" 0,", " 0.", L[-1]) 
    L[-1] <- gsub("ReplaceAsComma", ".000,", L[-1])
  }
  
  # and now, because Kingroup is goofy and puts leading spaces in its fields in the csv file, we will
  # just remove all spaces.  NOTE, people can't have spaces in individual IDs and expect this to work!
  L <- gsub(" *", "", L)
  
  # now read in the CSV to a data frame
  DF <- read.csv(textConnection(L), stringsAsFactors = FALSE)
  DF <- DF[, -1]  # drop the column of *'s
  rownames(DF) <- DF[,1]  # get the rownames on there
  DF <- DF[, -1]  # drop the column of rownames
  DF[1, 1] <- NA  # get rid of the hoaky "r" that Kingroup puts in there
  DF[, 1] <- as.numeric(DF[ ,1])  # and make them numbers after having removed the hoaky r
  
  # In fact, if there were any weird invisible characters that made things not numeric,  we zap them now
  for(i in 1:ncol(DF))  {
    DF[, i] <- as.numeric(DF[, i])
  }
  
  # finally make a symmetric matrix out of it.
  x <- as.matrix(DF)
  x[upper.tri(x)] <- t(x)[upper.tri(x)]
  
  x
  
}

