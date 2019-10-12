library(dplyr)
library(tidyr)
library(lubridate)
#
# Read in file
ctable <- read.table("household_power_consumption.txt", stringsAsFactors = FALSE, 
                     sep=";", header = TRUE)
# merge date and time string fields and then convert to date (using Lubridate package)
ctable <- ctable %>% mutate("DateTime" = dmy_hms(paste(Date, Time)))
#
# drop date and time columns, retain new column with converted field
#
ctable <- ctable %>% select(DateTime, 3:9)
#
# filter out by date range to get only 02-01-2007 and 02-02-2007 
#
ctable2days <- ctable %>% filter(DateTime > dmy_hms("01/02/2007 00:00:00") & 
                                 DateTime < dmy_hms("03/02/2007 00:00:00"))
# convert Global active power to numeric
ctable2days$Global_active_power <- as.numeric(ctable2days$Global_active_power)
# 
# plot 1 - histogram
png(filename="plot1.png", width=480, height=480, type="quartz")
hist(ctable2days$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", 
     main="Global Active Power")
dev.off()
#
# plot 2 - line graph (type="l") for Global active power
png(filename="plot2.png", width=480, height=480, type="quartz")
with(ctable2days, plot(DateTime, Global_active_power, type="l", ylab="Global active power"))
dev.off()
#
# plot 3 - 3 line graph with legend for energy sub metering
png(filename="plot3.png", width=480, height=480, type="quartz")
with(ctable2days, plot(ctable2days$DateTime, ctable2days$Sub_metering_1, type="l", ylab="", xlab=""))
lines(ctable2days$DateTime, ctable2days$Sub_metering_1, col="black", ylab="Energy sub metering")
lines(ctable2days$DateTime, ctable2days$Sub_metering_2, col="red")
lines(ctable2days$DateTime, ctable2days$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"), 
       col=c("black","red","blue"), lty=1, cex=1)
title(ylab="Energy sub metering")
dev.off()
#
# plot 4 - 4 sectional
png(filename = "plot4.png", width=480, height=480, type="quartz")
par(mfrow=c(2,2), oma=c(0,0,2,0), mar=c(4,4,1,1))
# plot 4.1
with(ctable2days, plot(ctable2days$DateTime, ctable2days$Global_active_power, 
                       col="black", type="l", ylab="Global Active Power", xlab="Datetime"))
# plot 4.2
with(ctable2days, plot(ctable2days$DateTime, ctable2days$Voltage, 
                       type="l", col="black", ylab="Voltage", xlab="Datetime"))
# plot 4.3
with(ctable2days, plot(ctable2days$DateTime, ctable2days$Sub_metering_1, 
                       ylab="Energy sub metering", xlab="Datetime", type="n"))
lines(ctable2days$DateTime, ctable2days$Sub_metering_1, col="black")
lines(ctable2days$DateTime, ctable2days$Sub_metering_2, col="red")
lines(ctable2days$DateTime, ctable2days$Sub_metering_3, col="blue")
legend("topright", cex=0.5, legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       col=c("black","red","blue"), lty=1)

# plot 4.4
with(ctable2days, plot(ctable2days$DateTime, ctable2days$Global_reactive_power, 
                       type="l", col="black", xlab="datetime", ylab="Global_reactive_power"))
dev.off()
#end
