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
    parents are the ones that were included in the kingroup analysis.  I must have three columns
    that are named `Ma`, `Pa`, and `Kid` (which _are_ case-sensitive), and it can have any other columns
    that you might happen to have in there, too.  Here is an example:
    
    ```
    Kid  Pa	Ma
    MKHM130058	MKHM100005	MKHM100004
    MKHM130049	MKHM100007	MKHM100006
    MKHM130045	MKHM100009	MKHM100008
    MKHM130030	MKHM100016	MKHM100015
    MKHM140072	MKHM100021	MKHM100020
    FRHM130259	MKHM100021	MKHM100020
    MKHM140026	MKHM100023	MKHM100022
    FRHM130841	MKHM100027	MKHM100026
    MKHM140042	MKHM100027	MKHM100026
    ```

1. A file with spawn date and sex of individuals in this sort of format:
    
    ```
    TK_ID	Sex	SpawnDate
    MKHM100001	Female	12/9/10
    MKHM100002	Male	12/9/10
    MKHM100003	Male	12/9/10
    MKHM100004	Female	12/9/10
    MKHM100005	Male	12/9/10
    MKHM100006	Female	12/9/10
    MKHM100007	Male	12/9/10
    MKHM100008	Female	12/16/10
    MKHM100009	Male	12/16/10
    ```

Note where we are in going through a simple MKMH example.  Eventually we will roll this into a function.

```r
library(inbredPermute)  # load the package
library(plyr)

# read the rxy values
rxy <- read_kingroup_csv(system.file("data_files/MKHM_kingroup_output.csv", package="inbredPermute", mustWork = T), ItalianCommas = TRUE)

# make a matrix of pairs that produced offspring that we found
# we make a matrix because we will use it to subset another matrix...
trios <- read.table(system.file("data_files/MKHM_trios.txt", package="inbredPermute", mustWork = T), header = T, stringsAsFactors=F)

# get their rxy values
mapa <- as.matrix(cbind(trios$Pa, trios$Ma))  # names of observed parents
colnames(mapa) <- c("Pa", "Ma")

# these are the parents we have rxy for:
havem <- (mapa[, 1] %in% rownames(rxy)) & (mapa[, 2] %in% rownames(rxy))
mapa_have <- mapa[havem, ]

# and here we pick out their rxy's
mapa_rxy <- rxy[mapa_have]
    
# put those into a data frame
survived <- as.data.frame(cbind(mapa_have, mapa_rxy), stringsAsFactors = FALSE) 
    
# now read in the meta data
meta <- read.table(system.file("data_files/MKHM2011_metadata.txt", package="inbredPermute", mustWork = T), header = TRUE, stringsAsFactors = FALSE, row.names = 1)

# attach the meta data into the survived frame
survived$paSex <- meta[survived$Pa, "Sex"]
survived$maSex <- meta[survived$Ma, "Sex"]
survived$paDate <- meta[survived$Pa, "SpawnDate"]
survived$maDate <- meta[survived$Ma, "SpawnDate"] 
    
# now count up the number of offspring each pair had and record the date
num_offs <- count(survived, vars = c("Pa", "Ma", "paDate"))
    
# now split that up by day:
num_offs_by_day <- split(num_offs, f = num_offs$paDate)
    
# and just turn unique individuals on each day into numbers:
nums_to_sim <- lapply(num_offs_by_day, function(x) {
  x$Pa <- as.integer(as.factor(x$Pa))
  x$Ma <- as.integer(as.factor(x$Ma))
  x
})
```

At this juncture, we need to use the numbers in `nums_to_sim` to draw individuals
(from meta) that were born on certain days and of certain sexes.  Then we can 
extract the rxy values for those and make a null distribution.




## Terms 

As a work partially of the United States Government, this package is in the
public domain within the United States. 

Of course, it would be awfully lame of anyone to take anything found within
here and use it as their own before we tried publishing any of this, should
we choose to do that.

See TERMS.md for more information.

