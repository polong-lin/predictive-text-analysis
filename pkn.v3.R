## Kneser-Ney Smoothing
directory <- "/Users//polong//Dropbox//Coursera/DataScienceSpecialization/dsscapstone-001/"
setwd(directory)

t.1 <- readRDS("final/rds_files/t.1e+05.1grams.split.rds")
t.2 <- readRDS("final/rds_files/t.1e+05.2grams.split.rds")
t.3 <- readRDS("final/rds_files/t.1e+05.3grams.split.rds")
t.4 <- readRDS("final/rds_files/t.1e+05.4grams.split.rds")
t.5 <- readRDS("final/rds_files/t.1e+05.5grams.split.rds")

dictlist <- list(t.1, t.2, t.3, t.4, t.5)
rm(t.1); rm(t.2); rm(t.3); rm(t.4); rm(t.5)

## Step 1: String reduction ####

#Reducing a given string to a substring that can be analyzed using the available ngrams

string <- "i do not know but he is the"
string <- strsplit(string, split = " ")[[1]]

#How much should we shorten the string by?
#Should equal min of (length(dictlist)-1, length(string))
min.length <- min(length(string), length(dictlist)-1) #2
string <- tail(string, min.length) #string reduced to length of min.length
rm(min.length)
string # "is the"


## Step 2: Generate candidatelist ####

# candidate: list of seen word2s in a bigram model [word1,word2] with count >= x, 
#               given the ith word in a string of length i.
#               For now, set x = 1.

#Establish 
last.word <- tail(string, 1) #ith.word is final word
names(string) <- paste("w",1:length(string), sep = "") #label each word in string is w1... wi.

#Generate list from bigrams
m = 2 #minimum count frequency, default 2
candidatelist <- dictlist[[2]][dictlist[[2]]$token1 == last.word &
                                   dictlist[[2]]$count >= m, "token2"]

#Create a logical vector to subset ngram model dataframe
logical.dfchecker <- function(string_start, token_start, ntokens, string_name, dict_number){
    ##string_start: number, which word to start in string (e.g., 3 if search starts from w3)
    ##token_start: number, which token to start search in dict (e.g., 3 if search starts at token3)
    ##ntokens: number of words/tokens to search (e.g., 2 for w1 w2)
    ##string_name: name of variable (e.g., "string"), in quotes
    ##dict: specific dictionary number from dictlist (e.g., 2 for "dictlist[[2]]")
    ##return: logical vector to match words in variable to words in dictionary, dict_name
    logicalvectorlist <- c()
    for(ntoken in 1:ntokens){
        logical.temp <- paste0("dictlist[[",dict_number,"]]$token",token_start+ntoken-1," == ",
                              string_name,"[",string_start+ntoken-1,"]")
        logicalvectorlist <- c(logicalvectorlist, logical.temp)
    }
    result <- paste(logicalvectorlist, collapse = " & ")
    return(result)
}

#Continuation count

continuationcount <- function(string_start, token_start, ntokens, string_name, dict_number, dictlist) {
    print(c(string_start,token_start, ntokens, string_name, dict_number))
    print(logical.dfchecker(string_start, token_start, ntokens, string_name, dict_number))
    print(head(dictlist[[dict_number]][eval(parse(text = logical.dfchecker(string_start, token_start, ntokens, string_name, dict_number))),]))
    nrow(dictlist[[dict_number]][eval(parse(text = logical.dfchecker(string_start, token_start, ntokens, string_name, dict_number))),])
}

## Function to collapse a split string
collapse <- function(splitstring){
    paste(splitstring, collapse = " ")
}

## Highest and middle-order calculations ####

append.candidate <- function(string, candidate){
    #string: a vector of words in a string
    #candidate: a word to be added to end of string
    result <- c(string, candidate = candidate)
    return(result)
}

#Appending a candidate string EXAMPLE: "but he is the" + "one"
searchstring <- append.candidate(string, "one")

