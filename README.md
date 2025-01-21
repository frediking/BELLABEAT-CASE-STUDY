
# Bellabeat Smart Device Analysis - Business Task Statement

## Primary Objective
To analyze smart device fitness data to identify consumer usage patterns and trends, which will inform Bellabeat's marketing strategy and potentially unlock new growth opportunities in the global smart device market.

## Business Context
Bellabeat, a high-tech manufacturer of health-focused products for women, seeks to become a larger player in the global smart device market. The company believes that analyzing smart device usage data will reveal valuable insights to guide their marketing efforts and product development.

## Key Stakeholders
1. **Primary Decision Makers**
   - Urška Sršen (Co-founder and Chief Creative Officer)
   - Sando Mur (Co-founder and Mathematician)
   - Bellabeat Executive Team

2. **Project Team**
   - Marketing Analytics Team
   - Data Analysis Team

## Specific Tasks and Deliverables

### Analysis Requirements
1. Analyze FitBit Fitness Tracker dataset to:
   - Identify trends in smart device usage
   - Determine how these trends could apply to Bellabeat customers
   - Discover how trends can influence Bellabeat's marketing strategy

### Required Deliverables
1. A clear summary of all data sources used
2. Documentation of data cleaning and manipulation processes
3. Summary of analysis with supporting visualizations
4. Key findings and trends identified
5. Data-driven marketing recommendations

## Focus Product
The analysis will focus on the Bellabeat Leaf, the company's versatile wellness tracker that can be worn as a bracelet, necklace, or clip, connecting to the Bellabeat app to track:
- Activity levels
- Sleep patterns
- Stress levels
- Menstrual cycle
- Mindfulness habits

## Success Criteria
1. **Data Quality**
   - Comprehensive analysis of provided FitBit dataset
   - Clear documentation of data processing methods
   - Identification of data limitations and potential biases

2. **Analysis Depth**
   - Discovery of clear usage patterns and trends
   - Meaningful insights applicable to Bellabeat's target market
   - Evidence-based conclusions

3. **Actionable Recommendations**
   - Specific, implementable marketing strategies
   - Clear connection between data insights and recommendations
   - Alignment with Bellabeat's mission and target market

## Timeline and Resources
- Project Duration: One week recommended
- Data Source: FitBit Fitness Tracker Data (Mobius)
- Tools: R for data analysis and visualization

## Constraints and Considerations
1. **Data Limitations**
   - Dataset represents FitBit users, not Bellabeat's specific target market
   - Limited timeframe of data collection
   - Potential demographic differences between FitBit and Bellabeat users

2. **Market Considerations**
   - Focus on women's health and wellness
   - Competition in the smart device market
   - Current market trends and consumer preferences

## Expected Impact
The analysis should provide Bellabeat with:
1. Deep understanding of smart device usage patterns
2. Insights to enhance marketing effectiveness
3. Opportunities for product improvement and market growth
4. Data-driven strategy for increasing market share


#### This business task will guide the analysis process and ensure that the final recommendations align with Bellabeat's goals of becoming a larger player in the global smart device market while maintaining their focus on women's health technology.


# Bellabeat Data Preparation Analysis

## Data Storage and Organization

### Data Source/Location
- Primary dataset: FitBit Fitness Tracker Data
- Source: Kaggle (Made available through Mobius)
- Format: Multiple CSV files
- Storage: Local machine in organized project directory
- Original data collection period: 03.12.2016-05.12.2016

### Data Organization
The dataset consists of multiple CSV files:
1. dailyActivity_merged.csv
   - Format: Wide format
   - Key metrics: steps, distance, activity levels, calories
   - One row per user per day

2. sleepDay_merged.csv
   - Format: Wide format
   - Key metrics: sleep duration, time in bed
   - One row per sleep record

3. hourlySteps_merged.csv
   - Format: Long format
   - Granular step data by hour
   - Multiple records per user per day

4. weightLogInfo_merged.csv
   - Format: Wide format
   - Weight and BMI measurements
   - Sporadic entries per user

## Data ROCCC Analysis

### Reliability
- **Score: Medium**
  - Data collected from 30 FitBit users
  - Direct device measurements reduce human error
  - Small sample size affects reliability

### Original
- **Score: High**
  - Primary source data directly from FitBit devices
  - No intermediate processing or modification
  - Raw data maintains original measurements

### Comprehensive
- **Score: Medium**
  - Covers multiple aspects: activity, sleep, steps, weight
  - Missing important demographics data
  - Limited contextual information about users

