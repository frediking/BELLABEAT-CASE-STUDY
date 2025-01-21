# Load required libraries
install.packages("skimr")          # Collection of R packages for data manipulation and visualization
install.packages("scales")         # Graphical scales provide methods for automatically determining breaks and labels for axes and legends
install.packages("hrbrthemes")     # Provides themes and tools for creating ggplot2 visualizations
library(tidyverse)                 # Collection of R packages for data manipulation and visualization
library(lubridate)                 # Functions to work with date-time objects 
library(scales)                    # Graphical scales provide methods for automatically determining breaks and labels for axes and legends
library(skimr)                      
library(dplyr)                     # Data manipulation and transformation                 
library(tidyr)                     # Tools for data tidying
library(readr)                     # Read flat files
library(hrbrthemes)                # Themes and tools for creating ggplot2 visualizations
library(ggplot2)                   # Data visualization package
library(extrafont)                 # Load the extrafont package

# Import datasets
daily_activity <- read_csv("dailyActivity_merged.csv", show_col_types = FALSE)
sleep_day <- read_csv("sleepDay_merged.csv", show_col_types = FALSE)
hourly_steps <- read_csv("hourlySteps_merged.csv", show_col_types = FALSE)
weight_log <- read_csv("weightLogInfo_merged.csv", show_col_types = FALSE)

# Check column specifications
spec(daily_activity)
spec(sleep_day)

# DATA CLEANING AND PREPARATION

# Convert date strings to Date/DateTime format
daily_activity <- daily_activity %>%
  mutate(ActivityDate = as.Date(ActivityDate, format = "%m/%d/%Y"))

sleep_day <- sleep_day %>%
  mutate(SleepDay = as.Date(SleepDay, format = "%m/%d/%Y"))

hourly_steps <- hourly_steps %>%
  mutate(ActivityHour = as.POSIXct(ActivityHour, format = "%m/%d/%Y %H:%M", tz = "UTC"))      # Convert to POSIXct format with UTC timezone. 
                                                                                              # POSIXct is a date-time class that stores date and time information

# Remove duplicates and check for missing values
daily_activity <- distinct(daily_activity)
sleep_day <- distinct(sleep_day)
hourly_steps <- distinct(hourly_steps)

# Basic statistics and data exploration
daily_activity_summary <- daily_activity %>%                                     # Use the daily_activity data frame
  summarise(                                                                     # Calculate summary statistics 
    avg_steps = mean(TotalSteps),                                                            # average daily steps
    avg_calories = mean(Calories),                                                           # average daily calories burned
    avg_active_minutes = mean(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes),    # average active minutes
    avg_sedentary_minutes = mean(SedentaryMinutes)                                                # average sedentary minutes
  )

sleep_summary <- sleep_day %>%
  summarise(                                                                      # Calculate summary statistics
    avg_sleep_time = mean(TotalMinutesAsleep)/60,                                 # average sleep duration in hours
    avg_time_in_bed = mean(TotalTimeInBed)/60,                                    # average time spent in bed in hours
    sleep_efficiency = (mean(TotalMinutesAsleep)/mean(TotalTimeInBed))*100        # sleep efficiency percentage
  )

# DATA EXPLORATION AND VISUALIZATIONS

# 1. USER CATEGORIZATION BASED ON ACTIVITY LEVELS

 # user_categories: Categorize users based on average daily steps
user_categories <- daily_activity %>%                                          # Use the daily_activity data frame
  group_by(Id) %>%                                                             # Group data by user Id
  summarise(                                                                   # Calculate summary statistics for each user
    avg_daily_steps = mean(TotalSteps)                                         # Calculate average daily steps
  ) %>%
  mutate(user_type = case_when(                                                # Categorize users based on average daily steps
    avg_daily_steps < 5000 ~ "Sedentary",                                             
    avg_daily_steps < 7500 ~ "Lightly Active",                                 
    avg_daily_steps < 10000 ~ "Fairly Active",
    TRUE ~ "Very Active"
  ))
head(user_categories)
str(user_categories)                                                          # Display the structure of the user_categories data frame

# Visualizations using ggplot2 and hrbrthemes
import_roboto_condensed()                                                      # Import Roboto Condensed font for ggplot2

# a. Daily Steps Distribution
ggplot(daily_activity, aes(x = TotalSteps)) +
  geom_histogram(binwidth = 1000, fill = "#2E8B57", color = "black") +       # Create histogram of Total Steps with green fill color
  labs(title = "Distribution of Daily Steps",                               # Title of the plot
       x = "Total Steps",                                                 # X-axis label
       y = "Count") +                                                   # Y-axis label
  theme_ipsum_rc()                                                    # Use the hrbrthemes theme for the plot