#Highest order calculation PKN
calc.pkn.highest <- function(string, lowerorder, discount, dictlist){
    #INPUT:
    #string: a vector of words
    #lowerorder: the pkn of the lower order calculations as a single numeric value.
    #discount: discount value, default = 0.75
    #n: length of string
    #diclist: list of dictionaries
    #OUTPUT:
    #result: pkn term excluding the final term
    n <- length(string)
    c.wi.to.n <- dictlist[[n]][dictlist[[n]]$token ==  collapse(string),"count"]
    if(length(c.wi.to.n) == 0){c.wi.to.n = 0.1}
    
    c.wi.to.n.minus.1 <- dictlist[[n-1]][dictlist[[n-1]]$token ==  collapse(string[1:n-1]),"count"]
    if(length(c.wi.to.n.minus.1) == 0){c.wi.to.n.minus.1 = 0.1}
    
    cont.wi.to.n.minus.1.ANY <- nrow(
        dictlist[[n]][
            eval(parse(
                text=logical.dfchecker(string_start = 1, token_start = 1, ntokens = n-1, string_name = "string", dict_number = n)
                )), ])
    
    if(length(cont.wi.to.n.minus.1.ANY) == 0){c.wi.to.n.minus.1 = 0.1}
    
    print("Highest order calculation:")
    print("c.wi.to.n")
    cat(c.wi.to.n)
    cat("\n")
    
    print("c.wi.to.n.minus.1")
    cat(c.wi.to.n.minus.1)
    cat("\n")
    
    print("cont.wi.to.n.minus.1.ANY")
    cat(cont.wi.to.n.minus.1.ANY)
    cat("\n")
    
    print("discount")
    cat(discount)
    cat("\n")
    
    print("lowerorder")
    cat(lowerorder)
    cat("\n")
    
    print("c.wi.to.n.minus.1")
    cat(c.wi.to.n.minus.1)
    cat("\n")
    
    result <- max(c.wi.to.n, 0)/c.wi.to.n.minus.1 + discount*cont.wi.to.n.minus.1.ANY*lowerorder/c.wi.to.n.minus.1
    
    return(result)
}

pkn.calc <- function(string, dictlist){
    discount <- 0.75
    n <- length(string)
    
    ## Lowest order calculation ####
    #PKN = continuationcount(any.wi.to.n) / continuationcount(any.wi.to.n.minus.1.any)
    cat("Lowest order calculation --------\n")
    pkn.lowest <- nrow(dictlist[[2]][dictlist[[2]]$token2 == tail(string,1),]) / 
        nrow(dictlist[[2]]) #the best, the same, the world
    cat("\n")
    
    print("pkn.lowest.numerator")
    cat(nrow(dictlist[[2]][dictlist[[2]]$token2 == tail(string,1),]))
    cat("\n")
    
    print("pkn.lower.denominator")
    cat(nrow(dictlist[[2]]))
    cat("\n")
    
    #List of results for lower order pkn calculations  
    pkn.lower.list <- list("lowest" = pkn.lowest)   
    
    #Lower order calculation
    for(i in (n-2):2){ #i is the recursion counter, from i until n-1 
        print("Lower order calculation -----------")
        print(paste("-- i <-", i, "---------"))
        string_start = i
        string_name = deparse(substitute(string))
        
        #Continuation count of [any][wi to n] in dictlist[[n]]
        cont.ANY.wi.to.n <- continuationcount(string_start,
                                              token_start   = 2, 
                                              ntokens       = n-i+1, 
                                              string_name, 
                                              dict_number   = n-i+2, 
                                              dictlist)
        if(length(cont.ANY.wi.to.n) == 0){cont.ANY.wi.to.n = 0.1}
        
        #Continuation count of [any][wi to n-1][any] in dictlist[[n]]
        cont.ANY.wi.to.n.minus.1.ANY <- continuationcount(string_start, 
                                                          token_start   = 2, 
                                                          ntokens       = n-i, 
                                                          string_name, 
                                                          dict_number   = n-i+2, 
                                                          dictlist)
        if(length(cont.ANY.wi.to.n.minus.1.ANY) == 0){cont.ANY.wi.to.n.minus.1.ANY = 0.1}
        
        #Continuation count of [wi to n-1][any] in dictlist[[n-1]]
        cont.wi.to.n.minus.1.ANY <- continuationcount(string_start, 
                                                      token_start   = 1, 
                                                      ntokens       = n-i, 
                                                      string_name, 
                                                      dict_number   = n-i+1, 
                                                      dictlist)
        if(length(cont.wi.to.n.minus.1.ANY) == 0){cont.wi.to.n.minus.1.ANY = 0.1}
        
        #Printing for debugging
        print("cont.ANY.wi.to.n")
        cat(cont.ANY.wi.to.n)
        cat("\n")
        
        print("cont.ANY.wi.to.n.minus.1.ANY")
        cat(cont.ANY.wi.to.n.minus.1.ANY)
        cat("\n")
        
        print("cont.wi.to.n.minus.1.ANY")
        cat(cont.wi.to.n.minus.1.ANY)
        cat("\n")
        
        print("discount")
        cat(discount)
        cat("\n")
        
        print("pkn.lowerorder")
        cat(tail(pkn.lower.list,1)[[1]])
        cat("\n")
        
        #Set to temporary result
        lowerorder <- tail(pkn.lower.list,1)[[1]]
        pkn.result.temp <- max(cont.ANY.wi.to.n,0)/cont.ANY.wi.to.n.minus.1.ANY + 
            discount *lowerorder/cont.wi.to.n.minus.1.ANY
        
        pkn.lower.list <- c(pkn.lower.list, lower.pkn = pkn.result.temp)
    }
    print(pkn.lower.list)
    lowerorder <- tail(pkn.lower.list,1)[[1]]
    
    pkn.result <- calc.pkn.highest(string, lowerorder, discount, dictlist)
    return(pkn.result)
}

