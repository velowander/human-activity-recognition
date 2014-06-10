##Human Activity Recognition - CodeBook.md
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
Re-combining the train and test datasets resulted in a table of 10,299 records and 561 features (columns).
###Subsetting features
The R script human-activity-recognition.R deliberately excluded some features, based on the project requirements. Any feature with a name including the expressions "mean" or "std" (standard deviation) was included in the working dataset, otherwise it was excluded.  
This reduced the number of features from 561 to 79.
###On project requirement step 2 "measurements"
Step 2 of the project requirements (see **README.md**) specifies extracting "measurements" from the data. Arguably, measurements would include only raw (time domain) force per unit mass readings from the smartphone accelerometer and would exclude any quantity derived or calculated from these readings, such as:

* jerk (time derivative of acceleration)  
* magnitudes of acceleration or jerk
* corrections to the raw accelerometer readings, due to gravity (gravity imposes a force on the accelerometer; unless the smartphone is in free fall, there is an opposing normal force on the smartphone by the user's hand or clothing or other object such that the smartphone's actual acceleration does not correspond directly to the raw accelerometer reading)
* standard signal processing or information theory concepts such as:
   * frequency domain
   * energy
   * entropy

The author notes that the requirements were unclear if the term "measurements" in step 2 was used in a scientific sense such that these derived values should be excluded or in any everyday sense such that all non-identifier columns are measurements.
  
The author decided not to remove any of the derived features, judging that it is easy to subset unwanted features from the tidy dataset if desired.

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
The author's preference was to make few transformations with the feature names unless required by the R language. As with the Activity transformation topic, the requirements were unclear.  
The author's justification is that changing the feature names is risky without substantial domain knowledge, and it also makes referring to the results of the original publication more difficult. The author weighed that consideration against the style recommendations from lecture and in the end made some modest transformations.  

The processing applies the following transformations:

1. feature names converted to lower case  
- dashes eliminated (replaced with nothing)
- the expression "bodybody" is replaced with "body" as the author believes repetition of the word body to have been an error
- the expression "acc" is replaced with "acceleration"
- the expression "mag" is replaced with "magnitude"

For additional information about the feature names, please see the original source citation in **README.md**, noting the name changes referenced in this section.
##Tidy data
###Dimensions
The default dataset (no optional parameters) is a "wide" or "cast" format with 35 records and 81 features.
###Verification of results 
The author was quite surprised that there were only 35 unique combinations in the tidy dataset.

As a check, the author used the combined dataset with 10,299 records and appended *subjectid* and *activity* fields with R's unique() command and confirmed that there are, indeed, only 35 unique subjectid-activity pairs present in the data.

###Data types
The features are given in order:
  
1. subjectid: integer: An anonymous identifier indicating the unique individual performing the activity  
- activity: R factor with 6 levels: laying sitting standing walking walkingdownstairs walkingupstairs  
- The other 79 features hold numeric data with up to 8 significant digits, matching the input measurements.

###Features represent mean values
From the third feature to the end, the remaining 79 "data" features represent means of their respective underlying data, aggregated or grouped by *subjectid* and *activity*.

These 79 features are means of means, and means of standard deviations in the underlying data.
