library(readr)
PM25 = read_csv('E:/NCIRL/sem-3/Data/experiments/PM25final2.csv')
pmts <- ts(pmdata[,2], start = c(2016), frequency = 24*60*18)
#Decomposing the time series--------------------------------------
decomoomp <- decompose(pmts)
autoplot(decomoomp)
