
#' function to do the permutations
#' 
#' @export
do_the_perms <- function(kg_file, trio_file, meta_file, REPS = 1000) {
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
  num_offs <- plyr::count(survived, vars = c("Pa", "Ma", "paDate"))
  
  # now split that up by day:
  num_offs_by_day <- split(num_offs, f = num_offs$paDate)
  
  # and just turn unique individuals on each day into numbers:
  nums_to_sim <- lapply(num_offs_by_day, function(x) {
    x$Pa <- as.integer(as.factor(x$Pa))
    x$Ma <- as.integer(as.factor(x$Ma))
    x
  })
  
  
  
  # now, make a list of all the males and females spawned on any given day
  spawner_lists <- split(meta, list(meta$SpawnDate, meta$Sex))
  
  # note that we can get all the males spawned on 2/3/11 with this:
  # spawner_lists$`2/3/11.Male`
  
  
  # now, we make a simulation function that operates on a single day and 
  # takes the variables we have prepared above as arguments
  perm_a_day <- function(day, reps=100) {
    
    # here is the total number of offpring that came back from parents spawned on this day
    tot_offs_this_day <- sum(nums_to_sim[[day]]$freq)
    
    # draw from fish spawned on that day
    sim_ma <- lapply(1:reps, function(x) sample(rownames(spawner_lists[[ paste(day, "Female", sep=".") ]]),
                                                size = max(nums_to_sim[[day]]$Ma),
                                                replace = FALSE
    ))
    sim_pa <- lapply(1:reps, function(x) sample(rownames(spawner_lists[[ paste(day, "Male", sep=".") ]]),
                                                size = max(nums_to_sim[[day]]$Pa),
                                                replace = FALSE
    ))
    
    idxs <- lapply(1:reps, function(x) cbind(Pa = rep(nums_to_sim[[day]]$Pa, nums_to_sim[[day]]$freq),
                                             Ma = rep(nums_to_sim[[day]]$Ma, nums_to_sim[[day]]$freq)))
    
    tempmat <- do.call(rbind, lapply(1:length(idxs), function(x) cbind(sim_pa[[x]][idxs[[x]][, "Pa"]], sim_ma[[x]][idxs[[x]][, "Ma"]])))
    
    matrix(rxy[tempmat], nrow=tot_offs_this_day) 
  }
  
  
  
  # now we cycle over the days and do it for each days and get a list that we rbind
  # together, after which we have a matrix where the columns are the reps and the rows
  # are different simulated individuals and the values of individuals inbreeding 
  # coefficients.
  ret <- do.call(rbind, lapply(names(nums_to_sim), function(day) perm_a_day(day, reps=REPS)))
  
  dimnames(ret) <- list(SimmedOffspring = 1:nrow(ret), Reps = 1:ncol(ret))
  
  ret
}