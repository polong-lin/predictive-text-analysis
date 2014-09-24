library(RCurl)
library(httr)
library(XML)

#Import :emoji: style emoticons from website
url_emoji <- "http://www.emoji-cheat-sheet.com/"
content_emoji <- htmlTreeParse(url_emoji, useInternalNodes = T)
x <- xpathSApply(content_emoji, "//span[@class='name']", xmlValue)
emojilist <- unlist(lapply(x, function(x) {paste0(":",x,":")}))


#Import smileys from website
url_smileys1 <- "http://cool-smileys.com/text-emoticons"
url_smileys2 <- "http://cool-smileys.com/text-emoticons-part2"

content_smileys1 <- htmlTreeParse(url_smileys1, useInternalNodes = T)
content_smileys2 <- htmlTreeParse(url_smileys2, useInternalNodes = T)

y <- xpathSApply(content_smileys1, "//input", xmlAttrs)
z <- xpathSApply(content_smileys2, "//input", xmlAttrs)
smileylist1 <- names(table(sapply(y, function(x) x["value"])))
smileylist2 <- names(table(sapply(z, function(x) x["value"])))

#Concatenate all emoticon lists into single list, emoticonlist
emoticonlist <- c(emojilist, smileylist2, smileylist2)

#Remove other items from memory
rm(x)
rm(y)
rm(z)
rm(url_emoji)
rm(emojilist)
rm(content_emoji)
rm(url_smileys1)
rm(url_smileys2)
rm(content_smileys1)
rm(content_smileys2)
rm(smileylist1)
rm(smileylist2)

print("...emoticonlist LOADED")
