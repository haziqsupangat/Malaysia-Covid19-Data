library(dplyr)
library(data.table)
library(tidyverse)
library(ggplot2)
library(RCurl)
library(lubridate)


#Data Source
jhu_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
            
#Filter country and Modify Table to remove unnecessary data
malaysia_case <- read.csv(url(jhu_url), header = TRUE, row.names = ) %>%
  filter(Country.Region == "Malaysia") %>%
  pivot_longer(-c(Province.State, Country.Region, Lat, Long), names_to = "Date", values_to = "Cumulative Cases") %>%
  rename(Country = "Country.Region") %>%
  ungroup() %>% 
  select(-c(Province.State, Lat, Long))
 

#Change some format
Date <- gsub("X", "", malaysia_case$Date)
Date_num <- as.Date(Date, format = "%m.%d.%y")


#Create data frame
Logged <- log10(Table$Cases)
Table <- data.frame(Dates = Date_num, Cases = malaysia_case$`Cumulative Cases`, Log = Logged)


#Plotting output
plot <- ggplot(Table, mapping = aes(x = Dates, y = Cases))  + geom_line()
print(plot)

break

#Plotting output
plot(Table$Dates, Table$Cases, xlab = "Months", ylab = "Cumulative Cases", type = "l")

