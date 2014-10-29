#Running this script assumes all the "split" dataframes have been pre-saved to RDS.
directory <- "~/Dropbox/Coursera/DataScienceSpecialization//dsscapstone-001/"
setwd(directory)

loadDictList <- function(sourceletter, 
                         lines, 
                         ngrams, 
                         rweka = FALSE, 
                         type, 
                         sorted = TRUE){
    source("predictive-text-analysis/importRDS_dt.R")
    loaddictlist <- list()
    for(i in 1:ngrams){
#         cat(paste("importing df for ", i, " ngram", collapse = ""),"\n")
        dict <- importRDS_dt(sourceletter, lines, i, rweka, type, sorted)
        if((class(dict)[1]) != "data.table"){
            print("--Converting to data.table and saving to RDS")
            dict <- data.table(dict)
            saveRDS(dict, file = paste0(directory,"final/rds_files/", sourceletter,".",
                                                    lines, ".", i, "grams.split.rds"))
        }
        if(length(unique(Encoding(dict$token))) > 1){
            print("--Converting to ASCII")
            dict$token <- iconv(dict$token, "UTF-8", "ASCII")
            dict$token1 <- iconv(dict$token1, "UTF-8", "ASCII")
            try(dict$token2 <- iconv(dict$token2, "UTF-8", "ASCII"), silent = TRUE)
            try(dict$token3 <- iconv(dict$token3, "UTF-8", "ASCII"), silent = TRUE)
            try(dict$token4 <- iconv(dict$token4, "UTF-8", "ASCII"), silent = TRUE)
            try(dict$token5 <- iconv(dict$token5, "UTF-8", "ASCII"), silent = TRUE)
            try(dict$token6 <- iconv(dict$token6, "UTF-8", "ASCII"), silent = TRUE)
            setkey(dict,token)
            dict <- dict[!is.na(token)]
            saveRDS(dict, file = paste0(directory,"final/rds_files/", sourceletter,".",
                                        lines, ".", i, "grams.split.rds"))
        }
        if((nrow(dict[count <= 1])) > 1){
            print("--Removing ngrams with count of 1 or 2")
            setkey(dict, count)
            dict <- data.table(dict)[count >= 2]
            saveRDS(dict, file = paste0(directory,"final/rds_files/", sourceletter,".",
                                        lines, ".", i, "grams.split.rds"))
        }
        loaddictlist <- c(loaddictlist, list(dict))
    }
    return(loaddictlist)
}

