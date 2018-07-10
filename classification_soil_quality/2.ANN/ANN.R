## Read the datafile.
soil_ann <- read.table("soil_data.csv", header=TRUE, sep=",", na.strings="NA", dec=".", 
                       strip.white=TRUE)
summary(soil_ann) 
soil_new<-soil_ann[,-1]   ## remove the first column
soil_new[,1]=soil_new[,11]  ## copy last column to first one
soil_new[,11]<-NULL ## remove last column
head(soil_new) ## first six rows

## It will not work.
##soil_new$Type<-factor(soil_new$Type, levels=c("highfertile","lowfertile","MedFertile"), labels=c(1,3,2))

## Since the measurement of data is different it needs to be normalized

install.packages("tabplot")
library(tabplot)
tableplot(soil_new)


install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
chart.Correlation(soil_new[,2:10],col=soil_new$f)




## for running Artificial Neural Network
## for this input is soil data which has 9 variable and 1 class variable
## First we need to normalize the data as the data has different range.

normalize <- function(x)
{
  return ( (x-min(x) ) / ( max(x)-min(x) ) )
}


soil_n<-as.data.frame(lapply(soil_new,normalize))
str(soil_n)

## Now we need to divide the data into testing and training phase

test_index<-sample(nrow(soil_n),200)
soil_test<- soil_n[test_index, ]
soil_train<- soil_n[-test_index, ]

install.packages("neuralnet")
library("neuralnet")

soil_model<-neuralnet(Type ~ depth + ph + conductivity + carbon + nitrogen + potassium + phosphorus + WHC + porosity , data = soil_train, hidden=3)

plot(soil_model)

model_results<-compute(soil_model,soil_test[2:10])
str(model_results)
predicted_class<-model_results$net.result
cor(predicted_class,soil_test$Type)
## This will give the percentage of corret classified data in ANN.

write.table(predicted_class, "C:/Users/nain/Documents/R/predicted_class.csv", sep=" ,", row.names=FALSE)
write.table(soil_test$Type, "C:/Users/nain/Documents/R/predicted_test.csv", sep=" ,", row.names=FALSE)


