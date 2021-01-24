# Malaysia-Covid19-Curve

R based software that automatically generate Covid19 case graph

This programme require R software to run.

It works by taking the covid 19 cases from Johns Hopkins University
(<https://github.com/CSSEGISandData/COVID-19>) every 24 hours and
generate the graph from the provided data.

# How To Use

1.  Install the latest R software from <https://www.r-project.org>

2.  Install the following library via “install.packages()”

    1.  tidyverse
    2.  ggplot2
    3.  RCurl
    4.  data.table
    5.  dplyr
    6.  lubridate

3.  Run the programme


``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(data.table)
```

    ## 
    ## Attaching package: 'data.table'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
    ## ✓ tibble  3.0.5     ✓ stringr 1.4.0
    ## ✓ tidyr   1.1.2     ✓ forcats 0.5.0
    ## ✓ readr   1.4.0

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x data.table::between() masks dplyr::between()
    ## x dplyr::filter()       masks stats::filter()
    ## x data.table::first()   masks dplyr::first()
    ## x dplyr::lag()          masks stats::lag()
    ## x data.table::last()    masks dplyr::last()
    ## x purrr::transpose()    masks data.table::transpose()

``` r
library(ggplot2)
library(RCurl)
```

    ## 
    ## Attaching package: 'RCurl'

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     complete

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     hour, isoweek, mday, minute, month, quarter, second, wday, week,
    ##     yday, year

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
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


#Plotting output
plot <- ggplot(Table, mapping = aes(x = Date, y = Cases))  + geom_line()
print(plot)
```

![](Graph-of-Total-Cases_files/figure-markdown_github/unnamed-chunk-1-1.png)

