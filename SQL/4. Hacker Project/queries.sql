/*Get the number of days to complete a project*/
SELECT a.*, MIN(End_date), MIN(End_date)-Start_data 
FROM(
    SELECT Start_data
    FROM project
	WHERE Start_data NOT IN (SELECT End_date FROM project)) a,
    
    (SELECT End_date
     FROM project
     WHERE End_date NOT IN (SELECT Start_data FROM project)) b
WHERE Start_data < End_date
GROUP BY 1;
        /*or*/
CREATE VIEW projectDuration_ AS
(SELECT Start_data, MIN(End_date) End_date, 
	CASE WHEN (MIN(End_date) - Start_data) = 1 THEN CONCAT((MIN(End_date) - Start_data), ' Day')
    	ELSE CONCAT((MIN(End_date) - Start_data), ' Days')
     END Duration
FROM (
    SELECT Start_data
    FROM project
    WHERE Start_data NOT IN (SELECT End_date FROM project)) table1,
    (
    SELECT End_date
    FROM project
    WHERE End_date NOT IN (SELECT Start_data FROM project)) table2
WHERE Start_data < End_date
GROUP BY 1
ORDER BY 3);


/*Show the Projects dates arranged orderly*/
SELECT p1.Start_data, MIN(p2.End_date) End_date
FROM project p1, project p2
WHERE (p1.Start_data NOT IN (SELECT p1.End_date FROM project p1))
AND 
(p2.End_date NOT IN (SELECT p2.Start_data FROM project p2))
AND
p1.Start_data < p2.End_date
GROUP BY 1
ORDER BY 1;