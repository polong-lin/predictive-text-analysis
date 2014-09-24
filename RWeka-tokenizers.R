library(RWeka)
#Tokenizer functions using RWeka
#original:
#rwekaTokenizer <- function(x, ngrams) NGramTokenizer(x, Weka_control(min = ngrams, max = ngrams))

rwekaTokenizer <- function(x, ngrams) NGramTokenizer(x, Weka_control(min = ngrams, max = ngrams))