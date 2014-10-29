directory <- "~/Dropbox/Coursera/DataScienceSpecialization//dsscapstone-001//"
setwd(directory)

#Load dictionaries
source("predictive-text-analysis/loadDictList.R")
lines = "5e+05"; ngrams = 4; rweka = FALSE; type = "tdm"; sorted = TRUE
tdictlist <- loadDictList("t", lines, ngrams, rweka, type, sorted)
bdictlist <- loadDictList("b", lines, ngrams, rweka, type, sorted)
ndictlist <- loadDictList("n", lines, ngrams, rweka, type, sorted)
rm(lines); rm(ngrams); rm(rweka); rm(type); rm(sorted)

source("predictive-text-analysis/loadDictList.R")
lines = 500000; ngrams = 1; rweka = TRUE; type = "tdm"; sorted = TRUE
tdictlist <- loadDictList("t", lines, ngrams, rweka, type, sorted)
bdictlist <- loadDictList("b", lines, ngrams, rweka, type, sorted)
ndictlist <- loadDictList("n", lines, ngrams, rweka, type, sorted)
rm(lines); rm(ngrams); rm(rweka); rm(type); rm(sorted)


# Load prediction script
source("predictive-text-analysis/dfFindNextWord.R")

td <- dfFindNextWord("I can't wait to", tdictlist, 10)
bd <- dfFindNextWord("I can't wait to", bdictlist, 10)
nd <- dfFindNextWord("I can't wait to", ndictlist, 10)

bd

resultslist <- c()
for(i in 1:10){
    result.temp <- dfFindNextWord(quiz2[[i]][1], bdictlist, 15)
    resultslist <- c(resultslist, list(result.temp))
}

resultslist



#List of strings to predict next words:
searchlist <- c("The guy in front of me just bought a pound of bacon, a bouquet, and a case of",
               "You're the reason why I smile everyday. Can you follow me please? It would mean the",
               "Hey sunshine, can you follow me and make me the",
               "Very early observations on the Bills game: Offense still struggling but the",
               "Go on a romantic date at the",
               "Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my",
               "Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some",
               "After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little",
               "Be grateful for the good times and keep the faith during the",
               "If this isn't the cutest thing you've ever seen, then you must be")

dfFindNextWord("You're the reason why I smile everyday. Can you follow me please? It would mean the", tdictlist)

resultlist <- function(searchlist, dictionarylist) {
    #results <- list()
    #results <- data.frame(string = c(), search_string = c(), sourceletter = c(), next_word = c())
    results <- c()
    for(string in searchlist){
        dfwords <- dfFindNextWord(string, dictlist = dictionarylist, n = 5)
        #results <- rbind(results, c(string, paste(dfwords$searchstring, collapse = ","), sourceletter, paste(dfwords$next_word, collapse = ", ")))
        #print(dfwords)
        print(dfwords$next_word)
        results <- c(results, list(dfwords$next_word))
    }
    #names(results) <- c("string", "search_string", "sourceletter", "next_word")
    return(results)
}

r <- resultlist(searchlist, "n")
#saveRDS(r, "Quiz1.attempt1.results.RDS") #1million lines twitter 8grams
saveRDS(r, "Quiz1.attempt4.results.RDS") #100,000 lines blogs 8grams
r

tdr <- resultlist(searchlist, tdictlist)
ndr <- resultlist(searchlist, ndictlist)
bdr <- resultlist(searchlist, bdictlist)

tdr
ndr
bdr
