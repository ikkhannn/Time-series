monthly_milk <- read.csv("monthly_milk.csv")
daily_milk <- read.csv("daily_milk.csv")

head(monthly_milk)

class(monthly_milk)

class(monthly_milk$month)


# coerce the month column to date class
monthly_milk$month <- as.Date(monthly_milk$month,format="%Y-%m-%d")

monthly_milk$month
  


head(daily_milk)
class(daily_milk$date_time)
#convert the daily milk date time column to posix
daily_milk$date_time_posix <- as.POSIXct(daily_milk$date_time,format="%Y-%m-%d %H:%M:%S")

class(daily_milk$date_time_posix)

head(daily_milk$date_time_posix)


#create bad format date column
monthly_milk$bad_date <- format(monthly_milk$month, format = "%d/%b/%Y-%u")
head(monthly_milk$bad_date)
class(monthly_milk$bad_date)


#visualize
timeplot<- ggplot(monthly_milk,aes(x=month,y=milk_prod_per_cow_kg))+geom_line()+scale_x_date(date_labels="%m-%d",date_breaks="1 year")+theme_classic()
timeplot

(timeplot2 <- ggplot(daily_milk,aes(x=date_time_posix,y=milk_prod_per_cow_kg))+geom_line()+scale_x_datetime(date_labels="%p-%d",date_breaks = "36 hour")+theme_classic())



#decomposition
(decomp_1 <- ggplot(monthly_milk, aes(x = month, y = milk_prod_per_cow_kg)) +
    geom_line() +
    scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
    theme_classic())


(decomp_2 <- ggplot(monthly_milk, aes(x = month, y = milk_prod_per_cow_kg)) +
    geom_line() +
    geom_smooth(method = "loess", se = FALSE, span = 0.6) +
    theme_classic())