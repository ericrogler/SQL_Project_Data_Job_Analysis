/*
Question: What are top paying jobs?
- Identify top 10 highest paying roles available remotely.
- Focuses on postings with specific salaries (no nulls)
- Why? Highlight top opportunities for DAs offering insights into job market.
*/

SELECT -- Columns are similar in joined tables used for query, so can simplify length.
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Scientist' --Title filter, case sensitive
    AND job_location = 'Denver, CO' --Location filter, case sensitive
    AND salary_year_avg IS NOT NULL --removes null values from results
ORDER BY
    salary_year_avg DESC -- DESC = High to low

LIMIT 10; --saves my sanity and load time on test queries