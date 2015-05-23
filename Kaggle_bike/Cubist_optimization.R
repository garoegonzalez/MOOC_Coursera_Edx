library(lubridate)
library(Cubist)
library(caret)

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

## We load the data
train <- read.csv("train.csv")

fit_cubist <- cubist(extractFeatures(train), train$count)
summary(fit_cubist)

## We map the performance as a function of the commitees and neighbors
## This could take some time...
cTune <- train(x = extractFeatures(train), y= train$count, method="cubist", tuneGrid = expand.grid(.committees = c(1, 10, 50, 100),.neighbors = c(0, 1, 5, 9)),trControl = trainControl(method = "cv"))

# We plot the result of the optimization
pdf()
plot(cTune)
dev.off()
##
## Lower error at committes = 100 and instances = 5
