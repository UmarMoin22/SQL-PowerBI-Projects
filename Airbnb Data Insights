-- Exploratory Data Analysis
-- AIRBNB_NEWYORK_CITY

-- What is the average, minimum, and maximum price for listings in each neighborhood?
SELECT 
    neighbourhood, AVG(price), MIN(price), MAX(price)
FROM
    airbnb_nyc
GROUP BY neighbourhood
ORDER BY AVG(price) DESC;

-- Which neighborhoods have the most listings?
SELECT neighbourhood, COUNT(*) AS total_listing FROM
    airbnb_nyc
GROUP BY neighbourhood
ORDER BY total_listing DESC
LIMIT 5;


-- What is the distribution of room types across different neighborhoods?
SELECT 
    neighbourhood, room_type, COUNT(*) AS total_listing
FROM
    airbnb_nyc
GROUP BY neighbourhood , room_type
ORDER BY total_listing DESC
LIMIT 10;

-- What are the average prices for each room type?
SELECT 
    room_type, AVG(price) AS Avg_Price
FROM
    airbnb_nyc
GROUP BY room_type;

-- Which hosts have the most listings?
SELECT 
    host_name, COUNT(*) AS most_listings
FROM
    airbnb_nyc
GROUP BY host_name
ORDER BY most_listings DESC
LIMIT 4;

-- TOP 5 HOST BY REVENUE:
SELECT 
    host_id,
    host_name,
    SUM(price * availability_365) AS total_revenue
FROM
    airbnb_nyc
GROUP BY host_id , host_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Which listings are available for more than 300 days in a year?
SELECT 
    name, neighbourhood, availability_365
FROM
    airbnb_nyc
WHERE
    availability_365 > 300
ORDER BY availability_365 DESC;

-- Listings with High Reviews and Availability:
SELECT 
    name, neighbourhood, availability_365, number_of_reviews
FROM
    airbnb_nyc
WHERE
    availability_365 > 300
        AND number_of_reviews > 50
ORDER BY number_of_reviews DESC; 


-- Listings with Above-Average Price and Below-Average Reviews:
WITH below_avg_listings AS (
  SELECT AVG(price) AS avg_price, AVG(number_of_reviews) AS avg_reviews
  FROM airbnb_nyc
)
SELECT host_name , name,avg_price, price , avg_reviews ,number_of_reviews
FROM airbnb_nyc, below_avg_listings
WHERE price > avg_price AND number_of_reviews < avg_reviews
ORDER BY price  DESC; 

-- Listings with Maximum Price Fluctuations
SELECT neighbourhood , VARIANCE(price) AS Price_fluctuation
FROM airbnb_nyc
GROUP BY neighbourhood ;
