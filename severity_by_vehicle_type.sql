SELECT 
    v.vehicle_type,
    COUNT(*) AS total_involvements,
    SUM(CASE WHEN a.collision_severity IN (1, 2) THEN 1 ELSE 0 END) AS severe_involvements,
    ROUND(SUM(CASE WHEN a.collision_severity IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS severe_rate_pct
FROM vehicles v
JOIN accidents a ON v.collision_index = a.collision_index
GROUP BY v.vehicle_type
ORDER BY total_involvements DESC;