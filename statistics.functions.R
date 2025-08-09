# TODO: add escape sequence for header text or when needed
#  In Bash, the character can be obtained with the following syntaxes:
#
# \e
# \033
# \x1B
#
# The commands (for easy copy-paste):
#
# echo -e "\e[1mbold\e[0m"
# echo -e "\e[3mitalic\e[0m"
# echo -e "\e[3m\e[1mbold italic\e[0m"
# echo -e "\e[4munderline\e[0m"
# echo -e "\e[9mstrikethrough\e[0m"
# echo -e "\e[31mHello World\e[0m"
# echo -e "\x1B[31mHello World\e[0m"
#

text_bold <- function(text) {
  paste0("\033[1m", text, "\033[0m")
}

text_underline <- function(text) {
  paste0("\033[4m", text, "\033[0m")
}

text_header <- function(text) {
  text_bold(text_underline(text))
}

get_current_year <- function() {
  substr(Sys.Date(), 1, 4)
}

get_current_month <- function() {
  substr(Sys.Date(), 6, 7)
}

get_date <- function(data) {
  substr(data, 1, 2)
}

get_month <- function(data) {
  substr(data, 4, 5)
}

get_year <- function(data) {
  substr(data, 7, 10)
}

sort_data_frame_ascending <- function(data, column) {
  data[order(data[[column]]), ]
}

sort_data_frame_descending <- function(data, column) {
  data[order(-data[[column]]), ]
}

select_shop_data <- function(data, shop) {
  data[data$shop == shop, ]
}

select_month_data <- function(data, month) {
  data[data$n_months == month, ]
}

get_data_receipts <- function() {
  read.csv(
    "tmp/table",
    header = TRUE,
    sep = "\t",
    quote = "",
    colClasses = c("character", "character", "character", "numeric"),
    encoding = "UTF-8",
    fileEncoding = "UTF-8"
  )
}

receipts_shop_trim <- function(receipts) {
  shop <- trimws(receipts$shop)
  receipts$shop <- shop
  receipts
}

receitps_add_month_column <- function(receipts) {
  months <- lapply(receipts$date, get_month)
  receipts$n_months <- months
  receipts
}

receitps_add_year_column <- function(receipts) {
  year <- lapply(receipts$date, get_year)
  receipts$year <- year
  receipts
}

prepare_data <- function(receipts) {
  data <- receitps_add_month_column(receipts)
  data <- receitps_add_year_column(data)
  data <- receipts_shop_trim(data)
  data
}

print_empty_line <- function() {
  cat("\n")
}

print_min_max_mean_median <- function(data) {
  cat("MIN:", data$min,
      "MAX:", data$max,
      "MEAN:", data$mean,
      "MEDIAN:", data$median,
      "\n")
}

calculate_min_max_mean_median <- function(data) {
  data.frame(
             min = min(data),
             max = max(data),
             mean = mean(data),
             median = median(data))
}

for_all_receipts_min_max_mean_median_price <- function(column_price) {
  result <- calculate_min_max_mean_median(column_price)
  cat(text_header("For all receipts MIN, MAX, MEAN, MEDIAN:"), "\n")
  print_min_max_mean_median(result)
  print_empty_line()
}

month_calculate_min_max_mean_median <- function(month, data) {
  result <- calculate_min_max_mean_median(data)
  result <- cbind(month = c(month), result)
  result
}

month_get_price <- function(data, month) {
  data <- data[data$n_months == month, ]
  data$price
}

for_each_month_min_max_mean_median <- function(data) {
  months <- unique(data$n_months)
  result <- NULL
  for (month in months) {
    result <- rbind(result,
      month_calculate_min_max_mean_median(month, month_get_price(data, month))
    )
  }
  cat(text_header("For each month calculate MIN, MAX, MEAN, MEDIAN:"), "\n")
  print(sort_data_frame_ascending(result, "month"))
  print_empty_line()

  # GRAPH
  # Note: https://r-graph-gallery.com/211-basic-grouped-or-stacked-barplot.html
  # TODO: sort by month
  result_as_matrix <- t(rev(result))
  result_as_matrix <- result_as_matrix[-c(5), ]
  result_as_matrix <- matrix(
                             as.numeric(result_as_matrix),
                             ncol = length(result$month))
  colnames(result_as_matrix) <- result$month
  rownames(result_as_matrix) <- c("median", "mean", "max", "min")
  result_values <- as.vector(t(rev(result[, -c(1)])))
  graph <- barplot(result_as_matrix,
    xlab = "Months",
    ylab = "Price",
    main = "For each month show MIN, MAX, MEAN and MEDIAN",
    col = colors()[c(12, 23, 62, 89)],
    border = "white",
    legend = rownames(result_as_matrix),
    args.legend = list(x = "bottomright", inset = c(-0.2, 0)),
    beside = TRUE,
    ylim = c(0, max(result$max) + 100)
  )
  labels_as_float <- sapply(
                            result_values,
                            function(value) sprintf("%.2f", value))
  text(
       graph,
       y = result_values + 10,
       labels = labels_as_float,
       adj = 0,
       srt = 90)
}

month_calculate_visited <- function(data, month) {
  counter <- nrow(data[data$n_month == month, ])
  result <- data.frame(month = month, counter = counter)
  result
}

