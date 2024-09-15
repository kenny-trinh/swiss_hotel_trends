# Import libraries
library(httr)
library(jsonlite)

# Function to fetch weather data for a given location and date range
fetch_weather_data <- function(lat, lon, start_date, end_date) {
  url <- paste0("https://archive-api.open-meteo.com/v1/archive?latitude=", lat,
                "&longitude=", lon, "&start_date=", start_date, "&end_date=", end_date,
                "&daily=temperature_2m_max,temperature_2m_min,temperature_2m_mean,rain_sum,snowfall_sum",
                "&timezone=auto")  # Set timezone to auto
  
  # Send GET request
  response <- GET(url)
  
  # Check if the request was successful
  if (status_code(response) != 200) {
    return(data.frame())  # Return empty if request fails
  }
  
  # Parse the response JSON data
  weather_data <- fromJSON(content(response, "text"))
  
  # Check if daily data is available
  if (is.null(weather_data$daily) || length(weather_data$daily) == 0) {
    return(data.frame())  # Return empty if no data
  }
  
  # Convert to data frame and add date column
  weather_df <- as.data.frame(weather_data$daily)
  weather_df$date <- as.Date(weather_data$daily$time)
  
  return(weather_df)
}

# Read the CSV file with canton locations
canton_data <- read.csv("data/swiss_cantons_locations.csv")

# Define the start and end date
start_date <- "2018-01-01"
end_date <- "2023-12-31"

# Initialize an empty list to store the weather data for each canton
all_weather_data <- list()

# Loop over each canton in the CSV
for (i in 1:nrow(canton_data)) {
  canton_name <- canton_data$Canton[i]
  lat <- canton_data$Latitude[i]
  lon <- canton_data$Longitude[i]
  
  # Fetch weather data for the current canton
  print(paste("Fetching weather data for:", canton_name))
  canton_weather <- fetch_weather_data(lat, lon, start_date, end_date)
  
  # Check if the data frame is empty
  if (nrow(canton_weather) == 0) {
    print(paste("No data found for:", canton_name))
    next  # Skip to the next iteration
  }
  
  # Add canton information to the data frame
  canton_weather$canton <- canton_name
  canton_weather$capital <- canton_data$Capital[i]
  
  # Append the canton weather data to the list
  all_weather_data[[canton_name]] <- canton_weather
}

# Combine all the canton weather data into a single data frame
combined_weather_data <- do.call(rbind, all_weather_data)

# View the combined data (optional)
print(head(combined_weather_data))

# Save the combined data to a CSV
write.csv(combined_weather_data, "data/swiss_cantons_weather_data_2018_2023.csv", row.names = FALSE)
