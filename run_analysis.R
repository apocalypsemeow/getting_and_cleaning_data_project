# This analysis on the UCI Human Activity Recognition Dataset assumes it is ran
# from the working directory in R, containing the following files and folders:
#    run_Analysis.R
#    activity_labels.txt
#    features.txt
#    test/
#    train/
# where test/ and train/ are directories containing the x_test, y_test, 
# x_train, y_train, subject_test, and subject_train data

library(dplyr)

print("Tidying up the UCI HAR Dataset. Will output result to tidy_har_data.csv")

# Loading the test data into three different data.frame variables
subject_test <- read.table("test/subject_test.txt")
y_test <- read.table("test/y_test.txt")
x_test <- read.table("test/X_test.txt")

# Loading the training data into three different data.frame variables
subject_train <- read.table("train/subject_train.txt")
y_train <- read.table("train/y_train.txt")
x_train <- read.table("train/X_train.txt")

# Combining the test and training data into one data set
merge_test <- cbind(subject_test, y_test, x_test)
merge_train <- cbind(subject_train, y_train, x_train)
merged <- rbind(merge_test, merge_train)

# Extracting the names of each variable from features.txt,
# appending subject.id and activity to beginning of features variable
# Then setting the variable names in the data set to the names given
# in features.txt
features <- read.table("features.txt",sep="\n",stringsAsFactors=FALSE)
features <- features$V1
features <- c("subject.id", "activity", features)
colnames(merged) <- features

# Extracting the names of the activity labels, then replacing the numbered 
# entries with character-valued, human-readable, lowercase activity names
activities <- read.table("activity_labels.txt",stringsAsFactors=FALSE)
activities <- activities$V2
activities <- tolower(activities)
activities <- gsub("_", ".", activities)
merged$activity <- activities[merged$activity]

# Replacing the numbered entries in the subject.id column with human-readable
# names 'subject1', 'subject2', etc.
subject.id <- rep("subject",times=30)
subject.id <- paste(subject.id, sprintf("%02d", 1:30), sep="")
merged$subject.id <- subject.id[merged$subject.id]

# Subsetting only the columns with 'mean' or 'std' in the column name,
# modifying the column names by removing special characters '(', ')', '-',
# then removing the numbering from features.txt. '-' characters are replaced
# with the '.' character
mean_std_set <- select(merged, subject.id, activity,
	grep("mean|std", features))
names <- colnames(mean_std_set)
names <- gsub("\\(\\)", "", names)
names <- gsub("-",".",names)
names <- gsub("[0-9]* ", "", names)
colnames(mean_std_set) <- names

# Averaging the repeated measurements over subject.id and activity
tidy_har_data <- mean_std_set %>% group_by(subject.id, activity) %>%
    summarize_each(funs(mean))

# Writing to csv file
write.csv(tidy_har_data, file= "tidy_har_data.csv")

# Removing intermediate variables
rm(activities, features, merged, merge_test, merge_train, names, mean_std_set,
subject.id, subject_test, subject_train, x_test, x_train, y_test, y_train)
