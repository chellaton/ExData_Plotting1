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
# #
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
