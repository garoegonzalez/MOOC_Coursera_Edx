pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## directory is a character vector of length 1 indicating
  ## the location of the CSV files
  #setwd(directory)
  x<-NULL
  for (i in id){
    name<-""
    if (i<10){name<-paste0("00",as.character(i),".csv")}
    else if (i<100){name<-paste0("0",as.character(i),".csv")}
    else {name<-paste0(as.character(i),".csv")}
    data<-read.csv(paste0(directory,"/",name))
    x<-append(x,data[,pollutant])
  }
  mean_v<-mean(x,na.rm=TRUE)
  ## pollutant is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".

  ## id is an integer vector indicating the monitor ID numbers
  ## to be used

  ## Return the mean of the pollutant across all monitors list
  ## in the id vector (ignoring NA values)
  ## NOTE: Do not round the result!
  mean_v;
}