for_each_month_shop_visited_counte <- function(data) {
  months <- unique(data$n_months)
  result <- NULL
  for (month in months) {
    result <- rbind(result, month_calculate_visited(data, month))
  }
  cat(text_header(
                  "For each month show how much time go to visite shops:"),
  "\n")
  print(sort_data_frame_ascending(result, "month"))
  print_empty_line()

  # GRAPH
  result_sorted <- sort_data_frame_ascending(result, "month")
  barplot(height = result_sorted$counter,
    names = result_sorted$month,
    col = rgb(0.8, 0.1, 0.1, 0.6),
    xlab = "Months",
    ylab = "Visiting",
    main = "For each month show how much time go to visite shops",
    ylim = c(0, max(result_sorted$counter) + 10)
  )
}

for_all_receipts_most_visited_shop_calculation <- function(data) {
  shops <- unique(data$shop)
  result <- NULL
  for (shop in shops) {
    counter <- nrow(data[data$shop == shop, ])
    result <- rbind(result, data.frame(shop = shop, counter = counter))
  }
  result
}

for_all_receipts_most_visited_shop <- function(data) {
  result <- for_all_receipts_most_visited_shop_calculation(data)
  result <- sort_data_frame_descending(result, "counter")
  cat(text_header("For all receipts most visited shops:"), "\n")
  print(result, right = FALSE)
  print_empty_line()

  # GRAPH
  # TODO: Fix names position for better view
  barplot(height = result$counter,
    names = result$shop,
    col = rgb(0.8, 0.1, 0.1, 0.6),
    xlab = "Shop",
    ylab = "Counter of visite",
    main = "For all time, most visited shop",
    ylim = c(0, max(result$counter) + 10),
    las = 2
  )
}

for_each_month_most_visited_shop <- function(data) {
  months <- sort(unlist(unique(data$n_months)))
  cat(text_header("For each month most visited shops are:"), "\n")
  for (month in months) {
    cat("In month ", month, "\n")
    current_month <- data[data$n_months == month, ]
    print(
          for_all_receipts_most_visited_shop_calculation(current_month),
          right = FALSE)
    print_empty_line()
  }
  print_empty_line()
}

for_each_month_calculate_range_of_price_get_range <- function(data, month) {
  value <- range(data$price)
  result <- data.frame(month = month, min = value[1], max = value[2])
  result
}

for_each_month_calculate_range_of_price <- function(data) {
  months <- sort(unlist(unique(data$n_months)))
  result <- NULL
  for (month in months) {
    current_month <- data[data$n_months == month, ]
    res <- for_each_month_calculate_range_of_price_get_range(current_month,
                                                             month)
    result <- rbind(result, res)
  }
  cat(text_header("For each month show range of price:"), "\n")
  print(result)
  print_empty_line()

  # GRAPH
  result_as_matrix <- t(rev(result[, -c(1)]))
  colnames(result_as_matrix) <- result$month
  result_values <- as.vector(t(rev(result[, -c(1)])))
  graph <- barplot(result_as_matrix,
    xlab = "Months",
    ylab = "Price",
    main = "For each month show RANGE - MIN, MAX",
    col = colors()[c(12, 62)],
    border = "white",
    legend = rownames(result_as_matrix),
    args.legend = list(x = "bottomright", inset = c(-0.2, 0)),
    beside = TRUE,
    ylim = c(0, max(result$max) + 100)
  )
  labels_as_float <- sapply(result_values,
                            function(value) sprintf("%.2f", value))
  text(graph,
       y = result_values + 10,
       labels = labels_as_float,
       adj = 0,
       srt = 90)
}

for_each_shop_for_each_month_min_max_mean_median <- function(data) {
  shops <- sort(unlist(unique(data$shop)))
  h <- text_header("For for each shop month calculate MIN, MAX, MEAN, MEDIAN:")
  cat(h, "\n")
  for (shop in shops) {
    result_for_shop <- NULL
    shop_data <- select_shop_data(data, shop)
    months <- sort(unlist(unique(shop_data$n_months)))
    for (month in months) {
      current_month <- select_month_data(shop_data, month)
      price <- current_month$price
      result_for_shop <- rbind(
        result_for_shop,
        data.frame(month = month, min = min(price),
                   max = max(price),
                   mean = mean(price),
                   median = median(price))
      )
    }
    cat(shop, "\n")
    print(result_for_shop)
    print_empty_line()

    # GRAPH
    # TODO: Fix not correct name of shop
    result_as_matrix <- t(rev(result_for_shop))
    result_as_matrix <- result_as_matrix[-c(5), ]
    result_as_matrix <- matrix(as.numeric(result_as_matrix),
                               ncol = length(result_for_shop$month))
    colnames(result_as_matrix) <- result_for_shop$month
    rownames(result_as_matrix) <- c("median", "mean", "max", "min")
    result_values <- as.vector(t(rev(result_for_shop[, -c(1)])))
    graph <- barplot(result_as_matrix,
      xlab = "Months",
      ylab = "Price",
      main = paste0("For each month of shop ",
                    enc2utf8(shop), "\nshow MIN, MAX, MEAN and MEDIAN"),
      col = colors()[c(12, 23, 62, 89)],
      border = "white",
      legend = rownames(result_as_matrix),
      args.legend = list(x = "bottomright", inset = c(-0.2, 0)),
      beside = TRUE,
      ylim = c(0, max(result_for_shop$max) + 100),
    )
    labels_as_float <- sapply(result_values,
                              function(value) sprintf("%.2f", value))
    text(graph,
         y = result_values + 10,
         labels = labels_as_float,
         adj = 0,
         srt = 90)
  }
  print_empty_line()
}
