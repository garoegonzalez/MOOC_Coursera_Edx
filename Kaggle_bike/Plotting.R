library(ggplot2)
library(lubridate)
library(scales)

train <- read.csv("train.csv")
test <- read.csv("test.csv")

## We merge train and set data sets to plot their variables together
## We removed the count, registered and casual entries
trainformerging<-train[,1:9]
trainformerging$flag<-"train"
test$flag<-"test"
traintest<-rbind(test,trainformerging)

## We prepare the data for plotting
train$hour  <- hour(ymd_hms(train$datetime))
train$date <- as.POSIXct(strftime(ymd_hms(train$datetime), format="%Y-%m-%d %X"), format="%Y-%m-%d")
train$times <- as.POSIXct(strftime(ymd_hms(train$datetime), format="%H:%M:%S"), format="%H:%M:%S")
train$day   <- wday(ymd_hms(train$datetime), label=TRUE)
train$workingday<-factor(train$workingday,levels=c(0,1),labels=c("No working day","Working day"))
#Transformation weather information into a factor.
train$weather<-factor(train$weather,levels=c(1,2,3,4),labels=c(":D",":)",":|",":("))
# We introduce a random minute to the time stamps so data is nicely presented when x-axis presets hours.
train$jitterTimes <- train$times+minutes(round(runif(nrow(train),min=0,max=59)))

# We plot as a function of the whole dataset time (2011 and 2012).
ggplot(train, aes(x=date,y=temp)) +
  geom_smooth(ce=FALSE, fill=NA, size=2) +
  scale_x_datetime(breaks = date_breaks("4 months"))+
  ylab("T (ºC)")+
  xlab("Date")+
  ggtitle("Measured temperature during 2011 and 2012\n")+
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")
ggsave("Temperature_vsTime.pdf")

ggplot(train, aes(x=date,y=count)) +
  geom_smooth(ce=FALSE, fill=NA, size=2) +
  scale_x_datetime(breaks = date_breaks("4 months"))+
  ylab("Number of Bike Rentals")+
  xlab("Date")+
  ggtitle("Number of bikes rented during 2011 and 2012\n")+
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")
ggsave("Rentedbikes_vs_Time.pdf")

## We plot as a function of hour of the day.
ggplot(train, aes(x=jitterTimes, y=count, color=day)) +
  geom_smooth(ce=FALSE, fill=NA, size=2) +
  xlab("Hour of the Day") +
  scale_x_datetime(breaks = date_breaks("4 hours"), labels=date_format("%I:%M %p")) +
  ylab("Number of Bike Rentals") +
  ggtitle("Number of bikes rented as a function of hour for the different week days\n") +
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")
ggsave("Numberofrented_vs_hour_perday.pdf")

ggplot(train, aes(x=jitterTimes, y=count)) +
  geom_smooth(ce=FALSE, fill=NA, size=2) +
  xlab("Hour of the Day") +
  scale_x_datetime(breaks = date_breaks("4 hours"), labels=date_format("%I:%M %p")) +
  ylab("Number of Bike Rentals") +
  ggtitle("Number of bikes rented as a function of hour for working and non working days\n") +
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")+
  facet_grid(workingday ~ .)
ggsave("Numberofrented_vs_hour_WorkingDays.pdf")

ggplot(train, aes(x=jitterTimes)) +
  geom_smooth(aes(y=count,color="All"),ce=FALSE, fill=NA, size=2)+
  geom_smooth(aes(y=registered, color="Registered"),ce=FALSE, fill=NA, size=2)+
  geom_smooth(aes(y=casual,color="Casual"),ce=FALSE, fill=NA, size=2)+
  scale_color_manual(name="User", values = c("All" ="blue","Registered"="green","Casual"="red")) +
  xlab("Hour of the Day") +
  scale_x_datetime(breaks = date_breaks("4 hours"), labels=date_format("%I:%M %p")) +
  ylab("Number of Bike Rentals") +
  ggtitle("Number of bikes rented as a function of hour for working and non working days\n") +
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")+
  facet_grid(workingday ~ .)
ggsave("Numberofrented_vs_hour_WorkingDays_casualRegistered.pdf")

ggplot(train, aes(x=jitterTimes, y=count, color=temp)) +
  #geom_smooth(ce=FALSE, fill=NA, size=2) +
  geom_point(position=position_jitter(w=0.0, h=0.4)) +
  xlab("Hour of the Day") +
  scale_x_datetime(breaks = date_breaks("4 hours"), labels=date_format("%I:%M %p")) +
  ylab("Number of Bike Rentals") +
  scale_color_discrete("") +
  ggtitle("Number of bikes rented as a function of hour of the day for working and no working days\n Temperature is presented as color gradient") +
  theme(plot.title=element_text(size=18))+
  scale_colour_gradientn("Temp (°C)", colours=c("#5e4fa2", "#3288bd", "#66c2a5", "#abdda4", "#e6f598", "#fee08b", "#fdae61", "#f46d43", "#d53e4f", "#9e0142"))+
  theme_bw(base_family="Times")+
  facet_grid(workingday ~ .)
ggsave("Numberofrented_vs_hour_perWorkingday_colorTemp.pdf")

ggplot(train, aes(x=jitterTimes, y=count, color=weather)) +
  geom_point(position=position_jitter(w=0.0, h=0.4)) +
  xlab("Hour of the Day") +
  scale_x_datetime(breaks = date_breaks("4 hours"), labels=date_format("%I:%M %p")) +
  ylab("Number of Bike Rentals") +
  scale_colour_manual(values = c("#5C8A00","#8AB800","#CC7A00","red"))+
  ggtitle("Number of bikes rented as a function of hour of the day for working and no working days\n Weather is presented as color gradient") +
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")+
  facet_grid(workingday ~ .)
ggsave("Numberofrented_vs_hour_perWorkingday_colorWeather.pdf")

## We compare density functions for continuous variables between train and test datasets
ggplot(traintest, aes(x=humidity, fill=flag)) +
  geom_density(alpha=0.3)+
  xlab("Relative humidity (%)")+
  theme_bw(base_family="Times")+
  theme(axis.title=element_text(size=18),legend.title=element_blank())
ggsave("RelativeHumidity.pdf")

ggplot(traintest, aes(x=temp, fill=flag)) +
  geom_density(alpha=0.3)+
  xlab("Temperature (ºC)")+
  theme_bw(base_family="Times")+
  theme(axis.title=element_text(size=18),legend.title=element_blank())
ggsave("Temperature.pdf")

ggplot(traintest, aes(x=atemp, fill=flag)) +
  geom_density(alpha=0.3)+
  xlab("'Feels like' temperature (ºC)")+
  theme_bw(base_family="Times")+
  theme(axis.title=element_text(size=18),legend.title=element_blank())
ggsave("FeelTemperature.pdf")

ggplot(traintest, aes(x=windspeed, fill=flag)) +
  geom_density(alpha=0.3)+
  xlab("Windspeed (km/h)")+
  theme_bw(base_family="Times")+
  theme(axis.title=element_text(size=18),legend.title=element_blank())
ggsave("Windspeed.pdf")
