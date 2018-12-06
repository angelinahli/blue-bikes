# filename: get_date.R
# author: Angelina Li
# date: 12/06/2018
# desc: weekday riderships graphics

required.pkgs <- c("lubridate", "dplyr", "reshape")
new.pkgs <- required.pkgs[!(required.pkgs %in% installed.packages()[,"Package"])]
if (length(new.pkgs) != 0) install.packages(new.pkgs)

library(dplyr)
library(lubridate)
library(reshape)

# change to the folder holding your code
setwd("~/Desktop/Code/in_progress/blue-bikes/")

working.df <- readRDS("data/intermediate/test.rds")
# assuming this date is the right one to use
working.df$day <- date(working.df$starttime) 
working.df$weekday <- wday(working.df$starttime)
working.df$weekday[1:5]
sort(unique(working.df$weekday)) # ranges from 1 - 7

colnames(working.df)
levels <- working.df %>%
  group_by(start.station.id, weekday) %>%
  summarise(n())
colnames(levels) <- c("station.id", "weekday", "count")
levels[1:5,]

station.incoming <- working.df %>%
  group_by(start.station.id, day) %>%
  summarise(n())
colnames(station.incoming) <- c("station.id", "day", "incoming")
station.incoming[1:5,]

station.outgoing <- working.df %>%
  group_by(end.station.id, day) %>%
  summarise(n())
colnames(station.outgoing) <- c("station.id", "day", "outgoing")
station.outgoing[1:5,]

stations <- merge(station.incoming, station.outgoing, 
                  by=c("station.id", "day"), all=TRUE)
stations$incoming[is.na(stations$incoming)] <- 0
stations$outgoing[is.na(stations$outgoing)] <- 0
stations$missing <- is.na(stations$incoming) || is.na(stations$outgoing)
# no missing! That's good.
stations[stations$missing,]

stations$flux <- stations$incoming - stations$outgoing

saveRDS(stations, "data/intermediate/reshaped_test.rds")