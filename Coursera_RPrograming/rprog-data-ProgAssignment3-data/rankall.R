rankall <- function(outcome, num = "best") {
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
  ## For each state, find the hospital of the given rank
  FindHospital<-function (data_state,num="best"){
    numRow<-nrow(data_state)
    if (is.character(num)){
      if (num=="best")       {return(data_state$name[1])}
      else if (num=="worst") {return(data_state$name[numRow])}
    }
    else if (is.numeric(num)){
      if (num>0 & num<=numRow) {return(data_state$name[num])}
      else {return(NA)}
    }
  }
  data<-data[complete.cases(data),]
  mysplit<-split(data,data$state)
  myordered<-lapply(mysplit,function(x) {x[order(x$outcome),]})
  numStates<-length(unique(data_ini$State))
  d = NULL
  for (state in unique(data_ini$State)){
    hospital<-FindHospital(myordered[[state]],num)
    d = rbind(d, data.frame(hospital=hospital,state=state,row.names=state))
  }
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  return(d[order(row.names(d)),])
}