searchstring
a <- pkn.calc(searchstring, dictlist)
a

string
dictlist[[4]][dictlist[[4]]$token2 == searchstring[3] & dictlist[[4]]$token3 == searchstring[4] & dictlist[[4]]$token4 == searchstring[5],]


#test
#Continuation count of [any][wi to n] in dictlist[[n]]

cont.ANY.wi.to.n <- continuationcount(string_start,
                                      token_start   = 2, 
                                      ntokens       = n-i+1, 
                                      string_name, 
                                      dict_number   = n-i+2, 
                                      dictlist)
if(length(cont.ANY.wi.to.n) == 0){cont.ANY.wi.to.n = 0.1}

#Continuation count of [any][wi to n-1][any] in dictlist[[n]]
cont.ANY.wi.to.n.minus.1.ANY <- continuationcount(string_start, 
                                                  token_start   = 2, 
                                                  ntokens       = n-i, 
                                                  string_name, 
                                                  dict_number   = n-i+2, 
                                                  dictlist)









searchstring <- append.candidate(string, "best")
i = 2; n = 5

searchstring #but he is the one

searchstring[i:n] #he is the one
n-i+1 #4

string_start = i; token_start = 2; ntokens = n-i+1; string_name = "searchstring"; dict_number = n-i+2
dictlist[[dict_number]][eval(parse(text = logical.dfchecker(string_start, token_start, ntokens, string_name, dict_number))),])

string_start = i; token_start = 2; ntokens = n-i; string_name = "searchstring"; dict_number = n-i+2
dictlist[[dict_number]][eval(parse(text = logical.dfchecker(string_start, token_start, ntokens, string_name, dict_number))),]

string_start = i; token_start = 1; ntokens = n-i; string_name = "searchstring"; dict_number = n-i+1
dictlist[[dict_number]][eval(parse(text = logical.dfchecker(string_start, token_start, ntokens, string_name, dict_number))),]

rm(string_start); rm(token_start); rm(ntokens); rm(string_name); rm(dict_number)
rm(i)

nrow(dictlist[[dict_number]][eval(parse(text = logical.dfchecker(string_start, token_start, ntokens, string_name, dict_number))),])
nrow(dictlist[[dict_number]][eval(parse(text = logical.dfchecker(string_start, token_start, ntokens, string_name, dict_number))),])
nrow(dictlist[[dict_number]][eval(parse(text = logical.dfchecker(string_start, token_start, ntokens, string_name, dict_number))),])




cont.ANY.wi.to.n <- continuationcount(start = i, end = n, string_name = "string", dict_number = n, dictlist = dictlist)
if(length(cont.ANY.wi.to.n) == 0){cont.ANY.wi.to.n = 0.1}
cont.ANY.wi.to.n.minus.1.ANY <- continuationcount(start = i, end = n-1, string_name = "string", dict_number = n, dictlist = dictlist)
if(length(cont.ANY.wi.to.n.minus.1.ANY) == 0){cont.ANY.wi.to.n.minus.1.ANY = 0.1}
cont.wi.to.n.minus.1.ANY <- continuationcount(start = i, end = n-1, string_name = "string", dict_number = n-1, dictlist = dictlist)
if(length(cont.wi.to.n.minus.1.ANY) == 0){cont.wi.to.n.minus.1.ANY = 0.1}

    #Highest order calculation
    print("Highest order calculation")
    print(collapse(string))
    pkn.highest <- calc.pkn.highest(string = string, lowerorder = lowerorder, dictlist = dictlist)
    
}

