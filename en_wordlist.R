url_emoji <- "http://www-personal.umich.edu/~jlawler/wordlist"

en_wordlist <- readLines(url_emoji)
rm(url_emoji)

print("...en_wordlist LOADED.")