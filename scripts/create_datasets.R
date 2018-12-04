# filename: create_datasets.R
# author: Angelina Li
# date: 12/04/2018
# desc: create datasets to use.

required.pkgs <- c("lubridate")
new.pkgs <- required.pkgs[!(required.pkgs %in% installed.packages()[,"Package"])]
if (length(new.pkgs) != 0) install.packages(new.pkgs)

library(lubridate)

# change to the folder holding your code
setwd("~/Desktop/Code/in_progress/blue-bikes/")

## uncomment whichever dataset you need
df.test <- readRDS("data/intermediate/test.rds")
df.test$weekday <- wday(df.test$starttime)

df.test[1:2,]

colnames(df.test)
wday(df.test$starttime[1])
df$start.station.name[1]
df$start.station.id[1]

sort(unique(df$start.station.id))[1:5]
nrow(df.test[df.test$start.station.id == 163])

