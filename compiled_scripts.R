## Init ####
require("tm")
require("slam")
require("tau")
require("qdap")
directory <- "~/Dropbox/Coursera/DataScienceSpecialization//dsscapstone-001/"
setwd(directory)
options(stringsAsFactors = FALSE)
options(mc.cores=1) #prevents ERROR: Error in rep(seq_along(x), sapply(tflist, length)) : invalid 'times' argument

## Load lists ####
# print("Loading lists...")
source("predictive-text-analysis/profanitylist.R") #loads "profanitylist"" as a string of profanity words
#Currently improperly censoring butterfly as censoredterfly
source("predictive-text-analysis/emoticonlist.R") #loads "emoticonlist"" as a string of emoticons
source("predictive-text-analysis/en_wordlist.R") #loads "en_wordlist" as string of English words

#cleanCorpus function
source("predictive-text-analysis/cleanCorpus.R") # cleanCorpus(corpus), returns cleaned corpus
# cat("...function cleanCorpus LOADED.\n")

#load tokenizers
source("predictive-text-analysis/tau_ngram_tokenizers.R") #tau_unigram(file), bigram, trigram, 4gram
source("predictive-text-analysis/RWeka-tokenizers.R") #UnigramTokenizer, Bigram, Trigram, Fourgram
# cat("...tokenizers LOADED.\n")

## Function: Generate TDM from a CLEANED corpus w/o dict####
source("predictive-text-analysis/generateCleanTDM.R")
# cat("...function generateCleanTDM LOADED.\n")

#Clean corpus, save to RDS file
source("predictive-text-analysis/clean.save.rm.R")
# cat("...function clean.save.rm LOADED.\n")

#Clean corpus, generate TDM, save to RDS, remove from environment
source("predictive-text-analysis/ngramModel.R")
# cat("...function ngramModel LOADED.\n")


## #EXAMPLE:
# ngramModel("t", lines = 10000, ngrams = 5 ,rweka = TRUE, precleaned = FALSE)
# ngramModel("t", lines = 10000, ngrams = 5 ,rweka = FALSE, precleaned = FALSE)

#rweka: "t", lines = 10000, ngrams = 5 ,rweka = TRUE ## 45 secs to clean, 21 secs to model
#tau:  "t", lines = 10000, ngrams = 5 ,rweka = TRUE ## 47 secs to clean, 14 secs to model


# 
# t.rweka <- readRDS("rds_files/t.10000.5grams.rweka.rds")
# t.tau <- readRDS("rds_files/t.10000.5grams.tau.rds")
# 
# head(sort(rowSums(as.matrix(t.rweka)), decreasing = TRUE), n = 3)
# head(sort(rowSums(as.matrix(t.tau)), decreasing = TRUE), n = 3)
# 


