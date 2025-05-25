-- Active: 1747546794749@@127.0.0.1@5432@conservation_db

-- Rangers table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    "name" VARCHAR(50),
    region VARCHAR(50)
);

INSERT INTO rangers ("name", region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');


-- Species table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(50)
);


INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


-- Sighting table

CREATE TABLE sightings(

    sighiting_id SERIAL PRIMARY KEY,
    ranger_id INT,
    species_id INT,
    sighting_time TIMESTAMP,
    "location" VARCHAR(100),
    notes TEXT,

    Foreign Key (ranger_id) REFERENCES rangers(ranger_id),
    Foreign Key (species_id) REFERENCES species(species_id)
);

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


SELECT * FROM sightings

SELECT * FROM rangers

SELECT * FROM species


-- 1. Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO rangers("name", region) 
    VALUES('Derek Fox', 'Coastal Plains')



--2. Count unique species ever sighted.

SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings


--  3. Find all sightings where the location includes "Pass".

SELECT * FROM sightings
WHERE "location" LIKE '%Pass%';


-- 4. List each ranger's name and their total number of sightings.
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM sightings s
JOIN rangers r ON s.ranger_id = r.ranger_id
GROUP BY r.name;


-- 5. List species that have never been sighted.
SELECT common_name FROM species
LEFT JOIN sightings ON  species.species_id = sightings.species_id
WHERE sighting_id IS NULL


--6.  Show the most recent 2 sightings.
SELECT common_name, sighting_time, "name"  FROM species
JOIN sightings ON  species.species_id = sightings.species_id
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
ORDER BY sighting_time DESC
LIMIT 2


-- 7. Update all species discovered before year 1800 to have status 'Historic'.

UPDATE species
SET conservation_status = 'Historic'
WHERE extract(year FROM discovery_date) < 1800


-- 8. Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

SELECT s.sighting_id, 
CASE
    WHEN EXTRACT(HOUR FROM s.sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM s.sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END AS time_of_day 
FROM sightings as s


--9. Delete rangers who have never sighted any species

DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);

