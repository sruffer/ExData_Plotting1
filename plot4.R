# plot4.R
# For each plot you should:
# 1. Construct the plot and save it to a PNG file with a width of 480 pixels
# and a height of 480 pixels.
# 2. Name each of the plot files as plot1.png, plot2.png, etc.
# 3. Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the 
# corresponding plot, i.e. code in plot1.R constructs the plot1.png plot. Your code file
# should include code for reading the data so that the plot can be fully reproduced. 
# You should also include the code that creates the PNG file.
# 4. Add the PNG file and R code file to your git repository
# 5. When you are finished with the assignment, push your git repository to GitHub so
# that the GitHub version of your repository is up to date. There should be four PNG files
# and four R code files.

# download and unzip data file if it doesn't exist yet
setInternet2(use = TRUE)
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("./powerconsumption.zip")) {
    download.file(fileUrl, destfile = "./powerconsumption.zip")
    unzip("./powerconsumption.zip")
}

# read data into data frame and subset filter on the dates 2007-02-01 and 2007-02-02
library(data.table)
library(dplyr)
data <- tbl_df(fread("./household_power_consumption.txt", header=TRUE, sep=";", na.strings="?"))
data <- filter(data, Date %in% c("1/2/2007", "2/2/2007"))

# combine date and time columns into single column
data <- data %>%
    mutate(datetime = paste(Date,Time))
data <- select(data, datetime, Global_active_power:Sub_metering_3)

# convert character columns to proper date/time and numeric, as applicable
data$datetime <- strptime(data$datetime, "%d/%m/%Y %H:%M:%S")
for (i in 2:8) {
    data[[i]] <- as.numeric(data[[i]])
}

# create  plots and save to png file
png(file = "plot4.png", width = 480, height = 480)
par(mfcol = c(2, 2))
with(data, {
    
    # Global Active Power plot
    plot(data$datetime, data$Global_active_power, type = "n", ylab = "Global Active Power", xlab = "")
    lines(data$datetime, data$Global_active_power)
    
    # Energy Submetering plot
    plot(data$datetime, data$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
    lines(data$datetime, data$Sub_metering_1, col = "black")
    lines(data$datetime, data$Sub_metering_2, col = "red")
    lines(data$datetime, data$Sub_metering_3, col = "blue")
    legend("topright", lwd = 1, bty = "n", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
    # Voltage plot
    with(data, plot(data$datetime, data$Voltage, type = "n", ylab = "Voltage", xlab = "datetime"))
    with(data, lines(data$datetime, data$Voltage))
    
    # Global Reactive Power plot
    plot(data$datetime, data$Global_reactive_power, type = "n", ylab = "Global_reactive_power", xlab = "datetime")
    lines(data$datetime, data$Global_reactive_power)
})
dev.off()