library(dplyr)
library(data.table)
library(tidyverse)
library(ggplot2)
library(RCurl)
library(lubridate)


#Data Source
jhu_url <- ("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")

#Filter country and Modify Table to remove unnecessary data
malaysia_recover <- read.csv(url(jhu_url), header = TRUE, row.names = ) %>%
  filter(Country.Region == "Malaysia") %>%
  pivot_longer(-c(Province.State, Country.Region, Lat, Long), names_to = "Date", values_to = "Cumulative Recovers") %>%
  rename(Country = "Country.Region") %>%
  ungroup() %>% 
  select(-c(Province.State, Lat, Long))


#Change some format
Dates <- gsub("X", "", malaysia_recover$Date)
Date_num <- as.Date(Dates, format = "%m.%d.%y")


#Create data frame
Table1 <- data.frame(Date = Date_num, Cumulative.Recovers = malaysia_recover$`Cumulative Recovers`)
daily <- Table1$Cumulative.Recovers - lag(Table1$Cumulative.Recovers)
Table <- data.frame(Date = Date_num, Cumulative.Recovers = malaysia_recover$`Cumulative Recovers`, Daily.Recovers = daily)
