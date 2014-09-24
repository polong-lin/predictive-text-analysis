#Clean corpus, generate TDM, save to RDS, remove from environment
setwd(directory)
ngramModel <- function(sourceletter, lines, ngrams, rweka = FALSE, precleaned = FALSE) {
    #INPUT:
    #sourceletter: "t", "b", "n" for twitter/blogs/news
    #lines: a number, number of lines to be read
    #ngrams: a number, number of ngrams (e.g., 2 for bigrams)
    #rweka: uses rweka to tokenize, or else uses tau
    #precleaned: if rds data file of the cleaned corpus already exists, will load it & skip cleaning
    #print("Running ngramModel...")
    if(precleaned == FALSE){clean.save.rm(sourceletter, lines)}
    cleanedcorpus <- readRDS(paste0(directory, "/final/rds_files/cl.",sourceletter,".",lines,".rds"))
    model <- generateCleanTDM(cleanedcorpus, rweka, ngrams)
    if(rweka == FALSE){
        saveRDS(model, file = paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.tau.rds"))
    } else{
        saveRDS(model, file = paste0(directory, "/final/rds_files//", sourceletter,".",lines,".",ngrams,"grams.rweka.rds"))
    }
    #print("...ngramModel DONE.")
}
# cleanedcorpus <- readRDS("rds_files/cl.t.100.rds")
# model <- generateCleanTDM(cleanedcorpus, TRUE, 2)
# 
# tau_ngrams <- function(x, n) return(rownames(as.data.frame(unclass(textcnt(x,method="string",n=n)))))
# 
# nwer = 3
# clean.tdm <- TermDocumentMatrix(cleanedcorpus, 
#                                 control = list(tokenize = function(x) {tau_ngrams(x, nwer)}))
# inspect(clean.tdm)
