### Exploring the data set we discover that 2007-02-01 starts in row 66637.
### and day 2007-02-02 finishes in row 659519, 2880 rows after.
data<-read.csv("household_power_consumption.txt",sep=";" ,skip = 66636,nrow = 2880, stringsAsFactors = FALSE)

### We retrieve the headers that we missed
headers<-read.csv("household_power_consumption.txt",sep=";", nrow=1, header = F, stringsAsFactors = FALSE)
### We add the names to the columns
colnames( data) <- unlist(headers)

### We construct the png device
png(filename = "plot1.png",width = 480, height = 480)
### We make the histogram and set the cosmetics
with(data,hist(Global_active_power,
               xlab = ("Global Active Power (kilowatts)"),
               main = ("Global Active Power"),
               col="red"))
### We turn off the device
dev.off()
