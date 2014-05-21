#Coursera Course Project "Getting and Cleaning Data"
##CodeBook.md
***
##Document scope
This document describes the data tidying process including selecting features (columns) and renaming of features and activities.  
While reviewing this document, it will be helpful to have both the **README.md** file and the source publication referenced in the README.md available as this document depends on both.
##Project requirements
See **README.md**
##Data transformation
Referring also to **README.md** in the R script section may be helpful.
###R script run_analysis() conceptual summary
See **README.md**.
###Combined train & test dataset
As described in **README.md**, the random separation of 70% of the data into a machine learning training set, and 30% into a test set fulfilled the original publication's requirements but is not relevant for this project.  
Re-combining the train and test datasets resulted in a table of 10,299 records and 561 features.
###Subsetting features
The R script run_analysis.R deliberately excluded some features, based on the project requirements. Any feature with a name including the expressions "mean" or "std" (standard deviation) was included in the working dataset, otherwise it was excluded.  
This reduced the number of features from 561 to 79.
###Add *subjectid*, *activity* features
As described in **README.md**, adding these two additional columns from the left increased the number of features from 79 to 81, the number in the output tidy dataset.

###Subjectid transformation
The processing interpreted the source data for this feature as integers but otherwise did not transform it.

###Activity (description) transformation
For compatibility with the original publication, the output uses the supplied activity descriptions (activity_labels.txt).  

In the author's judgement, it was prudent to avoid modifying the descriptions. The requirements were unclear on this point, though the lectures recommended using lower case, complete English words, and no underscores or periods.

The processing applies the following transformations:
1. text converted to lower case
2. underscores replaced with spaces

This seemed a reasonable compromise that allows easy comparison with the original publication.

###Feature (column) name transformation
The author's preference was to make few transformations with the feature names not required by the R language and as with the Activity transformation topic, the requirements were unclear.  
The author's justification is that changing the feature names is risky without substantial domain knowledge, and it also makes referring to the results of the original publication more difficult. The author weighed that consideration against the style recommendations from lecture and in the end made some modest transformations.  

The processing applies the following transformations (text was already lower case):
1. dashes eliminated (replaced with nothing)
2. the expression "bodybody" is replaced with "body" as the author believes repetition of the word body to have been an error
3. the expression "acc" is replaced with "acceleration"

### Feature naming conventions

##Tidy data
###Tidy data dimensions

###Tidy data types
The features are given in order:  
1. subjectid: integer; An anonymous identifier indicating the unique individual performing the activity  
2. activity: R factor with 6 levels: laying sitting standing walking walkingdownstairs walkingupstairs  
3. The other 79 features hold numeric data with up to 8 significant digits, matching the input measurements.
