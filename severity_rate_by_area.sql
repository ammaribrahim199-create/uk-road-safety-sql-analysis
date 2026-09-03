SELECT 
    local_authority_highway,
    total_collisions,
    severe_collisions,
    ROUND(severe_collisions / total_collisions * 100, 2) AS severe_rate_pct
FROM (
    SELECT 
        local_authority_highway,
        COUNT(*) AS total_collisions,
        SUM(CASE WHEN collision_severity IN (1, 2) THEN 1 ELSE 0 END) AS severe_collisions
    FROM accidents
    WHERE local_authority_highway IS NOT NULL AND local_authority_highway != ''
    GROUP BY local_authority_highway
) AS district_summary
WHERE total_collisions >= 100
ORDER BY severe_rate_pct DESC
LIMIT 15;