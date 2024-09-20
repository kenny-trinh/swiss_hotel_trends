# Swiss Hotel Stays and Weather Analysis

## Overview
This project analyzes Swiss hotel stays data in conjunction with weather data collected from 26 Swiss cantons. The main aim is to investigate how weather conditions influence tourism patterns, using data on overnight stays and various weather parameters such as temperature, snowfall, and rainfall.

## Project Structure

- **data/**: Contains the raw datasets, including weather data for each canton and hotel stay data.
- **scripts/**: All R scripts used for data cleaning, transformation, merging, visualization and model fitting.
- **output/**: Contains the cleaned hotel stays data, the merged weather data and final merged data.
- **Report_Hotel_Trends.Rmd**: The RMarkdown file for generating the project report.
- **readme.txt**: This file.

## Scripts Overview

1. **00_setup.R**  
   This script sets up the environment for the project. It installs and loads all necessary R packages if they are not already installed, and defines the data directories.

2. **01_data_cleaning.R**  
   This script handles the initial data import and cleaning for the hotel stays dataset. It:
   - Reads the dataset with the appropriate encoding.
   - Checks for missing values and replaces them.
   - Drops columns with only `NA` values and ensures that the data is cleaned and formatted correctly.
   - The cleaned dataset is then exported to an Excel file.

3. **02_data_transformation.R**  
   This script transforms the cleaned hotel stays dataset. Key tasks include:
   - Extracting and transforming data for arrivals and stays, converting them to a long format.
   - Joining the transformed arrivals and stays data into one final dataset (`d.hotel_stays_long_format`).
   - Adding a new `Date` column (based on `Year` and `Month`) and creating a `Season` column for analysis.
   - Reordering the columns in the final dataset for easier analysis.

4. **03_data_merging.R**  
   This script merges the hotel stays data with weather data collected from different cantons.  
   Key steps include:
   - Importing and processing weather data from multiple CSV files corresponding to different cantons.
   - Renaming the columns to remove special characters (such as the degree symbol in temperature columns).
   - Merging the cleaned weather dataset with the hotel stays dataset based on the `Date` and `Canton` columns.
   - Exporting the merged dataset to an Excel file for further analysis.

5. **04_data_exploration.R**  
   This script explores the merged hotel stays and weather dataset. Key tasks include:
   - Summarizing and visualizing the total overnight stays by canton and year using heatmaps.
   - Visualizing the top 10 nationalities visiting Switzerland by season.
   - Plotting the favorite cantons for top nationalities based on overnight stays.
   - Analyzing the relationships between weather variables (temperature, snowfall, and rainfall) and overnight stays using scatter plots and trend lines.
   
   Various plot and graphs are generated using `ggplot2` and made interactive with `plotly`.

   Note: Plots 9-11 take a long time to run.

6. **05_model_fitting.R**  
   This script fits basic linear regression models to explore the relationship between weather variables and overnight stays.  
   - Models are fitted to assess the impact of mean temperature, snowfall, and rainfall on overnight stays.
   - The model summaries are outputted to evaluate the effects of each weather variable.

## Packages Used

- **tidyverse**: A collection of R packages designed for data science, including ggplot2, dplyr, tidyr, and more.
- **lubridate**: For transforming and working with date data.
- **dplyr**: Provides a grammar of data manipulation, making it easier to work with data frames.
- **readr**: For reading and writing CSV files.
- **tidyr**: For tidying data, transforming it between wide and long formats.
- **stringr**: For working with strings and regular expressions.
- **purrr**: Functional programming tools to work with vectors and lists.
- **scales**: Ensures consistent formatting of axis labels in plots.
- **ggplot2**: For creating high-quality visualizations and plots.
- **writexl**: Allows writing data frames to Excel files (.xlsx format).
- **plotly**: Enables interactive plots and visualizations, especially for ggplot2 objects.
- **tidytext**: Used for reordering factors within plots.
- **tinytex**: A lightweight package to help compile LaTeX documents.
- **xfun**: Simplifies report rendering and document conversion.

## How to Run
1. Clone the repository from GitHub.
2. Ensure that R and RStudio are installed on your system.
3. Open each script (e.g., `00_setup.R`, `01_data_cleaning.R`) in RStudio and run the code chunk by chunk.
4. All outputs will be saved to the `output/` directory.

## GitHub Repository
You can find the full project code and datasets on our [GitHub repository](https://github.com/kenny-trinh/swiss_hotel_trends).