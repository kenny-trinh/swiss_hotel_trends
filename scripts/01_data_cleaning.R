## ----ImportData------------------------------------------------------------------------------------
# Read the CSV file with proper encoding
d.hotel_stays <- read_delim(
  file.path(data_dir, "swiss_hotel_stays.csv"),  # Use file.path for better cross-platform compatibility
  delim = ";",
  na = "...",
  locale = locale(encoding = "UTF-8")            # Ensure correct encoding
)

## ----DataPreview-----------------------------------------------------------------------------------
# Preview the data
glimpse(d.hotel_stays)  # More concise than head() and str()

## ----CheckNAValues---------------------------------------------------------------------------------
# Check for missing values in each column and total NA count
v.na_count <- colSums(is.na(d.hotel_stays))
total_na_count <- sum(v.na_count)

# Output NA summary
print(v.na_count)
print(total_na_count)

## ----DropLogicalColumns-------------------------------------------------------------------------------
# Drop logical columns (columns with only NA values)
d.hotel_stays_cleaned <- d.hotel_stays %>%
  select(-where(is.logical))

## ----CheckRemainingNA-------------------------------------------------------------------------------
# Check for remaining missing values
colSums(is.na(d.hotel_stays_cleaned))

# Replace NA values with 0
d.hotel_stays_cleaned[is.na(d.hotel_stays_cleaned)] <- 0

# Confirm that no NA values remain
print(sum(is.na(d.hotel_stays_cleaned)))

## ----FinalPreview-----------------------------------------------------------------------------------
# Preview the cleaned data
glimpse(d.hotel_stays_cleaned)

# Export the cleaned data frame to an Excel file
write_xlsx(d.hotel_stays_cleaned, file.path(output_dir, "hotel_stays_cleaned.xlsx"))