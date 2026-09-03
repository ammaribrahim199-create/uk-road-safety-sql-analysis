# uk-road-safety-sql-analysis
SQL analysis of UK road collision data (STATS19) exploring what drives collision severity

# UK Road Safety Analysis: What Drives Collision Severity?
### A SQL analysis of 101,523 UK road collisions using DfT STATS19 data (2025)

## Overview

This project explores what factors are associated with the **severity** of road collisions in the UK, using the Department for Transport's official STATS19 road safety dataset. Rather than just counting collisions, the analysis focuses on **severity rate** — asking not just "where do accidents happen?" but "when do they happen, and are they worse than average?"

The database consists of three linked tables reflecting the real structure of the STATS19 data:

| Table | Rows | Description |
|---|---|---|
| `accidents` | 101,523 | One row per collision |
| `vehicles` | 183,948 | One row per vehicle involved in a collision |
| `casualties` | 124,769 | One row per person injured or killed |

All three tables link via a shared `collision_index` field.

**Tools used:** MySQL 8, MySQL Workbench

## Key Findings

### 1. Night-time collisions are proportionally more severe, despite far lower volume
*(`queries/01_severity_by_hour.sql`)*

Collisions between midnight and 5am show a severe (fatal/serious) rate of **29–33%**, compared to just **21–26%** during the busiest daytime hours (7am–1pm) — even though daytime volume is 5–7x higher. A collision that happens overnight is meaningfully more likely to be serious, likely reflecting higher speeds and reduced visibility when roads are quieter.

### 2. Large motorcycles are involved in severe collisions at more than double the rate of cars
*(`queries/02_severity_by_vehicle_type.sql`)*

| Vehicle Type | Severe Rate |
|---|---|
| Car | 23.1% |
| HGV (7.5t+) | 31.1% |
| Motorcycle 125–500cc | 43.0% |
| **Motorcycle 500cc+** | **53.8%** |

This aligns with established road-safety research — motorcyclists lack the protective structure of a car — but it's striking to see the gap confirmed so clearly in the data.

### 3. Adverse weather is rare but disproportionately dangerous
*(`queries/03_severity_by_weather_and_road_surface.sql`)*

Fog/mist and high-wind conditions account for a small share of total collisions but show a severe rate of **32–37%**, compared to a **26.6%** baseline for fine weather on a dry road.

### 4. Severity rises with casualty age, and is consistently higher for male casualties
*(`queries/04_age_and_sex_breakdown.sql`)*

Casualties aged 60+ show the highest severe rate (30–32%), likely reflecting physical vulnerability to injury. Across every age band, male casualties showed a consistently higher severe rate than female casualties (roughly 6–9 percentage points). The dataset doesn't include road-user type (driver/passenger/pedestrian/cyclist) broken down by sex, so this analysis can't determine why — a natural next question for further investigation.

### 5. The highest severe-collision rates cluster in rural Scottish and Welsh authorities
*(`queries/05_severity_by_local_authority.sql`)*

The local authorities with the highest severe-collision rates (Aberdeenshire at 67.5%, Gwynedd at 56.2%) are rural areas in Scotland and Wales, not English cities. This is consistent with road-safety research linking higher speed limits and longer emergency response times in rural areas to more severe outcomes — though this dataset doesn't include speed-at-collision or response-time data to confirm the mechanism directly.

### 6. Large motorcycles show elevated severity across every driver age group — and it's worse for older riders
*(`queries/06_severity_by_vehicle_and_driver_age.sql`)*

Joining all three tables together, motorcycles 500cc+ show a severe casualty rate of **48–56% across every driver age band**, with the highest rate among riders 60+ (55.7%). This deepens finding #2: the elevated risk isn't just about the vehicle type in general, it holds regardless of rider experience, and appears to compound with the age-related vulnerability seen in finding #4.

**Note on this query:** because a single collision can involve multiple vehicles and multiple casualties, this three-way join creates a many-to-many relationship (a casualty is matched with every vehicle in their collision, not necessarily "their" vehicle). Standard STATS19 files don't include a direct casualty-to-vehicle link, so this is a genuine limitation worth flagging rather than treating the numbers as perfectly precise. The pattern is still directionally strong and consistent with the earlier vehicle-type finding.

## A note on data quality

Several fields in this dataset use `-1` as a "not recorded" placeholder rather than a true zero or blank (e.g. `local_authority_district`, which was unpopulated for every row in this file and was substituted with `local_authority_highway`, an ONS geography code). These placeholders are excluded from the relevant queries throughout.

## Repository structure

```
├── README.md
├── schema/
│   └── create_tables.sql
└── queries/
    ├── 01_severity_by_hour.sql
    ├── 02_severity_by_vehicle_type.sql
    ├── 03_severity_by_weather_and_road_surface.sql
    ├── 04_age_and_sex_breakdown.sql
    ├── 05_severity_by_local_authority.sql
    └── 06_severity_by_vehicle_and_driver_age.sql
```

## Data source

[DfT Road Safety Data (STATS19)](https://www.gov.uk/government/statistics/road-safety-data), Department for Transport, 2025 provisional data.
