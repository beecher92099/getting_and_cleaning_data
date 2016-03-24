run_analysis.R performs an analysis on the data collected from the accelerometers from the Samsung Galaxy S smartphone.

The script merges the training and the test sets to create one data set by reading in the relevant
files with read.table() and using rbind() to merge the files.

The measure labels for the 561 different measurements is read in and these labels are applied to the data frame
the colnames() function.

Then the dataset is reduced to only retain measurements which are either mean or standard deviation.  This is done by 
first creating a vector to identify the matching column headers and then using this in conjunction with
the subset() function.

Next the actvity_label and subject data is added as two additional columns to the dataset

The group_by() function is used to group the data frame by activity_label and subject.

summarize_each() is then used to calculate the mean value for all data columns.

Finally the melt function is used to create a tidy version of the data frame and
the result is written to a txt file using write.table.