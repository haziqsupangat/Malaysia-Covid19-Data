library(dplyr)
library(data.table)
library(tidyverse)
library(ggplot2)
library(RCurl)
library(lubridate)
library(plotrix)
library(RColorBrewer)


#Data Source
jhu_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
jhu_url1 <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
jhu_url2 <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
          
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

#Filter country and Modify Table to remove unnecessary data (Recovered)
malaysia_recover <- read.csv(url(jhu_url1), header = TRUE, row.names = ) %>%
  filter(Country.Region == "Malaysia") %>%
  pivot_longer(-c(Province.State, Country.Region, Lat, Long), names_to = "Date", values_to = "Cumulative Recovers") %>%
  rename(Country = "Country.Region") %>%
  ungroup() %>%
  select(-c(Province.State, Lat, Long))

#Change some format
Dates <- gsub("X", "", malaysia_recover$Date)
Date_num <- as.Date(Dates, format = "%m.%d.%y")


#Filter country and Modify Table to remove unnecessary data (Recovered)
malaysia_deaths <- read.csv(url(jhu_url2), header = TRUE, row.names = ) %>%
  filter(Country.Region == "Malaysia") %>%
  pivot_longer(-c(Province.State, Country.Region, Lat, Long), names_to = "Date", values_to = "Cumulative Deaths") %>%
  rename(Country = "Country.Region") %>%
  ungroup() %>%
  select(-c(Province.State, Lat, Long))

#Change some format
Dates <- gsub("X", "", malaysia_deaths$Date)
Date_num <- as.Date(Dates, format = "%m.%d.%y")



#Create data frame
Table1 <- data.frame(Date = Date_num,
                     Cumulative.Cases = malaysia_case$`Cumulative Cases`,
                     Cumulative.Recovers = malaysia_recover$`Cumulative Recovers`,
                     Cumulative.Deaths = malaysia_deaths$`Cumulative Deaths`)

daily.cases <- Table1$Cumulative.Cases - lag(Table1$Cumulative.Cases)
daily.recovers <- Table1$Cumulative.Recovers - lag(Table1$Cumulative.Recovers)
daily.deaths <- Table1$Cumulative.Deaths - lag(Table1$Cumulative.Deaths)
active <- Table1$Cumulative.Cases - Table1$Cumulative.Recovers
active.cases <- active - Table1$Cumulative.Deaths



Table <- data.frame(Date = Date_num,
                    Cumulative.Cases = malaysia_case$`Cumulative Cases`,
                    Daily.Cases = daily.cases,
                    Cumulative.Recovers =  malaysia_recover$`Cumulative Recovers`,
                    Daily.Recovers = daily.recovers,
                    Cumulative.Deaths = malaysia_deaths$`Cumulative Deaths`,
                    Daily.Deaths = daily.deaths,
                    Active.Cases = active.cases)


#Plotting output

plot <- ggplot(Table) +
  geom_line(aes(x=Date, y=Cumulative.Cases),colour="black", se = "False", span = 0.3) +
  geom_rect(data = Table, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = colour), alpha = -0.1) +
  scale_fill_identity()

print(plot)

#Github
Master <- Table %>%
  filter(Date > "2020-01-20") %>%
  ungroup()%>%
  select(-c(Log, Ratio))
write.csv(Master, '')
