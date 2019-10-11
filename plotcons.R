library(dplyr)
library(tidyr)
library(lubridate)
ctable <- read.table("household_power_consumption.txt", stringsAsFactors = FALSE, 
                     sep=";", header = TRUE)
ctable <- ctable %>% mutate("DateTime" = dmy_hms(paste(Date, Time)))
ctable <- ctable %>% select(DateTime, 3:9)
ctable2days <- ctable %>% filter(DateTime > dmy_hms("01/02/2007 00:00:00") & 
                                 DateTime < dmy_hms("03/02/2007 00:00:00"))
ctable2days$Global_active_power <- as.numeric(ctable2days$Global_active_power)
hist(ctable2days$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", 
     main="Global Active Power")