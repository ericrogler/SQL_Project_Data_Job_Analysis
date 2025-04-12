-- INITIAL QUERY BASE FROM "1_top_paying_jobs.sql"

/*
Question: What are the skills required for the given role(s)?
*/

--Convert to a CTE to reuse easily in later queries
WITH top_paying_jobs AS (
    SELECT -- Columns are similar in joined tables used for query, so can simplify length.
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Scientist' AND --Title filter, case sensitive
        job_location = 'Denver, CO' AND --Location filter, case sensitive
        salary_year_avg IS NOT NULL --removes null values from results
    ORDER BY
        salary_year_avg DESC -- DESC = High to low

    LIMIT 10 --saves sanity on test queries    
)

--Test CTE (copy paste the above query as well)
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

/*
Insights:

    Python dominates as the most in-demand skill, reflecting its central role in data science and machine learning.

    Cloud and infrastructure-related tools like AWS and Terraform are commonly required, indicating a need for deployment and scalability skills.

    Programming diversity is valued, with R, C, and SQL also appearing multiple times.
*/