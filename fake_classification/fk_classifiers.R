library(data.table)
library(dplyr)
library(caret)
library(randomForest)
library(e1071)

data <- fread(file="data/data_500000s_128f.csv", encoding='UTF-8', data.table=FALSE)

data[,ncol(data)] <- as.character(data[,ncol(data)])
data[,ncol(data)] <- as.factor(data[,ncol(data)])
inTrain <- createDataPartition(y=data[,ncol(data)], p = 0.7, list=FALSE)
data_train <- data[inTrain,]  
data_test <- data[-inTrain,]

#Train RF
time_taken <- c()
for (i in 1:10) {
  start_time <- Sys.time()
  model_RF <-randomForest(data_train[,1:(ncol(data_train)-1)], data_train[,ncol(data_train)], ntree = 10)
  end_time <- Sys.time()
  timet <- end_time - start_time
  time_taken <- c(time_taken, timet)
}
mean(time_taken)

#Train NB
time_taken <- c()
for (i in 1:10) {
  start_time <- Sys.time()
  model_NB <- naiveBayes(data_train[,1:(ncol(data_train)-1)], data_train[,ncol(data_train)])
  end_time <- Sys.time()
  timet <- end_time - start_time
  time_taken <- c(time_taken, timet)
}
mean(time_taken)

#Predictions (always with 100k datasets)
data <- fread(file="data/data_100000s_128f.csv", encoding='UTF-8', data.table=FALSE, check.names=TRUE)

data[,ncol(data)] <- as.character(data[,ncol(data)])
data[,ncol(data)] <- as.factor(data[,ncol(data)])
inTrain <- createDataPartition(y=data[,ncol(data)], p = 0.7, list=FALSE)
data_train <- data[inTrain,]  
data_test <- data[-inTrain,]


#model_RF <- randomForest(data_train[,1:(ncol(data_train)-1)], data_train[,ncol(data_train)], ntree = 10)
model_NB <- naiveBayes(data_train[,1:(ncol(data_train)-1)], data_train[,ncol(data_train)])

time_taken <- c()
for (i in 1:2) {
  start_time <- Sys.time()
  data_predict<-predict(model_NB, data_test[,1:ncol(data_test)-1])
  end_time <- Sys.time()
  timet <- end_time - start_time
  time_taken <- c(time_taken, timet)
}
mean(time_taken)

