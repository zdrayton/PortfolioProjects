-- 1st: Find the crime report for a muder that took place on January 15, 2018 in SQL City
SELECT *
FROM crime_scene_report
WHERE type = 'murder'

-- 2nd: Find the name of the two witness
-- 1st Witness: 14887, Morty Schapiro, 4949 Northwestern Dr
SELECT * 
FROM person
WHERE address_street_name = 'Northwestern Dr'
GROUP BY name
ORDER BY address_number DESC;
-- 2nd Witness: 16371, Annabel Miller, 103 Franklin ave
SELECT * 
FROM person
WHERE
	name LIKE '%Annabel%' AND
	address_street_name = 'Franklin Ave';


-- 3rd: Read transcripts from witness to gather info on killer
	-- Gunshot, Gold Member starting with 48Z, car plate H42W
	-- Killer working out with Annabel on Jan 9th
SELECT *
FROM interview
WHERE person_id IN (14887,16371);

-- 4th: Verify Gold Members starting with 48Z and a check in date of Jan 9th, 2018
-- Joe Germuska, 48Z7A
-- Jeremy Bowers, 48Z55
SELECT gfnm.id, gfnm.name
FROM get_fit_now_member gfnm
JOIN get_fit_now_check_in gfnc ON gfnm.id = gfnc.membership_id
WHERE 
	membership_id LIKE ('48Z%') AND
	membership_status = 'gold' AND
	check_in_date = 20180109;

-- 5th: Verify plate number to narrow down to Jeremy Bowers
SELECT gfnm.id, gfnm.name
FROM get_fit_now_member gfnm
JOIN get_fit_now_check_in gfnc ON gfnm.id = gfnc.membership_id
JOIN person p ON gfnm.person_id = p.id
JOIN drivers_license dl ON p.license_id = dl.id
WHERE 
	membership_id LIKE ('48Z%') AND
	membership_status = 'gold' AND
	check_in_date = 20180109 AND
	dl.plate_number LIKE '%H42W%';

-- 6th (Challenge): Find the woman who hire Jeremy Bowers to do the hit.
-- Has a lot of money
-- Height: 5'5 (65) or 5'7 (67)
-- Hair: red
-- Car: Tesla Model S
-- Attended SQL Symphony 3 times in December 2017
SELECT *
FROM interview
WHERE person_id = 67318

-- The woman's name is Miranda Priestly
SELECT p.name
FROM person p 
JOIN drivers_license dl ON p.license_id = dl.id 
JOIN income i ON p.ssn = i.ssn
JOIN facebook_event_checkin fec ON p.id = fec.person_id
WHERE
	gender = 'female' AND
	hair_color = 'red' AND
	car_make = 'Tesla' AND
	car_model = 'Model S' AND
	event_name = 'SQL Symphony Concert'
GROUP BY p.name
HAVING COUNT(event_name) = 3;
