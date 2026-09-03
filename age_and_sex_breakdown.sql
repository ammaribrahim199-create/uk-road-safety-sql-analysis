SELECT 
    CASE 
        WHEN age_of_casualty < 18 THEN 'Under 18'
        WHEN age_of_casualty BETWEEN 18 AND 24 THEN '18-24'
        WHEN age_of_casualty BETWEEN 25 AND 39 THEN '25-39'
        WHEN age_of_casualty BETWEEN 40 AND 59 THEN '40-59'
        WHEN age_of_casualty >= 60 THEN '60+'
        ELSE 'Unknown'
    END AS age_band,
    sex_of_casualty,
    COUNT(*) AS total_casualties,
    SUM(CASE WHEN casualty_severity IN (1, 2) THEN 1 ELSE 0 END) AS severe_casualties,
    ROUND(SUM(CASE WHEN casualty_severity IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS severe_rate_pct
FROM casualties
WHERE sex_of_casualty IN (1, 2)
GROUP BY age_band, sex_of_casualty
ORDER BY age_band, sex_of_casualty;