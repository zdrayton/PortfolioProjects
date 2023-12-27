/******************************* 
* Average Orders per Day = 60  *
* Average Pizzas per Order = 2 *
* Total Orders = 21,350        *
* Total Sales = $817860.50     *
*******************************/                 
SELECT 
	ROUND(COUNT(DISTINCT order_details.order_id)/COUNT(DISTINCT orders.date), 1) AS Avg_Per_Day,                    -- Calculates the average number of orders per day, rounded to one decimal place.
	ROUND(COUNT(DISTINCT order_details.order_details_id)/COUNT(DISTINCT orders.order_id), 1) AS Avg_Per_Order,      -- Calculates the average number of pizzas per order, rounded to one decimal place.
	COUNT(DISTINCT orders.order_id) As Total_Orders,                                                                -- Counts the total number of distinct orders.
	ROUND(SUM(order_details.quantity * pizzas.price), 2) AS Total_Sales                                             -- Calculates the total sales by summing the quantity times price for each order detail, rounded to two decimal places.
FROM order_details                                                                                                  	-- From the order_details table.
JOIN orders ON order_details.order_id = orders.order_id                                                             	-- Join the orders table to the order_details table through order_id.
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id;                                                            	-- Join the pizzas table to the order_details table through pizza_id.



/*********************************** 
* Total Orders and Sales Per Month *
***********************************/
SELECT 
    monthname(Monthly.date) AS Month,                                       	-- Extracts the month name from the date and aliases it as "Month".
    SUM(Monthly.Total_Orders) AS Orders,                                    	-- Calculates the total number of orders for each month. 
    ROUND(SUM(Monthly.Total_Sales),2) AS Sales                             	-- Calculates the total sales for each month and rounds to 2 decimal places.

-- Subquery: Aggregates data at the monthly level. 	
FROM ( 										 
	SELECT 
        	orders.date,                                                    -- Selects the date from the orders table. 
        	COUNT(orders.order_id) AS Total_Orders,                         -- Counts the total number of orders for each date. 
        	SUM(order_details.quantity * pizzas.price) AS Total_Sales       -- Calculates the total sales for each date.
	FROM order_details                                                  	-- From the order_details table.
	JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id             	-- Join the pizza table to the order_details table through pizza_id.
        JOIN orders ON order_details.order_id = orders.order_id             	-- Join the orders table to the order_details table through order_id.
	GROUP BY orders.date                                               	-- Groups the results by date. 
	) AS Monthly
GROUP BY monthname(Monthly.date);                                           	-- Groups the monthly results by month name.


/**********************************
* Pizza Type Performance by Sales *
**********************************/
SELECT 
    Total.Type,                                                                 -- Extracts the pizza types from the pizza_types table final aggregation.
    Total.Category,                                                             -- Extracts the pizza categories from the pizza_types table for final aggregation. 
    SUM(Total.Total_Orders) AS Orders,                                          -- Calculates the total number of orders for each month.  
    ROUND(SUM(Total.Total_Sales),2) AS Sales                                    -- Calculates the total sales for each month and rounds to 2 decimal places.

-- Subquery to aggregate data at the pizza type and category level
FROM ( 
	SELECT 
		pizza_types.name AS Type,                                       -- Extracts the pizza types from the pizza_types table for subquery aggregation.
		pizza_types.category AS Category,                               -- Extracts the pizza categories from the pizza_types table for subquery aggregation. 
            	COUNT(orders.order_id) AS Total_Orders,                         -- Counts the total number of orders for each date.  
            	SUM(order_details.quantity * pizzas.price) AS Total_Sales       -- Calculates the total sales for each date.
	FROM order_details                                                      -- From the order_details table.
        JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id                 -- Join the pizza table to the order_details table through pizza_id.
        JOIN orders ON order_details.order_id = orders.order_id                 -- Join the orders table to the order_details table through order_id.
        JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id    -- Join the pizza_types table to the pizzas table through order_id.
        GROUP BY Type, Category                                                 -- Group total orders and total sales by pizza type and category. 
	) AS Total
GROUP BY Type, Category                                                         -- Grouping the final result set by pizza type and category.
ORDER BY Sales DESC;                                                            -- Ordering the final result set by total sales in descending order.


/***********************************
* Pizza Category Performance Table *
***********************************/
SELECT 
    Total.Category,                                                                                 -- Extracts the pizza categories from the pizza_types table for final aggregation.                                          
    ROUND(SUM(Total.Total_Sales),2) AS Sales,                                                       -- Calculating and rounding the total overall sales.
    SUM(Total.Total_Orders) AS Orders,                                                              -- Summing up the monthly total orders.
    ROUND(SUM(Total.Total_Sales)/ SUM(SUM(Total.Total_Sales)) OVER(),3) AS Category_Sales_Ratio,    -- Uses a window function to sum up every order's category to sales ratios.     
    ROUND(SUM(Total.Total_Orders)/ SUM(SUM(Total.Total_Orders)) OVER(),3) AS Category_Order_Ratio   -- Uses a window function to sum up every order's category to order ratios.   

