dfTokenSplit <- function(df){
    #INPUT: dataframe with two columns (df$token, df$count)
    #RETURNS: a larger dataframe with a single column for each word in the token, split by " ",
    #           and the count as the final column.
    df.split <- data.frame(do.call(rbind, strsplit(as.vector(df$token), split = " ")))
    ncolumns <- 
        names(df.split) <- c(paste0("token",1:ncol(df.split)))
    newdf <- cbind(df.split, count = df$count)
    return(newdf)
}

tokensplittoRDS <- function(df, sourceletter, lines, ngrams){
    df.split <- data.frame(do.call(rbind, strsplit(as.vector(df$token), split = " ")))
    ncolumns <- 
        names(df.split) <- c(paste0("token",1:ncol(df.split)))
    newdf <- cbind(df.split, count = df$count)
    saveRDS(newdf, file = paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"))
}

importRDS <- function(sourceletter, lines, ngrams, rweka, type, sorted){
    #INPUT:
    #sourceletter: "t", "b", or "n"
    #lines: a number, number of lines read from text files
    #ngrams: a number, for n in ngram
    #reweka: TRUE for rweka package, FALSE for tau package
    #type: "corpus" or "tdm", selecting which file. tdm.split is if df has already been split.
    #sorted: TRUE/FALSE, if TRUE sorts dataframe by count of ngram token
    #RETURNS: data frame of tokens (e.g., unigram) and their total counts
    print(c("Running importRDS... for", ngrams, "ngrams;", lines, "lines"))
    starttime <- Sys.time()
    if(rweka == TRUE){
        package <- "rweka"
    } else (package <- "tau")
    if(type == "corpus"){
        f <- readRDS(paste0(directory, "/final/rds_files/cl.",sourceletter,".",lines,".",ngrams,"grams.",
                            package,".rds"))
    }else if(type == "tdm"){
        if(file.exists(paste0(directory, "/finalrds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds")) == FALSE){
            cat(paste0(directory, "/finalrds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"), "DNE", "\n")
            f <- readRDS(paste0(directory, "/final/rds_files/",sourceletter,".",lines,".",ngrams,"grams.",
                                package,".rds"))
            f <- rollup(f, 2, na.rm = TRUE, FUN = sum)
            f <- data.frame(token = f$dimnames$Terms, count = f$v)
            if(sorted == TRUE){
                f <- f[order(f$count, decreasing = TRUE),]
            }
            print("Tokensplit")
            f <- dfTokenSplit(f)
            saveRDS(f, file = paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"))
        } else {
            cat(paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"), "exists", "\n")
            cat("loading ", paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"), "\n")
            f <- readRDS(paste0(directory, "/final/rds_files/", sourceletter,".",lines,".",ngrams,"grams.split.rds"))
        }   
    }
    print("[TIME importRDS]")
    print(Sys.time() - starttime)
    print("...DONE.")
    return(f)
}