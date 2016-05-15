if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/data.zip")
unzip(zipfile="./data/data.zip", exdir="./data")
path <- file.path("./data", "UCI HAR Dataset")
files <- list.files(path, recursive=TRUE)
files

ytest <- read.table(file.path(path, "test", "y_test.txt"), header=FALSE)
ytrain <- read.table(file.path(path, "train", "y_train.txt"), header=FALSE)
subject_test <- read.table(file.path(path, "test", "subject_test.txt"), header=FALSE)
subject_train <- read.table(file.path(path, "train", "subject_train.txt"), header=FALSE)
xtest <- read.table(file.path(path, "test", "x_test.txt"), header=FALSE)
xtrain <- read.table(file.path(path, "train", "x_train.txt"), header=FALSE)

subject <- rbind(subject_train, subject_test)
activity <- rbind(ytrain, ytest)
features <- rbind(xtrain, xtest)

names(subject) <- c("subject")
names(activity) <- c("activity")
featuresNames <- read.table(file.path(path, "features.txt"), head=FALSE)
names(features) <- featuresNames$V2

combine <- cbind(subject, activity)
data <- cbind(features, combine)

subsetFeaturesNames <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
select <- c(as.character(subsetFeaturesNames), "subject", "activity")
data <- subset(data, select=select)
str(data)

activity_labels <- read.table(file.path(path, "activity_labels.txt"), header=FALSE)

names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))

install.packages("plyr")
library(plyr)
data2 <- aggregate(. ~subject + activity, data, mean)
data2 <- data2[order(data2$subject, data2$activity),]
write.table(data2, file="tidydata.txt", row.name=FALSE)