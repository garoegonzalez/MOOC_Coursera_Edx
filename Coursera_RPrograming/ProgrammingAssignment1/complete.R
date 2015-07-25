complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files

  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used

  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases
  #setwd(directory)
  result = data.frame(id=id,nobs=rep(0,length(id)))
  for (i in id){
    name<-""
    if (i<10){name<-paste0("00",as.character(i),".csv")}
    else if (i<100){name<-paste0("0",as.character(i),".csv")}
    else {name<-paste0(as.character(i),".csv")}
    data<-read.csv(paste0(directory,"/",name))
    result[id==i,]$nobs <-(sum(complete.cases(data)))
    }
  result
}
