## Function: Generate TDM from a CLEANED corpus w/o dict####
generateCleanTDM <- function(cleanedCorpus, rweka, ngrams) {
    #print("Running generateCleanTDM...")
    starttime <- Sys.time() #Start clock
    if(rweka == FALSE){
        clean.tdm <- TermDocumentMatrix(cleanedCorpus, 
                                        control = list(tokenize = function(x) tau_ngrams(x, 
                                                                               ngrams)))
    } else {
        clean.tdm <- TermDocumentMatrix(cleanedCorpus, 
                                        control = list(tokenize = function(x) rwekaTokenizer(x,
                                                                                 ngrams)))
    }
    print("[TIME generateCleanTDM]")
    print(Sys.time() - starttime) #total time
    #print("...generateCleanTDM DONE.")
    return(clean.tdm)
}
