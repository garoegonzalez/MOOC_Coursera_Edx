best <- function(state, outcome) {
  ## Read outcome data
  data_ini <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  data_ini$State <- as.factor(data_ini$State)
  data<-data_ini[,c("State","Hospital.Name")]
  ## Check that state and outcome are valid
  if (outcome=="heart attack"){
    #variable<-"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
    suppressWarnings(data$outcome<-as.numeric(data_ini[,11]))
    colnames(data) <- c("state", "name","outcome")
  }
  else if(outcome=="heart failure"){
    #variable<-"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
    suppressWarnings(data$outcome<-as.numeric(data_ini[,17]))
    colnames(data) <- c("state", "name","outcome")
  }
  else if(outcome=="pneumonia"){
    #variable<-"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Pneumonia"
    suppressWarnings(data$outcome<-as.numeric(data_ini[,23]))
    colnames(data) <- c("state", "name","outcome")
  }
  else {
    stop("invalid outcome")
  }
  if (!state %in% unique(data_ini$State)){
    stop("invalid state")
  }

  ## Return hospital name in that state with lowest 30-day death
  mysplit<-split(data,data$state)
  myordered<-lapply(mysplit,function(x) {x[order(x$outcome),]})
  return(myordered[[state]][1,"name"])
}
