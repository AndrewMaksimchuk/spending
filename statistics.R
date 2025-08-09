source("./statistics.functions.R")

# ============================== SETTINGS ==============================
options(warn = -1) # TODO: Suppress all warnings
formals(print.data.frame)$row.names <- FALSE
pdf(
  width = 8,
  height = 7,
  onefile = TRUE,
  family = "Helvetica",
  title = "Spending application graphs",
)
par(
  mar = c(5, 4, 4, 8),
  xpd = TRUE
)
# ============================== SETTINGS END ==============================

receipts <- get_data_receipts()
data <- prepare_data(receipts)

current_year <- get_current_year()
data_of_current_year <- data[data$year == current_year, ]

calculation <- function(data) {
  for_all_receipts_min_max_mean_median_price(data$price)
  for_each_month_min_max_mean_median(data[c("price", "n_months")])
  for_each_month_shop_visited_counte(data)
  for_all_receipts_most_visited_shop(data)
  for_each_month_most_visited_shop(data)
  for_each_month_calculate_range_of_price(data)
  for_each_shop_for_each_month_min_max_mean_median(data)
}

cat("Data for year: ", current_year, "\n\n")
calculation(data_of_current_year)
