receipts <- read.csv(
    "tmp/table", 
    header = TRUE, 
    sep = "\t", 
    quote = "", 
    colClasses = c("character", "character", "character", "numeric")
)

summary(receipts)

