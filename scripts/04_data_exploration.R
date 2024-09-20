# Preview hotel stays data
head(d.hotel_stays_long_format)

# Summarize the data: Calculate the total overnight stays for each canton
d.hotel_stays_summary <- d.hotel_stays_long_format %>%
  group_by(Canton) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

# View the summarized data
head(d.hotel_stays_summary)

# Sum of total overnight stays per canton and year
df.total_stays_by_canton <- d.hotel_stays_long_format %>%
  group_by(Canton, Year) %>%
  summarize(total_stays = sum(Stays, na.rm = TRUE))


#----- Plot 1: Heatmap of Total Overnight Stays by Canton and Year------------------#

# Heatmap showing total overnight stays by canton and year
p.hotel_stays <- ggplot(df.total_stays_by_canton, aes(x = Year, y = reorder(Canton, total_stays), fill = total_stays)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "lightblue", high = "darkblue", labels = scales::comma) +  # Gradient for total stays
  labs(
    title = "Heatmap of Total Overnight Stays by Canton and Year",
    x = "Year",
    y = "Canton",
    fill = "Total Stays"
  ) +
  theme_minimal()

ggplotly(p.hotel_stays) # ggplotly for interactivity


#----- Plot 2: "Top 10 Countries of Residence by Total Overnight Stays------------------#

# Summarize the data: Calculate the total overnight stays for each country of residence
d.hotel_stays_summary <- d.hotel_stays_long_format %>%
  group_by(CountryOfResidence) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

# Filter to get the top 10 countries of residence
df.top10_countries <- d.hotel_stays_summary %>%
  top_n(10, Total_Stays)

# View the summarized data for the top 10 countries
head(df.top10_countries)

# Plot the data: Bar plot showing total overnight stays by top 10 countries of residence
ggplot(df.top10_countries, aes(x = reorder(CountryOfResidence, Total_Stays), y = Total_Stays)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  scale_y_continuous(labels = scales::comma) +
  coord_flip() +  # Flip the coordinates to make the plot horizontal
  labs(title = "Top 10 Countries of Residence by Total Overnight Stays",
       x = "Country of Residence",
       y = "Total Overnight Stays") +
  theme_minimal()


#----- Plot 3: Percentage of Overnight Stays by Swiss Residence vs Foreign Residence------------------#

# Summarize the total number of stays for Switzerland and the rest of the world by year
d.origin_summary_year <- d.hotel_stays_long_format %>%
  mutate(Origin = ifelse(CountryOfResidence == "Switzerland", "Swiss Residence", "Foreign Residence")) %>%
  group_by(Year, Origin) %>%
  summarize(total_stays = sum(Stays, na.rm = TRUE)) %>%
  mutate(percentage = total_stays / sum(total_stays) * 100)  # Calculate percentages for each year

# Bar plot to show the percentage of overnight stays for Switzerland vs the rest of the world for each year
ggplot(d.origin_summary_year, aes(x = as.factor(Year), y = percentage, fill = Origin)) +
  geom_bar(stat = "identity", position = "fill", alpha = 0.85) +  # Added transparency
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Percentage of Overnight Stays by Swiss Residence vs Foreign Residence",
    x = "Year",
    y = "Percentage"
  ) +
  theme_minimal()


#----- Plot 4: "Top 5 Countries of Residence by Total Overnight Stays Each Year------------------#
# Summarize the data: Calculate the total overnight stays for each country of residence
d.country_summary_total <- d.hotel_stays_long_format %>%
  group_by(CountryOfResidence) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

# Identify the top 5 countries with the most overnight stays overall
d.top5_countries <- d.country_summary_total %>%
  top_n(5, Total_Stays) %>%
  pull(CountryOfResidence)

# Filter the original long format data to include only the top 5 countries
d.top5_countries_by_year <- d.hotel_stays_long_format %>%
  filter(CountryOfResidence %in% d.top5_countries) %>%
  group_by(Year, CountryOfResidence) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE))

