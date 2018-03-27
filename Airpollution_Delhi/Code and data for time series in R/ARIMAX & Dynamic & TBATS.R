install.packages(c('readr','zoo','forecast','gplot2','lubridate','xts','fpp2'))
library(readr)
library(zoo)
library(forecast)
library(ggplot2)
library(lubridate)
library(xts)
library(fpp2)
pmdata <- read_csv("C:/Users/nikhi/Desktop/merge.csv")
colnames(pmdata)

regr <- ts(pmdata, start = c(2016,1), frequency = 24*60*365.25/15)
#ARIMAx---------------------------------------------------------------------------

xreg <- cbind(regr[,2:15])
#applying ARIMAX model
fit <- auto.arima(regr[,"PM25"], xreg =xreg)
summary(fit)
checkresiduals(fit) 
#forecasting PM2.5 future value based on other values(given as input)
fc <- forecast(fit, xreg = cbind(12.43,121.47,56.4,816.67,10.7,580,
                                 26.3,381.33,1.43,128.2,65,0.3,3.53, 5.3), h=288)
autoplot(fc)
fc

#dynamic harmonic regression( useful for subdaily data like I have) ---------------------------
dhr <- auto.arima(regr[,"PM25"], xreg = fourier(xreg, K = 6),
                  seasonal = FALSE, lambda = 0.42)
dhr_result <- dhr %>% forecast(xreg = fourier(xreg,K=6, h = 288))
autoplot(dhr_result)
write.csv(dhr_result, 'dhr_result.csv')
summary(dhr)
checkresiduals(dhr)
dhr
#TBATS method (good for my model bcz mltiple seasonal period which cant be recognize)--------------------------------------------
pmdata <- read_csv('E:/NCIRL/sem-3/Data/experiments/PM25final2.csv')
tbt <- ts(pmdata[,2], start = c(2016,1), frequency = 24*60*365.25/15)
tbts <- tbt %>% tbats() %>% forecast(h = 1000)
summary(tbts)
tbts
autoplot(tbts)
checkresiduals(tbts)
write.csv(summary(tbts),"tbats_output.csv")
