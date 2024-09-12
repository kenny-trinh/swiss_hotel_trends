library(readr)
library(stringr)
library(sf)
library(leaflet)
library(lubridate)
library(dplyr)
library(tidyr)
library(scales)

# Load the data
overnight_stays <- read_csv("data/df_long_format.csv")

# Summarize the data: Calculate the total overnight stays for each canton
df_stays_summary <- df.long.format %>%
  group_by(Canton) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

# View the summarized data
head(df_stays_summary)

# Plot the data: Bar plot showing total overnight stays by canton
ggplot(df_stays_summary, aes(x = reorder(Canton, Total_Stays), y = Total_Stays)) +
  geom_bar(stat = "identity",fill = "Steelblue") +
  scale_y_continuous(labels = comma) +
  #geom_bar(stat = "identity",aes(fill = Canton))+ (to fill with colors)
  coord_flip() +  # Flip the coordinates to make the plot horizontal
  labs(title = "Total Overnight Stays by Canton from 2018 till 2023",
       x = "Canton",
       y = "Total Overnight Stays") +
  theme_minimal()



# Summarize the data: Calculate the total overnight stays for each country of residence
df_country_summary <- df.long.format %>%
  group_by(CountryOfResidence) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

# Filter to get the top 10 countries of residence
df_top10_countries <- df_country_summary %>%
  top_n(10, Total_Stays)

# View the summarized data for the top 10 countries
head(df_top10_countries)

# Plot the data: Bar plot showing total overnight stays by top 10 countries of residence
ggplot(df_top10_countries, aes(x = reorder(CountryOfResidence, Total_Stays), y = Total_Stays)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  scale_y_continuous(labels = scales::comma) +
  coord_flip() +  # Flip the coordinates to make the plot horizontal
  labs(title = "Top 10 Countries of Residence by Total Overnight Stays",
       x = "Country of Residence",
       y = "Total Overnight Stays") +
  theme_minimal()



# # Summarize the data: Calculate the total overnight stays for each country of residence by year
# df_yearly_summary <- df.long.format %>%
#   group_by(Year, CountryOfResidence) %>%
#   summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
#   arrange(Year, desc(Total_Stays))
# 
# # View the summarized data
# head(df_yearly_summary)
# 
# # Filter to get the top country of residence with the most overnight stays for each year
# df_top_country_by_year <- df_yearly_summary %>%
#   group_by(Year) %>%
#   top_n(1, Total_Stays)
# 
# # View the data for top country by year
# print(df_top_country_by_year)
# 
# # Plot the data: Line plot showing the top country of residence by year
# ggplot(df_top_country_by_year, aes(x = Year, y = Total_Stays, color = CountryOfResidence, group = CountryOfResidence)) +
#   geom_line(size = 1.5) +
#   geom_point(size = 3) +
#   labs(title = "Top Country of Residence by Total Overnight Stays Each Year",
#        x = "Year",
#        y = "Total Overnight Stays",
#        color = "Country of Residence") +
#   theme_minimal()



# Summarize the data: Calculate the total overnight stays for each country of residence
df_country_summary_total <- df.long.format %>%
  group_by(CountryOfResidence) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

# Identify the top 5 countries with the most overnight stays overall
top5_countries <- df_country_summary_total %>%
  top_n(5, Total_Stays) %>%
  pull(CountryOfResidence)

# Filter the original long format data to include only the top 5 countries
df_top5_countries_by_year <- df.long.format %>%
  filter(CountryOfResidence %in% top5_countries) %>%
  group_by(Year, CountryOfResidence) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE))

# Plot the data: Line plot showing total overnight stays by top 5 countries of residence over the years
ggplot(df_top5_countries_by_year, aes(x = Year, y = Total_Stays, color = CountryOfResidence, group = CountryOfResidence)) +
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Top 5 Countries of Residence by Total Overnight Stays Each Year",
       x = "Year",
       y = "Total Overnight Stays",
       color = "Country of Residence") +
  theme_minimal() +
  theme(legend.position = "right")  # Position the legend on the right for clarity




# Load necessary libraries

# Define the top countries based on the earlier analysis (top 10 shown in the image)
top_countries <- c("Switzerland", "Germany", "United.States", "United.Kingdom", "France",
                   "Italy", "China", "Netherlands", "Belgium", "India")

# Filter the original long format data to include only the top countries
df_top_countries_canton <- df.long.format %>%
  filter(CountryOfResidence %in% top_countries) %>%
  group_by(CountryOfResidence, Canton) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

# Identify the favorite canton for each country by selecting the one with the maximum stays
df_favorite_canton <- df_top_countries_canton %>%
  group_by(CountryOfResidence) %>%
  slice_max(Total_Stays, n = 1)

# View the favorite canton for each top country
head(df_favorite_canton)

# Plot the data: Bar plot showing the favorite canton for each of the top 10 countries of residence
ggplot(df_favorite_canton, aes(x = reorder(CountryOfResidence, -Total_Stays), y = Total_Stays, fill = Canton)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Favorite Canton for Top 10 Countries of Residence by Total Overnight Stays",
       x = "Country of Residence",
       y = "Total Overnight Stays",
       fill = "Favorite Canton") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability
