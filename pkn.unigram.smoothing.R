library(data.table)


#
directory <- "~/Dropbox/Coursera/DataScienceSpecialization//dsscapstone-001//"
setwd(directory)

#Load dictionaries
source("predictive-text-analysis/loadDictList.R")
lines = "5e+05"; ngrams = 4; rweka = FALSE; type = "tdm"; sorted = TRUE
ndictlist <- loadDictList("n", lines, ngrams, rweka, type, sorted)

#Adding pkn frequencies to unigrams, and bigrams

#set keys
setkey(ndictlist[[1]], token)
setkey(ndictlist[[2]], token2) #to search for token2
denom <- nrow(ndictlist[[2]])

ndictlist[[2]][ , `:=`( NROW = .N), by = token2]
bigram.nrow <- ndictlist[[2]][,unique(.SD), .SDcols = c("token2", "NROW")]

#For unigram in unigram dict, calculate pkn using continuation counts

pkn.unigram <- function(unigram, bigramdict = bigram.nrow, denominator = denom){
    #unigram: a single word
    #dictlist: bigramdictionary
    #denominator <- nrow(bigramdict)
    numerator <- bigramdict[unigram]$NROW
    return(numerator/denominator)
}


ndictlist[[1]][,`:=`(PKN = pkn.unigram(token))] #create new column PKN, a pkn-value for each unigram
ndictlist[[1]][is.na(PKN)]$PKN <- min(ndictlist[[1]][PKN > 0]$PKN)*0.9 #replace NA PKN values with a very small number
setkey(ndictlist[[1]],token) #set key to token

ndictlist[[1]][order(-count)][1:10]
ndictlist[[1]][order(-PKN)][1:10]


#result of pkn smoothing unigrams based on bigram continuations
ndictlist[[1]]