## ----ImportData------------------------------------------------------------------------------------
# Read the CSV file with proper encoding
d.hotel_stays <- read_delim(
  paste0(data_dir, "swiss_hotel_stays.csv"),
  delim = ";",
  na = "...",
  locale = locale(encoding = "UTF-8")  # Ensure correct encoding
)

## ----DataPreview-----------------------------------------------------------------------------------
# Preview the data and its structure
head(d.hotel_stays)
str(d.hotel_stays)

## ----CheckNAValues---------------------------------------------------------------------------------
# Check for missing values
v.na_count <- sapply(d.hotel_stays, function(x) sum(is.na(x)))

# Sum of total NA values
sum(v.na_count)

## ----ColumnTypes-----------------------------------------------------------------------------------
# Show the type of all columns
v.column_types <- sapply(d.hotel_stays, class)

# Create a data frame with logical columns
d.hotel_stays_logical <- d.hotel_stays %>%
  select_if(is.logical)

head(d.hotel_stays_logical)  # Preview logical columns (mostly NA)
str(d.hotel_stays_logical)

## ----DropLogicalColumns-------------------------------------------------------------------------------
# Drop logical (all NA) columns from the data frame and store it as a cleaned version
d.hotel_stays_cleaned <- d.hotel_stays %>%
  select(-where(is.logical))

# Check to confirm no logical columns remain
head(d.hotel_stays_cleaned %>% select(where(is.logical)))

# Final structure of the cleaned data frame
head(d.hotel_stays_cleaned)
str(d.hotel_stays_cleaned)
