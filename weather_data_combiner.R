# Load necessary libraries
library(dplyr)
library(readr)
library(lubridate) # For date handling

# Define the paths to the CSV files
file_paths <- list(
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

# Initialize an empty list to store data frames
data_list <- list()

# Loop through the file paths and read each CSV, adding canton names
for (file_name in names(file_paths)) {
  canton_name <- file_paths[[file_name]]
  
  # Read the CSV file, automatically using the header from the file
  df <- read_csv(file_name, skip = 3) # Skipping metadata row
  
  # Convert the 'time' column to Date type if necessary
  if ("time" %in% names(df)) {
    df <- df %>%
      mutate(time = ymd(time)) %>%
      mutate(canton = canton_name) # Add canton name to each dataframe
  } else {
    df$canton <- canton_name # Add canton name if 'time' column is not present
  }
  
  data_list[[canton_name]] <- df
}

# Combine all data frames into one
combined_df <- bind_rows(data_list)

head(combined_df)

# Save the combined dataframe to a new CSV file
write_csv(combined_df, "data/combined_weather_data.csv")