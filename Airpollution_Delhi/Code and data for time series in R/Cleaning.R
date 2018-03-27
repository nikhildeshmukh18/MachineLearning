library(readr)
NO <- read.csv("C:/Users/nikhi/Downloads/Book1NO2.csv")
PM25 <- read.csv("C:/Users/nikhi/Downloads/Book1PM2.5.csv")
PM10 <-  read.csv("C:/Users/nikhi/Downloads/Book1PM10.csv")
SO <- read.csv("C:/Users/nikhi/Downloads/BookSO.csv")

library(dplyr)
ab <- inner_join(NO, PM25, by = "Date")
bc <- inner_join(ab, SO, by = "Date")
cd <- inner_join(bc, PM10, by = "Date")

write.csv(cd, "2016.csv")
#-----------------------------------------------------------------------
library(lubridate)
comb <- read_csv("E:/NCIRL/sem-3/Data/Thesis/Classification/comb.csv")
tail(comb)
comb1 <-read.csv("E:/NCIRL/sem-3/Data/Thesis/Classification/SO2/comb2.csv", stringsAsFactors = FALSE)
comb1$Date <- as.Date(comb1$Date, "%d/%m/%y")
tail(comb1$Date)
final <- inner_join(comb, comb1, by = "Date")
tail(final)
write.csv(final, "final.csv")
#-----------------------------------------------------------------------------

abc <- read.csv("E:/NCIRL/sem-3/Data/Thesis/Classification/SO2/2016.csv")
head(abc$Date)
abc$Date <- s.Date(abc$Date, "%d/%m/%y")
#-----------------------------------------------------
aqi <- read.csv("C:/Users/nikhi/Desktop/new.csv")
aqi <- na.omit(aqi)
aqi$AQI
aqi$Class <- ifelse(aqi$AQI < 51, "Good",
                    ifelse(aqi$AQI < 101, "Satisfactory",
                           ifelse(aqi$AQI < 201, "Moderate",
                                  ifelse(aqi$AQI < 301, "Poor",
                                         ifelse(aqi$AQI < 401, "Very Poor", "Sever")))))


aqi$NumClass <- ifelse(aqi$AQI < 51, "1",
                       ifelse(aqi$AQI < 101, "2",
                              ifelse(aqi$AQI < 201, "3",
                                     ifelse(aqi$AQI < 301, "4",
                                            ifelse(aqi$AQI < 401, "5", "6")))))
write.csv(aqi, "new.csv")






