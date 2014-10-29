## Intro ####
# This is my implementation of the Kneser-Ney smoothing algorithm, for use up to trigram models.

#Example: the tallest ... building? 
#         w1  w2      ... w3?

#PKN(building | the tallest)
#PKN(w3 | w1 w2)

## PKN Bigram ###
# PKN(w2 | w1) = max{c(w1w2)-d, 0}/c(w1) + d/c(w1) * N1+(w1.any) * Pcont(w2)
# Pcont(w2) = c(any.w2)/c(any.any)


#Givens:
#uni.df #unigram model. colnames: "token1" "token" "count"
#bi.df #bigram model. colnames: "token1" "token2" "token" "count"

pkn.cont.word2.bigram <- function(word2, bi.df) {
    #Third term: PKN of word2 = ([any.word2] continuation count) / ([any.any] continuation count)
    cont.any.word2 <- nrow(bi.df[bi.df$token2 == word2,])
    if(length(cont.any.word2) == 0){cont.any.word2 <- 0.1} #sets cont.any.word2 to 0.1 if cont.any.word2 was numeric(0)
    cont.any.any <- nrow(bi.df)
    if(length(cont.any.any) == 0){cont.any.any <- 0.1} #sets cont.any.any to 0.1 if cont.any.any was numeric(0)

    result <- cont.any.word2 / cont.any.any
    return(term3)
}


pkn.bigram <- function(word1, word2, bi.df, uni.df) {
    #Input a bigram model with four columns:
    # token1: first word in bigram
    # token2: second word in bigram
    # token: bigram together
    # count: count
    discount <- 0.75 #0.75 as per Jurafsky's video. Value must be between 0 and 1.
    bigram.word <- paste(word1, word2) # "word1 word2"
    
    #First term: (max of discounted bigram count and zero) / (word1 count)
    c.bigram <- bi.df[bi.df$token == bigram.word,"count"] #count of bigram
    if(length(c.bigram) == 0){c.bigram <- 0.1} #sets c.bigram to 0.1 if c.bigram was numeric(0)
    max.term1 <- max(c.bigram - discount, 
                     0) #numerator (max) of c.bigram and zero
    c.word1 <- uni.df[uni.df$token == word1,"count"] # count of word1 from uni.df
    if(length(c.word1) == 0){c.word1 <- 0.1} #sets c.word1 to 0.1 if c.word1 was numeric(0)
    term1 <- max.term1/c.word1
    
    cat("\nmax.term1 = "); cat(max.term1)
    cat("\nterm1 = "); cat(term1)
    
    #Second term: lambda = discount * ([word1.any] continuation count) / (word1 count)
    cont.word1.any <- nrow(bi.df[bi.df$token1 == word1,]) #continuation count of word1.any from bi.df
    if(length(cont.word1.any) == 0){cont.word1.any <- 0.1} #sets cont.word1.any to 0.1 if cont.word1.any was numeric(0)
    term2 <- discount * cont.word1.any / c.word1
    
    cat("\ncont.word1.any = "); cat(cont.word1.any)
    cat("\nterm2 = "); cat(term2)
    
    #Third term: PKN of word2 = ([any.word2] continuation count) / ([any.any] continuation count)
    term3 <- pkn.cont.word2.bigram(word1, word2, bi.df) #equals N1+[any.word2]/N1+[any.any]

    cat("\ncont.any.word = "); cat(cont.any.word2)
    cat("\ncont.any.any = "); cat(cont.any.any)
    cat("\nterm3 = "); cat(term3)
    cat("\nresult = ")
    
    #Formula
    result <- term1 + term2 * term3
    return(result)
}

word1 <- "he"
word2 <- "is"
a <- pkn.bigram(word1, word2, bi.df = t.2, uni.df = t.1)

word1 <- "she"
word2 <- "is"
b <- pkn.bigram(word1, word2, bi.df = t.2, uni.df = t.1)
a;b
a > b

trigram:
1. strsplit string into words (3)
2. pkn(w3 | w1 w2)

if there are three words:
    trigram pkn + bigram pkn
