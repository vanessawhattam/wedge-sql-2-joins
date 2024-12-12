-- 2.1
-- Use table department_date return department and "Department Spend" (all time)
-- Join dept name from departments so 3cols. Sort high to low
SELECT department_date.department, sum(spend) as "Department Spend", departments.dept_name
FROM department_date LEFT JOIN departments
	ON department_date.department = departments.department
GROUP BY department_date.department
ORDER BY "Department Spend" DESC;

-- 2.2
-- Use department_date, return department, "Department Spend" (2015)
-- Join dept_name so 3cols, sort high to low
SELECT department_date.department, departments.dept_name, sum(spend) as "Department Spend"
FROM department_date LEFT JOIN departments
	ON department_date.department = departments.department
WHERE strftime("%Y", date) = "2015"
GROUP BY department_date.department
ORDER BY "Department Spend" DESC;

-- 2.3 
-- From owner_spend_date, return count DISTINCT owners and total spend by year
-- return 3 cols year, num_owners, total_spend
SELECT strftime("%Y", date) as "year", COUNT(DISTINCT(card_no)) as "num_owners", sum(spend) as "total_spend"
FROM owner_spend_date
GROUP BY "Year";

-- 2.4
-- from date_hour return # rows in date_hour by hour of day and sum(spend)
-- 3cols = hour, "Num Days", "Total Sales" order by hour, round sales to 2 decimals
SELECT hour, COUNT(*) as "Num Days", ROUND(SUM(spend), 2) as "Total Sales" 
FROM date_hour
GROUP BY hour
ORDER BY hour;

-- 2.5 
-- same as 2.4 but add a HAVING clause to return only those with < 2570 ROWS
SELECT hour, COUNT(*) as "Num Days", ROUND(SUM(spend), 2) as "Total Sales" 
FROM date_hour
GROUP BY hour
HAVING "Num Days" < 2570
ORDER BY hour;

-- 2.6
-- from owner_spend_date, return total spend, number shop days by card_no
-- 3cols = card_no, "Num Days", "Total Spend" and order by Total Spend DESC
SELECT card_no, COUNT(*) as "Num Days", SUM(spend) as "Total Spend"
FROM owner_spend_date
GROUP BY card_no
ORDER BY "Total Spend" desc;

-- 2.7
-- same as above, but with "Average Daily Spend" 
-- order by avg spend
SELECT card_no, COUNT(*) as "Num Days", SUM(spend) as "Total Spend", AVG(spend) as "Average Daily Spend"
FROM owner_spend_date
GROUP BY card_no
ORDER BY "Average Daily Spend" desc;

-- 2.8 
-- Same as above, but group by zip, which is joined from owners
-- FROM owner_spend_date, return total spend and num days by zip code
-- cols = zip, "Num Owner-Days", "Total Spend", "Average Daily Spend" 
-- ORDER BY total spend desc, round spend cols to 2 decimals
SELECT zip, COUNT(*) as "Num Owner-Days", ROUND(SUM(spend), 2) as "Total Spend", 
		ROUND(AVG(spend), 2) as "Average Daily Spend"
FROM owner_spend_date LEFT JOIN owners
	ON owner_spend_date.card_no = owners.card_no
GROUP BY zip
ORDER BY "Total Spend" DESC;

-- 2.9 
-- Wedge in zip 55405, use case to creat col "Area" with values wedge = 55405, 
-- adjacent = 55442, 55416, 55408, 55404, 55493
-- other = anything left OVER
-- Calculate # owners, # owner-days, avg days per owner, total spend, avg spend per owner, 
-- avg spend per owner day
SELECT 
	CASE 
		WHEN zip = 55405 THEN 'wedge'
		WHEN zip in (55442, 55416, 55408, 55404, 55403) THEN 'adjacent'
		ELSE 'other'
	END as "Area", 
	COUNT(DISTINCT owner_spend_date.card_no) as "Num Owners",
	COUNT(*) as "Num Owner-Days",
	SUM(spend) as "Total Spend",
	SUM(spend) / COUNT(DISTINCT owner_spend_date.card_no) as "Avg Owner Spend",
	SUM(spend) / COUNT(*) as "Avg Spend per Owner-Day"
FROM owner_spend_date 
INNER JOIN owners on owner_spend_date.card_no = owners.card_no
GROUP BY "Area";
	
-- 2.10 
-- from department_date, join departments to get dept_name
-- cols = dept num, dept_name, total spend by dept (round to full dollar), total # items purchased,
-- total # transactions, avg item price
-- order by avg item price DESC
SELECT department_date.department, dept_name, round(sum(spend)) as "Total Spend", sum(items) as "Num Items Purchased", 
		sum(trans) as "Num Transactions", sum(spend)/sum(items) as "Avg Item Price"
FROM department_date
INNER JOIN departments on department_date.department = departments.department
GROUP BY department_date.department
ORDER BY "Avg Item Price" desc;








