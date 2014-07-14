# inbreedPermute

Simple scripts/procedures in development


Note where we are in going through a simple MKMH example:
```r
library(inbredPermute)  # load the package

# read the rxy values
rxy <- read_kingroup(system.file("data_files/MKHM_rxy.txt", package="inbredPermute", mustWork = T), dec=",")

# make a matrix of pairs that produced offspring that we found
trios <- read.table(system.file("data_files/MKHM_trios.txt", package="inbredPermute", mustWork = T), header = T, sep="\t", stringsAsFactors=F)

# get their rxy values
mapa <- as.matrix(cbind(trios$Pa, trios$Ma))  # names of observed parents

# these are the parents we have rxy for:
havem <- (mapa[, 1] %in% rownames(rxy)) & (mapa[, 2] %in% rownames(rxy))
mapa_have <- mapa[havem, ]

# and here we pick out their rxy's
mapa_rxy <- rxy[mapa_have]
```
## Terms 

As a work partially of the United States Government, this package is in the
public domain within the United States. 

Of course, it would be awfully lame of anyone to take anything found within
here and use it as their own before we tried publishing any of this, should
we choose to do that.

See TERMS.md for more information.

