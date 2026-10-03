# BDA400 - Assignment 2
# Technical Analysis using R - Preliminary Stage
# Student: Liz Valerie
#
# This script contains the functions required to:
# 1. Read stock symbols from portfolio.txt
# 2. Download stock data with quantmod
# 3. Convert each stock to a separate data frame
# 4. Calculate moving average, mean, mode, median, and standard deviation

# Install these packages ONCE if they are not already installed:
# install.packages("quantmod")
# install.packages("TTR")

library(quantmod)
library(TTR)

# Function to calculate the statistical mode.
# If no value repeats, NA is returned because there is no unique mode.
statistical_mode <- function(x) {
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_real_)

  tab <- table(x)
  max_frequency <- max(tab)

  if (max_frequency == 1) {
    return(NA_real_)
  }

  modes <- as.numeric(names(tab)[tab == max_frequency])
  return(modes[1])
}

# Function to read portfolio.txt and download stock data.
load_stock_data <- function(file_name = "portfolio.txt",
                            from = Sys.Date() - 365,
                            to = Sys.Date()) {
  if (!file.exists(file_name)) {
    stop(paste("File not found:", file_name))
  }

  symbols <- trimws(readLines(file_name, warn = FALSE))
  symbols <- symbols[nzchar(symbols)]

  if (length(symbols) == 0) {
    stop("portfolio.txt does not contain any stock symbols.")
  }

  stock_list <- list()

  for (symbol in symbols) {
    message("Downloading: ", symbol)

    stock_xts <- tryCatch(
      getSymbols(symbol,
                 src = "yahoo",
                 from = from,
                 to = to,
                 auto.assign = FALSE),
      error = function(e) {
        warning(paste("Could not download", symbol, "-", e$message))
        return(NULL)
      }
    )

    if (!is.null(stock_xts)) {
      stock_df <- data.frame(
        Date = index(stock_xts),
        coredata(stock_xts),
        row.names = NULL
      )

      names(stock_df) <- c(
        "Date", "Open", "High", "Low",
        "Close", "Volume", "Adjusted"
      )

      stock_list[[symbol]] <- stock_df
    }
  }

  if (length(stock_list) == 0) {
    stop("No stock data could be downloaded.")
  }

  return(stock_list)
}

# Function to calculate the required statistics for one stock data frame.
calculate_statistics <- function(stock_df, moving_average_days = 20) {
  if (!is.data.frame(stock_df)) {
    stop("stock_df must be a data frame.")
  }

  if (!"Adjusted" %in% names(stock_df)) {
    stop("The data frame must contain an Adjusted column.")
  }

  adjusted <- stock_df$Adjusted
  adjusted <- adjusted[!is.na(adjusted)]

  if (length(adjusted) == 0) {
    stop("No valid adjusted closing prices were found.")
  }

  sma_values <- SMA(adjusted, n = moving_average_days)
  latest_sma <- tail(na.omit(sma_values), 1)

  result <- data.frame(
    Moving_Average_Days = moving_average_days,
    Latest_Moving_Average = round(as.numeric(latest_sma), 2),
    Mean = round(mean(adjusted), 2),
    Mode = round(statistical_mode(round(adjusted, 2)), 2),
    Median = round(median(adjusted), 2),
    Standard_Deviation = round(sd(adjusted), 2)
  )

  return(result)
}

# Function to calculate statistics for every stock in the portfolio.
calculate_all_statistics <- function(stock_list, moving_average_days = 20) {
  results <- lapply(
    stock_list,
    calculate_statistics,
    moving_average_days = moving_average_days
  )

  combined <- do.call(rbind, results)
  combined$Symbol <- rownames(combined)
  rownames(combined) <- NULL

  combined <- combined[, c(
    "Symbol",
    "Moving_Average_Days",
    "Latest_Moving_Average",
    "Mean",
    "Mode",
    "Median",
    "Standard_Deviation"
  )]

  return(combined)
}
