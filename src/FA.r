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


# Get Fine Fuel Mositure code for all hours in January except Jan 17 @1400
ffmc.o = c()
for(i in 1:(nrow(CD.data) - 1))
{
  if(i == 1)
  {
    ffmc.o[i] <- hffmc(CD.data[i,]) 
  }
  else
  {
    ffmc.o[i] <- hffmc(CD.data[i,], ffmc_old = ffmc.o[i-1])
  }
}

# Obtain FFMC for Jan 17th @ 1400 given previous hours FFMC
cd.hffmc <- hffmc(CD.data[nrow(CD.data),], ffmc.o[i])

# Getting Fire Weather Index for hour 1400 using FFMC derived above as well 
# as the same dataset
cd.fwi <- fwi(CD.data[nrow((CD.data)),], 
              init = data.frame(ffmc = cd.hffmc, dmc = 6, dc = 15, lat = 55))
cd.fwi$FWI
