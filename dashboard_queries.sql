-- Teen Mental Health & Social Media — Dashboard Analysis
-- Author: Donson Hoang
-- Tool: MySQL
-- Dataset: Teen Mental Health & Social Media dataset (1,200 rows)
--
-- I loaded this dataset into MySQL and wrote these queries to
-- explore how social media habits, sleep, and platform usage
-- relate to stress, anxiety, addiction, and depression in
-- teenagers aged 13–19. The results were used to build an
-- interactive dashboard with platform comparisons, age/gender
-- breakdowns, and a personal risk profile explorer.
--
-- Table: teen_mental_health
-- Columns:
--   age                        TINYINT
--   gender                     VARCHAR(10)
--   daily_social_media_hours   DECIMAL(4,1)
--   platform_usage             VARCHAR(20)   -- 'Instagram', 'TikTok', or 'Both'
--   sleep_hours                DECIMAL(4,1)
--   screen_time_before_sleep   DECIMAL(4,1)
--   academic_performance       DECIMAL(4,2)  -- GPA scale
--   physical_activity          DECIMAL(4,1)  -- hours per day
--   social_interaction_level   VARCHAR(10)   -- 'low', 'medium', or 'high'
--   stress_level               TINYINT       -- 1 to 10
--   anxiety_level              TINYINT       -- 1 to 10
--   addiction_level            TINYINT       -- 1 to 10
--   depression_label           TINYINT       -- 0 or 1


-- What is the overall mental health profile of teens in this dataset?
-- How common is depression, and what are the average sleep, screen time, and stress levels?
SELECT
    COUNT(*) AS total_participants,
    ROUND(AVG(depression_label) * 100, 1) AS depression_rate_pct,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(daily_social_media_hours), 2) AS avg_sm_hours,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(anxiety_level), 2) AS avg_anxiety,
    ROUND(AVG(addiction_level), 2) AS avg_addiction,
    ROUND(AVG(academic_performance), 2) AS avg_gpa,
    ROUND(AVG(screen_time_before_sleep), 2) AS avg_screen_before_sleep
FROM teen_mental_health;


-- How are sleep hours distributed across the dataset?
-- Are teens getting enough sleep?
SELECT
    CONCAT(FLOOR(sleep_hours), '-', FLOOR(sleep_hours) + 1, 'h') AS sleep_bin,
    COUNT(*) AS count
FROM teen_mental_health
WHERE sleep_hours BETWEEN 3 AND 10
GROUP BY FLOOR(sleep_hours)
ORDER BY FLOOR(sleep_hours);


-- How many hours a day are teens spending on social media?
-- What does the distribution look like across the group?
SELECT
    CONCAT(FLOOR(daily_social_media_hours), '-', FLOOR(daily_social_media_hours) + 1, 'h') AS sm_bin,
    COUNT(*) AS count
FROM teen_mental_health
GROUP BY FLOOR(daily_social_media_hours)
ORDER BY FLOOR(daily_social_media_hours);


-- Does the platform a teen uses affect their stress, anxiety, addiction, or depression?
-- Which platform is associated with the worst mental health outcomes?
SELECT
    platform_usage,
    COUNT(*) AS total,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(anxiety_level), 2) AS avg_anxiety,
    ROUND(AVG(addiction_level), 2) AS avg_addiction,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(daily_social_media_hours), 2) AS avg_sm_hours,
    ROUND(AVG(screen_time_before_sleep), 2) AS avg_screen_before_sleep,
    ROUND(AVG(academic_performance), 2) AS avg_gpa,
    ROUND(AVG(depression_label) * 100, 1) AS depression_rate_pct
FROM teen_mental_health
GROUP BY platform_usage;


-- Do teens on certain platforms have lower social interaction in real life?
SELECT
    platform_usage,
    SUM(CASE WHEN social_interaction_level = 'low' THEN 1 ELSE 0 END) AS low_count,
    SUM(CASE WHEN social_interaction_level = 'medium' THEN 1 ELSE 0 END) AS medium_count,
    SUM(CASE WHEN social_interaction_level = 'high' THEN 1 ELSE 0 END) AS high_count
FROM teen_mental_health
GROUP BY platform_usage;


-- Does mental health get worse as teens get older?
-- Which age group has the highest depression rate?
SELECT
    age,
    COUNT(*) AS total,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(anxiety_level), 2) AS avg_anxiety,
    ROUND(AVG(addiction_level), 2) AS avg_addiction,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(daily_social_media_hours), 2) AS avg_sm_hours,
    ROUND(AVG(academic_performance), 2) AS avg_gpa,
    ROUND(AVG(depression_label) * 100, 1) AS depression_rate_pct
FROM teen_mental_health
GROUP BY age
ORDER BY age;


-- Are there differences in stress, anxiety, and depression between male and female teens?
SELECT
    gender,
    COUNT(*) AS total,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(anxiety_level), 2) AS avg_anxiety,
    ROUND(AVG(addiction_level), 2) AS avg_addiction,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(daily_social_media_hours), 2) AS avg_sm_hours,
    ROUND(AVG(academic_performance), 2) AS avg_gpa,
    ROUND(AVG(depression_label) * 100, 1) AS depression_rate_pct
FROM teen_mental_health
GROUP BY gender;


-- Does more time on social media lead to higher stress and less sleep?
-- Does heavy screen time hurt academic performance?
SELECT
    CASE
        WHEN daily_social_media_hours < 2 THEN '0-2h'
        WHEN daily_social_media_hours < 4 THEN '2-4h'
        WHEN daily_social_media_hours < 6 THEN '4-6h'
        ELSE '6-8h'
    END AS sm_bucket,
    COUNT(*) AS total,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(anxiety_level), 2) AS avg_anxiety,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(academic_performance), 2) AS avg_gpa
FROM teen_mental_health
GROUP BY sm_bucket
ORDER BY MIN(daily_social_media_hours);


-- Raw data pull for the scatter plot
-- How does social media usage relate to sleep hours at the individual level?
SELECT
    daily_social_media_hours,
    sleep_hours,
    stress_level,
    depression_label,
    platform_usage
FROM teen_mental_health;
