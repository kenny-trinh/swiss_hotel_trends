## ----PackageSetup-----------------------------------------------------------------------------------

# List of required packages
required_packages <- c(
  "tidyverse",
  "lubridate",
  "dplyr",
  "readr",
  "tidyr",
  "stringr",
  "purrr",
  "scales",
  "ggplot2",
  "writexl",
  "plotly",
  "tidytext",
  "tinytex",
  "xfun"
)

# Function to check and install missing packages
install_if_missing <- function(packages) {
  missing_packages <- packages[!packages %in% installed.packages()[, "Package"]]
  if (length(missing_packages) > 0) {
    install.packages(missing_packages)
  }
}

# Install any missing packages
install_if_missing(required_packages)

# Load all packages
lapply(required_packages, library, character.only = TRUE)

## ----DataPaths-------------------------------------------------------------------------------------
# Define data paths
data_dir <- "data/"
output_dir <- "output/"

# Create output directory if it doesn't exist
dir.create(output_dir, showWarnings = FALSE)
