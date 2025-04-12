SELECT *
FROM (--Subquery Starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs
LIMIT 10;
-- SubQuery ends here

-- CTE Version
WITH january_jobs AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) -- CTE ends here

SELECT *
FROM january_jobs
LIMIT 10;


-- STANDARD VERSION 1
SELECT
    company_id,
    job_no_degree_mention
FROM   
    job_postings_fact
WHERE
    job_no_degree_mention = true
LIMIT 10;

--SUBQUERY VERSION 1
SELECT
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN(
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
    ORDER BY
        company_id
)
LIMIT 10;

-- CTE Practice
-- Find the companies with the most job openings
-- Get total number of job postings per company id
-- Return total number of jobs with the company name

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count on company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC;