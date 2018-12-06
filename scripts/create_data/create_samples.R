# filename: create_samples.R
# author: Angelina Li
# date: 12/04/2018
# desc: make 3 samples of data

setwd("~/Desktop/Code/in_progress/blue-bikes/")

set.seed(1)
df <- readRDS("data/intermediate/hubway.rds")
nrow(df)

# took 50% sample of entire  dataset first for manageability
df <- df[sample(nrow(df), nrow(df) * 0.5),]
nrow(df)
df["segment"] <- runif(nrow(df), 0, 3)

train <- df[df$segment <= 1, !(names(df) %in% c("segment"))]
nrow(train)
colnames(train)

test <- df[(df$segment > 1) & (df$segment <= 2), !(names(df) %in% c("segment"))]
nrow(test)

validate <- df[(df$segment > 2) & (df$segment <= 3), !(names(df) %in% c("segment"))]
nrow(validate)

saveRDS(train, "data/intermediate/train.rds")
saveRDS(test, "data/intermediate/test.rds")
saveRDS(validate, "data/intermediate/validate.rds")