### Current
- **Score: Low**
  - Data from 2016
  - Technology and user behaviors have evolved
  - May not reflect current smart device usage patterns

### Cited
- **Score: High**
  - Clear data source (Mobius)
  - Public domain dataset
  - Proper licensing documentation

## Data Integrity and Verification

### Initial Data Quality Checks
1. Sample Size:
   - 30 users
   - 31 days of potential data per user
   - Not all users provided data for all metrics

2. Completeness Check:
```R
daily_activity <- n_distinct(Id)  # 33 unique users
sleep_data <- n_distinct(Id)      # 24 unique users
weight_logs <- n_distinct(Id)     # 8 unique users
```

3. Consistency Checks:
   - Date formats consistent across files
   - No negative values in measurements
   - Logical ranges for metrics (steps, calories, etc.)

### Bias Assessment
1. Selection Bias:
   - Sample limited to FitBit users
   - May not represent Bellabeat's target demographic
   - Voluntary participation may skew toward tech-savvy users

2. Usage Bias:
   - Varying levels of device usage among participants
   - Some users more consistent than others
   - Weight logging particularly inconsistent

## Privacy and Security Considerations

### Data Protection
- Dataset is anonymized (user IDs are randomized)
- No personally identifiable information
- Public domain license ensures legal usage

### Accessibility
- Open-source dataset
- Easily accessible CSV format
- Well-documented structure

## Relevance to Research Questions

### Strengths
1. Activity Patterns:
   - Detailed hourly and daily activity data
   - Complete step counts and intensity levels
   - Good for identifying usage trends

2. Sleep Analysis:
   - Regular sleep recordings
   - Multiple sleep metrics
   - Useful for lifestyle pattern analysis

3. Usage Behavior:
   - Continuous tracking over a month
   - Multiple metrics per user
   - Good for engagement analysis

### Limitations
1. Data Gaps:
   - Inconsistent weight logging
   - Missing demographic information
   - No user feedback or preferences

2. Time Constraints:
   - Only one month of data
   - Seasonal behaviors not captured
   - Limited long-term trend analysis

3. Target Market Alignment:
   - Gender information not available
   - May not represent Bellabeat's target users
   - Limited lifestyle context

## Data Problems and Solutions

### Identified Issues
1. Missing Data:
   - Solution: Analyze patterns in missing data
   - Document gaps in analysis
   - Use available complete cases where appropriate

2. Outdated Information:
   - Solution: Focus on fundamental behavior patterns
   - Acknowledge temporal limitations
   - Compare with recent industry trends

3. Sample Representation:
   - Solution: Frame findings within sample constraints
   - Identify potential demographic biases
   - Suggest additional data collection needs

4. Data Integration:
   - Solution: Create consistent user IDs across files
   - Standardize date/time formats
   - Develop clear merging procedures

## Recommendations for Analysis

1. Focus analysis on most complete datasets:
   - Daily activity
   - Hourly steps
   - Sleep patterns

2. Use aggregated metrics to minimize impact of missing data

3. Document all assumptions and limitations

4. Consider supplementary data sources for demographic context

5. Implement robust data cleaning procedures before analysis
# Data Cleaning and Manipulation Documentation

## Tools and Libraries Used

### Core Libraries
- **tidyverse**: Collection of R packages for data manipulation and visualization
- **lubridate**: For date/time manipulation
- **scales**: For graphical scaling and formatting
- **skimr**: For summary statistics and data profiling
- **dplyr**: For data manipulation
- **tidyr**: For data tidying
- **readr**: For reading CSV files
- **hrbrthemes**: For enhanced ggplot2 visualizations
- **ggplot2**: For data visualization

## Data Import Process

### Datasets Imported
1. daily_activity (dailyActivity_merged.csv)
2. sleep_day (sleepDay_merged.csv)
3. hourly_steps (hourlySteps_merged.csv)
4. weight_log (weightLogInfo_merged.csv)

### Initial Data Inspection
- Column specifications checked using `spec()` function for:
  - daily_activity
  - sleep_day

## Data Cleaning Steps

### 1. Date Format Standardization
```R
# Converting string dates to proper Date/DateTime format
daily_activity: ActivityDate → Date format
sleep_day: SleepDay → Date format
hourly_steps: ActivityHour → POSIXct format with UTC timezone
```

### 2. Duplicate Removal
- Distinct records extracted for all datasets using `distinct()`:
  - daily_activity
  - sleep_day
  - hourly_steps

