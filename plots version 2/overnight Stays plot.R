
# Load necessary libraries
library(readr)
library(stringr)
library(sf)
library(leaflet)
library(lubridate)
library(dplyr)
library(tidyr)
library(scales)
library(plotly)

# Load the data
overnight_stays <- read_csv("data/df_long_format.csv")
head(overnight_stays)

# Summarize the data: Calculate the total overnight stays for each canton
df_stays_summary <- df.long.format %>%
  group_by(Canton) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

# View the summarized data
head(df_stays_summary)

# Sum of total overnight stays per canton and year
total_stays_by_canton <- df.long.format %>%
  group_by(Canton, Year) %>%
  summarize(total_stays = sum(Stays, na.rm = TRUE))

# Sum of total overnight stays per canton and year
total_stays_by_canton <- df.long.format %>%
  group_by(Canton, Year) %>%
  summarize(total_stays = sum(Stays, na.rm = TRUE))

#----- Plot 1: Heatmap of Total Overnight Stays by Canton and Year------------------#

# Heatmap showing total overnight stays by canton and year
p_overnightstay <- ggplot(total_stays_by_canton, aes(x = Year, y = reorder(Canton, total_stays), fill = total_stays)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "lightblue", high = "darkblue", labels = scales::comma) +  # Gradient for total stays
  labs(
    title = "Heatmap of Total Overnight Stays by Canton and Year",
    x = "Year",
    y = "Canton",
    fill = "Total Stays"
  ) +
  theme_minimal()

ggplotly(p_overnightstay) # ggplotly for interactivity


#----- Plot 2: "Top 10 Countries of Residence by Total Overnight Stays------------------#

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


#----- Plot 3: Percentage of Overnight Stays by Swiss Residence vs Foreign Residence------------------#

# Summarize the total number of stays for Switzerland and the rest of the world by year
origin_summary_year <- df.long.format  %>%
  mutate(Origin = ifelse(CountryOfResidence == "Switzerland", "Swiss Residence", "Foreign Residence")) %>%
  group_by(Year, Origin) %>%
  summarize(total_stays = sum(Stays, na.rm = TRUE)) %>%
  mutate(percentage = total_stays / sum(total_stays) * 100)  # Calculate percentages for each year

# Bar plot to show the percentage of overnight stays for Switzerland vs the rest of the world for each year
ggplot(origin_summary_year, aes(x = as.factor(Year), y = percentage, fill = Origin)) +
  geom_bar(stat = "identity", position = "fill", alpha = 0.85) +  # Added transparency
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Percentage of Overnight Stays by Swiss Residence vs Foreign Residence",
    x = "Year",
    y = "Percentage"
  ) +
  theme_minimal()


#----- Plot 4: "Top 5 Countries of Residence by Total Overnight Stays Each Year------------------#

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


#----- Plot 5: "Top 10 Nationalities Visiting in Each Season------------------#

# Filter top 10 nationalities separately for each season
top_10_nationalities_per_season <- top_nationalities_season %>%
  group_by(Season) %>%
  top_n(10, wt = total_stays)  # Get the top 10 countries based on total stays for each season

# Plot for all seasons with top 10 nationalities per season
ggplot(top_10_nationalities_per_season, aes(x = reorder_within(CountryOfResidence, -total_stays, Season), y = total_stays, fill = CountryOfResidence)) +
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
top_countries <- c("Switzerland", "Germany", "United.States", "United.Kingdom", "France",
                   "Italy", "China", "Netherlands", "Belgium", "India")

# Filter the original long format data to include only the top countries
df_top_countries_canton <- df.long.format %>%
  filter(CountryOfResidence %in% top_countries) %>%
  group_by(CountryOfResidence, Canton) %>%
  summarise(Total_Stays = sum(Stays, na.rm = TRUE)) %>%
  arrange(desc(Total_Stays))

#  favorite canton for each country by selecting the one with the maximum stays
df_favorite_canton <- df_top_countries_canton %>%
  group_by(CountryOfResidence) %>%
  slice_max(Total_Stays, n = 1)

# View the favorite canton for each top country
head(df_favorite_canton)

# Bar plot showing the favorite canton for each of the top 10 countries of residence
ggplot(df_favorite_canton, aes(x = reorder(CountryOfResidence, -Total_Stays), y = Total_Stays, fill = Canton)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Favorite Canton for Top 10 Countries of Residence by Total Overnight Stays",
       x = "Country of Residence",
       y = "Total Overnight Stays",
       fill = "Favorite Canton") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

