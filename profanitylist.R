library(RCurl)
x <- getURL("https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en")
profanitylist <- unlist(strsplit(x, "\n")) #list of swear words
rm(x)

print("...profanitylist LOADED.")