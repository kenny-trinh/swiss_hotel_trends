## ----CombineWeatherData-----------------------------------------------------------------------------------
# Define the paths to the CSV files with corresponding canton names
v.file_paths <- c(
  "data/weather/weather_aargau.csv" = "Aargau",
  "data/weather/weather_appenzell_ausserrhoden.csv" = "Appenzell Ausserrhoden",
  "data/weather/weather_appenzell_innerrhoden.csv" = "Appenzell Innerrhoden",
  "data/weather/weather_basel_city.csv" = "Basel-Stadt",
  "data/weather/weather_basel_landschaft.csv" = "Basel-Landschaft",
  "data/weather/weather_bern.csv" = "Bern",
  "data/weather/weather_fribourg.csv" = "Fribourg",
  "data/weather/weather_geneva.csv" = "Geneva",
  "data/weather/weather_glarus.csv" = "Glarus",
  "data/weather/weather_graubuenden.csv" = "Graubuenden",
  "data/weather/weather_jura.csv" = "Jura",
  "data/weather/weather_lucerne.csv" = "Lucerne",
  "data/weather/weather_neuchatel.csv" = "Neuchatel",
  "data/weather/weather_nidwalden.csv" = "Nidwalden",
  "data/weather/weather_obwalden.csv" = "Obwalden",
  "data/weather/weather_schaffhausen.csv" = "Schaffhausen",
  "data/weather/weather_schwyz.csv" = "Schwyz",
  "data/weather/weather_solothurn.csv" = "Solothurn",
  "data/weather/weather_st_gallen.csv" = "St. Gallen",
  "data/weather/weather_thurgau.csv" = "Thurgau",
  "data/weather/weather_ticino.csv" = "Ticino",
  "data/weather/weather_uri.csv" = "Uri",
  "data/weather/weather_valais.csv" = "Valais",
  "data/weather/weather_vaud.csv" = "Vaud",
  "data/weather/weather_zug.csv" = "Zug",
  "data/weather/weather_zurich.csv" = "Zurich"
)

# Function to read, process, and return a data frame for weather data
process_weather_data <- function(v.file_path, v.canton_name) {
  read_csv(v.file_path, skip = 3) %>%     # Skipping metadata row
    mutate(
      time = ymd(time),                   # Convert 'time' column to Date format
      Canton = v.canton_name              # Add canton name
    )
}


# Apply the function to all files and combine data frames
d.combined_weather_data <- map2_dfr(names(v.file_paths), v.file_paths, process_weather_data)


## ----DataPreview-----------------------------------------------------------------------------------
# Preview the combined data frame
head(d.combined_weather_data)


## ----CheckNAValues---------------------------------------------------------------------------------
# Check for missing values
v.na_count <- colSums(is.na(d.combined_weather_data))
total_na <- sum(v.na_count)

# Output the total NA count and column-wise NA summary
print(v.na_count)
print(total_na)


## ----CleanColumnNames-----------------------------------------------------------------------------------
# Convert column names to ASCII, removing special characters
clean_colnames <- colnames(d.combined_weather_data) %>%
  iconv(from = "UTF-8", to = "ASCII//TRANSLIT") %>%
  gsub("\\?C", "C", .)

# Apply cleaned column names
colnames(d.combined_weather_data) <- clean_colnames

# Manually rename columns with parentheses
d.combined_weather_data <- d.combined_weather_data %>%
  rename(
    temperature_2m_max_c = `temperature_2m_max (C)`,
    temperature_2m_min_c = `temperature_2m_min (C)`,
    temperature_2m_mean_c = `temperature_2m_mean (C)`,
    rain_sum_mm = `rain_sum (mm)`,
    snowfall_sum_cm = `snowfall_sum (cm)`
  )


# Verify the renaming was successful
print(colnames(d.combined_weather_data))


## ----SaveCleanedData-----------------------------------------------------------------------------------
# Save the combined weather dataframe to a new CSV file
write_csv(d.combined_weather_data, file.path(output_dir, "combined_weather_data.csv"))


## ----MergeData-------------------------------------------------------------------------------------------
# Perform the merge using inner_join on Date and Canton
d.merged_data <- d.hotel_stays_long_format %>%
  inner_join(d.combined_weather_data, by = c("Date" = "time", "Canton"))

# Preview the merged data
head(d.merged_data)

# Save the final merged dataframe to a new Excel file
write_xlsx(d.merged_data, file.path(output_dir, "merged_data.xlsx"))
