#Clean corpus, save to RDS file
clean.save.rm <- function(sourceletter, lines) {
    #print("Running clean.save.rm...")
    if(sourceletter == "t"){sourcename = "twitter"}
    if(sourceletter == "b"){sourcename = "blogs"}
    if(sourceletter == "n"){sourcename = "news"}
    text <- replace_contraction( #replaces all short-form contractions with full words
        readLines(paste0("en_US/en_US.",sourcename,".txt"),
                  n = lines)
        )
    cor.cl <- cleanCorpus(Corpus(VectorSource(text)))
    saveRDS(cor.cl, file=paste0(directory, "/final/rds_files/cl.",sourceletter,".",lines,".rds"))
    #print("...clean.save.rm DONE.")
}

