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
Dates <- gsub("X", "", malaysia_case$Date)
Date_num <- as.Date(Dates, format = "%m.%d.%y")


#Create data frame
Table <- data.frame(Date = Date_num, Cases = malaysia_case$`Cumulative Cases`)
write.csv(Table, row.names = FALSE)
