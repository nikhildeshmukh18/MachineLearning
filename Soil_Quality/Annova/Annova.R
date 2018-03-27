soil_svm <- read.table("soil_data.csv", header=TRUE, sep=",", na.strings="NA", dec=".", 
                       strip.white=TRUE)

summary(soil_svm)
library(ggplot2)
qplot(WHC,porosity,data = soil_svm,color = class)
soil_svmn<-soil_svm[,-1]   ## remove the first column
soil_svmn[,1]=soil_svmn[,11]  ## copy last column to first one
soil_svmn$class<-NULL  ## remove the last column

summary(soil_svmn)

anova(lm(soil_svmn$ph ~ soil_svmn$Type))

anova(lm(soil_svmn$conductivity ~ soil_svmn$Type))
anova(lm(soil_svmn$carbon ~ soil_svmn$Type))
anova(lm(soil_svmn$nitrogen ~ soil_svmn$Type))
anova(lm(soil_svmn$phosphorus ~ soil_svmn$Type))
anova(lm(soil_svmn$WHC ~ soil_svmn$Type))
anova(lm(soil_svmn$potassium ~ soil_svmn$Type))