-- Subquery to aggregate data at the category level
FROM ( 
	SELECT 
		pizza_types.category AS Category,                                                   -- Selecting the category from the pizza_types table.
            	COUNT(orders.order_id) AS Total_Orders,                                             -- Counts the total number of orders for each date.
            	SUM(order_details.quantity * pizzas.price) AS Total_Sales                           -- Calculates the total sales for each date.
	FROM order_details                                                                          -- From the order_details table.
        JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id                                     -- Join the pizza table to the order_details table through pizza_id.
        JOIN orders ON order_details.order_id = orders.order_id                                     -- Join the orders table to the order_details table through order_id.
        JOIN pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id                        -- Join the pizza_types table to the pizzas table through order_id.
        GROUP BY Category                                                                           -- Group total orders and total sales by category.
	) AS Total
GROUP BY Category                                                                                   -- Grouping the final result set by pizza category.
ORDER BY Sales DESC;                                                                                -- Ordering the final result set by total sales in descending order.


/*******************************
* Pizza Size Performance Table *
*******************************/
SELECT
	Total.Size AS Size,
    	ROUND(SUM(Total.Total_Sales),2) AS Sales,                                                   -- Calculating and rounding the total overall sales.
    	SUM(Total.Total_Orders) AS Orders,                                                          -- Summing up the monthly total orders. 
    	ROUND(SUM(Total.Total_Sales)/ SUM(SUM(Total.Total_Sales)) OVER(),3) AS Size_Sales_Ratio,    -- Uses a window function to sum up every order's size to sales ratios.    
    	ROUND(SUM(Total.Total_Orders)/ SUM(SUM(Total.Total_Orders)) OVER(),3) AS Size_Order_Ratio   -- Uses a window function to sum up every order's size to sales ratios.    

-- Subquery to aggregate data at the size level
FROM ( 
	SELECT 
		pizzas.size,                                                                        -- Selecting the sizes from the pizzas table.
            	COUNT(orders.order_id) AS Total_Orders,                                             -- Counts the total number of orders for each date. 
            	SUM(order_details.quantity * pizzas.price) AS Total_Sales                           -- Calculates the total sales for each date.
	FROM order_details                                                                          -- From the order_details table.
        JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id                                     -- Join the pizza table to the order_details table through pizza_id.
        JOIN orders ON order_details.order_id = orders.order_id                                     -- Join the orders table to the order_details table through order_id.
        GROUP BY pizzas.size                                                                        -- Group total orders and total sales by pizza size.
	) AS Total
GROUP BY Size                                                                                       -- Grouping the final result set by pizza sizes.
ORDER BY Sales DESC;                                                                                -- Ordering the final result set by total sales in descending order.


/***************************************************
* Orders per hour to find Peak Order time          *
* 12 PM to 3 PM was the busiest with 6,445 orders. *
***************************************************/
SELECT 
	COUNT(DISTINCT order_id) As Total_Orders,                                                   -- Count the number of distinct order IDs and alias the result as 'Total_Orders'
	CASE                                                                                        -- Categorize orders based on the time of day using a CASE statement
		WHEN TIME(orders.time) BETWEEN '09:00:00' AND '12:00:00' THEN '9 AM - 12 PM'
	        WHEN TIME(orders.time) BETWEEN '12:00:01' AND '15:00:00' THEN '12 PM - 3 PM'
	        WHEN TIME(orders.time) BETWEEN '15:00:01' AND '18:00:00' THEN '3 PM - 6 PM'
	        WHEN TIME(orders.time) BETWEEN '18:00:01' AND '21:00:00' THEN '6 PM - 9 PM'
        	ElSE '9 PM - 12 PM'
	END AS Hours
FROM orders                                                                                         -- From the orders table.
GROUP BY Hours                                                                                      -- Group the results by the 'Hours' category.
ORDER BY Total_Orders DESC;                                                                         -- Order the results by the total number of orders in descending order.


/*****************************************
* Orders per day to find Peak Order Day  *
* Friday was the most with 3,538 orders. *-- Format the order dates to Weekday names.
*****************************************/
SELECT 
	COUNT(DISTINCT order_id) As Total_Orders,                                                   -- Count the number of distinct order IDs and alias the result as 'Total_Orders'
	DATE_FORMAT(orders.date, '%W') AS Day_of_Week                                               -- Retrieve the day of the week from the 'date' column and format it to a day of the week.
FROM orders                                                                                         -- From the orders table.
GROUP BY Day_of_Week                                                                                -- Group the results by day of the week.
ORDER BY Total_Orders DESC;                                                                         -- Order the results by the total number of orders in descending order.                             
