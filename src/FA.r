# Check if cffdrs package is installed if not then install
if(!("cffdrs" %in% installed.packages()))
{
  install.packages("cffdrs")
}
install.packages("cron")
library(cffdrs)

# Read in dataset from Coastal Dairies Weather station 
CD.Jan.hourly <- read.delim("data/Coast_Dairies_Jan_hourly_dataset", sep = ",")

# Formatting Date and creating separate YYYY MM DD, and HH columns
Date.format <- as.POSIXct(CD.Jan.hourly$Date.MM.DD.YYYY, format = "%m-%d-%Y")
Time.format <- as.POSIXct(CD.Jan.hourly$Time.hh.mm, format = "%H:%M")
CD.yr <- format(Date.format, format="%Y")
CD.mm <- format(Date.format, format="%m")
CD.dd <- format(Date.format, format="%d")
CD.hh <- format(Time.format, format="%H")

# Extracting key data from dataset and inputting relevant geographical 
# information that is missing
CD.data <- data.frame(36.9741, -122.0307, CD.yr, CD.mm, CD.dd, CD.hh,
                      CD.Jan.hourly$Avg.Air.Temp, CD.Jan.hourly$Rel.Humidty, 
                      CD.Jan.hourly$Wind.Speed.m.s, CD.Jan.hourly$Precip.mm)
colnames(CD.data) <- c('lat', 'long', 'yr', 'mon', 'day', 'hr', 'temp', 'rh',
                       'ws', 'prec')


# Getting FWI using hourly dataset for Coastal Dairies using default values for
# ffmc, dmc, and dc
cd.fwi <- fwi(CD.data)
