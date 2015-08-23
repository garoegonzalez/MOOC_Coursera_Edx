library("xlsx")

setwd("/Users/Garo/Desktop/GitHub/main_repository/OfficeCoffee")

data_raw<-read.xlsx("Kawa-rozliczenia.xlsx",sheetIndex=1)

# We clean few
data_clean<-data_raw[,-c(2,87,88)]
# We invert the data frame
data_clean<-t(data_clean)
#We obtain the price of the coffee in each interval
price<-as.numeric(data_clean[seq(3,nrow(data_clean),by=3),1])
# We obtain the coffees per interval
data_clean<-data_clean[c(1,seq(2,nrow(data_clean),by=3)),]
data_clean[1,20]<-"Total"
#rownames(data)<-1:nrow(data)

values<-data_clean[2:29,2:20]
mode(values)<-'numeric'
data<-data.frame(values)
#data_final$date<-data[2:29,1]
rownames(data)<-1:nrow(data)
#colnames(data)<-data[1,2:20]
# We add the names
Names<-c("JKM","KHU","KLI","KBA","KPY","KSZ","LDO","LST","MKL","MZA","MBR","MNA","MWA","PBL","WBO","GGP","PKR","KMO","Total")
colnames(data)<-Names
# We add the timestamps and properly parser it as Date variable
data$date<-data_clean[2:29,1]
data$date<-as.Date(data$date,format="%d.%m.%Y")
# We add the price of the coffee
data$price<-price
# We set all not registered numbers to 0
data[is.na(data)]<-0
write.csv(data,"KawaDataClean.csv",row.names=FALSE)
