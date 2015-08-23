library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(fitdistrplus)
library(gridExtra)
setwd("/Users/Garo/Desktop/GitHub/main_repository/OfficeCoffee")

dir.create("plots/")
data<-read.csv("KawaDataClean.csv")

data<-data[!(data$Total>120 | data$Total<80),]

## We fit the distribution to a normal.
plot(fitdist(data$Total,"norm"))

ggplot(data, aes(x=as.POSIXct(date),y=Total)) +
  #geom_smooth(ce=FALSE, fill=NA, size=2) +
  geom_point()+
  scale_x_datetime(breaks = date_breaks("2 months"))+
  ylab("Number of coffee's drunk per bag")+
  xlab("Date")+
  ggtitle("Coffee's taken at MSR/DAR Gdanks office between Jul 2014 and Jul 2015")+
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")
#ggsave("Measured_predicted_RF.pdf")

ggplot(data,aes(x=as.POSIXct(date),y=cumsum(Total))) +
     #geom_smooth(ce=FALSE, fill=NA, size=2)+
     geom_line(ce=FALSE, fill=NA, size=2)+
     #geom_point()+
     ylab("Cumulative number of coffee's drunk")+
     xlab("Date")+
     ggtitle("Coffee's taken at MSR/DAR Gdanks office between Jul 2014 and Jul 2015")+
     theme(plot.title=element_text(size=18))+
     theme_bw(base_family="Times")
ggsave("CumulativeNumberOfCoffees.pdf")

ggplot(data,aes(x=as.POSIXct(date),y=cumsum(Total*price))) +
     #geom_smooth(ce=FALSE, fill=NA, size=2)+
     geom_line(ce=FALSE, fill=NA, size=2)+
     #geom_point()+
     ylab("Cumulative spent in coffee (Zloty)")+
     xlab("Date")+
     ggtitle("Coffee's taken at MSR/DAR Gdanks office between Jul 2014 and Jul 2015")+
     theme(plot.title=element_text(size=18))+
     theme_bw(base_family="Times")
ggsave("CumulativeSpentInCoffees.pdf")

## We create a new data frame such that every person is converted in a
## observable per measurements to easy perform an easy plotting
NamesString<-names(data)
NamesNum<-c(1:18,"Total","date","price")
colnames(data)<-NamesNum

data_Name<-melt(data,id.vars=c("Total","date","price"),variable.name="Name")

ggplot(data_Name,aes(x=as.POSIXct(date),y=value,color=Name)) +
  geom_smooth(ce=FALSE, fill=NA, size=2)+
  #geom_point()+
  ylab("Number of coffee's drunk per bag")+
  xlab("Date")+
  ggtitle("Coffee's taken at MSR/DAR Gdanks office between Jul 2014 and Jul 2015")+
  theme(plot.title=element_text(size=18))+
  theme_bw(base_family="Times")
  #stat_bin(aes(y=cumsum(price)),geom="step")
  #stat_bin(data=subset(x,A=="a"),aes(y=cumsum(..count..)),geom="step")+

data_Name$cost<-data_Name$value*data_Name$price
i=0
for (person in names(data)[1:18]){
     i<-i+1
     print (person)
     data_temp<-data_Name[data_Name$Name==person,]
     p1<-ggplot(data_temp,aes(x=as.POSIXct(date),y=value)) +
          geom_smooth(ce=FALSE, fill=NA, size=2)+
          #geom_s(ce=FALSE, method="lm", size=2)+
          #geom_point()+
          ylab("Coffees")+
          xlab("Date")+
          #ggtitle(paste("Coffee's taken by subject",as.character(1)))+
          theme_bw(base_family="Times")+
          theme(plot.title=element_text(size=18),
                axis.text.x=element_blank(),
                axis.title.x=element_blank(),
                axis.ticks.x=element_blank())

     p2<-ggplot(data_temp,aes(x=as.POSIXct(date),y=cumsum(value))) +
          geom_line(ce=FALSE, fill=NA, size=2)+
          ylab("Cumulative")+
          #xlab("Date")+
          #ggtitle("Coffee's taken by subject",as.character(1)))+
          theme_bw(base_family="Times")+
          theme(plot.title=element_text(size=18),
                axis.text.x=element_blank(),
                axis.title.x=element_blank(),
                axis.ticks.x=element_blank())

     p3<-ggplot(data_temp,aes(x=as.POSIXct(date),y=cumsum(cost))) +
          geom_line(ce=FALSE, fill=NA, size=2)+
          ylab("PLN")+
          xlab("Date")+
          #ggtitle("Coffee's taken by subject",as.character(1)))+
          theme(plot.title=element_text(size=18))+
          theme_bw(base_family="Times")


     pcomb<-arrangeGrob(p1, p2,p3, ncol = 1, main = paste("Subject",as.character(person)))
     ggsave(paste0("plots/",person,".png"),plot=pcomb)

     #stat_bin(aes(y=cumsum(price)),geom="step")
     #stat_bin(data=subset(x,A=="a"),aes(y=cumsum(..count..)),geom="step")+
}

df_cum<-data.frame(t(aggregate(data_Name$value,by=list(data_Name$Name),cumsum)))
df_cum<-df_cum[2:25,]
names(df_cum)<-1:18

df_cum$date<-data$date

data_Name_cum<-melt(df_cum,id.vars=c("date"),variable.name="Name")
data_Name_cum<-data_Name_cum[1:432,]
data_Name_cum$value<-as.numeric(data_Name_cum$value)
ggplot(data_Name_cum,aes(x=as.POSIXct(date,),y=value,color=Name)) +
     geom_line(ce=FALSE, fill=NA, size=1)+
     #geom_s(ce=FALSE, method="lm", size=2)+
     #geom_point()+
     ylab("Cummulative number of coffee's drunk")+
     xlab("Date")+
     #ggtitle(paste("Coffee's taken by subject",as.character(1)))+
     theme(plot.title=element_text(size=18))+
     theme_bw(base_family="Times")
ggsave("plots/HistoricalCummulatime.png")
