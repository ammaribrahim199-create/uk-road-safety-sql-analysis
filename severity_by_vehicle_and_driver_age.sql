SELECT 
    v.vehicle_type,
    CASE 
        WHEN v.age_of_driver < 25 THEN 'Under 25'
        WHEN v.age_of_driver BETWEEN 25 AND 59 THEN '25-59'
        WHEN v.age_of_driver >= 60 THEN '60+'
        ELSE 'Unknown'
    END AS driver_age_band,
    COUNT(*) AS total_casualties,
    SUM(CASE WHEN c.casualty_severity IN (1, 2) THEN 1 ELSE 0 END) AS severe_casualties,
    ROUND(SUM(CASE WHEN c.casualty_severity IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS severe_rate_pct
FROM accidents a
JOIN vehicles v ON a.collision_index = v.collision_index
JOIN casualties c ON a.collision_index = c.collision_index
WHERE v.age_of_driver IS NOT NULL AND v.age_of_driver > 0
GROUP BY v.vehicle_type, driver_age_band
HAVING total_casualties >= 50
ORDER BY severe_rate_pct DESC
LIMIT 20;