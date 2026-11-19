-- =============================================================
-- 01_create_tables.sql
-- Creates the database and its two tables.
-- drops and recreates the tables.
-- =============================================================

IF DB_ID('NCYouthJustice') IS NULL
    CREATE DATABASE NCYouthJustice;
GO

USE NCYouthJustice;
GO

-- Drop in reverse order of foreign key (child table first).
DROP VIEW  IF EXISTS state_totals;
DROP VIEW  IF EXISTS county_stats_with_rates;
DROP TABLE IF EXISTS county_stats;
DROP TABLE IF EXISTS counties;
GO

-- One row per county. Area and district don't change between years.
CREATE TABLE counties (
    county_name        varchar(30) NOT NULL PRIMARY KEY,
    area               varchar(20) NOT NULL,   -- DPS area: Central, Eastern, Piedmont, Western
    judicial_district  varchar(5)  NOT NULL
);

-- One row per county per year. composite primary key makes sure each key is unique.
CREATE TABLE county_stats (
    county_name                 varchar(30) NOT NULL REFERENCES counties (county_name),
    year                        smallint    NOT NULL,
    population_10_17            int NOT NULL,  -- young people aged 10-17
    complaints_violent          int NOT NULL,  -- Class A-E felonies
    complaints_serious          int NOT NULL,  -- Class F-I felonies and A1 misdemeanors
    complaints_minor            int NOT NULL,  -- Class 1-3 misdemeanors
    complaints_infraction       int NOT NULL,
    complaints_status           int NOT NULL,  -- e.g. truancy, running away (not crimes for adults)
    complaints_delinquent_total int NOT NULL,  -- violent + serious + minor + infraction
    superior_court_transfers    int NOT NULL,  -- juveniles moved to the adult court system
    juveniles_detained          int NOT NULL,  -- distinct young people held in detention
    detention_admissions        int NOT NULL,  -- times young people were admitted to detention
    ydc_commitments             int NOT NULL,  -- commitments to a Youth Development Center
    jcpc_youth_served           int NOT NULL,  -- youth served by local prevention programs
    PRIMARY KEY (county_name, year)
);
GO

PRINT 'Tables created.';
