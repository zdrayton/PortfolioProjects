/********************************
* Total Streams and Artist      *
  490B Streams from 953 Artists *
********************************/
SELECT 
	SUM(streams) AS Streams,                    -- Summing the 'streams' column and aliasing as 'Streams'
	COUNT("artists(s)_name") AS Total_Artist    -- Counting the occurrences of the 'artists(s)_name' column and aliasing as 'Total_Artists'
FROM updated_spotify_file;                      -- From the table named 'updated_spotify_file'




/************************* 
* Tracks by Release Date *
*************************/
SELECT
	released_year AS Year,                      -- Selecting and aliasing the 'released_year' column as 'Year'
	SUM(streams) AS Streams,                    -- Summing the 'streams' column and aliasing as 'Streams'
	COUNT("artists(s)_name") AS Total_Artists   -- Counting the occurrences of the 'artists(s)_name' column and aliasing as 'Total_Artists'
FROM updated_spotify_file                       -- From the table named 'updated_spotify_file'
GROUP BY Year                                   -- Grouping the results by the 'Year' column
ORDER BY Year ASC;                              -- Sorting the results in ascending order based on the 'Year' column



/********************************************************************** 
* Total Streams by Artist and Track Name from Highest to Lowest       *
* Most Streamed Song = The WEEKND - Blinding Lights with 3.7B streams *
**********************************************************************/
SELECT
	MAX(streams) AS Streams,                    -- Selecting the maximum value of 'streams' and aliasing it as 'Streams'
	`artist(s)_name` AS Artist,                 -- Selecting the 'artist(s)_name' column and aliasing it as 'Artist'
    track_name AS `Track Name`                  -- Selecting the 'track_name' column and aliasing it as 'Track Name'
FROM updated_spotify_file                       -- From the table named 'updated_spotify_file'
GROUP BY Artist, `Track Name`                   -- Grouping the results by 'Artist' and 'Track Name'
ORDER BY Streams DESC;                          -- Ordering the results in descending order based on each tracks total streams




/******************************************************* 
* A table of the most streamed Tracks by Release Year  *
*******************************************************/
-- Creating a Common Table Expression (CTE) named RankedArtists to organize data and rank artists based on streams.
WITH RankedArtists AS (
    SELECT
        released_year AS Year,                  -- Selecting the released year as Year.
        streams,                                -- Selecting the streams column
        `artist(s)_name` AS Artist,             -- Selecting the artist name as Artist.
        track_name,                             -- Selecting the track names
        RANK() OVER (PARTITION BY released_year ORDER BY streams DESC) AS ArtistRank  -- Assigning a rank to each artist based on streams, partitioned by released year.
    FROM updated_spotify_file
)
-- Selecting specific columns from the RankedArtists CTE where the artist has the highest rank (1) in each released year.
SELECT
    Year,                                     -- Selecting the Year column.
    streams AS Streams,                       -- Selecting the streams column.
    Artist,                                   -- Selecting the Artist column.
    track_name AS "Track Name"                -- Selecting the Track Name column and aliasing it.
FROM RankedArtists
WHERE ArtistRank = 1                          -- Filtering only rows where the artist has the highest rank.
ORDER BY Year ASC;                            -- Sorting the result by Year in ascending order.




/******************************************************************************************************************************************
* The below query can be used to find the number one song(s) in each category, just change the ORDER BY Clause to the respective Category *
******************************************************************************************************************************************/

SELECT 
    MAX(`acousticness_%`) AS Acousticness,  -- Selecting the maximum value of 'acousticness_%' and aliasing it as 'Acousticness'
	MAX(`danceability_%`) AS Danceability,  -- Selecting the maximum value of 'danceability_%' and aliasing it as 'Danceability'
    MAX(`energy_%`) AS Energy,              -- Selecting the maximum value of 'danceability_%' and aliasing it as 'Danceability'
    MAX(`speechiness_%`) AS Speechiness,    -- Selecting the maximum value of 'danceability_%' and aliasing it as 'Danceability'
    MAX(`valence_%`) AS Valence,            -- Selecting the maximum value of 'danceability_%' and aliasing it as 'Danceability'
    `artist(s)_name` AS Artist,             -- Selecting the 'artist(s)_name' column and aliasing it as 'Artist'
    track_name AS `Track Name`              -- Selecting the 'track_name' column and aliasing it as 'Track Name'
FROM updated_spotify_file                   -- From the table named 'updated_spotify_file'
GROUP BY Artist, `Track Name`               -- Grouping the results by 'Artist' and 'Track Name'
ORDER BY "Category_%" DESC;                  -- Ordering the results in descending order based on the select Category


/******************************************************************************************************************************************
* Tracks from Highest to Lowest Accousticness                                                                                             *
* Two way tie: Taylor Swift - Sweet Nothing = 97%                                                                                         *
*			   Lord Huron - The Night We Met = 97%                                                                                        *
******************************************************************************************************************************************/
ORDER BY Acousticness DESC;                   -- Ordering the results in descending order based on 'Acousticness'


/****************************************************
* Tracks from Highest to Lowest Danceability        *
* Ed Sheeran, Fireboy DML - Peru = 96%              *
****************************************************/
ORDER BY Danceability DESC;                   -- Ordering the results in descending order based on 'Danceability'


/******************************************************************************************************************************************
* Tracks from Highest to Lowest Energy                                                                                                    *
* Two way tie: Kordhell - Murder In My Mind = 97%                                                                                         *
*			   Bebe Rexha, David Guetta - I'm Good(Blue) = 97%                                                                            *
******************************************************************************************************************************************/
ORDER BY Energy DESC;                         -- Ordering the results in descending order based on 'Energy'


/****************************************************
* Tracks from Highest to Lowest Liveness            *
* MC Caverinha, KayBlack = Cartão Black = 97%       *
****************************************************/
ORDER BY Liveness DESC;                       -- Ordering the results in descending order based on 'Liveness'


/****************************************************
* Tracks from Highest to Lowest Speechiness         *
* MC Caverinha, KayBlack = Cartão Black = 64%       *
****************************************************/
ORDER BY Speechiness DESC;                   -- Ordering the results in descending order based on 'Speechiness'


/******************************************************************************************************************************************
* Tracks from Highest to Lowest Valence                                                                                                 *
* Five way tie: Central Cee - Doja = 97%                                                                                                  *
*			    Victor Cibrian - En El Radio Un Cochinero = 97%                                                                           *
*               Luis R Conriques, La Adictiva - JGL = 97%                                                                                 *
*               Shawn Mendes - There’s Nothing Holdin’ Me Back = 97%                                                                      *
*               Leo Santana - Zone De Perigo = 97%                                                                                        *
******************************************************************************************************************************************/
ORDER BY Valence DESC;                      -- Ordering the results in descending order based on 'Valence'