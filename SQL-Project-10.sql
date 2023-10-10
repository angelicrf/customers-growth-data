--* Project #10

--You are to develop SQL statements for each task listed.
--You should type your SQL statements under each task.
/* Submit your .sql file named with your last name, first name and project # (e.g., Project10.sql).
Submit your file to the instructor using through the course site. */
-- It is your responsibility to provide a meaningful column name for the return value of the function.
-- These statements will NOT use GROUP BY or HAVING. Those keywords are introduced in the next module. one cell
-- results sets (one column and one row) do not need to have an order by clause.
-- Recall that sales to resellers are stored in the FactResellerSales table and sales to customers are stored in
-- the FactInternetSales table.

-- Do not remove the USE statement
USE CustomersGrowthDb;

-- 1.a. Find the count of customers who are married. Be sure give each derived field
-- an appropriate alias.
select count(*) as MarriedCustomers
from [dbo].[DimCustomer]
where [MaritalStatus] = 'M';

--1.b. Check your result. Write queries to determine if the answer to 1.a. is correct.
-- You should be writing proofs for all of your statements.
select [CustomerKey]
from [dbo].[DimCustomer]
where [MaritalStatus] = 'M';

--1.c. Find the total children (sum) and the total cars owned (sum) for customers who are married.
select sum([TotalChildren]) as TotalChildren, sum([NumberCarsOwned]) as TotalCarsOwned
from [dbo].[DimCustomer]
where [MaritalStatus] = 'M';

--1.d. Find the total children, total cars owned, and average yearly income for customers who are married.
select sum([TotalChildren]) as TotalChildren,
sum([NumberCarsOwned]) as TotalCarsOwned,
avg([yearlyIncome]) as AverageyearlyIncome
from [dbo].[DimCustomer]
where [MaritalStatus] = 'M';

--2.a. List the total dollar amount (SalesAmount) for sales to Resellers. round to two decimal places.
select round(sum([SalesAmount]),2) as TotalDollarAmount
from [dbo].[FactResellerSales];

--2.b. List the total dollar amount (SalesAmount) for 2008 sales to resellers in Germany.
-- Show only the total sales--one row, one column--rounded to two decimal places.
select round(sum(frs.[SalesAmount]),2) as TotalDollarAmount
from [dbo].[FactResellerSales] as frs
inner join [dbo].[DimReseller] as r
on r.ResellerKey = frs.ResellerKey
inner join [dbo].[DimGeography] as g
on g.GeographyKey = R.GeographyKey
where g.EnglishcountryRegionName = 'Germany' and year([OrderDate]) = 2008;

--3.a. List the total dollar amount (SalesAmount) for sales to Customers. round to two decimal places.
select round(sum([SalesAmount]),2) as TotalDollarAmount
from [dbo].[FactInternetSales];

--3.b. List the total dollar amount (SalesAmount) for 2005 sales to customers located in the
-- United Kingdom. Show only the total sales--one row, one column--rounded to two decimal places.
select round(sum(fis.[SalesAmount]),2) as TotalDollarAmount
from [dbo].[FactInternetSales] as fis
inner join [dbo].[DimCustomer] as c
on c.CustomerKey = fis.CustomerKey
inner join [dbo].[DimGeography] as g
on g.GeographyKey = c.GeographyKey
where year([OrderDate]) = 2008 and G.EnglishcountryRegionName = 'United Kingdom';

--4. List the average unit price for a touring bike sold to customers. round to
-- two decimal places.
select round(avg(fis.[UnitPrice]),2) as AverageUnitPrice
from [dbo].[FactInternetSales] as fis
inner join [dbo].[DimProduct] as p
on p.ProductKey = fis.ProductKey
inner join [dbo].[DimProductSubcategory] as ps
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
where ps.EnglishProductSubcategoryName = 'touring bikes';

--5. List bikes that have a list price less than the average list price for all bikes.
-- Show product key, English product name, and list price.
-- Order descending by list price.
select [ProductKey], [EnglishProductName], [ListPrice]
from [dbo].[DimProduct] as p
inner join [dbo].[DimProductSubcategory] as ps
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
inner join [dbo].[DimProductCategory] as pc
on pc.ProductCategoryKey = ps.ProductCategoryKey
where pc.[ProductCategoryKey] = 1 and [ListPrice] <
(select avg([ListPrice]) from [dbo].[DimProduct])
order by [ListPrice] desc;

--6. List the lowest list price, the average list price, the highest list price, and product count for road bikes.
select min(p.[ListPrice]) as LowestListPrice,
avg(p.[ListPrice]) as AverageListPrice,
max(p.[ListPrice]) HighestListPrice,
count(*) as Productcount
from [dbo].[DimProduct] p
inner join [dbo].[DimProductSubcategory] as PS
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
where ps.EnglishProductSubcategoryName = 'road bikes';

-- 7. List the product alternate key, product name, and list price for the product(s)
-- with the lowest List Price. There can be multiple products with the lowest list price.
select [ProductAlternateKey], [EnglishProductName], [ListPrice]
from [dbo].[DimProduct]
where [ListPrice] =
(select min([ListPrice])
from [dbo].[DimProduct]);

-- 8.a. List the product alternate key, product name, list price, dealer price, and the
-- difference (calculated field) for all product(s). Show all money values to 2 decimal places.
-- Sort on difference from highest to lowest.
select [ProductAlternateKey], [EnglishProductName],
round([ListPrice],2) as ListPrice, round([DealerPrice],2) as DealerPrice,
round(([ListPrice] - [DealerPrice]),2) as PriceDifference
from [dbo].[DimProduct]
order by PriceDifference desc;

-- 8.b. Use the statement from 8.a. and modify to find the product(s) with the largest difference
-- between the list price and the dealer price. Show all money values to 2 decimal places.
select [ProductAlternateKey], [EnglishProductName],
round([ListPrice],2) as ListPrice,
round([DealerPrice],2) as DealerPrice,
round(([ListPrice] - [DealerPrice]),2) as PriceDifference
from [dbo].[DimProduct]
where [ListPrice] = 3578.27
order by PriceDifference desc;

-- 9. List total Internet sales for product BK-M82S-44 using two methods: Total the sales amount field
-- and calculate the total amount using unit price and quantity. Place both calculations in different
-- columns in the SAME select statement. There will be one results set with two columns and one row.
-- Show all money values to 2 decimal places. The values should be the same.
select round(sum(fis.[SalesAmount]),2) as TotalSalesAmount1,
round(sum(fis.[UnitPrice]*fis.[OrderQuantity]),2) as TotalSalesAmount2
from [dbo].[FactInternetSales] as fis
inner join [dbo].[DimProduct] as p
on p.ProductKey = fis.ProductKey
where p.ProductAlternateKey = 'BK-M82S-44';