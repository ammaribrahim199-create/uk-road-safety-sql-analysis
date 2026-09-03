SELECT 
    LEFT(time, 2) AS hour_of_day,
    COUNT(*) AS total_collisions,
    SUM(CASE WHEN collision_severity IN (1, 2) THEN 1 ELSE 0 END) AS severe_collisions,
    ROUND(SUM(CASE WHEN collision_severity IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS severe_rate_pct
FROM accidents
WHERE time IS NOT NULL AND time != ''
GROUP BY hour_of_day
ORDER BY hour_of_day;