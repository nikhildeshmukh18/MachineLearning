#Loading all required libraries
library(readr)
library(forecast)
library(ggplot2)
#reading data
pmdata = read_csv('E:/NCIRL/sem-3/Data/experiments/PM25final2.csv')
PM25.close <- PM25$PM25
#converting to time series
PM25 <- ts(pmdata[,2], start = c(2016,1), frequency = 24*60*365.25/15)
#plotting time series 
autoplot(PM25) + xlab("Time(Year)") + ylab("PM2.5(micro gram per meter cube)") +ggtitle('PM2.5 plot')
#Finding outliers
pmoutliers <- which.max(PM25)
#acf plot PM25  which shows it is not a white noise
acf.PM25=acf(PM25,main='ACF PM25',lag.max=100,ylim=c(- 0.5,1), na.action=na.pass)
#difference plot
autoplot(diff(PM25))
#ACF plot of diffrenec 
ggAcf(diff(PM25))
#Ljung test to see if it is a white noise or not
Box.test(diff(PM25), lag =100, type = "Ljung") # very small so not a white noise

#log and difrencing
difflogexpo <- diff(log(PM25))
autoplot(difflogexpo)
ggAcf(difflogexpo)
difflogexpo1 <- diff(difflogexpo)
autoplot(difflogexpo1)
ggAcf(difflogexpo1)

# Box cox test 
BoxCox.lambda(PM25)
# Fitting ARIMA
arima212 <- auto.arima(PM25, lambda = 1) #lambda from above box test
checkresiduals(arima212)
summary(arima212)
res.arima212 <- arima212$residuals

#cross validation 
sq <- function(u){u^2}
for(h in 1:10)
{
  PM25 %>% tsCV(forecastfunction = auto.arima, h = h) %>%
    sq() %>% mean(na.rm = TRUE) %>% print()
}

#forecasting with the model 
pointforecast <- arima212 %>% forecast(h =1000) 
autoplot(pointforecast)
pointforecast
write.csv(pointforecast, 'ARIMA_result.csv')

#Checking for residuals 
checkresiduals(arima212)

#-------ARIMA-GARCH--------------------------------------------------------------
library("tseries")
#check if ARIMA-GARCH can be used or not
qqnorm(PM25)
qqline(PM25)
#Arch
arch08=garch(res.arima212,order=c(0,8),trace=F)
loglik08=logLik(arch08)
summary(arch08)
#forecasting 
forecast212step1=forecast(arima212,1,level=95)
forecast212=forecast(arima212,100,level=95)
plot(forecast212)
ht.arch08=arch08$fit[,1]^2
#finding conditional variance
plot(ht.arch08,main='Conditional variances')
fit212=fitted.values(arima212)
low=fit212-1.96*sqrt(ht.arch08)
high=fit212+1.96*sqrt(ht.arch08)
plot(PM25,type='l',main='PM25,Low,High')
lines(low,col='red')
lines(high,col='blue')
archres=res.arima212/sqrt(ht.arch08)
#check sample quantiles with respect to quantiles
qqnorm(archres,main='ARIMA-ARCH Residuals')
qqline(archres)

