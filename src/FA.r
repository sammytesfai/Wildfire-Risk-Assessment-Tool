# Check if cffdrs package is installed if not then install
if(!("cffdrs" %in% installed.packages()))
{
  install.packages("cffdrs")
}
install.packages("cron")
library(cffdrs)

setwd("C:/Users/sammy/OneDrive/Desktop/Wildfire-Risk-Assessment-Tool")

# Read in dataset from Younger Weather station for 1 week in Feb
Feb.week <- read.csv("data/Younger-Week-Dataset.csv")

# Formatting Date and creating separate YYYY MM DD, and HH columns
Date.format <- as.POSIXct(Feb.week$time, format = "%m/%d/%Y %H:%M")

yr <- format(Date.format, format="%Y")
mm <- format(Date.format, format="%m")
dd <- format(Date.format, format="%d")
hh <- format(Date.format, format="%H")

# Extracting key data from dataset and inputting relevant geographical 
# information that is missing
data <- data.frame(36.948889, -122.066389, yr, mm, dd, hh,
                      Feb.week$air.temp.max.degc, Feb.week$relative.humidity.max.pct, 
                      Feb.week$wind.speed.max.ms, Feb.week$rainfall.mm, 12)
colnames(data) <- c('lat', 'long', 'yr', 'mon', 'day', 'hr', 'temp', 'rh',
                       'ws', 'prec', 'dmc')

# Adjust convert windspeed from m/s to km/h
data$ws <- data$ws*3.6


# Get Fine Fuel Mositure code every time interval of 10min
ffmc.o = c()
sdmc.o = c()
for(i in 1:(nrow(data)))
{
  if(i == 1)
  {
    ffmc.o[i] <- hffmc(data[i,], time.step = 1/6) 
  }
  else
  {
    ffmc.o[i] <- hffmc(data[i,], ffmc_old = ffmc.o[i-1], time.step = 1/6)
  }
}

sdmc.o <- sdmc(data)

# Obtain FFMC for Jan 17th @ 1400 given previous hours FFMC
hffmc.o <- hffmc(data[nrow(data),], ffmc.o[i])

# Getting Fire Weather Index for hour 1400 using FFMC derived above as well 
# as the same dataset
fwi.o <- fwi(data[nrow((data)),], 
              init = data.frame(ffmc = hffmc.o, dmc = 6, dc = 15, lat = 55))
fwi.o$FWI
