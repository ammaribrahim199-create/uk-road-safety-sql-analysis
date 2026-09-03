SELECT 
    weather_conditions,
    road_surface_conditions,
    COUNT(*) AS total_collisions,
    SUM(CASE WHEN collision_severity IN (1, 2) THEN 1 ELSE 0 END) AS severe_collisions,
    ROUND(SUM(CASE WHEN collision_severity IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS severe_rate_pct
FROM accidents
WHERE weather_conditions != -1 AND road_surface_conditions != -1
GROUP BY weather_conditions, road_surface_conditions
HAVING total_collisions >= 30
ORDER BY severe_rate_pct DESC;