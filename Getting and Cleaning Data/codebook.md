#Codebook for "Getting and Cleaning Data" Course Project

###Table of Contents
- [Overview](#overview)
- [The Data](#data)
- [The Scripts](#scripts)
- [The Result](#result)
- [The Setup](#setup)
- [The Process](#process)

##<a name="overview"></a>Overview
This project provides a concise analysis of a source dataset of accelerometer/gyroscope measurements, via two R scripts. The scripts are modular, to an extent, and produce a resultant tidy data set. 

##<a name="data"></a>The Data
The data was sourced from [a cloudfront server](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) for the course, originally obtained from [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The data is the result of study performed on 30 individuals who had Samsung Galaxy S II smartphones on their person. The phones recorded a variety of movement- and acceleration-related data, which was then pre-processed and delivered here. The data folder should contain both a train and a test folder, and should have files named "X\_test.txt" and "y\_test.txt" (the case is important here), with "train" replacing "test" in the test folder. Both folders should also have a file called "subject\_test.txt". There must also be an "activity\_labels.txt" file at the root of the data directory. For more about how the files were parsed, see [The Process](#process). For a more comprehensive description of the data, there is a README file and a "features_description.txt" file in the root folder of the data download.

##<a name="scripts"></a>The Scripts
There are two R script files involved with this analysis: 

- _load\_data.R_: Understands the format of the source data and parses it accordingly. It also appends additional columns that have been stored in separate files in the source data. More about this is explained in [The Process](#process). This script will also cache the initial data load in the environment so it doesn't have to be performed every time.
- _run\_analysis.R_: Tidies the data so that there is an initial tidy data version of the source data, then performs a mean analysis on it. More about the tidying is explained in [The Process](#process), and more about the analysis is explained in [The Result](#result).

The methods inside the scripts are as follows:

- _loadData(directory)_: Loads the source data, appends it, and returns a non-tidy, non-clarified version of the dataset as a dplyr tbl_df.
- _makeFolderCache(directory, columnNames)_: Takes a source data directory and a list of column names for that source data, and delivers a caching vector/object which can hold the results of the table load for future reference. These objects are stored in the environment by _loadData()_.
- _loadFolderData(cache)_: Takes a caching vector/object created by _makeFolderCache()_ and checks if it has cached data. If it does, the cached data is returned. If it does not, it looks in the directory specified by the cache and loads all necessary files into memory, appending them together into a single data frame with appropriate columns names. That resulting data frame is then stored in the cache object for next time.
- _runAnalysis()_: Performs the top-level analysis of the source data and returns the data frame of that analysis.
- _loadAndTidyDataset()_: Loads the dataset from the "UCI HAR Dataset" folder and performs a series of tidying actions on it, finally returning the tidied dataset.

##<a name="result"></a>The Result
This script can provide three distinct data frames as a result of various methods. All of the methods require the same setup.

- _loadData(directory)_: This method will deliver a non-tidy, non-clarified version of the original source data. Both the trial and test folders will be combined into a single dplyr data frame (a tbl_df). The subject and activity data will be appended to the main obervation data. The code book for this is the same as the original source data, with the caveat that the appended activity column is named "ActivityID" and the appended subject column is named "Subject".
- _loadAndTidyDataset()_: This method will deliver a tidied and clarified version of the source dataset, but with only columns relating to mean and standard deviation of an observation included. The data should contain one observation per row, with each observation having the following in this order:
1. Subject (numeric) - The number of the subject in the original study data.
2. Activity (character) - The activity that the subject was performing when the data was taken.
3. AccelerationType (character) - The type of acceleration being measured: Body, Gravity, or "BodyBody". The latter is not explained in the source data codebook, but _is_ included in the data, so it is included here for completeness.
4. Domain (character) - Whether the measurement was taken in the frequency domain or in the time domain.
5. Device (character) - Whether the measurement was taken with the accelerometer or the gyroscope.
6. Jerk (character) - Whether this is a "Jerk" measurement or not. Jerk is the acceleration of acceleration - how quickly the acceleration measurement was changing.
7. Type (character) - Whether the measurement was a mean measurement or a standard deviation measurement.
8. Axis (character) - What axis the measurement was taken in (i.e. X, Y, Z). A value of "Mag" means the measurement was of the magnitude of the vector and had no direction.
9. Measurement (numeric) - The actual value that was measured by the device.
- _runAnalysis()_: This method will deliver a tidied and clarified dataset that is an analysis of the source data - the tidied dataset returned from _loadAndTidyDataset()_ is grouped by subject, activity, acceleration type, domain, device, jerk, type, and axis. Then across these groups, the mean average of measurement is taken. This provides the mean average across all measurements that have the same parameters. The data should contain one observation per row, with each observation having the following in this order:
1. Subject (numeric) - The number of the subject in the original study data.
2. Activity (character) - The activity that the subject was performing when the data was taken.
3. AccelerationType (character) - The type of acceleration being measured: Body, Gravity, or "BodyBody". The latter is not explained in the source data codebook, but _is_ included in the data, so it is included here for completeness.
4. Domain (character) - Whether the measurement was taken in the frequency domain or in the time domain.
5. Device (character) - Whether the measurement was taken with the accelerometer or the gyroscope.
6. Jerk (character) - Whether this is a "Jerk" measurement or not. Jerk is the acceleration of acceleration - how quickly the acceleration measurement was changing.
7. Type (character) - Whether the measurement was a mean measurement or a standard deviation measurement.
8. Axis (character) - What axis the measurement was taken in (i.e. X, Y, Z). A value of "Mag" means the measurement was of the magnitude of the vector and had no direction.
9. mean(Measurement) - The mean of all observations of this type in the dataset.

##<a name="setup"></a>The Setup
These scripts require the dplyr and tidyr libraries to run correctly.

Setting up the scripts to perform on the data is fairly simple. The initial data is provided in the repository in the correct location, but additional data of the same format can be substituted instead. Simply unzip the dataset so that the root folder ("UCI HAR Dataset") is next to run\_analysis.R. Source run\_analysis.R, and then call one of the above methods to retrieve a dataset.

##<a name="process"></a>The Process
The included scripts process the data in the following order. Any assumptions made about the data are listed at that point.
1. The X_test.txt data is loaded into R. It is assumed to be fixed width, with each measurement column being 16 characters wide. As noted in the source data documentation, there are 561 rows.
2. The column names for this data set are assigned from the "features.txt" document in the root of the test data set. It is assumed that the order of these names is the same as the observation data columns, since there are no other columns in the features.txt file.
3. The y_test.txt data is loaded into R. This is the activity ID data for each observation. Since there are no other columns in this file, it is assumed that the order of these activity IDs are the same as the observations in the main data.
4. The subject_data.txt is loaded into R. This is the subject ID data for each observation. Since there are no other columns in this file, it is assumed that the order of these activity IDs are the same as the observations in the main data.
5. The subject data and activity data are mapped onto each of the observations in the test data.
6. The same process is followed for the training data set (X_train.txt, y_train.txt). The same column names are used.
7. The names for each activity ID are loaded into R.
8. All columns but the mean and standard deviation observations, the activity ID, and the subject ID are dropped. The instructions were (probably intentionally) vague about what "mean and standard deviation" columns to choose, but I made the decision to only pick the most narrowly-defined choice - only those columns which are strictly the mean and standard deviation of the direct observation. Several other columns are means of other derived values, but in my opinion a mean analysis of those columns is not useful in a statistical sense, so they are excluded.
9. All observation columns are gathered under a single column, with the observation measurement being moved into its own column beside it.
10. The column names are checked if they include the string "Mag" - if they do, they are a magnitude measurement. In order to make further processing easier, the word "Mag" is removed from the middle of the column name and appended to the end.
11. The column name is expanded into a number of columns. These are extracted from the column name using a regular expression-  "(\\w)(\\w+)(Acc|Gyro)(Jerk)*\\.(\\w+)\\.{2,3}(\\w+|\\s?)". Everything inside the quotes is necessary. Each set of parentheses slices off another column from the original column name. In order, they are: Domain, AccelerationType, Device, Jerk, Type, Axis. This creates a tidy data set in wide form.
12. The Domain column is altered to change "t" to "Time" and "f" to "Frequency"; as described in the source data codebook, this is what those letters stand for.
13. The Jerk column is altered so that values of "Jerk" are changed to "Y" and blank values are changed to "N". This prevents blank values and makes the column consistent.
14. The activity name data are joined with the new tidy dataset on the "ActivityID" column to provide descriptive names of the activities.
15. The now unnecessary ActivityID column is removed.
16. The dataset is sorted by Subject, ascending. This is not necessary for a tidy dataset, but prevents the data from seeming jumbled.
17. The resulting dataset is then grouped by all columns excepting Measurement - in other words, grouped by each original column name, subject ID, and activity.
18. Within each group, the mean of Measurement is taken, such that the dataset is now a single observation of that mean in each group.
19. The data is written to a text file, with space delimiters, and no row names.
20. The data is also returned from the method.
