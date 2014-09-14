library(dplyr)
library(tidyr)
source("load_data.R")

runAnalysis <- function() {
    baseDataset <- loadAndTidyDataset()
    
    # From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each 
    # activity and each subject.
    meanData <- baseDataset %>%
        group_by(Subject, Activity, AccelerationType, Domain, Device, Jerk, Type, Axis) %>%
        summarise(mean(Measurement))
    
    write.table(meanData, file="tidy_mean_dataset.txt", row.names=FALSE)
    meanData
}

loadAndTidyDataset <- function() {
    data <- loadAndMergeData("UCI HAR Dataset") 
    activityNames <- tbl_df(read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityID", "Activity")))
    
    # Use tidyr to hack and slash the data set.
    data <- data %>%
        # Extract only the measurements on the mean and standard deviation for each measurement. 
        select(matches("(.*\\.(std|mean)+\\..*)|ActivityID|Subject")) %>%
        # Tidying time. Gather all the columns together.
        gather(variableConglomerate, Measurement, -Subject, -ActivityID) %>%
        # Massage the variableName column 
        mutate(variableConglomerate = fixMagValue(variableConglomerate)) %>%
        # Extract out all the information that's crammed into that single column.
        extract(variableConglomerate, into=c("Domain", "AccelerationType", "Device", "Jerk", "Type", "Axis"), regex="(\\w)(\\w+)(Acc|Gyro)(Jerk)*\\.(\\w+)\\.{2,3}(\\w+|\\s?)") %>%
        # Fix the Domain and Jerk column values to be consistent.
        mutate(Domain = ifelse(Domain == "t", "Time", "Frequency")) %>%
        mutate(Jerk = ifelse(Jerk == "Jerk", "Y", "N")) #%>%
    
    # Join the data set up with the activity names.
    inner_join(data, activityNames, copy=TRUE)  %>%
        select(Subject, Activity, AccelerationType, Domain, Device, Jerk, Type, Axis, Measurement) %>%
        # Reorder by subject, just for appearances' sake.
        arrange(Subject)
}

# Method to massage the Mag value to the end of the column, so it gets caught when we extract the Axis.
fixMagValue <- function(column) {
    tmpCol <- as.character(column)
    ifelse(grepl("Mag", tmpCol), sub("$", "Mag", sub("Mag", "", tmpCol)), tmpCol)
}

