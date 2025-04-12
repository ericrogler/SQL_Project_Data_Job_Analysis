/*
Find job postings from the first quarter with salary >70k
- Combine job posting tables from first quarter of 2023
- Gets job postings with an average yearly salary > $70000
*/

--Subquery Start
SELECT
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000 AND 
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC

LIMIT 10;