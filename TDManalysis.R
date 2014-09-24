# function to load RDS files
directory <- "~/Dropbox/Coursera/DataScienceSpecialization//dsscapstone-001/"
setwd(directory)
library(tm)
library(slam)

source("predictive-text-analysis/importRDS.R")

#"Import twitter TDM (n=1000000) for unigram to 7grams, using tau package"
#takes about 3 min to run importRDS on 100Mb an rds file with 1e+06 lines


# sourceletter = "t"; lines = 1000000; ngrams = 1; rweka = FALSE; type = "tdm"; sorted = TRUE
# t.1 <- importRDS(sourceletter, lines, ngrams, rweka, type, sorted) #8secs at 1e+06 lines to import+write
# ngrams = 2
# t.2 <- importRDS(sourceletter, lines, ngrams, rweka, type, sorted) #1min at 1e+06 lines to import+write
# ngrams = 3
# t.3 <- importRDS(sourceletter, lines, ngrams, rweka, type, sorted) #min at 1e+06 lines to import+write
# ngrams = 4
# t.4 <- importRDS(sourceletter, lines, ngrams, rweka, type, sorted)#min at 1e+06 lines to import+write
# ngrams = 5
# t.5 <- importRDS(sourceletter, lines, ngrams, rweka, type, sorted)#min at 1e+06 lines to import+write
# ngrams = 6
# t.6 <- importRDS(sourceletter, lines, ngrams, rweka, type, sorted)#min at 1e+06 lines to import+write
# ngrams = 7
# t.7 <- importRDS(sourceletter, lines, ngrams, rweka, type, sorted)#min at 1e+06 lines to import+write
# ngrams = 8
# t.8 <- importRDS(sourceletter, lines, ngrams, rweka, type, sorted)#min at 1e+06 lines to import+write

# rm(sourceletter); rm(lines); rm(ngrams); rm(rweka); rm(type); rm(sorted)
# dictlist <- list(t.1, t.2, t.3, t.4, t.5, t.6, t.7, t.8)
# rm(t.1); rm(t.2); rm(t.3); rm(t.4); rm(t.5); rm(t.6); rm(t.7); rm(t.8)

##############################################

source("predictive-text-analysis/dfFindNextWord.R")













#be able to reduce sentences >7 words
#reduce multiple sentence input (?.!) and reduce to final sentence
#lower case

#done: break token for n>1 into words split by " ", reinsert as multiple dataframes
#to specific probable next words, do a search of a subset of the dataframe containing the word, 
#return top three next words.

#If input is a long sentence of n words, take the last m words, and do a prediction. if not found,
#try last m-1 words and do a prediction. iterate. if not found, then provide no prediction, and include that
#into the dataframe, with a count of "1" in each ngram dataframe.

#Create histograms for 1-7 ngrams to see how the distribution of count changes
#Create histograms to compare between twitter, blogs, and news. show examples of differences in predictions