library(class)
library(PerformanceAnalytics)
library(caret)
library(e1071)
library(ggplot2)
install.packages(c("caret", "e1071"))

soil_data <- read.csv("C:/Users/nikhi/Downloads/soil.csv", header=TRUE, sep=",", na.strings="NA", dec=".", 
                      strip.white=TRUE)
head(soil_data)
#Summary of the data
summary(soil_data)
#structure of the dataset
str(soil_data)

#Create a matrix plot of scatterplots
pairs(soil_data)
pairs
chart.Correlation(soil_data[,3:11],col=soil_data$class)

normalize <- function(x)
{
  return ( (x-min(x) ) / ( max(x)-min(x) ) )
}
soil_norm<-as.data.frame(lapply(soil_data[,3:11],normalize))
summary(soil_norm)

soil_norm
str(soil_norm)

soil_train<- soil_norm[1-700,]
soil_test<- soil_norm[701-711,]
KNN_pred<- knn(soil_train, soil_test, soil_data[1-700,12], k=17)
KNN_pred


conf1<- table(KNN_pred,factor(soil_data[701-711,12]))
confusionMatrix(conf1)
plot(KNN_pred, xlab="Fertile of Soil", ylab="Frequency", main="Histogram for K=17")
sum(diag(conf1)/sum(conf1))
