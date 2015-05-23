library(lubridate)
library(Cubist)

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

# prediction_error returns the coefficient of determination R^2
# between the prediction and the actual data.
prediction_error <- function(fit,data_test){
  predicted <- predict(fit, newdata=extractFeatures(data_test))
  actual <- data_test$count
  rsq <- 1-sum((actual-predicted)^2)/sum((actual-mean(actual))^2)
  return (rsq)
}

train <- read.csv("train.csv")

######### Cross validation ################
#apply the function which will randomly split the data
splits <- splitdf(train)

# save the training (2/3 of train.csv) and testing (1/3 of train.csv) sets as data frames
training <- splits$trainset
testing <- splits$testset

#out-of-box
fit_cubist <- cubist(extractFeatures(training), training$count)
error_out_of_box<-prediction_error(fit_cubist,testing) #0.924

# Boosting the algorithm using committees=100
fit_cubist_com <- cubist(extractFeatures(training), training$count,committees=100)
error_com<-prediction_error(fit_cubist_com,testing) # 0.942

# Applying nearest neighbords method to the predictions
predicted <- predict(fit_cubist_com, newdata=extractFeatures(testing),neighbors = 5)
actual <- testing$count
error_com_nn <- 1-sum((actual-predicted)^2)/sum((actual-mean(actual))^2) # 0.951

############################

## We plot our results
## Correlation between predicted and expected
valid_features <- extractFeatures(testing)
valid_features$predictions <- predict(fit_cubist_com, newdata=extractFeatures(testing),neighbors = 5)
valid_features$count <- testing$count

ggplot(valid_features, aes(x=count, y=predictions)) +
  geom_point() +
  theme_light(base_size=16) +
  xlab("Actual Hourly Bike Rentals") +
  ylab("Predicted Hourly Bike Rentals")+
  ggtitle("R^2=0.951")
ggsave("CrossValidation_using_cubist.pdf")

## rented bikes over time using our real and predicted data asked in the competition
test <- read.csv("test.csv")
results_pre <- data.frame(datetime=test$datetime, count=NA)
results_pre[,"count"]<-predict(fit_cubist_com, extractFeatures(test),neighbors = 5)
results_pre$flag<-"Predicted"
results_real<- data.frame(datetime=train$datetime)
results_real$count<-train$count
results_real$flag<-"Real"
results<-rbind(results_real,results_pre)
results$date <- as.POSIXct(strftime(ymd_hms(results$datetime), format="%Y-%m-%d %X"), format="%Y-%m-%d")

ggplot(results, aes(x=date,y=count,col=flag)) +
  #geom_point()+
  geom_smooth(ce=FALSE, fill=NA, size=2) +
  scale_x_datetime(breaks = date_breaks("4 months"))+
  ylab("Number of Bike Rentals")+
  xlab("Date")+
  ggtitle("Measured and predicted number of bikes rented 2011 and 2012\n Cubist")+
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")
ggsave("Measured_predicted_cubist.pdf")

ggplot(results, aes(x=date,y=count,col=flag)) +
  geom_point()+
  #geom_smooth(ce=FALSE, fill=NA, size=2) +
  scale_x_datetime(breaks = date_breaks("4 months"))+
  ylab("Number of Bike Rentals")+
  xlab("Date")+
  ggtitle("Measured and predicted number of bikes rented 2011 and 2012\n Cubist")+
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")
ggsave("Measured_predicted_cubist_scatter.pdf")
