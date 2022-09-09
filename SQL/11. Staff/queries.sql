/* How many total employees in this company */
SELECT COUNT(*)
FROM staff;

/* What about gender distribution? */
SELECT s.gender, COUNT(*)
FROM staff s
GROUP BY 1;

/* How many employees in each department */
SELECT s.department, COUNT(*) 'No of Staff'
FROM `staff` s
GROUP BY 1;

/* How many distinct departments ? */
SELECT COUNT(DISTINCT department)
FROM staff;

/* What is the highest and lowest salary of employees? */
SELECT *
FROM (SELECT MIN(s.salary) FROM staff s) TAB1, (SELECT MAX(s.salary) FROM staff s) TAB2


/* what about salary distribution by gender group? */
/* Data Interpretation: It seems like the average between male and female group is pretty close, with slighly higher average salary for Female group*/


/* How much total salary company is spending each year? */


/* want to know distribution of min, max average salary by department */
/* Data Interpretation: It seems like Outdoors deparment has the highest average salary paid  and Jewelery department with lowest */ 



/* how spread out those salary around the average salary in each department ? */
/* Data Interpretation: Although average salary for Outdoors is highest among deparment, it seems like data points
are pretty close to average salary compared to other departments. */



/* which department has the highest salary spread out ? */
/* Data Interpretation: based on the findings, Health department has the highest spread out. So let's find out more */


/* Let's see Health department salary */


/* we will make 3 buckets to see the salary earning status for Health Department */


/* we can see that there are 24 high earners, 14 middle earners and 8 low earners */



/* Let's find out about Outdoors department salary */


/* we can see that there are 34 high earners, 12 middle earners and 2 low earners */



/* 
After comparing to Health department with Outdoors department, there are higher numbers of middle 
and low earners buckets in Health than Outdoors. So from those salary earners point of view, the average salary
for Outdoors deparment may be a little bit more stretch than Outdoors deparment which has more high earners.
That's why salary standard deviation value of Health is highest among all departments.
*/

>>
/* What are the deparment start with B */

/* How many employees with Assistant roles */

/* What are those Assistant roles? */


/* let's check which roles are assistant role or not */



>>
/* We want to extract job category from the assistant position which starts with word Assisant */

/* As there are several duplicated ones, we want to know only unique ones */


>>
/* we want to replace word Assistant with Asst.  */

>>
/* job title starts with either E, P or S character , followed by any character*/


>>>
/* we want to know person's salary comparing to his/her department average salary */

/* how many people are earning above/below the average salary of his/her department ? */



/* Assume that people who earn at latest 100,000 salary is Executive.
We want to know the average salary for executives for each department.

Data Interpretation: it seem like Sports department has the highest average salary for Executives
where Movie department has the lowest.*/



/* who earn the most in the company? 
It seems like Stanley Grocery earns the most.
*/



/* who earn the most in his/her own department */



/* full details info of employees with company division
Based on the results, we see that there are only 953 rows returns. We know that there are 1000 staffs.
*/



/* now all 1000 staffs are returned, but some 47 people have missing company - division.*/



/* who are those people with missing company division? 
Data Interpretation: it seems like all staffs from "books" department have missing company division.
We may want to inform our IT team to add Books department in corresponding company division.
*/



/*Staff division reg*/
CREATE VIEW vw_staff_div_reg AS
	SELECT s.*, cd.company_division, cr.company_regions
	FROM staff s
	LEFT JOIN company_divisions cd ON s.department = cd.department
	LEFT JOIN company_regions cr ON s.region_id = cr.region_id;


SELECT COUNT(*)
FROM vw_staff_div_reg;

/* How many staffs are in each company regions */



   /*WRANGLINGand MUNGING */
SELECT DISTINCT(department)
FROM staff
ORDER BY department;


/********* Reformatting Characters Data *********/

SELECT DISTINCT(UPPER(department))
FROM staff
ORDER BY 1;


SELECT DISTINCT(LOWER(department))
FROM staff
ORDER BY 1;


/*** Concatetation ***/
SELECT 
	last_name,
	job_title || ' - ' || department AS title_with_department 
FROM staff;

/*** Trim ***/
SELECT
	TRIM('    data sciece rocks !    ');

