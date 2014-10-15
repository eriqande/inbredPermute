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

Then, to run the function you would do something like:

```r
    library(inbredPermute)
```

```
## Loading required package: plyr
```

```r
    simmat <- do_the_perms(kg_file = system.file("data_files/MKHM_kingroup_output.csv", package="inbredPermute", mustWork = T),
                           trio_file = system.file("data_files/MKHM_trios.txt", package="inbredPermute", mustWork = T),
                           meta_file = system.file("data_files/MKHM2011_metadata.txt", package="inbredPermute", mustWork = T),
                           ItalianCommas = TRUE,
                           REPS = 100  # you will want to do more in practice
                           )
    
    simmat[1:10, 1:10]
```

```
##                Reps
## SimmedOffspring       1       2       3       4       5       6       7
##              1  -0.0413 -0.2131 -0.3201  0.0855 -0.2790 -0.1911 -0.0233
##              2  -0.0580 -0.2512  0.0008 -0.0883 -0.0946 -0.1339  0.1077
##              3  -0.0580 -0.2512  0.0008 -0.0883 -0.0946 -0.1339  0.1077
##              4  -0.0129  0.0089 -0.1236  0.0092 -0.0233  0.0890  0.0855
##              5  -0.0129  0.0089 -0.1236  0.0092 -0.0233  0.0890  0.0855
##              6   0.1126 -0.0792  0.0358 -0.0582  0.4861  0.0695 -0.1714
##              7  -0.0666 -0.1197 -0.0139  0.0837  0.0850  0.2243 -0.0510
##              8  -0.0666 -0.1197 -0.0139  0.0837  0.0850  0.2243 -0.0510
##              9  -0.0666 -0.1197 -0.0139  0.0837  0.0850  0.2243 -0.0510
##              10 -0.1197 -0.1189 -0.1197 -0.0139 -0.0980 -0.0472 -0.2271
##                Reps
## SimmedOffspring       8       9      10
##              1  -0.1225 -0.1112 -0.1684
##              2  -0.1048 -0.0129  0.5008
##              3  -0.1048 -0.0129  0.5008
##              4  -0.0194  0.0807 -0.1225
##              5  -0.0194  0.0807 -0.1225
##              6   0.0685 -0.0644 -0.0355
##              7  -0.0326  0.1397 -0.0980
##              8  -0.0326  0.1397 -0.0980
##              9  -0.0326  0.1397 -0.0980
##              10 -0.0893  0.0487 -0.0360
```


## Terms 

As a work partially of the United States Government, this package is in the
public domain within the United States. 

Of course, it would be awfully lame of anyone to take anything found within
here and use it as their own before we tried publishing any of this, should
we choose to do that.

See TERMS.md for more information.

