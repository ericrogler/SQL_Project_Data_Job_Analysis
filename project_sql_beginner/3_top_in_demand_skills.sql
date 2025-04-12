/*
Question: What are the skills most in demand from the given roles?
- Estimate: High skill count = more in demand
- Identify top 5 to 10 in-demand skills.
- Focus on ALL relevant job postings
- Why? Provides insights into what skills employers desire most.
*/

--Method without subqueries / CTEs to solve problem
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' -- Specific title
    AND (job_location = 'Denver, CO' OR job_work_from_home = TRUE) -- Local or remote roles
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 10;