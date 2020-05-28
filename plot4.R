rm(list = ls())

library(lubridate)
library(dplyr)

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

data <- mutate(data, Date_and_time = data$Date + data$Time)
data <- data[, -(1:2)]
data <- data[, c(8, 1:7)]

png(filename = "plot4.png", height = 480, width = 480, units = "px")

par(mfrow = c(2,2), mar = c(4, 4, 5, 2))

with(data, plot(Date_and_time, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))
with(data, plot(Date_and_time, Voltage, type = "l", xlab = "datetime", ylab = "Voltage"))

with(data, plot(Date_and_time, Sub_metering_1, type = "l", xlab = "", ylab = "Enegy sub metering"))
with(data, lines(Date_and_time, Sub_metering_2, col = "red"))
with(data, lines(Date_and_time, Sub_metering_3, col = "blue"))
legend(x = "topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, bty = "n")

with(data, plot(Date_and_time, Global_reactive_power, type = "l", xlab = "datetime"))

dev.off()