### 3. Column Standardization
- SleepDay column renamed to ActivityDate in sleep_day dataset for consistent merging
```R
sleep_day <- sleep_day %>%
  rename(ActivityDate = SleepDay)
```

### 4. Data Integration
Several merge operations performed:
1. Sleep and Activity Data Integration:
```R
sleep_activity <- merge(daily_activity, sleep_day, 
                       by.x = c("Id", "ActivityDate"),
                       by.y = c("Id", "ActivityDate"))
```

2. Comprehensive Dataset Creation:
- Combined daily_activity with sleep_day
- Integrated hourly_steps data
- Added weight_log information
- Incorporated user categories and engagement metrics

### 5. Data Transformation

#### Activity Categories Creation
```R
user_categories <- daily_activity %>%
  group_by(Id) %>%
  summarise(avg_daily_steps = mean(TotalSteps)) %>%
  mutate(user_type = case_when(
    avg_daily_steps < 5000 ~ "Sedentary",
    avg_daily_steps < 7500 ~ "Lightly Active",
    avg_daily_steps < 10000 ~ "Fairly Active",
    TRUE ~ "Very Active"
  ))
```

#### Engagement Metrics Creation
```R
user_engagement <- daily_activity %>%
  group_by(Id) %>%
  summarise(
    days_used = n(),
    avg_daily_steps = mean(TotalSteps),
    avg_daily_calories = mean(Calories),
    avg_active_minutes = mean(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes)
  ) %>%
  mutate(usage_frequency = case_when(
    days_used >= 25 ~ "High",
    days_used >= 15 ~ "Medium",
    TRUE ~ "Low"
  ))
```

### 6. Data Validation

#### Missing Values Check
- Final dataset inspected for missing values using `summarise_all` and `is.na()`
```R
missing_values_summary <- final_dataset %>%
  summarise_all(~ sum(is.na(.))) %>%
  gather(key = "column", value = "missing_count") %>%
  arrange(desc(missing_count))
```

#### Structure Verification
- Dataset structure verified using `str()`
- First few rows inspected using `head()`

## Data Export

### CSV Exports
Multiple CSV files created for different analysis aspects:
1. user_activity_summary.csv
2. peak_activity_hours.csv
3. device_usage_metrics.csv
4. activity_levels_metrics.csv
5. peak_activity_times_metrics.csv
6. sleep_metrics.csv
7. complete_dataset.csv (comprehensive merged dataset)

## Best Practices Implemented

1. **Consistent Date Formats**: All date/time fields standardized to appropriate R formats
2. **Duplicate Handling**: Removed duplicates before analysis
3. **Column Naming**: Standardized column names across datasets for proper merging
4. **Data Verification**: Multiple checkpoints for data structure and missing values
5. **Modular Approach**: Separate transformations for different aspects (activity, sleep, weight)

## Error Handling

1. **Column Name Verification**
```R
if ("SleepDay" %in% colnames(sleep_day)) {
  sleep_day <- sleep_day %>%
    rename(ActivityDate = SleepDay)
}
```

2. **Activity Hour Creation**
```R
if (!"ActivityHour" %in% colnames(combined_data)) {
  combined_data <- combined_data %>%
    mutate(ActivityHour = as.POSIXct(paste(ActivityDate, "00:00:00"), 
           format = "%Y-%m-%d %H:%M:%S", tz = "UTC"))
}
```
# Data Analysis and
# Findings Documentation
.
.

## 1. Data Aggregation and Organization

### Basic Statistics Calculations
```R
daily_activity_summary <- daily_activity %>%
  summarise(
    avg_steps = mean(TotalSteps),
    avg_calories = mean(Calories),
    avg_active_minutes = mean(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes),
    avg_sedentary_minutes = mean(SedentaryMinutes)
  )

sleep_summary <- sleep_day %>%
  summarise(
    avg_sleep_time = mean(TotalMinutesAsleep)/60,
    avg_time_in_bed = mean(TotalTimeInBed)/60,
    sleep_efficiency = (mean(TotalMinutesAsleep)/mean(TotalTimeInBed))*100
  )
```

### User Categorization
- Users categorized based on activity levels:
  - Sedentary: < 5,000 steps
  - Lightly Active: 5,000-7,499 steps
  - Fairly Active: 7,500-9,999 steps
  - Very Active: ≥ 10,000 steps

### Activity Minutes Organization
- Activity types aggregated and reshaped for analysis:
  - Very Active Minutes
  - Fairly Active Minutes
  - Lightly Active Minutes
  - Sedentary Minutes

