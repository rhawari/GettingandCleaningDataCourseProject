#-----------------------------------------------
#Getting and Cleaning Data Course Project
#10/29/19
#-----------------------------------------------
if (!require("data.table")) {
  
  install.packages("data.table")
  
}


if (!require("reshape2")) {
  
  install.packages("reshape2")
  
}


require("data.table")

require("reshape2")



act_lab <- read.table("activity_labels.txt")[,2]
feat <- read.table("features.txt")[,2]


extract_feat <- grepl("mean|std", feat)


Xtest <- read.table("test/X_test.txt")

ytest <- read.table("test/y_test.txt")

subtest <- read.table("test/subject_test.txt")

names(Xtest) = feat

Xtest = Xtest[,extract_feat]

ytest[,2] = act_lab[ytest[,1]]
names(ytest) = c("Activity_ID", "Activity_Label")
names(subtest) = "subject"

test_data<-cbind(as.data.table(subtest), ytest, Xtest)


Xtrain <- read.table("train/X_train.txt")

ytrain <- read.table("train/y_train.txt")

subtrain <- read.table("train/subject_train.txt")

names(Xtrain) = feat

Xtrain=Xtrain[,extract_feat]

ytrain[,2] = act_lab[ytrain[,1]]

names(ytrain) = c("Activity_ID", "Activity_Label")

names(subtrain) = "subject"

traindata <- cbind(as.data.table(subtrain), ytrain, Xtrain)

data=rbind(test_data, traindata)

id_labels=c("subject", "Activity_ID", "Activity_Label")
data_labels=setdiff(colnames(data), id_labels)
melt_data= melt(data, id = id_labels, measure.vars = data_labels)

tidy_data=dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "tidy_data.txt")