#------INSERT PNG HERE------

# b. Activity Minutes Distribution
activity_minutes <- daily_activity %>%                                        
  select(VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes) %>%     # Select relevant columns
  gather(key = "activity_type", value = "minutes")                                               # Reshape the data frame
head(activity_minutes)

ggplot(activity_minutes, aes(x = activity_type, y = minutes)) +
  geom_boxplot(fill = "#2E8B57") +                                             # create Box plot with green fill color
  labs(title = "Distribution of Activity Minutes by Type",                       # Title of the plot
       x = "Activity Type",                                                      # X-axis label
       y = "Minutes") +                                                          # Y-axis label
  theme_minimal() +                                                             # Use a minimal theme for the plot
  theme(axis.text.x = element_text(angle = 90))                               # Rotate X-axis labels for better readability

#------INSERT PNG HERE------

# c. Steps vs Calories Correlation
ggplot(daily_activity, aes(x = TotalSteps, y = Calories)) +
  geom_point(alpha = 0.5, color = "blue", size = 3) +                    # Scatter plot with semi-transparent blue points
  geom_smooth(method = "lm", color = "red") +                            # Add a linear model smooth line in red
  labs(title = "Correlation between Daily Steps and Calories Burned",    # Title of the plot
       x = "Total Steps",                                              # X-axis label
       y = "Calories Burned") +                                        # Y-axis label
  theme_minimal()                                                      # Use a minimal theme for the plot
#------INSERT PNG HERE------

# d. Sleep Duration vs Activity Level
# Ensure column names match
colnames(daily_activity)
colnames(sleep_day)

# Rename 'SleepDay' column to 'ActivityDate' to match the column name in 'daily_activity' for merging
sleep_day <- sleep_day %>%
  rename(ActivityDate = SleepDay)

# Perform the merge
sleep_activity <- merge(daily_activity, sleep_day, 
                       by.x = c("Id", "ActivityDate"),
                       by.y = c("Id", "ActivityDate"))
head(sleep_activity)

ggplot(sleep_activity, aes(x = TotalSteps, y = TotalMinutesAsleep)) +
  geom_point(alpha = 0.5, color = "purple") +                             # Scatter plot with semi-transparent purple points
  geom_smooth(method = "lm", color = "red") +                             # Add a linear model smooth line in red
  labs(title = "Impact of Daily Steps on Sleep Duration",                 # Title of the plot
       x = "Total Steps",                                                 # X-axis label
       y = "Sleep Duration (minutes)") +                                  # Y-axis label
  theme_minimal()                                                         
#------INSERT PNG HERE------

# e. Hourly Activity Patterns
hourly_steps %>%
  mutate(hour = hour(ActivityHour)) %>%
  group_by(hour) %>%
  summarise(avg_steps = mean(StepTotal), .groups = 'drop') %>%                 # Calculate the average steps for each hour            
  ggplot(aes(x = hour, y = avg_steps)) +                                         
  geom_line(color = "#2E8B57") +                                               # Line plot with green color
  geom_point() +                                                               # Add points to the line plot
  labs(title = "Average Steps Throughout the Day",                            # Title of the plot
       x = "Hour of Day",                                                     # X-axis label
       y = "Average Steps") +                                                # Y-axis label
  theme_minimal()                                                           # Use a minimal theme for the plot

#------INSERT PNG HERE------

# DATA ANALYSIS AND KEY FINDINGS ON USER ACTIVITY

# a. User Activity Patterns
user_activity_summary <- user_categories %>%                            # Use the user_categories data frame  
  group_by(user_type) %>%                                               # Group data by user type
  summarise(count = n(), .groups = 'drop') %>%                          # Calculate the count of each user type
  mutate(percentage = count/sum(count) * 100)                           # Calculate the percentage of each user type
head(user_activity_summary) 

# b. Activity-Sleep Correlation
sleep_activity_corr <- cor.test(sleep_activity$TotalSteps, sleep_activity$TotalMinutesAsleep)

# c. Peak Activity Times
peak_activity_hours <- hourly_steps %>%                                # Use the hourly_steps data frame
  mutate(hour = hour(ActivityHour)) %>%                                # Extract the hour from the ActivityHour
  group_by(hour) %>%                                                   # Group data by hour
  summarise(avg_steps = mean(StepTotal), .groups = 'drop') %>%         # Calculate the average steps for each hour       
  arrange(desc(avg_steps)) %>%                                         # Arrange in descending order of average steps
  head(3)

