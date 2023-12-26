-- Data Science Project 1 
-- Analisis Kinerja Penjualan Superstore Menggunakan PostgreSQL dan Google Data Studio
-- Inne Andarini

-- Query all data from a table
select * from orders o;
select * from returns r;
select * from people p;

--Data Understanding
-- Query data and select only unique rows;
select distinct "Customer ID" from orders o; --Terdapat 793 Customer ID
select distinct "Ship Mode" from orders o; -- Terdapat 4 jenis mode pengiriman barang (Standard Class, Second Class, Same Day. dan First Class)
select distinct "segment" from orders o ; -- Terdapat 3 jenis segment (Consumer, Corporate, dan Home Office)
select distinct "country" from orders o; -- Hanya di negara United States
select distinct "city" from orders o; -- Pelanggan tersebar di 531 kota di United States
select distinct "state" from orders o; -- Pelanggan tersebar di 49 wilayah
select distinct "Product ID" from orders o; -- Terdapat 1862 Product ID/barang yang dijual
select distinct "category" from orders o; --Terdapat 3 category barang yang dijual (Furniture, Office Supplies, dan Technology)
select distinct "Sub-Category" from orders o; --Terdapat 17 Sub-Category
select distinct "discount" from orders o; --Terdapat 12 jenis discount yang berbeda digunakan (0% hingga 80%)

-- Rentang pemesanan yang dilakukan oleh Customer
select 
	min ("Order Date") as StartOrderDate,
	max ("Order Date") as EndOrderDate
from orders o; --Rentang pemesanan dari 03 Januari 2014 hingga 30 Desember 2017

-- Query data from a table with a filter
select * from orders o where  profit < 0; -- Terdapat 4096 jumlah data dengan profit negatif.

-- Data Analysis
-- 1. Total Sales dan Profit per Kategori Produk
select category,
  sum(sales) as Total_Sales,
  sum(profit) as Total_Profit,
  cast((sum(profit) / nullif(sum(sales), 0)) * 100 as numeric(10, 2)) as Profit_Margin
from orders o
group by category;


--2. Total Sales dan Profit per Tahun
select
  extract(year from TO_DATE("Order Date", 'YYYY-MM-DD')) as SalesYear,
  sum(sales) as TotalSales,
  sum(profit) as TotalProfit
from orders o 
group by SalesYear
order by SalesYear;

--3. Total Sales dan Profit per Negara
select country,
	sum (sales) as Total_Sales,
	sum (Profit) as Total_Profit
from orders o 
group by country;

--4. Jumlah Produk Terjual per Kategori
select category, "Sub-Category",
	sum (quantity) as Total_Quantity_Sold
from orders o 
group by category, "Sub-Category";

select category, 
	sum(quantity) as Total_Quantity_Sold
from orders o
group by category;

select "Sub-Category",
	sum (quantity) as Total_Quantity_Sold
from orders o 
group by "Sub-Category" ;

--5. Total Penjualan dan Laba per region
select region,
	sum (sales) as Total_Sales,
	sum(profit) as Total_Profit
from orders o 
group by region;

--6. Efektivitas Metode Pengiriman (Ship Mode)
select "Ship Mode",
	count (*) as Total_Orders,
	avg (profit) as Avg_Profit_perOrders
from orders o 
group by "Ship Mode";

--7.Pengaruh Diskon terhadap Profit
select discount,
	avg(profit) as Avg_profit
from orders o
group by discount;

--8. Analisis Segment Pelanggan
select segment,
	count (*) as Total_Customers,
	avg (profit) as Avg_Profit_perCustomer
from orders o 
group by segment;

-- 9. Trend Sales dan Profit Bulanan
select 
  extract(month  from to_date("Order Date", 'YYYY-MM-DD')) as SalesMonth,
  sum(sales) as TotalSales,
  sum(profit) as TotalProfit
from orders o
group by SalesMonth
order by SalesMonth;
 
--10. Kontribusi Pelanggan per Segment
select segment,
	count (distinct "Customer ID") as Total_Customers,
	sum (profit) as Total_Profit
from orders o 
group by segment;

-- 11. Profit yang negatif
select *
from orders o 
where profit < 0;

--12. Pengaruh Diskon terhadap Sales
select discount,
	avg (sales) as Average_Sales,
	avg (profit) as Average_Sales
from orders o 
group by discount 
order by discount;

--13. Analisis Region dan Segment
select region, segment,
	sum(sales) as Total_Sales,
	sum(profit) as Total_Profit
from orders o 
group by region, segment 
order by Total_Sales desc;


 --14. Total Pengembalian Product per Tahun
select
  extract(year  from to_date("Order Date", 'YYYY-MM-DD')) as "Order Year",
  count(distinct r."Order ID") as TotalReturns,
  count(distinct o."Order ID") as TotalOrders,
  count(distinct r."Order ID") * 100.0 / count(distinct o."Order ID") as ReturnPercentage
from orders o
left join
  returns r on o."Order ID" = r."Order ID"
group by "Order Year"
order by "Order Year";

--15. Produk apa saja yang kembalikan
select
  o."Product ID",
  o."Product Name",
  count(r."Order ID") as TotalReturns
from orders o 
inner join
  returns r on o."Order ID" = r."Order ID"
where r."returned" = 'Yes'
group by o."Product ID", o."Product Name"
order by TotalReturns desc;
 
--- Category
select
  o."category",
  count(r."Order ID") as TotalReturns
from orders o 
inner JOIN
  returns r on o."Order ID" = r."Order ID"
where r."returned" = 'Yes'
group by o."category"
order by TotalReturns desc;
 
 --- Sub-Category
 select
  o."Sub-Category",
  count(r."Order ID") as TotalReturns
from orders o 
inner JOIN
  returns r on o."Order ID" = r."Order ID"
where r."returned" = 'Yes'
group by o."Sub-Category"
order by TotalReturns desc;
 




 
 
 













