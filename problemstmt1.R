install.packages("RTextTools")
install.packages("tm")
install.packages("randomForest")
install.packages("SnowballC")
install.packages("caret")
install.packages('e1071', dependencies = TRUE)
install.packages("wordcloud")
installed.packages('catools')


# word cloud

reviews_stopwords <- c(stopwords("SMART"), neutral_words, store_words)
reviews_tf <- list(weighting = weightTfIdf, stopwords = reviews_stopwords,
                   removePunctuation = TRUE, removeNumbers = TRUE)

reviews_tdm   <- TermDocumentMatrix(corpus, control = reviews_tf)
reviews_freq  <- removeSparseTerms(reviews_tdm, 0.95)
reviews_rsums <- sort(rowSums(as.matrix(reviews_freq)), decreasing = TRUE)
reviews_df    <- data.frame(word = names(reviews_rsums),
                            freq = reviews_rsums)

reviews_wordcloud <- wordcloud(reviews_df$word, reviews_df$freq,
                               max.words = 60, min.freq = 2)



library(caret)
library(tm)
library(e1071) 
library(RTextTools)
library(randomForest)
library(wordcloud)
library(SnowballC)
library(rpart)


read_data<-read.csv("C:/Users/raggupta/Downloads/FinalProject/TrainingSet/yelp_training_set_review.csv")
test_data<-read_data[(read_data$votes.useful<1 & read_data$votes.cool<1 & read_data$votes.funny<1 ) ,] 
read_data <- read_data[(read_data$votes.useful>0 | read_data$votes.cool>0 | read_data$votes.funny>0 ) ,]
read_text <-read_data$text
read_votes<-read_data$votes.useful

# test Data
read_text_test<- test_data$text
read_votes_test<- test_data$votes.useful


# data cleaning
corpus = VCorpus(VectorSource(read_text))
corpus = tm_map(corpus,content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeURL)
corpus = tm_map(corpus, removeWords,stopwords())
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)

dtm.train <-DocumentTermMatrix(corpus,control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE)))
dtm.train<-removeSparseTerms(dtm.train, 0.90)

# converting to dataFrame
train_dataSet = as.data.frame(as.matrix(dtm.train))
train_dataSet$votes = read_data$votes.useful

training_set<-head(train_dataSet,5000)
test_set <-tail(train_dataSet, 600)

# encoding feature vector
#training_set$votes = factor(training_set$votes, levels = c(0,1,2,3,4,5))


# RandomForest
ctrl = trainControl(method = "cv", number = 10)
forestmodel <- train(factor(votes) ~ .,  data=training_set,method ="rf", ntree=15, trControl = ctrl,  type= c("raw"))
forestPredict <- predict(forestmodel, newdata = test_set[-104], type= c("raw"))
votes.useful = forestPredict
submit <- data.frame(votes.useful)
cm = table(test_set[,104], forestPredict )
plot(forestmodel)
#text(forestmodel)

# decision tree
dectree= rpart(formula = factor(votes) ~ ., data = training_set, control= rpart.control(minsplit = 1))
votes_pred = predict(dectree, newdata= test_set[-165])

# naiveBayes
classifier = naiveBayes(x= training_set[-104], y = factor(training_set$votes , levels = c(0,1,2,3,4,5)))
votes_pred = predict(classifier, newdata= factor(test_set[-104]))
submit <- data.frame(votes_pred)
cm = table(test_set[,104], votes_pred )
#plot(classifier)


# SVM
svmclassifier = svm(formula = factor(votes) ~ ., data = training_set, type = 'eps-regression')
votes_pred = predict(svmclassifier, newdata= test_set[-165])
submit <- data.frame(votes_pred)


# Knn
library(class)
knn = knn(train = training_set[, -104],
             test = test_set[,-104],
             cl = training_set[, 104],
             k = 15)

cm = table(test_set[,104], knn )
plot(knn)

# CNN
library(nnet)
set.seed(1)

seedstrain<-sample(1:1000,470)
ideal <- class.ind(read_text)
seedsANN = nnet(test_set[seedstrain,-10], ideal[seedstrain,], size=NA, max=FALSE)
predict(seedsANN, seeds[seedstrain,-8], type="class")
table(predict(seedsANN, seeds[seedstest,-8], type="class"),seeds[seedstest,]$Class)


# linear regression
regressor=glm(formula = factor(votes) ~ ., data = training_set,  family = binomial)
votes_pred = predict(regressor, newdata= test_set[-104])
submit <- data.frame(votes_pred)
submit1= data.frame(floor(votes_pred))
submit2 = data.frame(votes_pred)
floor(submit2)
cm = table(test_set[,104],floor(submit2 ))