# Print key findings
print("Key Findings:")                                                                      
print(paste("Average daily steps:", round(daily_activity_summary$avg_steps)))               
print(paste("Average daily calories burned:", round(daily_activity_summary$avg_calories)))  
print(paste("Average sleep duration (hours):", round(sleep_summary$avg_sleep_time, 2)))
print(paste("Sleep efficiency:", round(sleep_summary$sleep_efficiency, 2), "%"))
print("User Categories Distribution:")
print(user_activity_summary)
print("Peak Activity Hours:")
print(peak_activity_hours)

# Save key findings to a CSV file
write.csv(user_activity_summary, "user_activity_summary.csv", row.names = FALSE)
write.csv(peak_activity_hours, "peak_activity_hours.csv", row.names = FALSE)


# 2. SMART DEVICE USAGE TRENDS ANALYSIS AND VISUALIZATIONS

# User engagement analysis
user_engagement <- daily_activity %>%                 
  group_by(Id) %>%                                                    # Group data by user Id
  summarise(                                                          # Calculate summary statistics for each user
    days_used = n(),                                                  # Calculate the number of days the device was used
    avg_daily_steps = mean(TotalSteps),                               # Calculate average daily steps
    avg_daily_calories = mean(Calories),                              # Calculate average daily calories burned
    avg_active_minutes = mean(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes),
    .groups = 'drop'                                                  # Drop the grouping after summarising
  ) %>%
  mutate(                                                             # Categorize users based on usage frequency
    usage_frequency = case_when(                                      # Categorize users based on the number of days used
      days_used >= 25 ~ "High",
      days_used >= 15 ~ "Medium",
      TRUE ~ "Low"
    )
  )
head(user_engagement)
user_engagement <- as.data.frame(user_engagement)                     # Convert the tibble to a data frame

# Visualization 1: Device Usage Frequency
ggplot(user_engagement, aes(x = usage_frequency, fill = usage_frequency)) +  
  geom_bar() +                                                                 # Create a bar plot of device usage frequency
  scale_fill_manual(values = c("High" = "#90EE90", "Medium" = "#F0E68C", "Low" = "red")) +
  labs(title = "Smart Device Usage Frequency Distribution",                          # Title of the plot
       x = "Usage Frequency",                                                     # X-axis label
       y = "Number of Users") +                                                  # Y-axis label
  theme_ipsum()                                                               # Use the hrbrthemes theme for the plot

#------INSERT PNG HERE------

# Activity patterns throughout the day
hourly_activity_patterns <- hourly_steps %>%                 
  mutate(                                                                   # Create a new column 'part_of_day' based on the hour of the day
    hour = hour(as.POSIXct(ActivityHour, format = "%m/%d/%Y %I:%M:%S %p")),     # Extract the hour from the ActivityHour
    part_of_day = case_when(                                               # Categorize the hour into different parts of the day
      hour >= 5 & hour < 12 ~ "Morning",
      hour >= 12 & hour < 17 ~ "Afternoon",
      hour >= 17 & hour < 22 ~ "Evening",
      TRUE ~ "Night"
    )
  ) %>%                                                                
  group_by(hour) %>%                                        # Group data by hour
  reframe(avg_steps = mean(StepTotal))                      # Calculate the average steps for each hour

print(hourly_activity_patterns, n = 24)                     # Display the average steps for each hour

# Visualization 2: Daily Activity Patterns
import_roboto_condensed()

ggplot(hourly_activity_patterns, aes(x = hour, y = avg_steps)) +
  geom_line(color = "#2E8B57", linewidth = 1) +                # Line plot with green color
  geom_point(color = "#2E8B57") +                              # Add points to the line plot
  labs(title = "Average Hourly Activity Pattern",              # Add Title of the plot
       x = "Hour of Day",                                      # X-axis label 
       y = "Average Steps") +                                  # Y-axis label
  scale_x_continuous(breaks = 0:23) +                          # Set breaks for X-axis
  theme_ipsum_rc()                                             # Use the hrbrthemes theme for the plot

#------INSERT PNG HERE------

# ANALYSIS AND MORE VISUALIZATIONS

# - SLEEP PATTERN ANALYSIS 
# Variable  "sleep_summary" already created to store the summary of the sleep_day data frame 
# earlier in the script

# Display the first few rows of the sleep summary
head(sleep_summary)

