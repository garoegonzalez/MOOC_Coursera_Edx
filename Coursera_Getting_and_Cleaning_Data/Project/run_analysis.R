## We check that we have the data in our working directory
filesToOpen<-c("UCI HAR Dataset/features.txt",
               "UCI HAR Dataset/train/X_train.txt",
               "UCI HAR Dataset/train/y_train.txt",
               "UCI HAR Dataset/train/subject_train.txt",
               "UCI HAR Dataset/test/X_test.txt",
               "UCI HAR Dataset/test/y_test.txt",
               "UCI HAR Dataset/test/subject_test.txt"
               )

for (file in filesToOpen){
     if (!file.exists(file)) stop (paste("Data missing: ",file))
}
## We open the variables names file
FeaturesNames<-read.table(filesToOpen[1])

## We open the different variables measurements
dataXTrain<-read.table(filesToOpen[2])
dataYTrain<-read.table(filesToOpen[3])
dataSubTrain<-read.table(filesToOpen[4])

## We set the variables names
colnames(dataXTrain)<-FeaturesNames[,"V2"]
colnames(dataYTrain)<-"ActivityType"
colnames(dataSubTrain)<-"SubjectID"

## We merge all training information
dataTrain<-cbind(dataSubTrain,dataYTrain,dataXTrain)

## We do the same with the test sample
dataXTest<-read.table(filesToOpen[5])
dataYTest<-read.table(filesToOpen[6])
dataSubTest<-read.table(filesToOpen[7])
colnames(dataXTest)<-FeaturesNames[,"V2"]
colnames(dataYTest)<-"ActivityType"
colnames(dataSubTest)<-"SubjectID"
dataTest<-cbind(dataSubTest,dataYTest,dataXTest)

## We merge Train and Test data sets
data<-rbind(dataTrain,dataTest)

## We obtain the column numbers that contain the patterns
## mean, Mean and std and we combine them in a vector
## with "SubjectID"    "ActivityType" in positions 1 and 2
dataWithmean<-which(grepl("*mean*",names(data)))
dataWithMean<-which(grepl("*Mean*",names(data)))
dataWithstd<-which(grepl("*std*",names(data)))

ColumnsToUse<-c(1,2,dataWithmean,dataWithMean,dataWithstd)

## We get only the columns in which we are interested
data<-data[,ColumnsToUse]

## We change the Activity variable to a factor with proper label
Activitylabels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
data$ActivityType<-factor(data$ActivityType,levels=c(1,2,3,4,5,6),labels = Activitylabels)

################### Our data is clean and ready to be used
## Data frame ->   data

################# We compute the mean for every subject and activity
##### We end up with a dataframe of 180 rows (30 subjects* 6 activities)
### and 88 columns corresponding to all variables with mean and std
tidydata<-aggregate( . ~ SubjectID+ActivityType, data, mean)
