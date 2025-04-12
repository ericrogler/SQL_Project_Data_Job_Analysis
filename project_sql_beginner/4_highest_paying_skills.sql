/*
Question: What are top skills based on salary?
- Average salary related to each skill for X position(s)
- Focuses on roles with specific salaries and less emphasis on location
- Why? Reveals how different skills affect impact salary and identify most financially rewarding skills to acquire/improve
*/

SELECT
    skills AS skill,
    ROUND(AVG(salary_year_avg), 0) AS average_salary -- Rounds values to 0 decimals.
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' -- Specific title
    AND salary_year_avg IS NOT NULL
    AND (job_location = 'Denver, CO' OR job_work_from_home = TRUE) -- Local or Remote
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 15;

/*
✅ Insights:

    GDPR tops the list, suggesting that roles requiring expertise in data privacy and compliance command high salaries, likely due to growing legal and ethical requirements in AI and data.

    Golang (Go) appears twice under "golang" and "go", both with high averages (~$208k and ~$163k), highlighting backend system expertise as lucrative.

    Tools for automation and testing like Selenium are highly valued.

    Vision-related tools like OpenCV reflect strong demand for computer vision expertise.

🧠 Notable Specialized Tools & Platforms:

    Neo4j, Redis, DynamoDB, and Cassandra: Suggest demand for professionals who understand modern databases, especially NoSQL and graph DBs.

    MicroStrategy, Looker, Qlik: High-paying roles for BI and analytics platforms, showing the value of turning data into insights for business decisions.

    Hugging Face: $163k average reflects the high demand for transformer models and NLP proficiency.

🌐 Cloud & Infrastructure-Oriented Skills:

    Terraform, GCP, Airflow, BigQuery: Reflect a trend where data engineering and cloud orchestration drive up pay.

    Watson (IBM’s AI), Slack, Terminal: Integration and ops-focused tooling, showing value in DevOps and MLOps fluency.

🔬 Emerging Languages & Frameworks:

    Rust, Elixir, Julia, Scala: These high-paying languages suggest specialized systems programming, concurrency, and scientific computing are lucrative but niche areas.

🎯 Summary:

    💸 Niche expertise pays off — Skills that are specialized (like GDPR or Neo4j) often yield higher average salaries than more common ones like Python or SQL.

    🚀 Data privacy, scalable backend systems, and cloud orchestration are big pay boosters.

    🧠 Advanced ML/NLP skills (e.g., Hugging Face, Datarobot) are being richly rewarded in the evolving AI landscape.
*/