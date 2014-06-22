library(data.table)

# load test and training sets and the activities
# Use the course CDN instead of the original UCI zip file.
#fileUrl <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip", method = "curl")
unzip("Dataset.zip")

##test data
testData <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testData_activity <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testData_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)

##train data
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainData_activity <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainData_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

# Uses descriptive activity names to name the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testData_activity$V1 <- factor(testData_activity$V1,levels=activities$V1,labels=activities$V2)
trainData_activity$V1 <- factor(trainData_activity$V1,levels=activities$V1,labels=activities$V2)

# labels the data set with  activity names
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(testData)<-features$V2
colnames(trainData)<-features$V2
colnames(testData_activity)<-c("Activity")
colnames(trainData_activity)<-c("Activity")
colnames(testData_subject)<-c("Subject")
colnames(trainData_subject)<-c("Subject")

#merge test and training sets into one data set
testData<-cbind(testData,testData_activity)
testData<-cbind(testData,testData_subject)
trainData<-cbind(trainData,trainData_activity)
trainData<-cbind(trainData,trainData_subject)
bigData<-rbind(testData,trainData)

#extract only the measurements on the mean and standard deviation for each measurement
bigData_mean<-sapply(bigData,mean,na.rm=TRUE)
bigData_sd<-sapply(bigData,sd,na.rm=TRUE)

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
DT <- data.table(bigData)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="tidy.csv",sep=",",row.names = FALSE)