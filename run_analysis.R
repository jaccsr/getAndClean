# 1
# download and unzip
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "w3.zip")
unzip("w3.zip")

# merge training data
tr.x <- read.table("UCI HAR Dataset/train/X_train.txt")
tr.y <- read.table("UCI HAR Dataset/train/y_train.txt")
tr.s <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(tr.y) <- "Activity"
names(tr.s) <- "Subject"
tr <- cbind(tr.x, tr.y, tr.s)

# merge test data
te.x <- read.table("UCI HAR Dataset/test/X_test.txt")
te.y <- read.table("UCI HAR Dataset/test/y_test.txt")
te.s <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(te.y) <- "Activity"
names(te.s) <- "Subject"
te <- cbind(te.x, te.y, te.s)

# merge two datasets
t.data <- rbind(tr, te)
# 10299 563


# 2
features <- read.table("UCI HAR Dataset/features.txt")
features <- as.vector(features$V2)
# add x and sub into the tags
features <- c(features, names(t.data)[562:563])
# extract the mean and standard deviation
m.s <- grep("mean|std|Activity|Subject", features)
# extract the meanFreq, we do not want it
n.s <- grep("meanFreq", features)
# delete the meanFreq
m.s <- subset(data.frame(m.s), ! data.frame(m.s)[,1] %in% n.s)
m.s <- as.vector(m.s$m.s)
# the lables
lables <- features[m.s]
# extracted dataset
ex.data <- t.data[, m.s]
# add lables
names(ex.data) <- lables


# 3
# load activity names
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
# replace number with names
for (i in 1:10299) 
{
    ex.data$Activity[i] <- as.character(activities[ex.data$Activity[i], 2])
}

# 4
# already done in step 2

# 5
ex.data$Subject <- as.factor(ex.data$Subject)
ex.data <- data.table(ex.data)
tt.data <- aggregate(. ~Subject + Activity, ex.data, mean)
tt.data <- tt.data[order(tt.data$Subject,tt.data$Activity),]
write.table(tt.data, file = "tt.txt", row.names = FALSE)
