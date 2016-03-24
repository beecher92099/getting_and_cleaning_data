run_analysis <- function() {
  
## load needed libraries: dplyr for summarize_each, reshape for melt  
  
  library(dplyr)
  library(reshape)
  
## 1. Merge the training and test data sets to create one data set.
  
  ## subject file
  
  f1 <- read.table("test/subject_test.txt")
  f2 <- read.table("train/subject_train.txt")
  subject <- rbind(f1,f2)

  ## X file - the one with 561 feature columns
  
  f1 <- read.table("test/X_test.txt")
  f2 <- read.table("train/X_train.txt")
  x_file <- rbind(f1,f2)

  ## y file - training labels
  
  f1 <- read.table("test/y_test.txt")
  f2 <- read.table("train/y_train.txt")
  y_file <- rbind(f1,f2)
  colnames(y_file) <- c("activity_code")
  
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
  
  ## read in the measure labels
  measure_labels <- read.table("features.txt", stringsAsFactors = FALSE)
  measure_labels <- measure_labels$V2
  
  ##apply measure labels to the dataframe
  colnames(x_file) <- measure_labels
  
  ##now select only columns with mean or std
  select_vector <- grep("mean|std", names(x_file))
  x_file_sel <- subset(x_file, select = select_vector)
  
## 3. Use descriptive activity names to name the activities in the data set
  
  ##read in the actvity label mapping
  activity_mapping <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
  colnames(activity_mapping) <- c("activity_code", "activity_label")
  
  ##add the descriptive activity label to y file
  y_file <- merge(y_file, activity_mapping)
  
  ##add the actvity label column to the x_file
  x_file_sel["activity_label"] <- y_file$activity_label
  
  ##add the subject column to the x_file
  x_file_sel["subject"] <- subject$V1
  
  ## move subect and activity label to first two columns
  x_file_sel <- x_file_sel[c(81,80,1:79)]
  
  
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

  x_file_group <- group_by(x_file_sel, activity_label, subject)
  x_file_sum <- summarize_each(x_file_group, funs(mean))
  
  # make the data frame "tidy" now
  
  x_file_tidy <- melt(as.data.frame(x_file_sum), id = c("activity_label", "subject"))
  write.table(x_file_tidy, "x_file_tidy.txt", row.names = FALSE)
  
  
}