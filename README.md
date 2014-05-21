#Coursera Course Project "Getting and Cleaning Data"
##README.md
***
###Source Citation
#####All referenced data is from the following publication:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
**Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine.**
_International Workshop of Ambient Assisted Living (IWAAL 2012)_. Vitoria-Gasteiz, Spain. Dec 2012
#####Source URL:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

###Document scope
This document is not self contained and relies upon documents from the original source publication for the original study motivation, measurement techniques, and naming conventions. Readers seeking detail on the original publication should see the source citation.

###Project Requirements
Create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive activity names. 
- Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###Files in this repo
**README.md**: this file

**run_analysis.R**: the commented, R programming language source code to download, extract, and process the data

**CodeBook.md**: Documentation of the variables, data, and data cleaning or transformation steps undertaken to fulfill the Project Requirements

**tidydata.txt**: A space delimited text file. It contains only features with names containing the expressions "mean" or "std". The numeric values represent means of these features, aggregated by subject and activity type. See **CodeBook.md**.

###Reproducing results
####Test Platform
The author tested the run_analysis.R script on Mac OSX 10.9, R version 3.1.0 "Spring Dance", and RStudio 0.98.507.

The author presumes the script will run on recent versions of R on other supported platforms.

####Steps to reproduce results
* Execute `run_analysis()` with no parameters and capture the output to an object of your choice. This will download and extract the data files to the R working directory if they are not already present, assuming the computer has internet access. Next, the data tidying and processing will begin. You should capture the output to an R object of your choice.

Example: `run_analysis() -> myTidyData`.

* Do not use any optional parameters with run_analysis() if your goal is to reproduce the format of tinydata.txt exactly. See the _run_analysis.R_ sourcecode for information on the optional parameters. Typical users will not need them.
* To create the space separated text output file in your working directory, use `write.table(myTidyData, "tidydata.txt", col.names = TRUE)`.

####Notes
To download and extract the data files but without running the analysis, run `RetrieveRawData()`. Executing `run_analysis()` later will not result in downloading the data set twice.

###R script run_analysis() conceptual summary
As described in the source publication, the original data were partitioned randomly: 70% to a machine learning training set and 30% to a test test. The distinction between training and test data sets is not relevant to this project's objectives; The `run_analysis()` script recombines the training and test sets as noted below.  

The script does not use any of the files in the _Inertial Signals_.  

All given file paths are relative to the **UCI HAR Dataset** directory.

Upon executing `run_analysis()`:

1. The `RetrieveRawData()` function downloads and extracts the Human Activity Recognition (HAR) dataset if it is not already present in the working directory.
- Combines the training and test data sets **./train/X_train.txt** and **./test/X_test.txt** together in that order, matching column for column. This dataset does not have column labels.
- Lookup the numerically indexed feature names (column names) in **./features.txt** and label the dataset columns.
- Removes from the dataset any feature if the feature name does not contain the expression "mean" or "std" (standard deviation) as specified in the requirements.
- Builds two new columns, adds them from the left as columns 1 & 2 of the dataset:  
   a. The subject identifier ("subjectid") by combining **./train/subject_train.txt** and **./test/subject_test.txt**  
   b. The activity description ("activity") by combining **./train/y_train.txt** and **./test/y_test.txt**, creating a list of numeric activity codes. Perform a numeric lookup in **./activity_labels.txt** to retrieve the text activity descriptions to populate this column.
- Clean the activity name and feature names. See **CodeBook.md**.
- Create an output dataset taking the mean of each feature, grouped by each subject and each activity. That is, the script is taking the means of means and the means of standard deviations.
The numeric values in the output dataset have 8 significant digits where possible to match the numeric values in **./train/X_train.txt**.  
- Sends the output dataset to the R console standard out.

###R Sourcecode
* The complete R sourcecode to download and extract the data and complete all processing steps from the Project Requirements is included in this repo in run_analysis.R.  
* Readers familiar with R may wish to review the sourcecode.
* Code follows Google's R style guide except as required by the assignment parameters. For example, dataset (data.frame) feature names are lower case with no punctuation as suggested in class lectures, however other code variables are camel case.  
<https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml>
