library (lubridate) ## To easily handle the dates

### Exploring the data set we discover that 2007-02-01 starts in row 66637.
### and day 2007-02-02 finishes in row 659519, 2880 rows after.
data<-read.csv("household_power_consumption.txt",sep=";" ,skip = 66636,nrow = 2880, stringsAsFactors = FALSE)

### We retrieve the headers that we missed
headers<-read.csv("household_power_consumption.txt",sep=";", nrow=1, header = F, stringsAsFactors = FALSE)
### We add the names to the columns
colnames( data) <- unlist(headers)

## We construct the timestamp from the date and the time
data$timestamp<-dmy_hms(paste(data$Date,data$Time))

### We construct the png device
png(filename = "plot4.png",width = 480, height = 480)

## We set the canvas to plot 2x2 plots
par(mfcol = c (2,2))

## Plot1
with(data,plot(timestamp,Global_active_power,
               type="l",
               ylab = ("Global Active Power (kilowatts)"),
               xlab =""
))

## Plot2

### We make the histogram and set the cosmetics
with(data,plot(timestamp,Sub_metering_1,
               type="l",
               ylab = ("Energy sub metering"),
               xlab =""
))
with(data,lines(timestamp,Sub_metering_2,col="red"))
with(data,lines(timestamp,Sub_metering_3,col="blue"))
legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1),col=c("black","red","blue"))

## Plot 3
with(data,plot(timestamp,Voltage,
               type="l",
               ylab = "Voltage",
               xlab ="DateTime"
))
## Plot 4
with(data,plot(timestamp,Global_reactive_power,
               type="l",
               ylab = "Global reactive power",
               xlab ="DateTime"
))
### We turn off the device
dev.off()
