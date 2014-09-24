#Running this script assumes all the "split" dataframes have been pre-saved to RDS.
directory <- "~/Dropbox/Coursera/DataScienceSpecialization//dsscapstone-001/"
setwd(directory)

source("/predictive-text-analysis/importRDS.R")

loadDictList <- function(sourceletter, 
                         lines, 
                         ngrams, 
                         rweka = FALSE, 
                         type, 
                         sorted = TRUE){
    loaddictlist <- list()
    for(i in 1:ngrams){
        cat("importing df for ", i, " ngram", "\n")
        dict <- importRDS(sourceletter, lines, i, rweka, type, sorted)
        loaddictlist <- c(loaddictlist, list(dict))
    }
    return(loaddictlist)
}


