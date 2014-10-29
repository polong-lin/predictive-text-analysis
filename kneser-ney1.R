#outdated file
directory <- "/Users//polong//Dropbox//Coursera/DataScienceSpecialization/dsscapstone-001/"
setwd(directory)

t.1 <- readRDS("final/rds_files/t.1e+05.1grams.split.rds")
t.2 <- readRDS("final/rds_files/t.1e+05.2grams.split.rds")
t.3 <- readRDS("final/rds_files/t.1e+05.3grams.split.rds")

## Bigrams ####

<s> This is a list containing the tallest buildings in San Francisco : </s>
<s> The Transamerica Pyramid is the tallest building in San Francisco . </s>
<s> 555 California Street is the 2nd-tallest building in San Francisco . </s>


## How many times does w appear as a novel continuation?
# > head(t.2)
# token1 token2 count
# 1      i     am  6380
# 2     it     is  4202
# 3     in    the  3269 ### 
# 4    for    the  3143
# 5     do    not  3127

#Total count of bigram types (i.e., unique bigrams)

"""
P(the | in) = c(in the)/c(in) = (t.2[t.2$token == "in the",]$count)/(t.1[t.1$token == "in",]$count) = 3263/14584
"""
head(t.1)
head(t.2)
t.1
t.2[t.2$token == "in the",]$count
t.1[t.1$token == "in",]$count



vari <- 1
tryCatch(print("passes"), error = function(e) print(vari), finally=print("finished")) 
tryCatch(stop("fails"), error = function(e) print(vari), finally=print("finished")) 


