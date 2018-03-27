att_data <- read.csv("C:/Users/nikhi/Downloads/soil.csv", stringsAsFactors = FALSE)
set.seed(13)

# Load the rpart, rattle, rpart.plot and RColorBrewer package
library(rpart)
library(rpart.plot)
library(RColorBrewer)

#Shuffle the dataset, call the result shuffled
n <- nrow(att_data)
shuffled_data <- att_data[sample(n),]

# Split the data in train and test   

train_indices <- 1:round(0.7 * n)
train_data <- shuffled_data[train_indices, ]
test_indices <- (round(0.7 * n) + 1):n
test_data <- shuffled_data[test_indices, ]

att_tree <- rpart(class ~ ph + depth + condictivity + carbon + Nitrogen + Phosphorus + Potassium + WHC + Porosity, train_data, method="class")
pred <- predict(att_tree,test_data, type= "class")
prp(att_tree,  box.palette="auto")
table(pred,test_data$class)
att_data <- read.csv("C:/Users/nikhi/Downloads/soil.csv", stringsAsFactors = FALSE)
set.seed(13)

# Load the rpart, rattle, rpart.plot and RColorBrewer package
library(rpart)
library(rpart.plot)
library(RColorBrewer)

#Shuffle the dataset, call the result shuffled
n <- nrow(att_data)
shuffled_data <- att_data[sample(n),]

# Split the data in train and test   

train_indices <- 1:round(0.7 * n)
train_data <- shuffled_data[train_indices, ]
test_indices <- (round(0.7 * n) + 1):n
test_data <- shuffled_data[test_indices, ]

att_tree <- rpart(class ~ ph + depth + condictivity + carbon + Nitrogen + Phosphorus + Potassium + WHC + Porosity, train_data, method="class")
#rpart.plot(att_tree,extra=104, box.palette="GnBu",tweak=0.8,branch.lty=3, shadow.col="gray", nn=TRUE)
pred <- predict(att_tree,test_data, type= "class")
prp(att_tree,  box.palette="auto")
conf <- table(pred,test_data$class)
acc <- sum(diag(conf)/sum(conf))
acc
