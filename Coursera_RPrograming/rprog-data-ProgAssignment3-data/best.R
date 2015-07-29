best <- function(state, outcome) {
  ## Read outcome data
  data_outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  ## Check that state and outcome are valid
  if (outcome=="heart attack")
    variable<-"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
  else if(outcome=="heart failure"){
    variable<-"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
  }
  else if(outcome=="pneumonia"){
    variable<-"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Pneumonia"
  }
  else {
    stop("invalid outcome")
  }
  if (!state %in% unique(data_outcome$State)){
    stop("invalid state")
  }

  ## Return hospital name in that state with lowest 30-day death
  min_rate<-min(data_outcome[data_outcome$State==state ,variable],na.rm=T)
  data_outcome<-data_outcome[data_outcome$State==state & complete.cases(data_outcome),c("Hospital.Name",variable)]
  #return (data_outcome)
  return(data_outcome[data_outcome[,variable]==min_rate,"Hospital.Name"])
  #outcome[outcome$State=="WI" & outcome["Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"]==var,"Hospital.Name"]
  #print("hola")
  ## rate
}
