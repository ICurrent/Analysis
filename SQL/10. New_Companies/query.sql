/*Write a query to print the company_code, founder name, 
total number of lead_managers, total_number of senior_managers,
total number of managers and total number of employess..
Order your your output by ascending company_code.*/



SELECT c.*, COUNT(DISTINCT l.lead_manager_code) 'No of lead managers', 
COUNT(DISTINCT s.senior_manager_code) 'No of senior managers', 
OUNT(DISTINCT m.manager_code) 'No of manager', 
COUNT( DISTINCT e.employee_code) 'No of employees'
FROM company c
JOIN lead_manager l ON c.company_code = l.company_code
JOIN senior_manager s ON l.company_code = s.company_code
JOIN manager m ON s.company_code = m.company_code
JOIN employee e ON m.company_code = e.company_code
GROUP BY 1
;