-- with trim is 19 characters
SELECT
	LENGTH(TRIM('    data sciece rocks !    '));
	
-- without trim is 27 characters
SELECT
	LENGTH('    data sciece rocks !    ');


/********* Extracting Strings from Characters *********/
-- SUBSTRING('string' FROM position FOR how_many)

---------------------- SubString words -----------------------
SELECT 'abcdefghijkl' as test_string;


SELECT 
	SUBSTRING('abcdefghikl' FROM 5 FOR 3) as sub_string;


SELECT 
	SUBSTRING('abcdefghikl' FROM 5) as sub_string;


--------------------- Replacing words -------------------------

/* we want to replace word Assistant with Asst.  */
SELECT
	OVERLAY(job_title PLACING 'Asst.' FROM 1 FOR LENGTH('Assistant')) AS shorten_job_title
FROM staff
WHERE job_title LIKE 'Assistant%';

---------------------------------------------------------------

/********* Filtering with Regualar Expressions *********/
-- SIMILAR TO

/* We want to know job title with Assistant with Level 3 and 4 */
-- we will put the desired words into group
-- Pipe character | is for OR condition 
SELECT
	job_title
FROM staff
WHERE job_title SIMILAR TO '%Assistant%(III|IV)';


/* now we want to know job title with Assistant, started with roman numerial I, follwed by 1 character
it can be II,IV, etc.. as long as it starts with character I 

underscore _ : for one character */

SELECT
	DISTINCT(job_title)
FROM staff
WHERE job_title SIMILAR TO '%Assistant I_';


/********* Reformatting Numerics Data *********/
-- TRUNC() Truncate values Note: trunc just truncate value, not rounding value.
-- CEIL
-- FLOOR
-- ROUND

SELECT 
	department, 
	AVG(salary) AS avg_salary, 
	TRUNC(AVG(salary)) AS truncated_salary,
	TRUNC(AVG(salary), 2) AS truncated_salary_2_decimal,
	ROUND(AVG(salary), 2) AS rounded_salary,
	CEIL(AVG(salary)) AS ceiling_salary,
	FLOOR(AVG(salary)) AS floor_salary
FROM staff
GROUP BY department;


/***** Grouping Sets *****************/
-- Grouping Sets : allows to have more than one grouping in the results table
-- there is no need to seperately use group by per query statement

-- 2 groupings
SELECT company_regions, company_division, COUNT(*) AS total_employees
FROM vw_staff_div_reg
GROUP BY 
	GROUPING SETS(company_regions, company_division)
ORDER BY 1,2;


-- 3 groupings
SELECT company_regions, company_division, gender, COUNT(*) AS total_employees
FROM vw_staff_div_reg
GROUP BY 
	GROUPING SETS(company_regions, company_division, gender)
ORDER BY 1, 2



----------------------------------------------------------------------------------------------


CREATE OR REPLACE VIEW vw_staff_div_reg_country AS
	SELECT s.*, cd.company_division, cr.company_regions, cr.country
	FROM staff s
	LEFT JOIN company_divisions cd ON s.department = cd.department
	LEFT JOIN company_regions cr ON s.region_id = cr.region_id;

/* employees per regions and country */
SELECT company_regions, country, COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY 
	company_regions, country
ORDER BY country, company_regions;

-------------- ROLL UP & CUBE to create Sub Totals ----------------------------------------
-- both are sub clauses of Group by


-------------- ROLL UP ----------------
-- is used to generate sub totals and grand totals

/* number of employees per regions & country, Then sub totals per Country, Then toal for whole table*/
SELECT country,company_regions, COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY
	ROLLUP(country, company_regions)
ORDER BY country, company_regions;


----------- CUBE -------------------
SELECT company_division, company_regions, COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY 
	CUBE(company_division, company_regions)
ORDER BY company_division, company_regions;


-------------------------------------------------------------------------------

/* Difference between Roll Up and Cube 

Reference: https://www.postgresqltutorial.com/postgresql-rollup/

For example, the CUBE (c1,c2,c3) makes all eight possible grouping sets:
(c1, c2, c3)
(c1, c2)
(c2, c3)
(c1,c3)
(c1)
(c2)
(c3)
()


However, the ROLLUP(c1,c2,c3) generates only four grouping sets, assuming the hierarchy c1 > c2 > c3 as follows:

(c1, c2, c3)
(c1, c2)
(c1)
()

*/

SELECT company_division, company_regions, country, COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY 
	ROLLUP(company_division, company_regions, country)
ORDER BY company_division, company_regions, country;


SELECT company_division, company_regions, country, COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY 
	CUBE(company_division, company_regions, country)
ORDER BY company_division, company_regions, country;


-------------------------------------------------------------------------------

------------ FETCH FIRST ----------
/* 
Fetch First works different from Limit.

For Fetch First, Order By Clause works first for sorting. Then Fetch First selets the rows.

For Limit, Limit acutally limits the rows and then performs the operations.

*/


/* What are the top salary earners ? */
SELECT last_name, salary
FROM staff
ORDER BY salary DESC
FETCH FIRST	10 ROWS ONLY;
	
	
/* Top 5 division with highest number of employees*/
SELECT
	company_division,
	COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY company_division
ORDER BY company_division
FETCH FIRST 5 ROWS ONLY;



SELECT
	company_division,
	COUNT(*) AS total_employees
FROM vw_staff_div_reg_country
GROUP BY company_division
ORDER BY company_division
LIMIT 5;
	


/******** Windows Functions and Ordered Data ************/

-- allows us to make sql statements about rows that are related to current row during processing.
-- somewhat similar to Sub Query.


--------------------- OVER (PARTITION BY) ---------------------------

/* employee salary vs average salary of his/her department */
SELECT 
	department, 
	last_name, 
	salary,
	AVG(salary) OVER (PARTITION BY department)
FROM staff;


/* employee salary vs max salary of his/her department */
SELECT 
	department, 
	last_name, 
	salary,
	MAX(salary) OVER (PARTITION BY department)
FROM staff;


/* employee salary vs min salary of his/her Company Region */
SELECT 
	company_regions, 
	last_name, 
	salary,
	MIN(salary) OVER (PARTITION BY company_regions)
FROM vw_staff_div_reg;



---------------------  FIRST_VALUE()  ---------------------------
-- FIRST_VALUE returns first value of the partition conditions, in this case decending order of salary group by department

SELECT
	department,
	last_name,
	salary,
	FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;


/* this is same as above one, but above query is much cleaner and shorter */
SELECT
	department,
	last_name,
	salary,
	MAX(salary) OVER (PARTITION BY department)
FROM staff
ORDER BY department ASC, salary DESC;

---------------

/* compare with the salary of person whose last name is in ascenidng in that department */
SELECT
	department,
	last_name,
	salary,
	FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY last_name ASC)
FROM staff;


---------------------  RANK ()  ---------------------------

-- give the rank by salary decending oder withint the specific department group.
-- the ranking 1, 2, 3 will restart when it reaches to another unique group.
-- works same as Row_Number Function
SELECT
	department,
	last_name,
	salary,
	RANK() OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;



---------------------  ROW_NUBMER ()  ---------------------------
-- same as above
SELECT
	department,
	last_name,
	salary,
	ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC)
FROM staff;	
	

--------------------- LAG() function ---------------------------
-- to reference rows relative to the currently processed rows.
-- LAG() allows us to compare condition with the previous row of current row.

/* we want to know person's salary and next lower salary in that department */
/* that is an additional column LAG. First row has no value because there is no previous value to compare.
So it continues to next row and lag value of that second row will be the value of previous row, etc.
It will restart again when we reache to another department.
*/
SELECT 
	department,
	last_name,
	salary,
	LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC)
FROM staff;



--------------------- LEAD() function ---------------------------
-- opposite of LAG()
-- LEAD() allows us to compare condition with the next row of current row.
-- now the last line of that department's LEAD value is empty because there is no next row value to compare.
SELECT 
	department,
	last_name,
	salary,
	LEAD(salary) OVER(PARTITION BY department ORDER BY salary DESC)
FROM staff;


--------------------- NTILE(bins number) function ---------------------------
-- allows to create bins/ bucket

/* there are bins (1-10) assigned each employees based on the decending salary of specific department
and bin number restart for another department agian */
SELECT 
	department,
	last_name,
	salary,
	NTILE(10) OVER(PARTITION BY department ORDER BY salary DESC)
FROM staff;