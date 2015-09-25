# rm(list = ls()) # clear workspace
setwd("C:/Users/Vladislav/Desktop/R_code/MovieTitleIntuition")

library(plyr)
library(tm)
library(SnowballC)
library(caret)

# initinal data formatting
# movie dataset
data <- read.csv("movies.dat", header = FALSE, sep = "|", na.strings = "")


data[, 1] <- as.character(data[, 1])
split <- strsplit(data[, 1], split = "::", fixed = TRUE)
# # if there were NAs
# n <- max(sapply(split, length))
# l <- lapply(split, function(x) c(x, rep(n - length(x))))
data.s <- data.frame(t(do.call(cbind, split)))

data.s$X2 <- as.character(data.s$X2)
split <- strsplit(data.s$X2, split = " (", fixed = TRUE)
n <- max(sapply(split, length))
l <- lapply(split, function(x) c(x, rep(NA, n - length(x))))
data.s2 <- data.frame(t(do.call(cbind, l)))

data.mov <- data.frame(movieID = data.s$X1, movieName = data.s2$X1, 
                       genre = data.s$X3)
data.s <- NULL
data <- NULL
l <- NULL
data.s2 <- NULL
split <- NULL

# rating file
data <- read.csv("ratings.dat", header = FALSE, na.strings = "")

data[, 1] <- as.character(data[, 1])
split <- strsplit(data[, 1], split = "::", fixed = TRUE)
n <- max(sapply(split, length))
l <- lapply(split, function(x) c(x, rep(NA, n - length(x))))
data.s <- data.frame(t(do.call(cbind, l)))

data.rat <- data.frame(movieID = as.numeric(data.s$X2), 
                       rating = as.numeric(data.s$X3))

data.rat <- aggregate(rating ~ movieID, data.rat, function(x) mean(x,na.rm=TRUE))

joined <- join(data.mov, data.rat, by='movieID')

joined$movieName <- as.character(joined$movieName)

data.s <- NULL
data <- NULL
l <- NULL
data.s2 <- NULL
split <- NULL
data.mov <- NULL
data.rat <- NULL

# text formatting
## text corpus which is necessary for 'tm' package
CorpusDescription <-  Corpus(VectorSource(c(joined$movieName)))

## tolower and plain text
CorpusDescription <-  tm_map(CorpusDescription, content_transformer(tolower))
CorpusDescription <-  tm_map(CorpusDescription, PlainTextDocument)

## removing punctuation
CorpusDescription <-  tm_map(CorpusDescription, removePunctuation)

## removing english stopwords
CorpusDescription <-  tm_map(CorpusDescription, removeWords, stopwords("english"))

## stemming
CorpusDescription <-  tm_map(CorpusDescription, stemDocument)

## frequency or tf-idf matrix
dtm <-  DocumentTermMatrix(CorpusDescription) 
#                          , control = list(weighting = weightTfIdf))
CorpusDescription <- NULL

## deleting sparse terms - for big base
dtm <-  removeSparseTerms(dtm, 0.999)

## transforming frequency matrix into a data frame
dw = as.data.frame(as.matrix(dtm))
dtm <- NULL
colnames(dw) = make.names(colnames(dw))

for (i in 1:dim(dw)[2]) {
  dw[, i] <- as.factor(dw[, i])
}

row.names(dw) <- NULL

joined.trf <- cbind(dw, joined[, c(-1, -2)])

dw <- NULL

glm.m <- supressWarnings(train(joined.trf$rating ~ ., method = "glm", 
               data = joined.trf))
#----------------------------------------------------------
input <- "Third Zombie Train in Africa"
inputgenre <- "Horror"

# text formatting
## text corpus which is necessary for 'tm' package
CorpusDescription <-  Corpus(VectorSource(c(input)))

## tolower and plain text
CorpusDescription <-  tm_map(CorpusDescription, content_transformer(tolower))
CorpusDescription <-  tm_map(CorpusDescription, PlainTextDocument)

## removing punctuation
CorpusDescription <-  tm_map(CorpusDescription, removePunctuation)

## removing english stopwords
CorpusDescription <-  tm_map(CorpusDescription, removeWords, stopwords("english"))

## stemming
CorpusDescription <-  tm_map(CorpusDescription, stemDocument)

## frequency or tf-idf matrix
dtm <-  DocumentTermMatrix(CorpusDescription) 
#                          , control = list(weighting = weightTfIdf))

## transforming frequency matrix into a data frame
dwinput = as.data.frame(as.matrix(dtm))
colnames(dwinput) = make.names(colnames(dwinput))

for (i in 1:dim(dwinput)[2]) {
  dwinput[, i] <- as.factor(dwinput[, i])
}

input.verif <- names(joined.trf) %in% c(names(dwinput), "rating", "genre")
rest <- joined.trf[!input.verif][1, ]

for (i in names(rest[which(rest == 1)])) {
  rest[[i]] <- 0
  rest[[i]] <- as.factor(rest[[i]])
}


genre <- inputgenre

joined.input <- cbind(dwinput, genre)
joined.input <- cbind(rest, joined.input)


prediction <- supressWarnings(predict(glm.m, joined.input))

prediction