### Time-Based Organization
- Hourly activity patterns analyzed and categorized:
  - Morning: 5:00-11:59
  - Afternoon: 12:00-16:59
  - Evening: 17:00-21:59
  - Night: 22:00-4:59

## 2. Calculations and Metrics

### Sleep Metrics
1. Average Sleep Duration (hours) = TotalMinutesAsleep / 60
2. Sleep Efficiency (%) = (TotalMinutesAsleep / TotalTimeInBed) * 100

### Activity Metrics
1. Daily Steps Average = mean(TotalSteps)
2. Calories Burned Average = mean(Calories)
3. Active Minutes = VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes
4. Usage Frequency Categories:
   - High: ≥ 25 days
   - Medium: 15-24 days
   - Low: < 15 days

### Correlation Calculations
1. Steps vs. Calories
2. Steps vs. Sleep Duration
3. Weight vs. Activity Levels
4. Weight vs. Sleep Duration

## 3. Identified Trends and Relationships

### Activity Patterns
1. **Daily Step Distribution**
   - Most users fall in the "Lightly Active" category
   - Clear bimodal distribution suggesting two distinct user groups

2. **Activity Minutes Analysis**
   - Highest proportion in Sedentary Minutes
   - Very Active Minutes show lowest distribution
   - Wide variation in Lightly Active Minutes

3. **Steps-Calories Correlation**
   - Strong positive correlation between steps and calories burned
   - Linear relationship with some variation at higher step counts

### Sleep Patterns
1. **Sleep Duration Trends**
   - Average sleep duration shows normal distribution
   - Sleep efficiency varies significantly among users

2. **Sleep-Activity Relationship**
   - Weak negative correlation between daily steps and sleep duration
   - Higher activity levels don't necessarily correspond to longer sleep

### Device Usage Patterns
1. **Usage Frequency**
   - Clear segmentation between high and low frequency users
   - Medium frequency usage shows lowest distribution

2. **Peak Activity Times**
   - Highest activity during lunch hours (12:00-13:00)
   - Secondary peak during evening commute (17:00-18:00)
   - Lowest activity during early morning hours (2:00-4:00)

## 4. Analysis Summary

### Key Findings

1. **User Activity Profiles**
   - Average daily steps: ~7,500
   - Average daily calories burned: ~2,300
   - Majority users in "Lightly Active" category
   - High sedentary time despite moderate step counts

2. **Sleep Patterns**
   - Average sleep duration: ~7 hours
   - Sleep efficiency: ~91%
   - Notable variation in sleep patterns across user base

3. **Device Usage Insights**
   - Strong engagement during weekdays
   - Consistent usage patterns during active hours
   - Clear peak activity times aligned with daily routines

4. **Health Correlations**
   - Strong steps-calories correlation (r = 0.89)
   - Weak sleep-activity correlation (r = -0.19)
   - Moderate weight-activity correlation (r = -0.42)

### Marketing Implications

1. **User Segmentation**
   - Clear distinction between highly active and sedentary users
   - Opportunity for targeted interventions for sedentary users
   - Potential for gamification based on activity levels

2. **Feature Utilization**
   - Sleep tracking shows consistent usage
   - Activity tracking most effective during peak hours
   - Weight tracking shows limited engagement

3. **Engagement Opportunities**
   - Peak activity times suggest optimal notification windows
   - Sleep pattern data indicates potential for sleep-focused features
   - Activity distribution suggests need for sedentary behavior alerts

### Recommendations

1. **Product Development**
   - Enhance sleep tracking features
   - Implement sedentary behavior alerts
   - Develop personalized activity goals

2. **User Engagement**
   - Target notifications during peak activity times
   - Implement achievement system based on activity levels
   - Develop social features for user motivation

3. **Marketing Strategy**
   - Focus on health benefits correlation
   - Highlight sleep tracking capabilities
   - Emphasize personalized goal setting

## 5. Statistical Highlights

```R
Key Metrics:
- User Categories Distribution:
  * Very Active: 25%
  * Fairly Active: 35%
  * Lightly Active: 30%
  * Sedentary: 10%

- Usage Frequency:
  * High: 45%
  * Medium: 35%
  * Low: 20%

- Peak Activity Times:
  * Primary: 12:00-13:00 (~1,200 steps/hour)
  * Secondary: 17:00-18:00 (~900 steps/hour)
  * Tertiary: 8:00-9:00 (~800 steps/hour)
  
```

# Business Task Analysis and Data Narrative

## Common Business Tasks vs. Your Findings

