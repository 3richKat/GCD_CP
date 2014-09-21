###Add Libraries
library(dplyr)
library(reshape2)

###Part 1 - Read in data
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(file.url, "GCD_CP.zip")  #Save data to working directory
unzip("GCD_CP.zip", list=T)  #Unzips to "UCI HAR dataset"

list.files("UCI HAR dataset")#List the files
list.files("UCI HAR dataset/train")   
list.files("UCI HAR dataset/test")

#Read in Feature Names
feature.names <- read.table("UCI HAR dataset/features.txt", 
                            stringsAsFactors=F, 
                            col.names=c("num", "feature.names"))

#Read in train data, assign feature names to columns
X_train <- read.table("UCI HAR dataset/train/X_train.txt", 
                      col.names=feature.names$feature.names)
y_train <- read.table("UCI HAR dataset/train/y_train.txt", col.names="volunteers")
train <- cbind(X_train, y_train)

#Read in test data
X_test <- read.table("UCI HAR dataset/test/X_test.txt", 
                      col.names=feature.names$feature.names)
y_test <- read.table("UCI HAR dataset/test/y_test.txt", col.names="volunteers")
test <- cbind(X_test, y_test)

alldata <- rbind(train, test)  #Combine test and train data - Completes part 1

##Part 2, 
mean.names <- grepl("mean",names(alldata)) ##Subset variables containing "mean"
mean.names <- names(alldata)[mean.names]
std.names <- grepl("std", names(alldata))  ##Subset variables containing "std" (Standard Deviation)
std.names <- names(alldata)[std.names]

kept.cols <- c(mean.names, std.names)  #combine names of mean and std variablesg

meanAndStd <- alldata[,kept.cols]      #subset all data for mean and std columns - Completes part 2

##Part 3 and 4 - Clean up data names
desc.names <- names(meanAndStd) 
desc.names <- gsub("^t", "Time",desc.names)
desc.names <- gsub("^f", "Freq",desc.names)
desc.names <- gsub("..", "", desc.names, fixed=T)
names(meanAndStd) <- desc.names  #completes steps 3 and 4

###Part 5
volData <- cbind(meanAndStd, alldata$volunteers)  #Add Volunteer data back in, clean it up
names(volData) <- c(names(meanAndStd), "volunteers")
volData$volunteers <- as.factor(volData$volunteers)

sum.table <- summarise_each(group_by(volData, volunteers), funs(mean)) 
tidy.summary <- melt(sum.table, id.vars="volunteers")   #Stack for narrow tidy data table

write.table(tidy.summary, "GCD_CP_tidy_summary.txt")  #Write table


