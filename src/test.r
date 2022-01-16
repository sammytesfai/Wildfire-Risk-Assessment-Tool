source("FA.r")
library(cffdrs)

my_data <- read.delim("..\data\Coast_Dairies_dataset", sep = ",")

IRAWS1 <- data.frame(36.9741, -122.0307, 2021, 11, my_data$Day.of.Month , my_data$Air.Temp.mean, my_data$Hum.Mean, my_data$Wind.Avg, my_data$Tot.Precip, my_data$Air.Temp.Max)

colnames(IRAWS1) <- c('lat', 'long', 'yr', 'mon', 'day', 'temp', 'rh', 'ws', 'prec', 'tmax')

FA(IRAWS1, winterDC = NULL)
