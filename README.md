predictive-text-analysis
========================

Program to predict the next word in a sentence using R's tm, tau, and RWeka (optional)

_Incomplete - please check back later._



**Importing text into the program:**

1. Import text file.

2. Convert text file to corpus.

3. Given n, use tau/RWeka packages on corpus to produce df of frequencies of ngrams.

4. Create a list of dfs with ngrams with n from 1 to 5.

5. Convert frequencies to a more effective predictor.


**Running the program:**

1. Program attempts to predict the next word of an incomplete sentence.

2. User inputs a phrase or a list of strings of words.

3. Program runs through the ngram models to find highest match based on calculated probabilities.

4. Returns word, or a dataframe containing words sorted by their probabilities.


**Other features:**

1. Ignores profanity; profanity list customizable.

2. Ignores Arabic numbers.

3. Ignores emoticons; emoticon list customizable.



