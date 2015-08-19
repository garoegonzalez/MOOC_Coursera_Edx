
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

##To be continued
grepl("*mean*",names(data))
