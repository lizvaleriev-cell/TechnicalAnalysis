# BDA400 - Assignment 2
# Display imported stock data and visualizations
# Student: Liz Valerie

library(quantmod)
library(TTR)

# Load the required functions.
source("stock_functions.R")

# Download approximately one year of data for every symbol in portfolio.txt.
stocks <- load_stock_data(
  file_name = "portfolio.txt",
  from = Sys.Date() - 365,
  to = Sys.Date()
)

# Display the names of successfully loaded stocks.
print(names(stocks))

# Display the first six rows of every stock data frame.
for (symbol in names(stocks)) {
  cat("\n==============================\n")
  cat("STOCK:", symbol, "\n")
  cat("==============================\n")
  print(head(stocks[[symbol]]))
}

# Calculate and display the required statistics.
statistics <- calculate_all_statistics(stocks, moving_average_days = 20)

cat("\n==============================\n")
cat("PORTFOLIO STATISTICS\n")
cat("==============================\n")
print(statistics)

# Display one chart for every stock.
# Each chart shows the adjusted closing price and a 20-day moving average.
for (symbol in names(stocks)) {
  stock_df <- stocks[[symbol]]
  ma20 <- SMA(stock_df$Adjusted, n = 20)

  plot(
    stock_df$Date,
    stock_df$Adjusted,
    type = "l",
    main = paste(symbol, "- Adjusted Close and 20-Day Moving Average"),
    xlab = "Date",
    ylab = "Price"
  )

  lines(stock_df$Date, ma20, lwd = 2)
  legend(
    "topleft",
    legend = c("Adjusted Close", "20-Day Moving Average"),
    lty = c(1, 1),
    lwd = c(1, 2),
    bty = "n"
  )
}

# Optional: inspect a complete data frame in RStudio.
# View(stocks[["AAPL"]])