# Plot the data: Line plot showing total overnight stays by top 5 countries of residence over the years
ggplot(d.top5_countries_by_year, aes(x = Year, y = Total_Stays, color = CountryOfResidence, group = CountryOfResidence)) +
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Top 5 Countries of Residence by Total Overnight Stays Each Year",
       x = "Year",
       y = "Total Overnight Stays",
       color = "Country of Residence") +
  theme_minimal() +
  theme(legend.position = "right")  # Position the legend on the right for clarity


#----- Plot 5: "Top 10 Nationalities Visiting in Each Season------------------#
# Filter out Switzerland from the data
d.tourist_data <- d.hotel_stays_long_format %>%
  filter(CountryOfResidence != "Switzerland")

# Summarize the data by season and nationality, filtering out Switzerland
d.top_nationalities_season <- d.tourist_data %>%
  group_by(Season, CountryOfResidence) %>%
  summarize(total_stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(Season, desc(total_stays))  # Sort by season and stays

# Filter top 10 nationalities separately for each season
d.top_10_nationalities_per_season <- d.top_nationalities_season %>%
  group_by(Season) %>%
  top_n(10, wt = total_stays)  # Get the top 10 countries based on total stays for each season

# Plot for all seasons with top 10 nationalities per season
ggplot(d.top_10_nationalities_per_season, aes(x = reorder_within(CountryOfResidence, -total_stays, Season), y = total_stays, fill = CountryOfResidence)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.05))) +  # Ensure bars appear properly
  scale_x_reordered() +  # Reorders within each facet
  facet_wrap(~ Season, scales = "free_x") +  # Facet by season with free x-axis for each season
  labs(
    title = "Top 10 Nationalities Visiting in Each Season",
    x = "Country of Residence",
    y = "Total Overnight Stays"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Align country names underneath the bars
    strip.text = element_text(size = 12)  # Adjust size of facet titles (seasons)
  )


#----- Plot 6: ""Favorite Canton for Top 10 Countries of Residence by Total Overnight Stays"------------------#
# Define the top countries based on the earlier analysis (top 10 shown in the image)
v.top_countries <- c("Switzerland", "Germany", "United.States", "United.Kingdom", "France",
                     "Italy", "China", "Netherlands", "Belgium", "India")

# Filter the original long format data to include only the top countries
d.top_countries_canton <- d.hotel_stays_long_format %>%
  filter(CountryOfResidence %in% v.top_countries) %>%
  group_by(CountryOfResidence, Canton) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

#  favorite canton for each country by selecting the one with the maximum stays
d.favorite_canton <- d.top_countries_canton %>%
  group_by(CountryOfResidence) %>%
  slice_max(Total_Stays, n = 1)

# View the favorite canton for each top country
head(d.favorite_canton)

# Bar plot showing the favorite canton for each of the top 10 countries of residence
ggplot(d.favorite_canton, aes(x = reorder(CountryOfResidence, -Total_Stays), y = Total_Stays, fill = Canton)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Favorite Canton for Top 10 Countries of Residence by Total Overnight Stays",
       x = "Country of Residence",
       y = "Total Overnight Stays",
       fill = "Favorite Canton") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability


#------ Weather Data Analysis -------------------------------------------------#
# Preview the combined weather data
head(d.combined_weather_data)
colnames(d.combined_weather_data)

# Convert 'time' to Date type and extract month and year
d.combined_weather_data$time <- as.Date(d.combined_weather_data$time, format = "%d-%m-%y")
d.combined_weather_data$year <- format(d.combined_weather_data$time, "%Y")
d.combined_weather_data$month <- format(d.combined_weather_data$time, "%B")  # Full month name

# Aggregate the data by canton, month, and year to get the average monthly temperature
# Using the full column name as seen in colnames
d.monthly_weather_data <- d.combined_weather_data %>%
  group_by(Canton, year, month) %>%
  summarise(mean_temp = mean(temperature_2m_mean_c, na.rm = TRUE))

