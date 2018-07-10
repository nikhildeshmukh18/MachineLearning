## Read the datafile.

soil_svm <- read.table("soil_data.csv", header=TRUE, sep=",", na.strings="NA", dec=".", 
  strip.white=TRUE)

summary(soil_svm)
library(ggplot2)
qplot(WHC,porosity,data = soil_svm,color = class)
soil_svmn<-soil_svm[,-1]   ## remove the first column
soil_svmn[,1]=soil_svmn[,11]  ## copy last column to first one
soil_svmn$class<-NULL  ## remove the last column

 summary(soil_svmn)
                                                                                                                                                                   
 
## Since the measurement of data is different it needs to be normalized

install.packages("tabplot")
library(tabplot)
tableplot(soil_svmn)
 
install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
chart.Correlation(soil_svmn[,2:10],col=soil_svmn$f)


## for running support vector machine
## for this input is soil data which has 9 variable and 1 class variable
## SVM learner require all features to be numneric
## Generally we need to normalize the data but this svm package will perform this activity.
## Now we need to divide the data into testing and training phase

test_index<-sample(nrow(soil_svmn),200)
soil_stest<- soil_svmn[test_index, ]
soil_strain<- soil_svmn[-test_index, ]

install.packages("kernlab")
install.packages("e1071")
library(e1071)
library(kernlab)

model<-ksvm(Type ~ .,data=soil_strain, kernel="polydot")
model
Soil_predict<-predict(model,soil_stest)
conf=table(Soil_predict,soil_stest$Type)
conf


Hyperbolic<-ksvm(Type ~ .,data=soil_strain, kernel="tanhdot")
Hyperbolic
Soil_predict<-predict(Hyperbolic,soil_stest)
table(Soil_predict,soil_stest$Type)



Radial<-ksvm(Type ~ .,data=soil_strain, kernel="rbfdot")
Radial            
Soil_predict<-predict(Radial,soil_stest)
table(Soil_predict,soil_stest$Type)

write.table(Soil_predict, "C:/Users/nain/Documents/R/predicted_class.csv", sep=" ,", row.names=FALSE)
write.table(soil_stest$Type, "C:/Users/nain/Documents/R/test_class.csv", sep=" ,", row.names=FALSE)



