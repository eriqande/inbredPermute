# README

## inbredPermute

Simple scripts/procedures in development to permute values of rxy around to
see if survival is related to inbreeding in salmon pedigrees.  Joint work 
with David Vendrami.

## Basic workflow

The basic idea here is that we should be able to proceed directly with two ingredients:

1. A raw kingroup output file that includes $r_{xy}$ values.  The top of that file should
    look something like this:
    
    ```
    *, This is the results file [in KINSHIP format] of KINGROUP v2_090501
    *, Saved at 21:41  gio lug 17 2014
    *, Column delimiter: comma
    *, Last saved file: Asus\Desktop\MKHM_kingroup_output
    *, Last imported file: CVB11_12_13_14\NEW\MKHM_kingroup_input.txt
    *, Population
    *,  
    *, ALLELE FREQUENCY BLOCK
    ```

1. A list of trios that were found in the population, that include offspring whose
    parents are the ones that were included in the kingroup analysis.  The columns have to
    be named `ma`, `pa`, and `kid`.  Here is an example:
    
    ```
    Kid	Pa	Ma	FDR
    MKHM130030	MKHM100016	MKHM100015	0
    MKHM130031	MKHM110070	MKHM110046	0.001045
    MKHM130035	MKHM110008	MKHM110007	0
    MKHM130037	MKHM110060	MKHM110059	0
    MKHM130041	MKHM100065	MKHM100064	0
    MKHM130042	MKHM110035	MKHM110034	0
    MKHM130043	MKHM110086	MKHM110078	0.000024
    MKHM130044	MKHM110076	MKHM110077	0
    MKHM130045	MKHM100009	MKHM100008	0
    ```




Note where we are in going through a simple MKMH example:

```r
library(inbredPermute)  # load the package

# read the rxy values
rxy <- read_kingroup_csv(system.file("data_files/MKHM_kingroup_output.csv", package="inbredPermute", mustWork = T), ItalianCommas = TRUE)

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

