corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files

  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0

  ## Return a numeric vector of correlations
  ## NOTE: Do not round the result!
  com_data<-complete(directory)
  com_id<-com_data[com_data$nobs>threshold,]$id
  if (sum(com_data$nobs>threshold)==0) return (vector(mode="numeric", length=0))
  x<-NULL
  for (i in com_id){
    name<-""
    if (i<10){name<-paste0("00",as.character(i),".csv")}
    else if (i<100){name<-paste0("0",as.character(i),".csv")}
    else {name<-paste0(as.character(i),".csv")}
    data<-read.csv(paste0(directory,"/",name))
    data<-data[complete.cases(data),]
    x<-append(x, cor(x=data$nitrate, y=data$sulfate) )
  }
  return (x)
}
