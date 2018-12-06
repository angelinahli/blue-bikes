# filename: get_date.R
# author: Angelina Li
# date: 12/06/2018
# desc: weekday riderships

required.pkgs <- c("lubridate")
new.pkgs <- required.pkgs[!(required.pkgs %in% installed.packages()[,"Package"])]
if (length(new.pkgs) != 0) install.packages(new.pkgs)

library(lubridate)

# change to the folder holding your code
setwd("~/Desktop/Code/in_progress/blue-bikes/")

df.test <- readRDS("data/intermediate/test.rds")
df.test$weekday <- wday(df.test$starttime)
df.test$weekday[1:5]
unique(df.test$weekday) # ranges from 1 - 7
