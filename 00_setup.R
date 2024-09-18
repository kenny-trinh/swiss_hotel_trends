## ----PackageSetup-----------------------------------------------------------------------------------

# Load necessary packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("lubridate")) install.packages("lubridate")
if (!require("dplyr")) install.packages("dplyr")
if (!require("readr")) install.packages("readr")
if (!require("tidyr")) install.packages("tidyr")
if (!require("stringr")) install.packages("stringr")
if (!require("purrr")) install.packages("purrr")
if (!require("scales")) install.packages("scales")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("writexl")) install.packages("writexl")


library(tidyverse)
library(lubridate)
library(dplyr)
library(readr)
library(tidyr)
library(stringr)
library(purrr)
library(scales)
library(ggplot2)
library(writexl)

## ----DataPaths-------------------------------------------------------------------------------------
# Define data paths
data_dir <- "data/"
output_dir <- "output/"

# Create output directory if it doesn't exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}