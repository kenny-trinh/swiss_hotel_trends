# Load necessary libraries
library(ggplot2)
library(dplyr)
library(plotly)

# Load the data
weather_data <- read.csv('data/combined_weather_data.csv')
head(weather_data)
colnames(weather_data)

# Convert 'time' to Date type and extract month and year
weather_data$time <- as.Date(weather_data$time, format = "%d-%m-%y")
weather_data$year <- format(weather_data$time, "%Y")
weather_data$month <- format(weather_data$time, "%B")  # Full month name

# Aggregate the data by canton, month, and year to get the average monthly temperature
# Using the full column name as seen in colnames
monthly_weather_data <- weather_data %>%
  group_by(canton, year, month) %>%
  summarise(mean_temp = mean(temperature_2m_mean...C, na.rm = TRUE))

##----- Plot 6:Heatmap of Average Monthly Temperature by Canton ------------------#

#Correcting the months in order 
weather_data$month <- factor(weather_data$month, 
                             levels = c("January", "February", "March", "April", "May", 
                                        "June", "July", "August", "September", "October", 
                                        "November", "December"))

# calculating the monthly average temperature from year 2018 to 2023
monthly_avg_temp <- weather_data %>%
  group_by(canton, month) %>%
  summarize(avg_temp = mean(temperature_2m_mean...C, na.rm = TRUE))

# Creating the heatmap with the average monthly temperature
p_temperature <- ggplot(monthly_avg_temp, aes(x = month, y = canton, fill = avg_temp)) +
  geom_tile() +
  scale_fill_gradient(low = "blue",high = "orange", name = "Avg Temp (°C)") +
  labs(
    title = "Heatmap of Average Monthly Temperature by Canton",
    x = "Month",
    y = "Canton"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)  # Adjust month labels for readability
  )
ggplotly(p_temperature)

##----- Plot 7:Heatmap of Average Snowfall by Canton ------------------#
# Ensuring that the months are ordered correctly
weather_data$month <- factor(weather_data$month, 
                             levels = c("January", "February", "March", "April", "May", 
                                        "June", "July", "August", "September", "October", 
                                        "November", "December"))

# Calculating the monthly average temperature from year 2018 to 2023
monthly_avg_snowfall <- weather_data %>%
  group_by(canton, month) %>%
  summarize(avg_snowfall = mean(`snowfall_sum (cm)`, na.rm = TRUE))



#heatmap with the average monthly snowfall
p_snowfall <- ggplot(monthly_avg_snowfall, aes(x = month, y = canton, fill = avg_snowfall)) +
  geom_tile() +
  scale_fill_gradient(low = "grey", high = "yellow", name = "Avg Snowfall (cm)") +
  labs(
    title = "Heatmap of Average Monthly Snowfall by Canton",
    x = "Month",
    y = "Canton"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)  # Adjust month labels for readability
  )

# ggplotly for interactivity
ggplotly(p_snowfall)



