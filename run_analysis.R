## Getting and cleaning data
## Tim Arapov
## 2017
## This downloads the data and unzips it in your working directory




library(reshape2)
File_url_from_coursera <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
File_name <- "xy_data.zip"
download.file(File_url_from_coursera, File_name)
unzip(File_name)

#This reads in each of the needed documents.
xt <- read.table("UCI HAR Dataset/test/X_test.txt")
yt <- read.table("UCI HAR Dataset/test/y_test.txt")
st <- read.table("UCI HAR Dataset/test/subject_test.txt")
xtr <- read.table("UCI HAR Dataset/train/X_train.txt")
ytr <- read.table("UCI HAR Dataset/train/y_train.txt")
str <- read.table("UCI HAR Dataset/train/subject_train.txt")
act_l <- read.table("UCI HAR Dataset/activity_labels.txt")
feat <- read.table("UCI HAR Dataset/features.txt")

# This secton of code modifies the lables and features making the text "characters"
act_l[,2] <- as.character(act_l[,2])
feat[,2] <- as.character(feat[,2])

#This section selects the mean and standard devation using a regulater expression.
means_std <- grep(".*mean.*|.*std.*", feat[,2])
names_mean_std <- feat[means_std,2]

# Clean up the names of variables gathered

names_mean_std = gsub("-std", "Std",names_mean_std)
names_mean_std = gsub("-mean", "Average", names_mean_std)
names_mean_std <- gsub("[-()]", "", names_mean_std)

# Puts together the test set, the train set, puts together train and test set
test_set <- cbind(st, yt, xt)
train_set <- cbind(str,ytr,xtr)
tnt <- rbind(train_set, test_set)
# Rename the the first two columns and then the rest through the features we extracted and renamed
colnames(tnt) <- c("subject", "activity", names_mean_std)
tnt$subject <- as.factor(tnt$subject)
tnt$activity <- factor(tnt$activity, levels = act_l$V1, labels = act_l$V2)

tnt_final <- melt(tnt, id = c("subject", "activity"))
tnt_mean <- dcast(tnt_final, subject + activity ~ variable, mean)
write.table(tnt_mean, "final_data.txt", row.names = FALSE, quote = FALSE)
                       




