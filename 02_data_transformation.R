# Function to extract relevant columns based on a specific word and transform them to long format
extract_and_transform <- function(d.data, word, pattern_to_remove) {
  d.data %>%
    select(1:3, contains(word)) %>%             # Select first 3 columns and columns containing the word
    pivot_longer(cols = contains(word),         # Pivot the selected columns to long format
                 names_to = "CountryOfResidence",
                 values_to = word) %>%
    mutate(CountryOfResidence = str_remove_all(CountryOfResidence, pattern_to_remove)) # Remove pattern from CountryOfResidence
}

## ----ArrivalsDataframe-----------------------------------------------------------------------------
# Extract and transform arrivals data
d.arrivals_long_format <- extract_and_transform(d.data = d.hotel_stays_cleaned, word = "Arrivals", pattern_to_remove = ".Arrivals")
head(d.arrivals_long_format)

## ----StaysDataframe--------------------------------------------------------------------------------
# Extract and transform stays data
d.stays_long_format <- extract_and_transform(d.data = d.hotel_stays_cleaned, word = "Stays", pattern_to_remove = ".Overnight.stays")
head(d.stays_long_format)

## ----JoinDataframes--------------------------------------------------------------------------------
# Join the transformed data frames
d.hotel_stays_long_format <- d.arrivals_long_format %>%
  inner_join(d.stays_long_format, by = c("Year", "Month", "Canton", "CountryOfResidence"))
head(d.hotel_stays_long_format)

## ----DateAndSeasonColumns---------------------------------------------------------------------------

# Create a new Date column from Year and Month in the correct format, followed by Season calculation
d.hotel_stays_long_format <- d.hotel_stays_long_format %>%
  mutate(
    # Create Date column
    #Date = format(as.Date(paste("01", Month, Year, sep = " "), format = "%d %B %Y"), "%d-%m-%Y"),
    #Date = as.Date(paste("01", Month, Year, sep = " "), format = "%d %B %Y"),
    Date = dmy(paste("01", Month, Year)),
    
    # Create Season column
    Season = case_when(
      Month %in% c("December", "January", "February") ~ "Winter",
      Month %in% c("March", "April", "May") ~ "Spring",
      Month %in% c("June", "July", "August") ~ "Summer",
      Month %in% c("September", "October", "November") ~ "Fall",
      TRUE ~ NA_character_
    )
  )

# Check the structure of Date to confirm it's in Date format
str(d.hotel_stays_long_format)

## ----ColumnOrder-----------------------------------------------------------------------------------
# Reorder columns by specifying the desired order
d.hotel_stays_long_format <- d.hotel_stays_long_format %>%
  select(
    Date,
    Year,
    Month,
    Season,
    Canton,
    CountryOfResidence,
    Arrivals,
    Stays
  )

# Check the head of the reordered data
head(d.hotel_stays_long_format)

