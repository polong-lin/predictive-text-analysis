if(file.exists("predictive-text-analysis/profanitylist.rds") == FALSE){
    library(RCurl)
    x <- getURL("https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en")
    ?getURL
    profanitylist <- unlist(strsplit(x, "\n")) #list of swear words
    saveRDS(profanitylist, file = "predictive-text-analysis/profanitylist.rds")
    rm(x)
} else {
    profanitylist <- readRDS("predictive-text-analysis/profanitylist.rds")
}
print("...profanitylist LOADED.")