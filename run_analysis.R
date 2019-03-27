library(tidyverse)
library(dplyr)
setwd("C:/Users/wlima/OneDrive - WMActuary/UERJ/CEPAR/Ciência de Dados Johns Hopkins University/Data")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "Dataset.zip")


setwd("C:/Users/wlima/OneDrive - WMActuary/UERJ/CEPAR/Ciência de Dados Johns Hopkins University/Data/Dataset/UCI HAR Dataset")

activity_labels<-read.table("activity_labels.txt")



features<-read.table("features.txt")

View(features)

setwd("C:/Users/wlima/OneDrive - WMActuary/UERJ/CEPAR/Ciência de Dados Johns Hopkins University/Data/Dataset/UCI HAR Dataset/test")


subject_test<-read.table("subject_test.txt")
X_test<-read.table("X_test.txt")
Y_test<-read.table("Y_test.txt")



setwd("C:/Users/wlima/OneDrive - WMActuary/UERJ/CEPAR/Ciência de Dados Johns Hopkins University/Data/Dataset/UCI HAR Dataset/train")


subject_train<-read.table("subject_train.txt")
X_train<-read.table("X_train.txt")
Y_train<-read.table("Y_train.txt")




idsubject<-c(subject_test$V1,subject_train$V1)

idactivity<-c(Y_test$V1,Y_train$V1)

str(idactivity)

# Merges the training and the test sets to create one data set.

datasetmerge<-rbind(X_test,X_train)

datasetmerge<-cbind(idsubject,idactivity,datasetmerge)

names(datasetmerge)[1]<-"idsubject"
names(datasetmerge)[2]<-"idactivity"

datasetmerge$idactivity<-as.factor(datasetmerge$idactivity)

# Extracts only the measurements on the mean and standard deviation for each measurement.

datasetproj<-data.frame()

datasetproj[1,]<-datasetmerge %>% select(V1:V561)%>% summarize_all(mean)

datasetproj[2,]<-datasetmerge %>% select(V1:V561)%>% summarize_all(sd)

#Uses descriptive activity names to name the activities in the data set

names(activity_labels)<-c("idactivity","descricao")

activity_labels$idactivity<-as.factor(activity_labels$idactivity)

datasetmerge<-merge(activity_labels,datasetmerge )

#Appropriately labels the data set with descriptive variable names



colnames(datasetmerge)<-c("idactivity","descricao","idsubject",gsub("\\)","",gsub("\\(","",gsub("\\()","",gsub(",","",(gsub("-","",paste(features[,2],features[,1], sep=""))))))))


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

datasettydybase<-datasetmerge %>% select(-descricao) %>% group_by(idactivity,idsubject)%>% summarize_all(mean)


datasettydy<-datasettydybase %>%  gather("features", "media",3:563)



