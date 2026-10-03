# TechnicalAnalysis

BDA400 - Data Science Tools and Techniques  
Assignment 2 - Technical Analysis using R, Preliminary Stage

## Assignment 2 files
- `portfolio.txt` - stock symbols, one per line.
- `stock_functions.R` - functions for loading stock data and calculating statistics.
- `display_analysis.R` - code for displaying imported data, statistics, and visualizations.
- `Valerie_Liz_BDA400_A02_Report.docx` - assignment report with step-by-step documentation.

## Required R packages
```r
install.packages("quantmod")
install.packages("TTR")
```

## Run order
1. Put all files in the same RStudio project/folder.
2. Open `display_analysis.R`.
3. Run the script.
4. Review the Console and Plots panes.

The script downloads stock data from Yahoo Finance through `quantmod`, creates a separate data frame for each successfully loaded symbol, calculates a 20-day moving average plus mean, mode, median, and standard deviation, and displays charts.
