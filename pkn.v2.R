directory <- "/Users//polong//Dropbox//Coursera/DataScienceSpecialization/dsscapstone-001/"
setwd(directory)

t.1 <- readRDS("final/rds_files/t.1e+05.1grams.split.rds")
t.2 <- readRDS("final/rds_files/t.1e+05.2grams.split.rds")
t.3 <- readRDS("final/rds_files/t.1e+05.3grams.split.rds")

dictlist <- list(t.1, t.2, t.3)

"""
Steps:
1. Input a string with i number of words, with the intention of predicting the (i+1)th word
    (e.g., "a jury to settle the _____"). Obviously, the string may be much longer than our n number
    of ngram models. Actually, the string of length i cannot be greater than n-1, so the string must
    be reduce to length n-1.
2. So where do we get the candidate words for the (i+1)th word? We can take it from the bigram 
    model, using the ith-word to subset the bigram model, and return a list of (i+1)th words. This
    list, "candidatelist", may be a very large list of potential (i+1)th words. To reduce this list,
    we can only look at bigrams that have appeared at least twice (m = 2) in the corpus. In the
    event that no bigrams are found for a given i-th word, one option is to return nothing - a
    different method may be needed to predict a word that did not appear as word1 in a bigram from 
    the corpus.
3. Iterate over every word in the candidatelist and apply Kneser-Ney smoothing. This should return
    a dataframe, with each candidate word and the P(KN) value, sorted. This step can be 
    parallelized using map-reduce.
4. For word, w, in "possiblelist" (nrow = 3485), take largest n for available n-gram models and do 
    calculations on: 
    PKN(w | w1 ... wy), where y is the max(n, i), with n for ngram and i for words in string.
5. Sort words by PKN score. 

#Notes
Given t.2 for twitter bigram model of first 100,000 lines.
Bigrams for t.2 ["the".any] for ALL counts = 9211
t.2[t.2$token1 == "the" & t.2$count == 1,] = 3485
t.2[t.2$token1 == "the" & t.2$count == 2,] = 2281
t.2[t.2$token1 == "the" & t.2$count == 3,] = 1689

#Notes on ngram models to search
dictlist contains a list of all the ngram models, from unigram to ngram. length(dictlist) gives us
the number of ngram models available (currently 3 for trigram).

"""

## Step 1: String reduction ####

#Reducing a given string to a substring that can be analyzed using the available ngrams

string <- "i do not know but he is the"
A <- strsplit(string, split = " ")[[1]]

#How much should we shorten the string by?
#Should equal min of (length(dictlist)-1, length(A))
length(A) #8
length(dictlist) #3

min.length <- min(length(A), length(dictlist)-1) #2
A <- tail(A, min.length) #A reduced to length of min.length
A # "is the"


## Step 2: Generate candidatelist ####

# candidate: list of seen word2s in a bigram model [word1,word2] with count >= x, 
#               given the ith word in a string of length i.
#               For now, set x = 1.

#Take the last word
ith.word <- tail(A, 1)

#Generate list
m = 2 #minimum count frequency, default 2
candidatelist <- dictlist[[2]][dictlist[[2]]$token1 == ith.word &
                  dictlist[[2]]$count >= m, "token2"]


## Step 3: For each candidate word in "candidatelist", return KN values. ####
#Return: df containing columns: "phrase" "candidate" "KN-value  "
#Parallelizable using map-reduce.

#Example of B = "same"
B = "same"

## Base Case ####
#If the string is only one word (base case), return continuation probability using:
#P(KN) = N1+[word.any] / N1+[any.any]
base.case = nrow(dictlist[[2]][dictlist[[2]]$token1 == ith.word,]) / 
    nrow(dictlist[[2]]) #the best, the same, the world

#If the string has two words (e.g., "is" "the"), return probability using:
#PKN(B | A) = max{c(AB) - D, 0} / c(A) + D * N1+[A.any] / c(A) * PKN()

#Establish constants outside of recursion
discount <- 0.75

#Establish recursion-related rules:
min.length <- min(length(A), length(dictlist)-1) #2
A <- tail(A, min.length)

#Establish other constants within each recursion:
i <- length(A) # number of words in the string
A.collapsed <- paste(A, collapse = " ") # into a single string of words

## TERM 1 ####
## c(AB) ####
AB <- paste(A.collapsed, B, sep = " ")
c.AB <- dictlist[[i+1]][dictlist[[i+1]]$token == AB,
                                "count"] #c.AB = 18 for "is the same"
if(length(c.AB) == 0){c.AB <- 0.1} #sets c.string.ngram to 0.1 if numeric(0)

## max{c(AB) - D, 0} ####
max.term1 <- max(c.AB - discount, 0) #max of c.AB and zero

## c(A) ####
c.A <- dictlist[[i]][dictlist[[i]]$token == A.collapsed,"count"] 
if(length(c.A) == 0){c.A <- 0.1} #sets c.A to 0.1 if c.A was numeric(0)

## term1 ####
term1 <- max.term1/c.A
#term1 #0.0117 for "is the _same_"

## TERM 2 ####

## N.A.any ####
#Continuation count of [A.any] in an n-gram model, where n is 1+length(A)

#Create a logical vector to subset ngram model dataframe
logical.dfchecker <- function(i, var_name, dict_name){
    ##i: length of variable
    ##var_name: name of variable (e.g., "A"), in quotes
    ##dict_name: should be "dictlist"; otherwise name of dictionary of ngram models, in quotes.
    ##return: logical vector to match words in variable to words in dictionary, dict_name
    ##paste(dict_name,"[[",1:length(A),"] == ",A,"[",1:length(A),"]",collapse = " & ", sep = "")
    paste(dict_name,"[[",i+1,"]]$token",1:i," == ",var_name,"[",1:i,"]", collapse = " & ", sep = "")
}
#Example of logical.dfchecker:
# > logical.dfchecker(2, "A", "dictlist")
# [1] "dictlist[[3]]$token1 == A[1] & dictlist[[3]]$token2 == A[2]"

N.A.any <- nrow(dictlist[[i+1]][eval(parse(text=logical.dfchecker(i, "A", "dictlist"))), ])
#N.A.any #637

## term2 ####
term2 <- discount * N.A.any / c.A
#term2 #0.323 for "is the _same_"

## term3 ####
term3 <- 



