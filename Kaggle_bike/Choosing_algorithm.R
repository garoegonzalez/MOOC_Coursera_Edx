library(lubridate)
library(earth)
library(kernlab)
library(e1071)
library(caret)
library(gbm)
library(Cubist)
library(randomForest)

set.seed(1)

# splitdf function will return a list of training and testing sets.
# It takes a data.frame and splitting in 2/3 for training and 1/3 for
# testing.
splitdf <- function(dataframe) {
  index <- 1:nrow(dataframe)
  trainindex <- sample(index, trunc(length(index)*(2/3)))
  trainset <- dataframe[trainindex, ]
  testset <- dataframe[-trainindex, ]
  list(trainset=trainset,testset=testset)
}

# extractFeatures gives a data.frame with only the features used in the model
extractFeatures <- function(data) {
  features <- c("season",
                "holiday",
                "workingday",
                "temp",
                "atemp",
                "humidity",
                "windspeed",
                "hour",
                "day",
                "month",
                "year"
  )
  data$hour <- hour(ymd_hms(data$datetime))
  data$day <- wday(ymd_hms(data$datetime))
  data$month<- month(ymd_hms(data$datetime))
  data$year<- year(ymd_hms(data$datetime))
  return(data[,features])
}

# prediction_error returns the coefficient of determination R^2
# between the prediction and the actual data.
prediction_error <- function(fit,data_test){
  predicted <- predict(fit, newdata=extractFeatures(data_test))
  actual <- data_test$count
  rsq <- 1-sum((actual-predicted)^2)/sum((actual-mean(actual))^2)
  return (rsq)
}

##############################################
data <- read.csv("train.csv")

#apply the function which will randomly split the data
splits <- splitdf(data)

# save the training (2/3 of train.csv) and testing (1/3 of train.csv) sets as data frames
training <- splits$trainset
testing <- splits$testset

#############################################
## Multivariate Adaptive Regression Splines (MARS)
fit_earth <- earth(training$count ~ .,data = extractFeatures(training))
summary(fit_earth)
earth_r2<-prediction_error(fit_earth,testing) ## out of the box 0.60


#############################################
# Support Vector Machine (SVM)
# From "kernlab" package
fit_ksvm <- ksvm(training$count ~ .,data = extractFeatures(training) )
summary(fit_ksvm)
ksvm_r2<-prediction_error(fit_ksvm,testing) ## out of the box 0.584

# From "e1071" package
fit_svm<-svm(training$count ~ ., data = extractFeatures(training) )
summary(fit_svm)
svm_r2<-prediction_error(fit_svm,testing) # 0.596

#############################################
## k-Nearest Neighbor
fit_knn <- knnreg( extractFeatures(training), training$count)
summary(fit_knn)
knn_r2<-prediction_error(fit_knn,testing) # 0.524

####################################
# Gradient Boosted Machine
datafor_gbm<-extractFeatures(training)
datafor_gbm$count<-training$count
testfor_gbm<-extractFeatures(testing)
testfor_gbm$count<-testing$count
fit_gbm <- gbm(count ~ .,data=datafor_gbm, distribution="gaussian")
best.iter <- gbm.perf(fit_gbm,method="OOB")
summary(fit_gbm,n.trees=best.iter)
print(pretty.gbm.tree(fit_gbm,1))
predicted_gbm<-predict(fit_gbm,testfor_gbm,best.iter)
gbm_r2 <- 1-sum((testfor_gbm$count-predicted_gbm)^2)/sum((testfor_gbm$count-mean(testfor_gbm$count))^2)
####################################
# Cubist decision trees.
fit_cubist <- cubist(extractFeatures(training), training$count)
summary(fit_cubist)
cubist_r2<-prediction_error(fit_cubist,testing) # 0.92
####################################
# Random forest
fit_rf <- randomForest(training$count ~ .,data = extractFeatures(training))
summary(fit_rf)
rf_r2<-prediction_error(fit_rf,testing) # 0.86

cat ("earth algorithm r^2=",earth_r2,"\n")
cat ("ksvm algorithm r^2=",ksvm_r2,"\n")
cat ("svm algorithm r^2=",svm_r2,"\n")
cat ("knn algorithm r^2=",knn_r2,"\n")
cat ("gbm algorithm r^2=",gbm_r2,"\n")
cat ("Cubist algorithm r^2=",cubist_r2,"\n")
cat ("randomForest algorithm r^2=",rf_r2,"\n")
