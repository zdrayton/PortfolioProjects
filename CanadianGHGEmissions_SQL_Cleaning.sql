/***********************************************
* Total Canadian CO2eq Emissions over 30 years *
***********************************************/
SELECT ROUND(SUM(CO2eq),2) AS Total_CO2eq_Mt        -- Select the rounded sum of CO2eq column and alias it as Total_CO2eq_Mt
FROM ghg_econ_can_prov_terr                         -- From the table ghg_econ_can_prov_terr
WHERE                                               -- Filter rows where Region is 'Canada' and Source is 'National Inventory Total'
	Region= 'Canada'
    AND Source = 'National Inventory Total';


/***********************************************
* Total CO2eq Emissions per year over 30 years *
***********************************************/
SELECT 
	Year,                                           -- Select the Year column
    ROUND(SUM(CO2eq),2) AS Total_CO2eq_Mt           -- Select the rounded sum of CO2eq column and alias it as Total_CO2eq_Mt
FROM ghg_econ_can_prov_terr                         -- From the table ghg_econ_can_prov_terr
WHERE                                               -- Filter rows where Region is 'Canada' and Source is 'National Inventory Total' 
	Region= 'Canada'
    AND Source = 'National Inventory Total'
GROUP BY Year;                                      -- Group results by Year


/*********************************************************
* Total CO2eq Per Province sorted from highest to lowest *
*********************************************************/
SELECT 
    Region, 
    ROUND(SUM(CO2eq),2) AS Total_CO2eq_Mt           -- Select the rounded sum of CO2eq column and alias it as Total_CO2eq_Mt
FROM ghg_econ_can_prov_terr                         -- From the table ghg_econ_can_prov_terr
WHERE                                               -- Filter rows where Region is not 'Canada', Source is 'National Inventory Total', and Total = True  
	Region <> 'Canada'
    AND Source = 'Provincial Inventory Total'
    AND Total = "True"
GROUP by Region                                     -- Group results by Region
ORDER BY Total_CO2eq_Mt DESC;                       -- Order results by Total_CO2eq_MT in descending order


/*************************
* Total CO2eq by Source  *
*************************/
SELECT 
    Source, 
    ROUND(SUM(CO2eq),2) AS Total_CO2eq_Mt           -- Select the rounded sum of CO2eq column and alias it as Total_CO2eq_Mt
FROM ghg_econ_can_prov_terr                         -- From the table ghg_econ_can_prov_terr
WHERE                                               -- Filter rows where Region is not 'Canada', Source is NOT the 'National Inventory Total' or Territorial Inventory Total, Category, Sub-category,Sub-sub-category are blank and the Total = True
	Region <> 'Canada'                               
    AND Source NOT IN ('Provincial Inventory Total', 'Territorial Inventory Total')
    AND Category = ""
	AND `Sub-category` = ""
    AND `Sub-sub-category` = ""
    AND Total = "True"
GROUP by Source                                     -- Group results by Source
ORDER BY Total_CO2eq_Mt DESC;                       -- Order results by Total_CO2eq_MT in descending order
