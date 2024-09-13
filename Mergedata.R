# Load necessary libraries
library(readr)
library(dplyr)
library(scales)  # Load the scales package for better axis formatting
library(ggplot2)

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

# Step 2: Export the Merged Data to Excel
# Now that the data is merged, export it as an Excel file:

# Install and load the writexl package if needed
install.packages("writexl")
library(writexl)

# Export the merged dataset to an Excel file
write_xlsx(combined_data, "combined_data.xlsx")

# Check where the file is saved
getwd()  # This will show the directory where the Excel file is saved



# # Plot 1: Trend of Overnight Stays Over Time with improved y-axis formatting
# ggplot(combined_data, aes(x = Date, y = Stays, color = Canton)) +
#   geom_line() +
#   scale_y_continuous(labels = scales::comma) +  # Use commas for large numbers
#   labs(title = "Overnight Stays Over Time in Different Cantons",
#        x = "Date",
#        y = "Overnight Stays") +
#   theme_minimal()
# 
# # Summarize total stays per canton
# top_cantons <- combined_data %>%
#   group_by(Canton) %>%
#   summarize(total_stays = sum(Stays, na.rm = TRUE)) %>%
#   arrange(desc(total_stays)) %>%
#   slice(1:10)  # Get the top 5 cantons by total stays
# 
# # Print the top 10 cantons to verify
# print(top_cantons)
# 
# # Filter combined_data for only the top 10 cantons
# filtered_data <- combined_data %>%
#   filter(Canton %in% top_cantons$Canton)
# 
# # Plot 1.a: Trend of Overnight Stays Over Time for the Top 10 Cantons
# 
# ggplot(filtered_data, aes(x = Date, y = Stays, color = Canton)) +
#   geom_line() +
#   scale_y_continuous(labels = scales::comma) +  # Use commas for large numbers
#   labs(title = "Overnight Stays Over Time in Top 10 Cantons",
#        x = "Date",
#        y = "Overnight Stays") +
#   theme_minimal()

# Sum of total overnight stays per canton and year
total_stays_by_canton <- combined_data %>%
  group_by(Canton, Year) %>%
  summarize(total_stays = sum(Stays, na.rm = TRUE))

# Sum of total overnight stays per canton and year
total_stays_by_canton <- combined_data %>%
  group_by(Canton, Year) %>%
  summarize(total_stays = sum(Stays, na.rm = TRUE))
# Plot for each canton using facet_wrap
ggplot(total_stays_by_canton, aes(x = Year, y = total_stays, fill = Canton)) +
  geom_bar(stat = "identity") +  # Bar plot
  scale_y_continuous(labels = scales::comma) +  # Use commas for large numbers
  labs(title = "Total Overnight Stays by Year for Each Canton",
       x = "Year",
       y = "Total Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "free_y", ncol = 3) 

#Total Overnight Stays by Canton from year 2018 to 2023
ggplot(total_stays_by_canton, aes(x = reorder(Canton, -total_stays), y = total_stays)) +
  geom_bar(stat = "identity", fill = "steelblue") +  # Creates the bar plot
  scale_y_continuous(labels = comma) +  # Use commas for large numbers on the y-axis
  labs(title = "Total Overnight Stays by Canton from year 2018 to 2023",
       x = "Canton",
       y = "Total Overnight Stays") +
  theme_minimal() +
  coord_flip() 

# Plot 2: Relationship Between Mean Temperature and Overnight Stays
library(ggplot2)
library(scales)  # For axis formatting

# Plot 2: Relationship Between Mean Temperature and Overnight Stays with fixed y-axis
# ggplot(combined_data, aes(x = `temperature_2m_mean (°C)`, y = Stays, color = Canton)) +
#   geom_point(alpha = 0.6) +     # Scatter plot of data points
#   geom_smooth(method = "lm", se = FALSE) +   # Add a linear trend line
#   scale_y_continuous(labels = comma) +       # Fix y-axis to show comma-separated numbers
#   labs(title = "Effect of Mean Temperature on Overnight Stays",
#        x = "Mean Temperature (°C)",
#        y = "Overnight Stays") +
#   theme_minimal()

# Facet by Canton to see trends individually
ggplot(combined_data, aes(x = `temperature_2m_mean (°C)`, y = Stays, color = Canton)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_y_continuous(labels = comma) +
  labs(title = "Effect of Mean Temperature on Overnight Stays by Canton",
       x = "Mean Temperature (°C)",
       y = "Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "free_y")  # Facet by canton to see trends separately

# Fit a linear regression model to test if temperature has a significant effect on stays
model <- lm(Stays ~ `temperature_2m_mean (°C)`, data = combined_data)
summary(model)

############### Snowfall vs overnight stays

# Plot snowfall vs overnight stays, faceted by canton
ggplot(combined_data, aes(x = `snowfall_sum (cm)`, y = Stays, color = Canton)) +
  geom_point(alpha = 0.6) +  # Scatter plot of snowfall and stays
  geom_smooth(method = "lm", se = FALSE) +  # Add a linear trend line
  scale_y_continuous(labels = scales::comma) +  # Format y-axis with commas
  labs(title = "Effect of Snowfall on Overnight Stays by Canton",
       x = "Snowfall (cm)",
       y = "Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "free_y")  # Create separate plots for each canton with independent y-axes

############### Rainfall and Stay###
library(ggplot2)

# Plot rainfall vs overnight stays, faceted by canton
ggplot(combined_data, aes(x = `rain_sum (mm)`, y = Stays, color = Canton)) +
  geom_point(alpha = 0.6) +  # Scatter plot of rainfall and stays
  geom_smooth(method = "lm", se = FALSE) +  # Add a linear trend line for each canton
  scale_y_continuous(labels = scales::comma) +  # Format y-axis with commas
  labs(title = "Effect of Rainfall on Overnight Stays by Canton",
       x = "Rainfall (mm)",
       y = "Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "free_y")  # Facet by canton with independent y-axes


###### TOurist ####
# Filter out Switzerland from the data
tourists_data <- overnight_stays %>%
  filter(CountryOfResidence != "Switzerland")

# View the filtered data
head(tourists_data)

# Summarize the data by season and nationality, filtering out Switzerland
top_nationalities_season <- tourists_data %>%
  group_by(Season, CountryOfResidence) %>%
  summarize(total_stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(Season, desc(total_stays))  # Sort by season and stays

# Get top 10 nationalities for each season
top_10_nationalities_per_season <- top_nationalities_season %>%
  group_by(Season) %>%
  top_n(10, total_stays)  # Select the top 10 nationalities for each season

# Plot the top 10 nationalities for each season
ggplot(top_10_nationalities_per_season, aes(x = reorder(CountryOfResidence, -total_stays), y = total_stays, fill = CountryOfResidence)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) +  # Use commas for large numbers
  facet_wrap(~ Season, scales = "free_y") +  # Facet by season
  labs(title = "Top 10 Nationalities Visiting in Each Season",
       x = "Country of Residence",
       y = "Total Overnight Stays") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for readability


