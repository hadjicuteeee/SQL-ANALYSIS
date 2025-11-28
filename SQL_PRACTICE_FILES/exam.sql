-- Student Final Grades with Honors, Status, Top Performer, and Ranking
WITH student1 AS (
    
	SELECT 
		s.name,
		SUM(prelim + midterm + finals) / 3 AS "Final Grade"  -- average ng tatlong exams
	FROM students s
	INNER JOIN exams e ON s.student_id = e.student_id
	GROUP BY s.name
),
	
honor AS (
    
	SELECT 
		"Final Grade",
		CASE 
			WHEN "Final Grade" >= 98 THEN 'Highest Honor'
			WHEN "Final Grade" >= 90 THEN 'High Honor'
			WHEN "Final Grade" >= 80 THEN 'Passed'
			WHEN "Final Grade" >= 75 THEN 'Satisfaction'
			ELSE 'Did not meet requirement'
		END AS honorable
	FROM student1
),
shin AS (
	
   
	SELECT 
		honorable,
		CASE 
			WHEN honorable IN ('Highest Honor', 'High Honor', 'Passed', 'Satisfaction') THEN 'PASSED'
			ELSE 'Failed'
		END AS status
	FROM honor
),
glimpse AS (
    
	SELECT 
		honorable,
		CASE 
			WHEN honorable = 'Passed' THEN 'Yes'
			ELSE 'No'
		END AS "Top Performer"
	FROM shin
)
SELECT DISTINCT
	ss.name AS name,
	CONCAT(ROUND(ss."Final Grade", 2), '%') AS "FINAL GRADE",  
	h.honorable AS mention,
	gl."Top Performer",
	DENSE_RANK() OVER (ORDER BY ss."Final Grade" DESC) AS ranking  
FROM student1 ss
INNER JOIN honor h ON ss."Final Grade" = h."Final Grade"
INNER JOIN shin sh ON h.honorable = sh.honorable
INNER JOIN glimpse gl ON sh.honorable = gl.honorable
ORDER BY ranking;
-- Analysis:
-- Pinakita dito ang final grade ng bawat student, honor classification, pass/fail status at ranking.
-- DENSE_RANK ginagamit para walang gap sa ranking kapag pareho ang score.

--------------------------------------------------------


SELECT * 
FROM STUDENTS s
INNER JOIN exams e on s.student_id = e.student_id;
-- Analysis:
-- Quick look para makita ang raw scores ng bawat student sa prelim, midterm, finals.
-- Useful for verifying data before aggregation.

--------------------------------------------------------

--  Exam-wise average and standard deviation
SELECT
	'Prelim' as exam_type,
	ROUND(AVG(prelim), 2) as avg,
	ROUND(STDDEV_SAMP(prelim), 2) as "Standard Deviation"
FROM exams
UNION ALL
SELECT
	'Midterm',
	ROUND(AVG(midterm), 2),
	ROUND(STDDEV_SAMP(midterm), 2)
FROM exams
UNION ALL
SELECT
	'Finals',
	ROUND(AVG(finals), 2),
	ROUND(STDDEV_SAMP(finals), 2) 
FROM exams;
-- Analysis:
-- Nagcompute ng average at sample standard deviation per exam type.
-- STDDEV_SAMP ginagamit para malaman ang dispersion o variability ng scores.

--------------------------------------------------------

-- Student-level analytics: Final grade, Remarks, Class SD, Z-score, Ranking
WITH examination AS(
	SELECT name,
	prelim,
	midterm,
	finals,
	ROUND((prelim + midterm + finals)/3 , 2 ) AS final_grade,  
	CASE 
		WHEN ROUND((prelim + midterm + finals)/3 , 2 ) >= 98 THEN 'HIGHEST HONOR'
		WHEN ROUND((prelim + midterm + finals)/3 , 2 ) >= 90 THEN 'HIGH HONOR'
		WHEN ROUND((prelim + midterm + finals)/3 , 2 ) >= 80 THEN 'PASSED'
		WHEN ROUND((prelim + midterm + finals)/3 , 2 ) >= 75 THEN 'SATISFACTION'
		ELSE 'FAILED' 
	END AS REMARKS,
	AVG(prelim + midterm + finals) OVER() as "Average"  
	FROM EXAMS e
	INNER JOIN students s on e.student_id = s.student_id
)
SELECT
	name,
	prelim,
	midterm,
	finals,
	CONCAT(final_grade, '%') as "Final Grade",
	REMARKS,
	ROUND(STDDEV_SAMP(final_grade) OVER (), 2) AS "CLASS SD",  
	ROUND((final_grade - "Average") / STDDEV_SAMP(final_grade) OVER(), 2 ) as "Z-SCORE", 
	PERCENT_RANK() OVER (ORDER BY final_grade DESC) AS Ranking  
FROM examination;
-- Analysis:
-- Pinakita lahat ng important stats per student: final grade, remarks, class SD, Z-score, ranking.
-- Useful sa statistical analysis at comparisons between students.

--------------------------------------------------------

--Percentile calculation per student
WITH percentile AS(
	SELECT name,
	       (prelim + midterm + finals)/3 AS final_grade  
	FROM exams e 
	JOIN students s on e.student_id = s.student_id 
),
percentile2 AS (
	SELECT
		ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY final_grade)::numeric, 2) as prct_25,
		ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY final_grade)::numeric, 2) as median,
		ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY final_grade)::numeric, 2) as prct_75
	FROM percentile
)
SELECT p.name,
       ROUND(final_grade , 2) as final_grade,
       pp.prct_25,
       pp.median,
       pp.prct_75
FROM percentile p
CROSS JOIN percentile2 pp;
-- Analysis:
-- Nagcompute ng 25th, 50th (median), at 75th percentiles ng class grades.
-- CROSS JOIN para ma-apply sa bawat student row, mas efficient kaysa sa multiple subqueries.
-- ROUND + ::numeric ginagamit para maiwasan error at gawing 2 decimal places lang.
