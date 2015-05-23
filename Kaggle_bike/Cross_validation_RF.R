library(randomForest)
library(ggplot2)
library(lubridate)
library(scales)
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
# Random forest
# We run our random Forest we the optimized mtry parameter ntree=500 and mtry = 9
rf_optimal<- randomForest(extractFeatures(training), training$count, ntree=500, mtry=9)
## We obtain the R^2
rf_r2<-prediction_error(rf_optimal,testing)

## We plot our results
## Correlation between predicted and expected
valid_features <- extractFeatures(testing)
valid_features$predictions <- predict(rf_optimal, newdata=extractFeatures(testing))
valid_features$count <- testing$count

ggplot(valid_features, aes(x=count, y=predictions)) +
  geom_point() +
  theme_light(base_size=16) +
  xlab("Actual Hourly Bike Rentals") +
  ylab("Predicted Hourly Bike Rentals")+
  ggtitle("R^2=0.943")
ggsave("CrossValidation_usingRF.pdf")

## rented bikes over time using our real and predicted data asked in the competition
test <- read.csv("test.csv")
results_pre <- data.frame(datetime=test$datetime, count=NA)
results_pre[,"count"]<-predict(rf_optimal, extractFeatures(test))
results_pre$flag<-"Predicted"
results_real<- data.frame(datetime=data$datetime)
results_real$count<-data$count
results_real$flag<-"Real"
results<-rbind(results_real,results_pre)
results$date <- as.POSIXct(strftime(ymd_hms(results$datetime), format="%Y-%m-%d %X"), format="%Y-%m-%d")

ggplot(results, aes(x=date,y=count,col=flag)) +
  #geom_point()+
  geom_smooth(ce=FALSE, fill=NA, size=2) +
  scale_x_datetime(breaks = date_breaks("4 months"))+
  ylab("Number of Bike Rentals")+
  xlab("Date")+
  ggtitle("Measured and predicted number of bikes rented 2011 and 2012\n Random Forest")+
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")
ggsave("Measured_predicted_RF.pdf")

ggplot(results, aes(x=date,y=count,col=flag)) +
  geom_point()+
  #geom_smooth(ce=FALSE, fill=NA, size=2) +
  scale_x_datetime(breaks = date_breaks("4 months"))+
  ylab("Number of Bike Rentals")+
  xlab("Date")+
  ggtitle("Measured and predicted number of bikes rented 2011 and 2012\n Random Forest")+
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")
ggsave("Measured_predicted_RF_scatter.pdf")
