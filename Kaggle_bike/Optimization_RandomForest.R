library(lubridate)
library(tree)
library(randomForest)

set.seed(1)

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

train <- read.csv("train.csv")

# We plot and export a tree for our own education
tree_model= tree(train$count ~. ,data=extractFeatures(train))
tree_model
pdf("ExampleOfTree.pdf")
plot(tree_model)
text(tree_model,pretty=0)
dev.off()

## We train our randomForest using all data
## Internal cross validation method will obtained the R^2 using out-of-bag (OBB) data
rf <- randomForest(extractFeatures(train), train$count, ntree=1000)

## Summary of the plot
rf

## We plot the error as a function of the number of trees
pdf("RandomForest_error_vs_nTrees.pdf")
plot(rf)
dev.off()
## From the Error vs Number of tress plot we observe there is no more learning improvement by the algorithm after a forest of ~500 trees.

# We run a new random Forest fit activating the flag to plot the ranking of important variables in the training process
rf_imp <- randomForest(extractFeatures(train), train$count, ntree=500, importance=TRUE)
# We plot the ranking of variables
pdf("RandomForest_Variable_of_importance.pdf")
varImpPlot(rf_imp)
dev.off()

## We optimize the parameter mtry. Could take some time...
best_mtry<-tuneRF(extractFeatures(train),train$count, ntreeTry=500, stepFactor=1.5,improve=0.01, trace=TRUE, plot=TRUE)
## We plot the optimization
pdf("RandomForest_Optimization_mtry.pdf")
plot(best_mtry)
dev.off()
# We extract the best mtry from the optmization matrix result.
best_mtry_value<-best_mtry[best_mtry[, 2] == min(best_mtry[, 2]),1]

# We run our random Forest we the optimized mtry parameter ntree=500 and mtry = 9
rf_optimal<- randomForest(extractFeatures(train), train$count, ntree=500, mtry=best_mtry_value)
### Result using the OOB internal cross validation
### Mean of squared residuals=1682.363
### % Var explained (R^2): 94.87

## If a file wants to be submitted to the kaggle competition
test <- read.csv("test.csv")
submission <- data.frame(datetime=test$datetime, count=NA)
## We predict the bike counts using our RandomForest
submission[,"count"]<-predict(rf_optimal, extractFeatures(test))
write.csv(submission, file = "RandomForest_Kaggle_competition.csv", row.names=FALSE)
