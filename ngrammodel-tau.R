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
source("predictive-text-analysis/profanitylist.R") #loads "profanitylist"" as a string of profanity words
source("predictive-text-analysis/emoticonlist.R") #loads "emoticonlist"" as a string of emoticons
source("predictive-text-analysis/en_wordlist.R") #loads "en_wordlist" as string of English words

#cleanCorpus function
source("predictive-text-analysis/cleanCorpus.R") # cleanCorpus(corpus), returns cleaned corpus

#load tokenizers
source("predictive-text-analysis/tau_ngram_tokenizers.R") #tau_unigram(file), bigram, trigram, 4gram
source("predictive-text-analysis/RWeka-tokenizers.R") #UnigramTokenizer, Bigram, Trigram, Fourgram

## Function: Generate TDM from a CLEANED corpus w/o dict####
source("predictive-text-analysis/generateCleanTDM.R")

#Clean corpus, save to RDS file
source("predictive-text-analysis/clean.save.rm.R")

#Clean corpus, generate TDM, save to RDS, remove from environment
source("predictive-text-analysis/ngramModel.R")
ngramModel("t", 100000, "uni") #9min
ngramModel("t", 100000, "bi") #9min
ngramModel("t", 100000, "tri") #9min

ngramModel("b", 100000, "uni") #9min
ngramModel("b", 100000, "bi") #10min
ngramModel("b", 100000, "tri") #11amin

ngramModel("n", 100000, "uni") #10min
ngramModel("n", 100000, "bi") #11min
ngramModel("n", 100000, "tri") #11min

ngramModel("t", 500000, "uni") #42min
ngramModel("t", 500000, "bi") #>5hrs??
ngramModel("t", 500000, "tri")

ngramModel("t", 200000, "tri") #20min
ngramModel("b", 200000, "tri") #20min
ngramModel("n", 200000, "tri") #20min

ngramModel("t", 1000, "bi", rweka = TRUE, precleaned = TRUE)

ngramModel("t", 100000, "bi", rweka = TRUE, precleaned = TRUE)
ngramModel("b", 100000, "bi", rweka = TRUE, precleaned = TRUE)
ngramModel("n", 100000, "bi", rweka = TRUE, precleaned = TRUE)

ngramModel("t", 50000, "4gram", rweka = TRUE, precleaned = TRUE)
ngramModel("b", 50000, "4gram", rweka = TRUE, precleaned = TRUE)
ngramModel("n", 50000, "4gram", rweka = TRUE, precleaned = TRUE)

ngramModel("t", 50000, "5gram", rweka = TRUE, precleaned = TRUE)
ngramModel("b", 50000, "5gram", rweka = TRUE, precleaned = TRUE)
ngramModel("n", 50000, "5gram", rweka = TRUE, precleaned = TRUE)

ngramModel("t", 50000, "6gram", rweka = TRUE, precleaned = TRUE)
ngramModel("b", 50000, "6gram", rweka = TRUE, precleaned = TRUE)
ngramModel("n", 50000, "6gram", rweka = TRUE, precleaned = TRUE)

# r <- readLines("en_US/en_US.twitter.txt", n = 10000)
# r.corp <- Corpus(VectorSource(r))
# 
# #tdm vs. weka
# r.tdm <- generateCleanTDM(cleanCorpus(r.corp), tau_bigrams) #52 secs with 10k lines
# r.tdm.weka <- generateCleanTDM(cleanCorpus(r.corp), BigramTokenizer) #57 secs with 10k lines

