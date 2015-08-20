#########  Getting and Cleaning Data #############

This file explains how the data for the course project has been manipulated to obtain a tidy data set prepared for work 

1) Data can be downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

2) Downloaded file is then unzip in working directory 

3) Then run_analysis.R is executed in the working directory


################ run_analysis.R ####################

This script does the following to the data
1) Checks if the needed files exist

2) Open the file which contains the variables names

3) Open all train related files and set the proper names to the variables
4) Same for the test related files

5) It merges train and test data frames

6) It selects a subset of variables with contain in their names "mean", "Mean" or "std"

7) It changes the activity variable to a factor and it properly set it name

8) It summarizes the data by taking the mean as function of subject and activity type


############# Variables ##############################

In the resulting data set it can be found the following variables:

 "SubjectID"    ->>> It gives the subject from which the data was recorded                           
 "ActivityType" ->>> It corresponds to the activity performed while the data was recorded 
                     1,2,3,4,5,6  ->>> "WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"                             

##### Different information recorded by the accelerometer and gyroscope from the mobile phone
 "tBodyAcc-mean()-X"                   
 "tBodyAcc-mean()-Z"                   
 "tGravityAcc-mean()-Y"                
 "tBodyAccJerk-mean()-X"               
 "tBodyAccJerk-mean()-Z"               
 "tBodyGyro-mean()-Y"                  
 "tBodyGyroJerk-mean()-X"              
 "tBodyGyroJerk-mean()-Z"              
 "tGravityAccMag-mean()"               
 "tBodyGyroMag-mean()"                 
 "fBodyAcc-mean()-X"                   
 "fBodyAcc-mean()-Z"                   
 "fBodyAcc-meanFreq()-Y"               
 "fBodyAccJerk-mean()-X"               
 "fBodyAccJerk-mean()-Z"               
 "fBodyAccJerk-meanFreq()-Y"           
 "fBodyGyro-mean()-X"                  
 "fBodyGyro-mean()-Z"                  
 "fBodyGyro-meanFreq()-Y"              
 "fBodyAccMag-mean()"                  
 "fBodyBodyAccJerkMag-mean()"          
 "fBodyBodyGyroMag-mean()"             
 "fBodyBodyGyroJerkMag-mean()"         
 "angle(tBodyAccMean,gravity)"         
 "angle(tBodyGyroMean,gravityMean)"    
 "angle(X,gravityMean)"                
 "angle(Z,gravityMean)"                
 "tBodyAcc-std()-Y"                    
 "tGravityAcc-std()-X"                 
 "tGravityAcc-std()-Z"                 
 "tBodyAccJerk-std()-Y"                
 "tBodyGyro-std()-X"                   
 "tBodyGyro-std()-Z"                   
 "tBodyGyroJerk-std()-Y"               
 "tBodyAccMag-std()"                   
 "tBodyAccJerkMag-std()"               
 "tBodyGyroJerkMag-std()"              
 "fBodyAcc-std()-Y"                    
 "fBodyAccJerk-std()-X"                
 "fBodyAccJerk-std()-Z"                
 "fBodyGyro-std()-Y"                   
 "fBodyAccMag-std()"                   
 "fBodyBodyGyroMag-std()"              
 "tBodyAcc-mean()-Y"                        
 "tGravityAcc-mean()-X"                     
 "tGravityAcc-mean()-Z"                     
 "tBodyAccJerk-mean()-Y"                    
 "tBodyGyro-mean()-X"                       
 "tBodyGyro-mean()-Z"                       
 "tBodyGyroJerk-mean()-Y"                   
 "tBodyAccMag-mean()"                       
 "tBodyAccJerkMag-mean()"                   
 "tBodyGyroJerkMag-mean()"                  
 "fBodyAcc-mean()-Y"                        
 "fBodyAcc-meanFreq()-X"                    
 "fBodyAcc-meanFreq()-Z"                    
 "fBodyAccJerk-mean()-Y"                    
 "fBodyAccJerk-meanFreq()-X"                
 "fBodyAccJerk-meanFreq()-Z"                
 "fBodyGyro-mean()-Y"                       
 "fBodyGyro-meanFreq()-X"                   
 "fBodyGyro-meanFreq()-Z"                   
 "fBodyAccMag-meanFreq()"                   
 "fBodyBodyAccJerkMag-meanFreq()"           
 "fBodyBodyGyroMag-meanFreq()"              
 "fBodyBodyGyroJerkMag-meanFreq()"          
 "angle(tBodyAccJerkMean),gravityMean)"     
 "angle(tBodyGyroJerkMean,gravityMean)"     
 "angle(Y,gravityMean)"                     
 "tBodyAcc-std()-X"                         
 "tBodyAcc-std()-Z"                         
 "tGravityAcc-std()-Y"                      
 "tBodyAccJerk-std()-X"                     
 "tBodyAccJerk-std()-Z"                     
 "tBodyGyro-std()-Y"                        
 "tBodyGyroJerk-std()-X"                    
 "tBodyGyroJerk-std()-Z"                    
 "tGravityAccMag-std()"                     
 "tBodyGyroMag-std()"                       
 "fBodyAcc-std()-X"                         
 "fBodyAcc-std()-Z"                         
 "fBodyAccJerk-std()-Y"                     
 "fBodyGyro-std()-X"                        
 "fBodyGyro-std()-Z"                        
 "fBodyBodyAccJerkMag-std()"                
 "fBodyBodyGyroJerkMag-std()"               