# Merge sleep and activity data on 'Id' and 'ActivityDate'
sleep_activity_correlation <- merge(daily_activity, sleep_day,                       
                                   by = c("Id", "ActivityDate"))           

# Display the first few rows of the merged data
head(sleep_activity_correlation)

# Visualization 3: Sleep-Activity Relationship
# Plot the relationship between Total Steps and Sleep Duration
ggplot(sleep_activity_correlation, aes(x = TotalSteps, y = TotalMinutesAsleep/60)) +
  geom_point(alpha = 0.5, color = "#2E8B57") +                         # Scatter plot with semi-transparent green points
  geom_smooth(method = "lm", color = "#90EE90") +                      # Add a linear model smooth line in light green
  labs(title = "Relationship Between Daily Steps and Sleep Duration",  # Title of the plot
       x = "Total Daily Steps",                                        # X-axis label
       y = "Sleep Duration (Hours)") +                                 # Y-axis label
  theme_minimal()                                                      # Use a minimal theme for the plot

#------INSERT PNG HERE------

# 3. INSIGHTS FOR BELLABEAT CUSTOMERS

# Activity level categorization
# Group by user Id and calculate average steps, active minutes, and sedentary minutes
user_segments <- daily_activity %>%
  group_by(Id) %>%                                                            # Group data by user Id
  summarise(
    avg_steps = mean(TotalSteps),                                          # Calculate average daily steps
    avg_active_minutes = mean(VeryActiveMinutes + FairlyActiveMinutes),  # Calculate average active minutes
    avg_sedentary_minutes = mean(SedentaryMinutes),                     # Calculate average sedentary minutes
    .groups = 'drop'                                                  # Drop the grouping after summarising
  )

# Visualization 4: User Segments Distribution
ggplot(user_segments, aes(x = activity_level, fill = activity_level)) +
  geom_bar() +                                                         # Create a bar plot of user activity levels
  scale_fill_manual(values = c("Very Active" = "#2E8B57",
                              "Active" = "#90EE90",
                              "Moderately Active" = "#F0E68C",
                              "Sedentary" = "#FFB6C1")) +            # Define colors for each activity level
  labs(title = "Distribution of User Activity Levels",            # Title of the plot
       x = "Activity Level",                                      # X-axis label
       y = "Number of Users") +                                # Y-axis label
  theme_minimal()                                             # Use a minimal theme for the plot

#------INSERT PNG HERE------

# CALCULATE MARKETING METRICS
marketing_metrics <- list(                                  # Create a list of marketing metrics
  "Device Usage" = user_engagement %>%                      # Device usage metrics based on user engagement
    group_by(usage_frequency) %>%                           # Group data by usage frequency category
    summarise(count = n(), percentage = n()/nrow(user_engagement)*100, .groups = 'drop'),            # Calculate count and percentage
  
  "Activity Levels" = user_segments %>%                     # User activity segments based on average daily steps
    group_by(activity_level) %>%                            # Group data by activity level
    summarise(count = n(), percentage = n()/nrow(user_segments)*100, .groups = 'drop'),  # Calculate count and percentage
  
  "Peak Activity Times" = hourly_activity_patterns %>%      # Peak activity hours based on average steps 
    arrange(desc(avg_steps)) %>%                            # Arrange in descending order of average steps
    head(3),                                                # Select the top 3 peak activity hours
  
  "Sleep Metrics" = sleep_summary                           # Sleep metrics based on average sleep duration and efficiency
)

head(marketing_metrics)                                     # Display the first few rows of the marketing metrics

# Print key findings for marketing strategy
print("=== Key Findings for Bellabeat Marketing Strategy ===")
print("\n1. Device Usage Patterns:")                         
print(marketing_metrics$`Device Usage`)                     
print("\n2. User Activity Segments:")
print(marketing_metrics$`Activity Levels`)
print("\n3. Peak Activity Hours:")
print(marketing_metrics$`Peak Activity Times`)
print("\n4. Sleep Patterns:")
print(marketing_metrics$`Sleep Metrics`)

# Save the marketing metrics to a CSV file                             
write.csv(marketing_metrics$`Device Usage`, "device_usage_metrics.csv", row.names = FALSE)
write.csv(marketing_metrics$`Activity Levels`, "activity_levels_metrics.csv", row.names = FALSE)
write.csv(marketing_metrics$`Peak Activity Times`, "peak_activity_times_metrics.csv", row.names = FALSE)
write.csv(marketing_metrics$`Sleep Metrics`, "sleep_metrics.csv", row.names = FALSE)



