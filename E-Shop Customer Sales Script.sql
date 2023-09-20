SELECT * FROM sales_eshop.customer_sales;
-- Limpieza de datos:
UPDATE customer_sales
SET gender = CASE
    WHEN gender = 0 THEN 'M'
    WHEN gender = 1 THEN 'F'
    ELSE gender
END,
newsletter = CASE
    WHEN newsletter = 0 THEN 'No'
    WHEN newsletter = 1 THEN 'Yes'
    ELSE newsletter
END,
pay_method = CASE
WHEN pay_method = 0 THEN "E-Wallet"
WHEN pay_method = 1 THEN "Card"
WHEN pay_method = 2 THEN "PayPal"
WHEN pay_method = 3 THEN "Other"
END,
browser = CASE
WHEN browser = 0 THEN "Chrome"
WHEN browser = 1 THEN "Safari"
WHEN browser = 2 THEN "Edge"
WHEN browser = 3 THEN "Others"
END,
voucher = CASE
WHEN voucher = 0 THEN "Not used"
WHEN voucher = 1 THEN "Used"
END
;

-- Distribución de compras por género:
SELECT gender, count(n_purchases) as purchases, sum(Purchase_VALUE) as total_value_purchases
from customer_sales
group by gender
order by sum(Purchase_VALUE);
-- Cantidad de compras promedio por género:
select gender, max(n_purchases) as max_quantity_purchase_by_gender, max(purchase_value) as max_purchase_by_gender
from customer_sales
group by gender
order by max(purchase_value) desc;
-- Comportamiento de compra según la edad
SELECT
 CONCAT(FLOOR(age / 10) * 10, '-', FLOOR(age / 10) * 10 + 9) AS age_range, count(n_purchases) as purchases, sum(Purchase_VALUE) as total_value_purchases
FROM
    customer_sales
GROUP BY
    age_range
ORDER BY
    sum(Purchase_VALUE) desc;
-- Cantidad de compras promedio por rango de edad
SELECT
    CONCAT(FLOOR(age / 10) * 10, '-', FLOOR(age / 10) * 10 + 9) AS age_range,
    ROUND(AVG(n_purchases), 2) AS avg_quantity_purchase_by_age,
    ROUND(AVG(purchase_value), 2) AS avg_purchase_by_age
FROM
    customer_sales
GROUP BY
    age_range
ORDER BY
    avg_purchase_by_age DESC;
-- Distribución de compras por método de pago
SELECT pay_method, ROUND(sum(purchase_value), 2) AS Total_Spend, count(n_purchases) AS Total_Purchases, ROUND(avg(n_purchases), 2) AS Avg_of_Purchases
FROM customer_sales
GROUP BY pay_method
ORDER BY Total_Purchases DESC;
-- Distribución de compras por navegadores
select browser, round(sum(purchase_value), 2) as Total_Spend, sum(n_purchases) as Quantity_of_Products, count(n_purchases) as Quantity_of_Purchases
from customer_sales
group by browser
order by Total_Spend desc;
-- Órdenes de compra por navegadores
SELECT
    Browser,
    COUNT(*) AS total_orders,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM customer_sales)) * 100, 2) AS percentage
FROM
    customer_sales
GROUP BY
    Browser;
-- Tiempo promedio en el sitio web por género
select gender, round(avg(time_spent),2) as Avg_Time_on_Website
from customer_sales
group by gender
order by Avg_Time_on_Website;
-- Tiempo promedio en el sitio web por rango de edad
SELECT
    CONCAT(FLOOR(age / 10) * 10, '-', FLOOR(age / 10) * 10 + 9) AS age_range,
round(avg(time_spent),2) as Avg_Time_on_Website
from customer_sales
group by age_range
order by Avg_Time_on_Website desc; 
-- Tiempo promedio en el sitio web por cantidad de productos comprados:
SELECT n_purchases as Purchases, round(avg(time_spent),2) as Avg_Time_on_Website
from customer_sales
group by Purchases
order by Avg_Time_on_Website desc;
-- Relación Precio - Tiempo en el website
SELECT
    CASE
        WHEN purchase_value >= 1.0 AND purchase_value <= 9.9 THEN '1.0 - 9.9'
        WHEN purchase_value >= 10.0 AND purchase_value <= 19.9 THEN '10.0 - 19.9'
        WHEN purchase_value >= 20.0 AND purchase_value <= 29.9 THEN '20.0 - 29.9'
        WHEN purchase_value >= 30.0 AND purchase_value <= 39.9 THEN '30.0 - 39.9'
        WHEN purchase_value >= 40.0 AND purchase_value <= 49.9 THEN '40.0 - 49.9'
        WHEN purchase_value >= 50.0 AND purchase_value <= 59.9 THEN '50.0 - 59.9'
        ELSE 'Others'
    END AS purchase_range,
    round(avg(time_spent),2) as Avg_Time_on_Website
FROM
    customer_sales
GROUP BY
    purchase_range
    ORDER BY Avg_Time_on_Website desc;
-- Distribución de compra por boletín
select newsletter, count(n_purchases) as Purchases_w_Newsletter, round(sum(purchase_value),2) as Total_Spend_in_Newsletter
from customer_sales
where newsletter = "yes"
group by Newsletter
order by Total_Spend_in_Newsletter desc; 
-- Distribución de compra por cupón
select voucher, count(n_purchases) as Purchases_w_Voucher, round(sum(purchase_value),2) as Total_Spend_in_Voucher
from customer_sales
where voucher = "used"
group by Voucher
order by Total_Spend_in_Voucher desc;