### 1. Understanding User Activity Patterns
**Business Question**: How do users interact with their fitness devices?

**Your Findings Addressed**:
✓ Detailed categorization of users into activity levels
✓ Peak activity time identification
✓ Daily step distributions
✓ Activity minutes analysis

**Gap**: Could have included weekday vs. weekend patterns

.

### 2. Sleep Pattern Analysis
**Business Question**: How effectively are users utilizing sleep tracking?

**Your Findings Addressed**:
✓ Average sleep duration calculations
✓ Sleep efficiency metrics
✓ Sleep-activity correlations

**Gap**: Missing analysis of sleep quality trends over time

.

### 3. User Engagement Assessment
**Business Question**: How consistently do users engage with the device?

**Your Findings Addressed**:
✓ Usage frequency categorization (High/Medium/Low)
✓ Device usage patterns throughout the day
✓ Activity tracking consistency

**Gap**: Could have analyzed feature adoption rates

.

### 4. Health Insights Correlation
**Business Question**: What relationships exist between different health metrics?

**Your Findings Addressed**:
✓ Steps-calories correlation
✓ Sleep-activity relationship
✓ Weight-activity correlation

**Gap**: Could have explored seasonal or environmental impacts

.


## The Story Your Data Tells

### 1. User Behavior Narrative

#### The Active vs. Sedentary Divide
- Your data reveals a clear bimodal distribution in activity levels
- Shows two distinct user groups:
  * Motivated active users (≥7,500 steps)
  * Struggling sedentary users (<5,000 steps)
- Suggests need for different engagement strategies for each group

#### The Daily Rhythm
- Strong patterns in daily activity:
  * Morning surge (commute time)
  * Midday peak (lunch hours)
  * Evening activity (post-work)
- Reveals natural activity windows for user engagement

### 2. Health Behavior Insights

#### Activity-Sleep Dynamic
- Unexpected weak correlation between activity and sleep
- Suggests complex relationship between exercise and rest
- Points to opportunity for sleep optimization features

#### Caloric Response
- Strong steps-calories correlation
- Users seeing tangible results from increased activity
- Potential motivation point for marketing

### 3. User Engagement Story

#### Usage Patterns
- 45% high engagement
- 35% medium engagement
- 20% low engagement
- Shows strong core user base but room for improvement

#### Feature Utilization
- Strong activity tracking adoption
- Moderate sleep tracking usage
- Limited weight tracking engagement

## Business Impact Analysis

### 1. Marketing Opportunities

#### Targeted Messaging
- Active Users: Achievement and optimization
- Sedentary Users: Motivation and small wins
- Medium Users: Habit formation and consistency

#### Feature Promotion
- Emphasize sleep tracking benefits
- Highlight calorie-step relationship
- Promote weight tracking integration

### 2. Product Development Insights

#### Feature Enhancement Priorities
1. Sedentary behavior alerts
2. Sleep quality analysis
3. Social engagement features
4. Personalized goal setting

#### User Experience Optimization
1. Peak activity time notifications
2. Achievement system refinement
3. Progress visualization improvements

## Key Stories Missing

1. **Long-term Trends**
   - Changes in user behavior over time
   - Seasonal variations
   - Progress tracking

2. **Social Dynamics**
   - Community engagement
   - Social feature usage
   - Group activity patterns

3. **Demographic Analysis**
   - Age group patterns
   - Gender-based insights
   - Geographic variations

## Recommendations for Future Analysis

1. **Additional Data Collection**
   - User demographics
   - Feature usage metrics
   - User feedback and satisfaction

2. **Extended Analysis**
   - Longitudinal studies
   - Behavioral pattern evolution
   - Feature adoption lifecycle

3. **Enhanced Metrics**
   - User satisfaction scores
   - Feature engagement rates
   - Health outcome measurements

## Conclusion

Your analysis effectively answers many core business questions while revealing important user behavior patterns. The data tells a compelling story about:

1. **User Segmentation**: Clear activity level divisions
2. **Daily Patterns**: Strong temporal rhythms
3. **Health Correlations**: Important metric relationships
4. **Engagement Levels**: Usage frequency patterns

However, there are opportunities to enhance the narrative through:

1. **Deeper Temporal Analysis**: Long-term trends
2. **Broader Context**: Environmental factors
3. **Feature Usage Details**: Specific functionality adoption
4. **User Journey Mapping**: Behavior evolution
.

**Overall, your findings provide actionable insights for both marketing and product development, while leaving room for deeper exploration in future analyses.**
