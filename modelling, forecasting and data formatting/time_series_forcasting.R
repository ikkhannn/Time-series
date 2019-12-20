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


#check pattern

monthly_milk$year_num <- format(monthly_milk$month,format="%Y")
monthly_milk$month_num <- format(monthly_milk$month,format="%m")

# Create a colour palette using the `colortools` package
year_pal<- sequential(color="darkturquoise",percentage = 5,what = "value")


#make the plot
(seasonal <- ggplot(monthly_milk,aes(x = month_num,y = milk_prod_per_cow_kg,group=year_num))+geom_line(aes(colour=year_num))+theme_classic()+scale_color_manual(values=year_pal))

#quicker way of making these plots
# Transform to `ts` class
monthly_milk_ts <- ts(monthly_milk$milk_prod_per_cow_kg, start = 1962, end = 1975, freq = 12)  # Specify start and end year, measurement frequency (monthly = 12)

# Decompose using `stl()`
monthly_milk_stl <- stl(monthly_milk_ts, s.window = "period")

# Generate plots
plot(monthly_milk_stl)  # top=original data, second=estimated seasonal, third=estimated smooth trend, bottom=estimated irregular element i.e. unaccounted for variation
monthplot(monthly_milk_ts, choice = "seasonal")  # variation in milk production for each month
seasonplot(monthly_milk_ts)
