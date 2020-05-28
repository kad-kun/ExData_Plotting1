rm(list = ls())

library(lubridate)

file <- "household_power_consumption.txt"
zipf <- "household_power_consumption.zip"
wd <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"


if(!file.exists(file)){
    download.file(url, zipf, method = "curl")
}

if(!file.exists(file)){
    unzip(zipf)
}

data <- read.table(file.path(wd, file), nrows = 75000, header = TRUE, sep = ";")
data$Date <- dmy(data$Date)
data <- data[data$Date >= dmy("01/02/2007") & data$Date < dmy("03/02/2007"), ]
data[, 3:9] <- lapply(data[, 3:9], as.numeric)
data$Time <- hms(data$Time)

png(filename = "plot1.png", height = 480, width = 480, units = "px")
with(data, hist(Global_active_power, main = "Global Active Power", col = "red", xlab = "Global Active Power (kilowatts)"))
dev.off()