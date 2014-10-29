## Function: Generate TDM from a CLEANED corpus w/o dict####
library(tm)
generateCleanTDM <- function(cleanedCorpus, rweka, ngrams) {
    #print("Running generateCleanTDM...")
    starttime <- Sys.time() #Start clock
    if(rweka == FALSE){
        clean.tdm <- TermDocumentMatrix(cleanedCorpus, 
                                        control = list(tokenize = function(x) tau_ngrams(x, 
                                                                               ngrams),
                                                       wordLengths = c(1, Inf)))
    } else {
        clean.tdm <- TermDocumentMatrix(cleanedCorpus, 
                                        control = list(tokenize = function(x) rwekaTokenizer(x,
                                                                                 ngrams),
                                                       wordLengths = c(1, Inf)))
    }
    print("[TIME generateCleanTDM]")
    print(Sys.time() - starttime) #total time
    #print("...generateCleanTDM DONE.")
    return(clean.tdm)
}
