directory <- "~/Dropbox/Coursera/DataScienceSpecialization//dsscapstone-001/"
setwd(directory)
source("predictive-text-analysis/compiled_scripts.R")

#Creates cleaned corpuses -> rds. Then creates tokenizes the corpus -> rds.

rweka = TRUE; precleaned = TRUE

lines = 500000; ngrams = 1
ngramModel("t", lines, ngrams, rweka, precleaned) #cleaning 8 min, then 1.2 min
ngramModel("b", lines, ngrams, rweka, precleaned) #cleaning 9 min, then 1.4 min
ngramModel("n", lines, ngrams, rweka, precleaned) #cleaning 9 min, then 1.4 min

precleaned = TRUE

lines = 500000; ngrams = 2
ngramModel("t", lines, ngrams, rweka, precleaned) # 1.5 min
ngramModel("b", lines, ngrams, rweka, precleaned) # 2.5 min
ngramModel("n", lines, ngrams, rweka, precleaned) # 2.1 min

lines = 500000; ngrams = 3
ngramModel("t", lines, ngrams, rweka, precleaned) # 1.7 min
ngramModel("b", lines, ngrams, rweka, precleaned) # 3.1 min
ngramModel("n", lines, ngrams, rweka, precleaned) # 2.5 min

lines = 500000; ngrams = 4
ngramModel("t", lines, ngrams, rweka, precleaned) # 1.6 min
ngramModel("b", lines, ngrams, rweka, precleaned) # 3.3 min
ngramModel("n", lines, ngrams, rweka, precleaned) # 2.7 min

lines = 500000; ngrams = 5
ngramModel("t", lines, ngrams, rweka, precleaned) # 1.6 min
ngramModel("b", lines, ngrams, rweka, precleaned) # 3.6 min 
ngramModel("n", lines, ngrams, rweka, precleaned) # 2.8 min

lines = 100000; ngrams = 6
ngramModel("t", lines, ngrams, rweka, precleaned) # 1.6 min
ngramModel("b", lines, ngrams, rweka, precleaned) # 3.5 min
ngramModel("n", lines, ngrams, rweka, precleaned) # 3.5 min

lines = 100000; ngrams = 7
ngramModel("t", lines, ngrams, rweka, precleaned) # 1.6 min
ngramModel("b", lines, ngrams, rweka, precleaned) # 3.6 min
ngramModel("n", lines, ngrams, rweka, precleaned) # 2.8 min

--------------------------

lines = 50000; ngrams = 1; precleaned = FALSE
ngramModel("t", lines, ngrams, rweka, precleaned) #r cleaning 4 min, then 41 secs
ngramModel("b", lines, ngrams, rweka, precleaned) #r cleaning 4 min, then 44 secs
ngramModel("n", lines, ngrams, rweka, precleaned) #r cleaning 4 min, then 44 secs

precleaned = TRUE

ngrams = 2
ngramModel("t", lines, ngrams, rweka, precleaned) #46 secs
ngramModel("b", lines, ngrams, rweka, precleaned) #1.2 min
ngramModel("n", lines, ngrams, rweka, precleaned) #1 min

ngrams = 3
ngramModel("t", lines, ngrams, rweka, precleaned) #49 secs
ngramModel("b", lines, ngrams, rweka, precleaned) #1.5 min
ngramModel("n", lines, ngrams, rweka, precleaned) #1.3 min

ngrams = 4
ngramModel("t", lines, ngrams, rweka, precleaned) #50 secs
ngramModel("b", lines, ngrams, rweka, precleaned) #1.7 min
ngramModel("n", lines, ngrams, rweka, precleaned) #1.4 min

ngrams = 5
ngramModel("t", lines, ngrams, rweka, precleaned) #50 secs
ngramModel("b", lines, ngrams, rweka, precleaned) #1.7 min
ngramModel("n", lines, ngrams, rweka, precleaned) #1.4 min

ngrams = 6
ngramModel("t", lines, ngrams, rweka, precleaned) # 50 secs
ngramModel("b", lines, ngrams, rweka, precleaned) # 1.7 min
ngramModel("n", lines, ngrams, rweka, precleaned) # 1.4 min

ngrams = 7
ngramModel("t", lines, ngrams, rweka, precleaned) #
ngramModel("b", lines, ngrams, rweka, precleaned) # 1.7 min
ngramModel("n", lines, ngrams, rweka, precleaned) # 1.5 min


-----------------------------------------------
## Evening of Sunday Sep.14

source("predictive-text-analysis/compiled_scripts.R")

## capture all the output to a file.
outputpath <- "9.17.t.1e+05.txt" 
zz <- file(outputpath, open = "wt")
sink(zz)
sink(zz, type = "message")

#begin scripts
sourceletter = c("t","b","n")
rweka = FALSE; precleaned = FALSE
lines = 100000; ngrams = 8

for(letter in sourceletter){
    cat("\n")
    print(paste(letter, "; ngrams = 1"))
    ngramModel(sourceletter = letter, lines, ngrams = 1,rweka, precleaned = FALSE)
    for(n in 2:ngrams){
        cat("\n")
        print(paste(letter, "; ngrams =", n))
        ngramModel(sourceletter = letter, lines, ngrams = n,rweka, precleaned = TRUE)
}}
closeAllConnections()
## back to the console
# sink(type = "message")
# sink()
file.show(outputpath)



