# author: Angelina Li
# date: 11/29/2018
# filename: clean_data.R
# description: short script to clean, compile and save all data in RDS format

# NOTE - TO RUN AGAIN:
# (1) set working dir to a folder
# (2) make sure there exists a folder at path data/input
# (3) make sure there exists a folder at path data/intermediate
# (4) download all available input files from data source and store in data/input
# (5) run code

required.pkgs <- c("splitstackshape", "lubridate")
new.pkgs <- required.pkgs[!(required.pkgs %in% installed.packages()[,"Package"])]
if (length(new.pkgs) != 0) install.packages(new.pkgs)

library(splitstackshape)
library(lubridate)

# NOTE - CHANGE PATH IF RUNNING AGAIN
setwd("~/Desktop/Code/in_progress/blue-bikes/")

# some data exploration
sample_df <- read.csv("data/input/201502-hubway-tripdata.csv")
colnames(sample_df)
sample_df[1:5,"starttime"]
sample_df[1:5,"stoptime"]

started.accum <- FALSE
df <- NA 
for (file in list.files("data/input")) {
  # just to have output to look at
  print(paste("Working on file:", file))
  mth.df <- read.csv(paste("data/input/", file, sep=""), stringsAsFactors = FALSE)
  if(!started.accum) {
    df <- mth.df
    started.accum <- TRUE
  } else {
    df <- rbind(df, mth.df)
  }
}

# exploring our mammothian dataset
colnames(df)
dim(df)

# making a date variable
df$starttime <- ymd_hms(df$starttime)
df$starttime[1:5]
df$year <- year(df$starttime)
df$year[1:5]
df$month <- month(df$starttime)
df$month[1:5]
df$stoptime <- ymd_hms(df$stoptime)
df$stoptime[1:5]

# making a 5% simple random sample of data for convenient use
set.seed(1)
df.small.sample <- df[sample(nrow(df), nrow(df) * 0.05),]
dim(df.small.sample)

# and a 25% simple random sample for larger analyses
df.large.sample <- df[sample(nrow(df), nrow(df) * 0.25),]
dim(df.large.sample)

# saving it all for later use
saveRDS(df.large.sample, "data/intermediate/hubway_lg.rds")
saveRDS(df.small.sample, "data/intermediate/hubway_sm.rds")
