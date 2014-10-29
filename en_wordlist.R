if(file.exists("predictive-text-analysis/en_wordlist.rds")==FALSE){
    url_emoji <- "http://www-personal.umich.edu/~jlawler/wordlist"
    en_wordlist <- readLines(url_emoji)
    rm(url_emoji)
    saveRDS(en_wordlist, file = "predictive-text-analysis/en_wordlist.rds")
} else{
    en_wordlist <- readRDS("predictive-text-analysis/en_wordlist.rds")
}
print("...en_wordlist LOADED.")