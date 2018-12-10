# filename: make_graphics.R
# author: Angelina Li
# date: 12/06/2018
# desc: weekday riderships graphics

required.pkgs <- c("dplyr", "reshape", "lubridate", "ggplot2", "raster")
new.pkgs <- required.pkgs[!(required.pkgs %in% installed.packages()[,"Package"])]
if (length(new.pkgs) != 0) install.packages(new.pkgs)

library(dplyr)
library(ggmap)
library(lubridate)
library(reshape)
library(Rmisc)
library(ggplot2)
library(plotly)

# change to the folder holding your code
setwd("~/Desktop/Code/in_progress/blue-bikes/")
working.df <- readRDS("data/intermediate/test.rds")
reshape.df <- readRDS("data/intermediate/reshaped_test.rds")

colnames(working.df)
gb <- working.df %>%
  group_by(start.station.id, start.station.name, 
           start.station.latitude, start.station.longitude)
station.info <- gb %>% dplyr::summarise(n())
colnames(station.info) <- c("station.id", "name", "lat", "long", "n")
station.info <- station.info[order(station.info$station.id),]
# randomly grabbed each first row of the data for each station
station.info <- station.info[!duplicated(station.info$station.id),
                             c("station.id", "name", "lat", "long")]
nrow(station.info)

reshape.df <- transform(reshape.df, station.id = as.numeric(station.id))
reshape.df <- left_join(reshape.df, station.info, by="station.id")
reshape.df[1:5,]


station.incoming <- working.df %>%
  group_by(start.station.id) %>%
  dplyr::summarise(n())
colnames(station.incoming) <- c("station.id", "incoming")

station.outgoing <- working.df %>%
  group_by(end.station.id) %>%
  dplyr::summarise(n())
colnames(station.outgoing) <- c("station.id", "outgoing")

stations <- merge(station.incoming, station.outgoing, 
                  by=c("station.id"), all=TRUE)
stations$incoming[is.na(stations$incoming)] <- 0
stations$outgoing[is.na(stations$outgoing)] <- 0

stations[1:5,]
stations$flux <- stations$incoming - stations$outgoing
stations$station.id <- as.numeric(stations$station.id)

# above: data cleaning work.
# now lets check everything.
colnames(stations)
colnames(station.info)
stations$station.id[1:5]
station.info$station.id[1:5]
nrow(unique(stations))
nrow(station.info)

all.stations <- merge(stations, station.info, by=c("station.id"), all=TRUE)
all.stations[1:5,]
colnames(all.stations)
