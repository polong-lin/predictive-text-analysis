
## Clean Corpus ####

#Create clean functions
remove_symbols <- function(corpus) gsub(perl = TRUE, 
                                        pattern = '[\\]\\[\\(\\)-/+;:#%$^\\*=^~\\{\\}/"<>«»_\\“\\”⁰•‘’–]', 
                                        replacement = "", corpus)

convert_to_period <- function(corpus) gsub(pattern = "[\\!\\?…]", 
                                           replacement = ".", corpus)
reduce_periods <- function(corpus) gsub(pattern = "[\\.]{2,}", 
                                        replacement = ".", corpus)
convert_to_and <- function(corpus) gsub(pattern = "&", replacement = " and ", corpus)
censor_profanity <- function(corpus) gsub(pattern = paste0(profanitylist, collapse="|"), 
                                          replacement = "", corpus)
replace_numbers <- function(corpus) gsub(pattern = "[0-9]+", 
                                         replacement = "", corpus)

#List of clean functions
reduce_list <- list(remove_symbols, 
                    convert_to_period, 
                    reduce_periods, 
                    convert_to_and,
                    censor_profanity, 
                    replace_numbers,
                    tolower,
                    stripWhitespace)

#Combine clean functions into single tm_map clean function
cleanCorpus <- function(corpus) {
    #print("Running cleanCorpus...")
    starttime <- Sys.time()
    cleaned <- tm_map(corpus, FUN = tm_reduce, tmFuns = reduce_list)
    print("[TIME] cleanCorpus")
    print(Sys.time() - starttime)
    #print("...cleanCorpus DONE.")
    return(cleaned)
}
