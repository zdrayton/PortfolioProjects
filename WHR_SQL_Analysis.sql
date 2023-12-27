/************************************************************
* In-depth Analysis of Happiness Scores by Year and Country *
************************************************************/
SELECT
	Year,                                                                                               -- Extracts data from the Year column.
    	Country,                                                                                            -- Extracts data from the Country column.
	ROUND(AVG(`Happiness Score`), 2) AS Happiness_Score,                                                -- Calculating and rounding the average Happiness Score to 2 decimal places.
	ROUND(AVG(`Economy (GDP per Capita)`), 2) AS Economy,                                               -- Calculating and rounding the average GDP per Capita to 2 decimal places. 
    	ROUND(AVG(Family), 2) AS Family,                                                                    -- Calculating and rounding the average Family score to 2 decimal places.
    	ROUND(AVG(`Health (Life Expectancy)`), 2) AS Health,                                                -- Calculating and rounding the average Life Expectancy to 2 decimal places.
    	ROUND(AVG(Freedom), 2) AS Freedom,                                                                  -- Calculating and rounding the average Freedom score to 2 decimal places.
    	ROUND(AVG(`Trust (Government Corruption)`), 2) AS Corruption,                                       -- Calculating and rounding the average Government Corruption score to 2 decimal places.
    	ROUND(AVG(Generosity), 2) AS Generosity,                                                            -- Calculating and rounding the average Generosity score to 2 decimal places.
    	ROUND(AVG(`Dystopia Residual`), 2) AS Dystopian_Residual,                                           -- Calculating and rounding the average Dystopia Residual to 2 decimal places.
FROM whr_raw_data                                                                                           -- From the whr_raw_data table.
GROUP BY Year, Country;                                                                                     -- Grouping the results by Year and Country.


/******************************************************************
* Analysis of Countries with the highest Happiness Scores by Year *
******************************************************************/
SELECT
	Year,                                                                                               -- Extracts data from the Year column.
    	Country,                                                                                            -- Extracts data from the Country column.
	ROUND(AVG(`Happiness Score`), 2) AS Happiness_Score,                                                -- Calculating and rounding the average Happiness Score to 2 decimal places.
	ROUND(AVG(`Economy (GDP per Capita)`), 2) AS Economy,                                               -- Calculating and rounding the average GDP per Capita to 2 decimal places.  
    	ROUND(AVG(Family), 2) AS Family,                                                                    -- Calculating and rounding the average Family score to 2 decimal places.
    	ROUND(AVG(`Health (Life Expectancy)`), 2) AS Health,                                                -- Calculating and rounding the average Life Expectancy to 2 decimal places.
    	ROUND(AVG(Freedom), 2) AS Freedom,                                                                  -- Calculating and rounding the average Freedom score to 2 decimal places.
    	ROUND(AVG(`Trust (Government Corruption)`), 2) AS Corruption,                                       -- Calculating and rounding the average Government Corruption score to 2 decimal places.
    	ROUND(AVG(Generosity), 2) AS Generosity,                                                            -- Calculating and rounding the average Generosity score to 2 decimal places.
	ROUND(AVG(`Dystopia Residual`), 2) AS Dystopian_Residual                                            -- Calculating and rounding the average Dystopia Residual to 2 decimal places.
FROM whr_raw_data                                                                                           -- From the whr_raw_data table.
WHERE `Happiness Rank` = 1                                                                                  -- Filter rows where Happiness Rank = 1.
GROUP BY Year, Country;                                                                                     -- Grouping the results by Year and Country.

/********************************************************
* Happiness Score Category Ratios in Percentage by Year *
********************************************************/
SELECT
-- Selecting columns and calculating the percentage of each factor relative to Happiness Score.
	Year,
	ROUND((Economy/Happiness_Score)*100, 2) AS `Economy (GDP) to Happiness (%)`,
    	ROUND((Family/Happiness_Score)*100, 2) AS `Family to Happiness (%)`,
    	ROUND((Health/Happiness_Score)*100, 2) AS `Health to Happiness (%)`,
    	ROUND((Freedom/Happiness_Score)*100, 2) AS `Freedom to Happiness (%)`,
    	ROUND((Corruption/Happiness_Score)*100, 2) AS `Govt_Corruption to Happiness (%)`,
    	ROUND((Generosity/Happiness_Score)*100, 2) AS `Generosity to Happiness (%)`,
    	ROUND((Dystopian_Residual/Happiness_Score*100), 2) AS `Dystopian Residual to Happiness (%)`

-- Subquery to calculate average values for each factor grouped by Year.
FROM ( 
	SELECT
		Year,
            	AVG(`Happiness Score`) AS Happiness_Score,
            	AVG(`Economy (GDP per Capita)`) AS Economy, 
            	AVG(Family) AS Family,
            	AVG(`Health (Life Expectancy)`) AS Health,
            	AVG(Freedom) AS Freedom,
            	AVG(`Trust (Government Corruption)`) AS Corruption,
            	AVG(Generosity) AS Generosity,
            	AVG(`Dystopia Residual`) AS Dystopian_Residual
	FROM whr_raw_data
        GROUP BY Year
	) AS Averages
GROUP BY Year;
