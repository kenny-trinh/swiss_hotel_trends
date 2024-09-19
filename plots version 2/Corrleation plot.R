# Load necessary libraries
library(readr)
library(dplyr)
library(scales)  # Load the scales package for better axis formatting
library(ggplot2)
library(writexl)

# Load the data
overnight_stays <- read_csv("data/df_long_format.csv")
weather_data <- read_csv("data/combined_weather_data.csv")

# Check structure
str(overnight_stays)
str(weather_data)

# View a sample of the data
head(overnight_stays)
head(weather_data)

# Convert Date in overnight_stays to Date format (assume it's in day-month-year order)
overnight_stays <- overnight_stays %>%
  mutate(Date = dmy(Date))  # Using the dmy() function from lubridate

# Convert time in weather_data to Date format (also assuming day-month-year order)
weather_data <- weather_data %>%
  mutate(time = dmy(time))  # Adjust as needed depending on the actual format

# Merge the two datasets on Canton and Date
combined_data <- merge(overnight_stays, weather_data, by.x = c("Canton", "Date"), by.y = c("canton", "time"))

# View the first few rows of the merged dataset to ensure it worked
head(combined_data)


# Export the merged dataset to an Excel file
write_xlsx(combined_data, "combined_data.xlsx")

# Check where the file is saved
getwd()  # This will show the directory where the Excel file is saved

#----- Plot 8: Relationship Between Mean Temperature and Overnight Stays------------------#

ggplot(combined_data, aes(x = `temperature_2m_mean (°C)`, y = Stays, color = Canton)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_y_continuous(labels = comma) +
  labs(title = "Effect of Mean Temperature on Overnight Stays by Canton",
       x = "Mean Temperature (°C)",
       y = "Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "fixed", labeller = label_wrap_gen(width = 20)) +  # Adjusts width of the labels
  theme(strip.text = element_text(size = 7.5))  # Adjust font size for canton labels

#----- Plot 9: Relationship Between snowfall and Overnight Stays------------------#
ggplot(combined_data, aes(x = `snowfall_sum (cm)`, y = Stays, color = Canton)) +
  geom_point(alpha = 0.6) +  # Scatter plot of snowfall and stays
  geom_smooth(method = "lm", se = FALSE) +  # Add a linear trend line
  scale_y_continuous(labels = scales::comma) +  # Format y-axis with commas
  labs(title = "Effect of Snowfall on Overnight Stays by Canton",
       x = "Snowfall (cm)",
       y = "Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "fixed", labeller = label_wrap_gen(width = 20)) +  # Adjusts width of the labels
  theme(strip.text = element_text(size = 7.5))  # Adjust font size for canton labels 

#----- Plot 10: Relationship Between Mean Temperature and Overnight Stays------------------#

# Plot rainfall vs overnight stays, faceted by canton
ggplot(combined_data, aes(x = `rain_sum (mm)`, y = Stays, color = Canton)) +
  geom_point(alpha = 0.6) +  # Scatter plot of rainfall and stays
  geom_smooth(method = "lm", se = FALSE) +  # Add a linear trend line for each canton
  scale_y_continuous(labels = scales::comma) +  # Format y-axis with commas
  labs(title = "Effect of Rainfall on Overnight Stays by Canton",
       x = "Rainfall (mm)",
       y = "Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "fixed", labeller = label_wrap_gen(width = 20)) +  # Adjusts width of the labels
  theme(strip.text = element_text(size = 7.5))  # Adjust font size for canton labels


###### MODEL FITTING ######

# Linear regression for temperature effect
model_temp <- lm(Stays ~ `temperature_2m_mean (°C)`, data = combined_data)
summary(model_temp)

# Linear regression for snowfall effect
model_snow <- lm(Stays ~ `snowfall_sum (cm)`, data = combined_data)
summary(model_snow)

# Linear regression for temperature effect
model_temp <- lm(Stays ~ `temperature_2m_mean (°C)`, data = combined_data)
summary(model_temp)
