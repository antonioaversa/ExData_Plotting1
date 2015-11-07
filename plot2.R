# The code performs the following operations:
# 1. download and unzip the dataset into the current working directory, if needed
# 2. reads the observations for 1/2/2007 and 2/2/2007
# 3. performs the needed col types conversions (read.csv.sql doesn't support specific NA handling)
# 4. generates the plot

zippedDataFileName <- "exdata-data-household_power_consumption.zip";
dataFileName  <- "household_power_consumption.txt";

if (!file.exists(zippedDataFileName))
  download.file(url =  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = zippedDataFileName, mode = "wb");

if (!file.exists(dataFileName))
  unzip(zipfile = zippedDataFileName);

library(sqldf);
library(lubridate);
library(dplyr);

df <- read.csv.sql(dataFileName, colClasses = rep('character', 9),  sep = ";", 
                   sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'");
closeAllConnections();

df = 
  df %>% 
  mutate(
    Date = dmy(Date), 
    Time = as.difftime(Time),
    Global_active_power = as.numeric(Global_active_power),
    Global_reactive_power = as.numeric(Global_reactive_power),
    Voltage = as.numeric(Voltage),
    Global_intensity = as.numeric(Global_intensity),
    Sub_metering_1 = as.numeric(Sub_metering_1),
    Sub_metering_2 = as.numeric(Sub_metering_2),
    Sub_metering_3 = as.numeric(Sub_metering_3)); 

png(filename = "plot2.png", width = 480, height = 480, bg = "transparent");
plot(df$Date + df$Time, df$Global_active_power, 
     xlab = "",
     ylab = "Global Active Power (kilowatts)", 
     type = "l");
dev.off();