##----- Plot 7:Heatmap of Average Monthly Temperature by Canton ------------------#
#Correcting the months in order 
d.combined_weather_data$month <- factor(d.combined_weather_data$month, 
                                        levels = c("January", "February", "March", "April", "May", 
                                                   "June", "July", "August", "September", "October", 
                                                   "November", "December"))

# calculating the monthly average temperature from year 2018 to 2023
d.monthly_avg_temp <- d.combined_weather_data %>%
  group_by(Canton, month) %>%
  summarize(avg_temp = mean(temperature_2m_mean_c, na.rm = TRUE))

# Creating the heatmap with the average monthly temperature
p.temperature <- ggplot(d.monthly_avg_temp, aes(x = month, y = Canton, fill = avg_temp)) +
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
ggplotly(p.temperature)


##----- Plot 8:Heatmap of Average Snowfall by Canton ------------------#
# Ensuring that the months are ordered correctly
d.combined_weather_data$month <- factor(d.combined_weather_data$month, 
                                        levels = c("January", "February", "March", "April", "May", 
                                                   "June", "July", "August", "September", "October", 
                                                   "November", "December"))

# Calculating the monthly average temperature from year 2018 to 2023
d.monthly_avg_snowfall <- d.combined_weather_data %>%
  group_by(Canton, month) %>%
  summarize(avg_snowfall = mean(snowfall_sum_cm, na.rm = TRUE))



#heatmap with the average monthly snowfall
p_snowfall <- ggplot(d.monthly_avg_snowfall, aes(x = month, y = Canton, fill = avg_snowfall)) +
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


#----- Plot 9: Relationship Between Mean Temperature and Overnight Stays------------------#

ggplot(d.merged_data, aes(x = temperature_2m_mean_c, y = Stays, color = Canton)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_y_continuous(labels = comma) +
  labs(title = "Effect of Mean Temperature on Overnight Stays by Canton",
       x = "Mean Temperature (°C)",
       y = "Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "fixed", labeller = label_wrap_gen(width = 16)) +  # Adjusts width of the labels
  theme(strip.text = element_text(size = 7.5)) +  # Adjust font size for canton labels
  theme(
    plot.title = element_text(size = 12)
)


#----- Plot 10: Relationship Between snowfall and Overnight Stays------------------#
ggplot(d.merged_data, aes(x = snowfall_sum_cm, y = Stays, color = Canton)) +
  geom_point(alpha = 0.6) +  # Scatter plot of snowfall and stays
  geom_smooth(method = "lm", se = FALSE) +  # Add a linear trend line
  scale_y_continuous(labels = scales::comma) +  # Format y-axis with commas
  labs(title = "Effect of Snowfall on Overnight Stays by Canton",
       x = "Snowfall (cm)",
       y = "Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "fixed", labeller = label_wrap_gen(width = 16)) +  # Adjusts width of the labels
  theme(strip.text = element_text(size = 7.5)) +  # Adjust font size for canton labels
  theme(
    plot.title = element_text(size = 12)
)


#----- Plot 11: Relationship Between Mean Temperature and Overnight Stays------------------#

# Plot rainfall vs overnight stays, faceted by canton
ggplot(d.merged_data, aes(x = rain_sum_mm, y = Stays, color = Canton)) +
  geom_point(alpha = 0.6) +  # Scatter plot of rainfall and stays
  geom_smooth(method = "lm", se = FALSE) +  # Add a linear trend line for each canton
  scale_y_continuous(labels = scales::comma) +  # Format y-axis with commas
  labs(title = "Effect of Rainfall on Overnight Stays by Canton",
       x = "Rainfall (mm)",
       y = "Overnight Stays") +
  theme_minimal() +
  facet_wrap(~ Canton, scales = "fixed", labeller = label_wrap_gen(width = 16)) +  # Adjusts width of the labels
  theme(strip.text = element_text(size = 7.5)) +  # Adjust font size for canton labels
  theme(
    plot.title = element_text(size = 12)
)