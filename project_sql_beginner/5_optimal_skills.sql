/*
Question: What are the most optimal skills to learn (High demand + high paying)
- Identifiy high pay and demand skills based on average salaries for a role
- Preference for remote positions with listed salaries (i.e. limiting "null" values)
- Why? Targets job security and financial benefits for insights in career development.
*/

--CTE: See "3_top_in_demand_skills" and "4_highest_paying_skills"
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id, -- Key to combine on later
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist' -- Specific title
        AND salary_year_avg IS NOT NULL
        AND (job_location = 'Denver, CO' OR job_work_from_home = TRUE) -- Local or Remote
    GROUP BY
        skills_dim.skill_id -- Groups by key
), average_salary AS (
    SELECT
        skills_job_dim.skill_id, -- Key to combine on later
        ROUND(AVG(salary_year_avg), 0) AS average_salary -- Rounds values to 0 decimals.
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist' -- Specific title
        AND salary_year_avg IS NOT NULL
        AND (job_location = 'Denver, CO' OR job_work_from_home = TRUE) -- Local or Remote
    GROUP BY
        skills_job_dim.skill_id -- Groups by key
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE -- Limits extremely low demand skills
    demand_count >= 10
ORDER BY
    average_salary DESC,
    demand_count DESC
    
LIMIT 30

--Query rewrite for brevity
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
    AND (job_location = 'Denver, CO' OR job_work_from_home = TRUE)
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10 -- No aggregations allowed in WHERE
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 30;

/*
📊 Takeaways:

    Best of Both Worlds:
    If you're looking for a strong combo of high salary and high demand, skills like PyTorch, TensorFlow, Pandas, and Spark are top contenders—ideal for machine learning and big data roles.

    Specialized High Earners:
    Skills like C, Go, and Qlik command high salaries despite lower demand, likely due to niche use cases or a shortage of skilled professionals.

    Foundational Powerhouses:
    Python, SQL, and AWS dominate in demand, making them valuable for job security and flexibility, though they may not offer top-tier salaries alone.
*/