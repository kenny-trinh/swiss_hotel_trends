## ----InstallPackages-------------------------------------------------------------------------------
# install.packages("readr")
# install.packages("stringr")
# install.packages("sf")
# install.packages("leaflet")
# install.packages("lubridate")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("writexl")

## ----ImportLibraries-------------------------------------------------------------------------------
library(readr)
library(stringr)
library(sf)
library(leaflet)
library(lubridate)
library(dplyr)
library(tidyr)
library(writexl)

## ----SetWorkingDirectory----------------------------------------------------------------------------
## Set the working directory to source file location!


## ----ImportData------------------------------------------------------------------------------------
df <- read.csv("data/swiss_hotel_stays.csv",
               sep = ";",
               na.strings = "...")

## ----DataPreview-----------------------------------------------------------------------------------
dim(df)
head(df)
str(df)


## ----ImportData2-----------------------------------------------------------------------------------
# TODO: Weather data


## ----CheckNAValues---------------------------------------------------------------------------------
sum(is.na(df))
sapply(df, function(x)
  sum(is.na(x)))


## --------------------------------------------------------------------------------------------------
# Show the type of all the columns
sapply(df, class)

# Show only columns with logical type
sapply(df, is.logical)

# Create a data frame with logical columns
df_logical <- df %>%
  select_if(is.logical)

head(df_logical) # all logical columns are columns that only have NA values


## ----DropNAValues----------------------------------------------------------------------------------
# Drop logical columns from the data frame df
df <- df %>%
  select(-where(is.logical))

# Check the data frame
head(df %>%
       select(where(is.logical)))


## ----FunctionToExtractColumns----------------------------------------------------------------------
# Function to extract columns that contain a specific word
extract_columns <- function(data, word) {
  data %>%
    select(1:3, contains(word))
}

## ----FunctionToLongFormat--------------------------------------------------------------------------
# Function to convert a data frame to long format
to_long_format <- function(data, word) {
  data %>%
    pivot_longer(cols = contains(word),
                 names_to = "CountryOfResidence",
                 values_to = word)
}

## ----ArrivalsDataframe-----------------------------------------------------------------------------
# Create a new data frame with columns that contain the word "Arrivals" and the first 3 columns
# df_arrivals <- df %>%
#   select(1:3, contains("Arrivals"))
# head(df_arrivals)

df_arrivals <- extract_columns(data = df, word = "Arrivals")


## ----ArrivalsLongFormatDataframe-------------------------------------------------------------------
# Show all the columns that contain the word ".Arrivals" in the data frame df_arrivals in long format
# df_arrivals.long.format <- df_arrivals %>%
#   pivot_longer(cols = contains("Arrivals"),
#                names_to = "CountryOfResidence",
#                values_to = "Arrivals")

df_arrivals.long.format <- to_long_format(data = df_arrivals, word = "Arrivals")
head(df_arrivals.long.format)


## ----ArrivalsLongFormatDataframe2------------------------------------------------------------------
# Remove .Arrivals from the CountryOfResidence values
df_arrivals.long.format$CountryOfResidence <- str_remove_all(string = df_arrivals.long.format$CountryOfResidence, pattern = ".Arrivals")
head(df_arrivals.long.format)


## ----StaysDataframe--------------------------------------------------------------------------------
# Create a new data frame with columns that contain the word "Stays" and the first 3 columns
# df_stays <- df %>%
#   select(1:3, contains("Stays"))

df_stays <- extract_columns(data = df, word = "Stays")
head(df_stays)


## ----StaysLongFormatDataframe----------------------------------------------------------------------
# Show all the columns that contain the word ".Stays" in the data frame df_stays in long format
# df_stays.long.format <- df_stays %>%
#   pivot_longer(cols = contains("Stays"),
#                names_to = "CountryOfResidence",
#                values_to = "Stays")
df_stays.long.format <- to_long_format(data = df_stays, word = "Stays")
head(df_stays.long.format)


## ----StaysLongFormatDataframe2---------------------------------------------------------------------
# Remove .Overnight.stays from the CountryOfResidence values
df_stays.long.format$CountryOfResidence <- str_remove_all(string = df_stays.long.format$CountryOfResidence, pattern = ".Overnight.stays")
head(df_stays.long.format)


## ----JoinDataframes--------------------------------------------------------------------------------
# Join the dataframes df_arrivals.long.format and df_stays.long.format
df.long.format <- df_arrivals.long.format %>%
  inner_join(df_stays.long.format,
             by = c("Year", "Month", "Canton", "CountryOfResidence"))
head(df.long.format)


## ----DateColumn------------------------------------------------------------------------------------
# Create a new column Date from Year and Month
df.long.format$Date <- as.Date(paste("01", df.long.format$Month, df.long.format$Year, sep = " "),
                               format = "%d %B %Y")
df.long.format$Date <- format(df.long.format$Date, "%d-%m-%Y")
head(df.long.format)


## ----SeasonColumn----------------------------------------------------------------------------------
df.long.format <- df.long.format %>%
  mutate(
    Season = case_when(
      Month %in% c("December", "January", "February") ~ "Winter",
      Month %in% c("March", "April", "May") ~ "Spring",
      Month %in% c("June", "July", "August") ~ "Summer",
      Month %in% c("September", "October", "November") ~ "Fall",
      TRUE ~ NA_character_
    )
  )
View(df.long.format)


## ----ColumnOrder-----------------------------------------------------------------------------------
# Reorder columns by specifying the desired order
df.long.format <- df.long.format[, c(
  "Date",
  "Year",
  "Month",
  "Season",
  "Canton",
  "CountryOfResidence",
  "Arrivals",
  "Stays"
)]
head(df.long.format)
View(df.long.format)


# Export df.long.format to an .xslx file
write_xlsx(df.long.format, "data/df_long_format.xlsx")

# Extract all unique Swiss cantons in df.long.format as a new data frame
df.cantons <- df.long.format %>%
  select(Canton) %>%
  distinct()

write_csv(df.cantons, "data/swiss_cantons.csv")


View(df.cantons)


summary(df.long.format)
dim(df.long.format)

summary(df.long.format)


df.weather <- read.csv("data/combined_weather_data.csv",
               sep = ",")
View(df.weather)

# Check combined weather data for missing values
sum(is.na(df.weather))
