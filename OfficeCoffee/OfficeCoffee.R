library("xlsx")

setwd("/Users/Garo/Desktop/GitHub/main_repository/OfficeCoffee")

data_raw<-read.xlsx("Kawa-rozliczenia.xlsx",sheetIndex=1)

# We clean few
data_clean<-data_raw[,-c(2,87,88)]
# We invert the data frame
data<-t(data_clean)
# We obtain the coffees per interval
data<-data[c(1,seq(2,nrow(data),by=3)),]
rownames(data)<-1:nrow(data)

for (i in seq(2,nrow(data),by=3)){
  date<-as.character(data[i,1])
  print(date)
  #df = rbind(df, data.frame(date=date, y, z))
}

