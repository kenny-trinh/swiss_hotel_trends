# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the data
weather_data <- read.csv('path_to_your_file/combined_weather_data.csv')

# Convert the 'time' column to Date format
weather_data$time <- as.Date(weather_data$time, format = "%d-%m-%y")

# Create a new column for the year
weather_data$year <- format(weather_data$time, "%Y")

# Filter data between 2018 and 2023
filtered_data <- weather_data %>%
  filter(year >= 2018 & year <= 2023)

# Group by year and canton to calculate the mean temperature
mean_temp_by_year_canton <- filtered_data %>%
  group_by(year, canton) %>%
  summarise(mean_temp = mean(`temperature_2m_mean (°C)`, na.rm = TRUE))

# Convert the 'year' column back to numeric for plotting
mean_temp_by_year_canton$year <- as.numeric(mean_temp_by_year_canton$year)

# Create the plot
ggplot(mean_temp_by_year_canton, aes(x = year, y = mean_temp, color = canton, group = canton)) +
  geom_line() +
  geom_point() +
  labs(title = 'Average Temperature per Year from 2018 to 2023 by Canton',
       x = 'Year', 
       y = 'Average Temperature (°C)') +
  theme_minimal() +
  theme(legend.title = element_blank())