# WEIGHT LOG ANALYSIS
# NB: THE WEIGHT LOG DATA FRAME HAS ALREADY BEEN IMPORTED AND CLEANED
# Merge weight log with daily activity and sleep data
weight_activity_sleep <- merge(daily_activity, weight_log, by = "Id")            # Merge daily_activity and weight_log 
weight_activity_sleep <- merge(weight_activity_sleep, sleep_day, by = c("Id", "ActivityDate"))      # Merge weight_activity_sleep with sleep_day

# Correlation between weight and activity levels                                  
weight_activity_corr <- cor.test(weight_activity_sleep$WeightKg, weight_activity_sleep$TotalSteps)   # example analysis : correlation between weight and daily steps 

# Correlation between weight and sleep duration
weight_sleep_corr <- cor.test(weight_activity_sleep$WeightKg, weight_activity_sleep$TotalMinutesAsleep)  # example analysis : correlation between weight and sleep duration

# Print correlation results
print(weight_activity_corr)
print(weight_sleep_corr)

# END OF ANALYSIS




# SAVE COMPREHENSIVE DATASET TO CSV

# Combine relevant data frames into one comprehensive data frame
 # Ensure all data frames have the same columns for merging
 
 # Inspect column names of sleep_day
colnames(sleep_day)

# rename 'SleepDay' column to 'ActivityDate'
if ("SleepDay" %in% colnames(sleep_day)) {                          # Check if 'SleepDay' column exists
  sleep_day <- sleep_day %>%                                        # Rename 'SleepDay' column to 'ActivityDate'
    rename(ActivityDate = SleepDay)
}

# Merge daily_activity and sleep_day using an inner join
combined_data <- merge(daily_activity, sleep_day, by = c("Id", "ActivityDate"), all = FALSE)

# Ensure 'ActivityHour' column exists in combined_data
if (!"ActivityHour" %in% colnames(combined_data)) {            # Check if 'ActivityHour' column exists
  combined_data <- combined_data %>%                          # Create 'ActivityHour' column by combining 'ActivityDate' and '00:00:00'
    mutate(ActivityHour = as.POSIXct(paste(ActivityDate, "00:00:00"), format = "%Y-%m-%d %H:%M:%S", tz = "UTC")) # Convert to POSIXct format           
}                                                                                                                 
# Merge combined_data with hourly_steps using an inner join
combined_data <- merge(combined_data, hourly_steps, by = c("Id", "ActivityHour"), all = FALSE)

# Merge combined_data with weight_log using an inner join
combined_data <- merge(combined_data, weight_log, by = "Id", all = FALSE)

# Add user_categories to combined_data
user_categories <- daily_activity %>%                       
  group_by(Id) %>%                                          
  summarise(                                                
    avg_daily_steps = mean(TotalSteps)                      
  ) %>%                                                     
  mutate(user_type = case_when(                            
    avg_daily_steps < 5000 ~ "Sedentary",
    avg_daily_steps < 7500 ~ "Lightly Active",
    avg_daily_steps < 10000 ~ "Fairly Active",
    TRUE ~ "Very Active"
  ))

combined_data <- merge(combined_data, user_categories, by = "Id", all = FALSE)        # Merge user_categories with combined_data

# Add user_engagement to combined_data
user_engagement <- daily_activity %>%
  group_by(Id) %>%
  summarise(
    days_used = n(),
    avg_daily_steps = mean(TotalSteps),
    avg_daily_calories = mean(Calories),
    avg_active_minutes = mean(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes),
    .groups = 'drop'
  ) %>%
  mutate(
    usage_frequency = case_when(
      days_used >= 25 ~ "High",
      days_used >= 15 ~ "Medium",
      TRUE ~ "Low"
    )
  )

combined_data <- merge(combined_data, user_engagement, by = "Id", all = FALSE)        # Merge user_engagement with combined_data

# Save the combined data frame to a CSV file
write.csv(combined_data, "complete_dataset.csv", row.names = FALSE)

# Read the final dataset for inspection
final_dataset <- read_csv("complete_dataset.csv")

# Display the first few rows of the dataset
head(final_dataset)

# Display the structure of the dataset
str(final_dataset)

# Check for missing values in the final dataset
missing_values_summary <- final_dataset %>%
  summarise_all(~ sum(is.na(.))) %>%
  gather(key = "column", value = "missing_count") %>%
  arrange(desc(missing_count))

# Display the summary of missing values
print(missing_values_summary)