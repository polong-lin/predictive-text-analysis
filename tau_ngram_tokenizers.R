#Tau tokenizing functions

#tau_unigrams <- function(file) textcnt(file, n = 1, method = "string")
#tau_bigrams <- function(file) textcnt(file, n = 2, method = "string")
#tau_trigrams <- function(file) textcnt(file, n = 3, method = "string")

tau_ngrams <- function(x, ngrams) return(rownames(as.data.frame(unclass(textcnt(x,method="string",n=ngrams)))))
#tau_ngrams <- function(file, ngrams) textcnt(file, n = ngrams, method = "string")


