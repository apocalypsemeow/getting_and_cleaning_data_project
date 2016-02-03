# Getting and Cleaning Data Project
Coursera Project Repository for Getting and Cleaning Data

This analysis on the UCI Human Activity Recognition Dataset assumes it is ran
from the working directory in R, containing the following files and folders:

    run_Analysis.R
    activity_labels.txt
    features.txt
    test/
    train/

where test/ and train/ are directories containing the x_test, y_test, 
x_train, y_train, subject_test, and subject_train data.

Run this script from an R terminal using

    > source("run_analysis.R")

This script first loads the test data into three different dataframe variables,
then loads the training data into three different dataframe variables. The
the test and training data are then combined into one data set.

Extracting the names of each variable from features.txt, 'subject.id' and
'activity' are appended to the beginning of the column names vector of the data
set. The column names of the activity labels are replaced with character-valued,
human-readable, lowercase activity names, and the subject ids are replaced with
human-readable names 'subject01', 'subject02',etc.

Finally, the new data set is averaged over the repeated subject.id and activity
pairs, which gets outputted to a csv file containing the new, tidy data set. All
variables are then removed from the R workspace.
