require(data.table)

dtTokenSplit <- function(dt){
    #INPUT: datatable with two columns (dt$token, dt$count)
    #RETURNS: a larger datatable with a single column for each word in the token, split by " ",
    #           and the count as the final column.
    dt.split <- data.table(do.call(rbind, strsplit(as.vector(dt$token), split = " ")))
    setnames(dt.split,c(paste0("token",1:ncol(dt.split))))
    newdt <- cbind(dt.split, token = dt$token, count = dt$count)
    newdt <- data.table(newdt)
    return(newdt)
}

importRDS_dt <- function(sourceletter, lines, ngrams, rweka, type, sorted){
    #INPUT:
    #sourceletter: "t", "b", or "n"
    #lines: a number, number of lines read from text files
    #ngrams: a number, for n in ngram
    #reweka: TRUE for rweka package, FALSE for tau package
    #type: "corpus" or "tdm", selecting which file. tdm.split is if dt has already been split.
    #sorted: TRUE/FALSE, if TRUE sorts datatable by count of ngram token
    #RETURNS: data frame of tokens (e.g., unigram) and their total counts
#     print(c("Running importRDS... for", ngrams, "ngrams;", lines, "lines"))
    starttime <- Sys.time()
    if(rweka == TRUE){
        package <- "rweka"
    } else (package <- "tau")
    if(type == "corpus"){
        f <- readRDS(paste0(directory, "/final/rds_files/cl.",sourceletter,".",lines,".",ngrams,"grams.",
                            package,".rds"))
    }else if(type == "tdm"){
        if(file.exists(paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds")) == FALSE){
            #If the split file does not exist:
#             cat(paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"), "DNE", "\n")
            f <- readRDS(paste0(directory, "/final/rds_files/",sourceletter,".",lines,".",ngrams,"grams.",
                                package,".rds"))
            f <- rollup(f, 2, na.rm = TRUE, FUN = sum)
            f <- data.table(token = f$dimnames$Terms, count = f$v)
            setkey(f, token)
            if(sorted == TRUE){
                f <- f[order(-count)]
            }
#             print("Tokensplit")
            f <- dtTokenSplit(f)
            saveRDS(f, file = paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"))
        } else {
            #If the split file DOES exist:
#             cat(paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"), "exists", "\n")
#             cat("loading ", paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"), "\n")
            f <- readRDS(paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"))
        }   
    }
#     print("[TIME importRDS_dt]")
#     print(Sys.time() - starttime)
#     print("...DONE.")
    return(f)
}