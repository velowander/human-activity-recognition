#Coursera R Data Science Specialization Getting and Cleaning Data Course project
#Code follows Google's R style guide except as required by the assignment parameters
#https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
#
#All referenced data is from the following study:
#Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
#Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine.
#International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
#
#To get started: run_analysis() -> myTidyData. Note that run_analysis() produces no objects in the global environment; capture output
#to an object of your choice. See the run_analysis() below for more information, including optional parameters.
#To download and extract the data files but without running the analysis, run RetrieveRawData()


RetrieveRawData <- function() {
  #If unzipped folder is present, doesn't download anything and finishes.
  #If the original zip file is not present in the working directory, will download to working directory
  #Called by run_analysis(), not typically necessary to execute it directly though it can run independently
  #Tested on: Mac OSX 10.9 Mavericks
  DownloadFile <- function() {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  "getdata_projectfiles_UCI HAR Dataset.zip", method="curl");
  }
  
  UnzipRawFile <- function() {
    print("Unzipping Raw Data file")
    unzip("getdata_projectfiles_UCI HAR Dataset.zip")
  }
  
  if (!file.exists("UCI HAR Dataset")) {
    if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
      print("Can't find the HAR Dataset folder or zip file, will try to download.")
      if (DownloadFile() == 0) {
        print("File downloaded")
        UnzipRawFile()
        return (0) #SUCCESS!!
      } else {
        print("Unable to find or download needed HAR Dataset file.")
        return (-1) #FAILURE
      }
    } else {
      UnzipRawFile()
    }
  }
  else print("Unzipped dataset 'UCI HAR Dataset' already exists in working directory")
}

run_analysis <- function(suppressRetrieveRawData = FALSE, outputNarrow = FALSE, tidyFeatureName = TRUE) {
  #Function name violates google R style guidelines; name specified in project requirements
  #In:
  #  optional parameters:
  #    supressRetrieveRawData: if TRUE, don't attempt to download or unzip data set
  #    outputNarrow: if TRUE, tidy data output is narrow or "melted" (as per melt()), FALSE data is "wide" format
  #    tidyFeatureName: if TRUE, remove "-" in feature names and expand descriptions
  #Notes: Does not create any data in the global environment; save the output to a variable to see it.
  #Methodology for rbind() on training and test sets: training is always appended first, test sets are second for consistency.
  
  require(reshape2)
  require(plyr)
  
  BuildActivityColumn <- function(tidyActivityNames = TRUE) {
    #In: Optional tidyActivityNames: if TRUE converts output to lower case and removes underscores
    #  if FALSE outputs activity names directly from supplied activity_labels.txt
    #Out: a vector of the activity descriptions for all the records in the main data set. R factor type.
    #This output matches up with the rows of culledData and is ready to cbind()
    #Dependencies: The dataPath variable should be set in the parent environment (or global)
    
    #create a single set of activity IDs from the training and test activity IDs bound together
    fullActivityId <- rbind(read.table(paste0(dataPath, "/train/y_train.txt")), 
                            read.table(paste0(dataPath, "/test/y_test.txt"))
    )
    out <- merge(fullActivityId, read.table(paste0(dataPath, "/activity_labels.txt")), by.x=1, by.y=1)[ , 2]
    if (tidyActivityNames) out <- tolower(gsub("_", "", out))
    out
    
    #return the vector that results from the 2nd column of the merge
  }
  
  BuildSubjectColumn <- function() {
    #In: None
    #Out: a vector of the activity descriptions for all the records in the main data set. R factor type.
    #This output matches up with the rows of culledData and is ready to cbind()
    #Dependencies: The dataPath variable should be set in the parent environment (or global)
    rbind(read.table(paste0(dataPath, "/train/subject_train.txt")), read.table(paste0(dataPath, "/test/subject_test.txt"))
    )
  }
  
  if (!suppressRetrieveRawData) RetrieveRawData()
  #Assumes the intact and unmodified "UCI HAR Dataset" is a subdirectory of the working directory
  
  dataPath <- "./UCI HAR Dataset"
  #mergeData is the combined raw data from the training and test sets
  mergeData <- rbind(read.table(paste0(dataPath, "/train/X_train.txt")), 
                     read.table(paste0(dataPath, "/test/X_test.txt")))
  print("Training and test datasets read and combined")
  colnames(mergeData) <- gsub("\\(|\\)", "", read.table("./UCI HAR Dataset/features.txt")[, 2])
  columnstokeep <- grep("std|mean", colnames(mergeData))
  #culledData adds the Subject and Activity columns as columns 1 & 2 to the merged
  culledData <- cbind(BuildSubjectColumn(), BuildActivityColumn(), mergeData[, columnstokeep])
  colnames(culledData)[1:2] <- c("subjectid","activity")
  colnames(culledData) <- tolower(colnames(culledData)) #convert to lower case
  
  narrowData <- melt(culledData, id.vars = c("subjectid","activity"))
  if (tidyFeatureName) {
    #The molten feature names are very conveniently all in column "variable", we can search and replace just this one column
    narrowData$variable <- gsub("-", "", narrowData$variable)
    narrowData$variable <- gsub("bodybody", "body", narrowData$variable) #for some reason "bodybody" appears in the features
    narrowData$variable <- gsub("acc", "acceleration", narrowData$variable)
  }
  #Attempt to product output of the specified significant figures (8)
  if (outputNarrow) {
    print("Creating tidy data in narrow (melted key-value) format")
    tidyData <- ddply(narrowData, colnames(narrowData)[1:3], summarize, 
                      signif(mean(value), 8)) 
    #inside ddply it couldn't see a variable I had defined outside, had to hard code 8 sig figs
  }
  else {
    print("Creating tidy data in wide (many columns) format")
    tidyData <- dcast(narrowData, subjectid + activity ~ variable,
                      function(df) signif(mean(df), 8))
  }
  tidyData
}

#Notes:
#Removing parenthesis using gsub and regex:
#gsub(pattern="\\(|\\)", x="abc(123)", replacement="") ; "abc(123)" to "abc123"
#2 escape characters required for each paren
#https://class.coursera.org/getdata-003/forum/thread?thread_id=180