# SQL_Project_Data_Job_Analysis
# Introduction
Diving into the job market for data analytic, data science, and data engineering roles. Project is focusing on insights in salary, skills, and the intersection between high demand and high salary.

SQL queries are located here [Project Folder](/project_sql_beginner/)

# Background

Datasets come from Luke Barousse and his courses on SQL for Data Analytics.

### Questions to answer:

1. What are top paying jobs?
2. What are the skills required for the given role(s)?
3. What are the skills most in demand from the given roles?
4. What are top skills based on salary?
5. What are the most optimal skills to learn? (High demand + high paying)

# Tools I Used
Going into the data required several tools:

- SQL: General language used to query datasets
- PostgreSQL: Database management to host the data (primarily CSV files)
- Visual Studio Code (VSCode): Go-to for code and database management, as well as testing and executing SQL queries
- Git & GitHub: Version control, sharing, and collaboration tool

# The Analysis
Each query is designed to solve each problem and investigate aspects of the job market.


### Top Paying Jobs
Data was filtered for data scientist positions as well as the location/city where I made these queries from today. If we're searching for specific salaries, we also want to eliminate any roles with null or non-listed salaries on their job postings.

The query below shows the process.
```sql
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
```

Breaking down the query

- **Large salary band:** Even just the top 10 jobs span around $150000 to ~$280000
- **Multiple Employer Industries:** Companies listed focus on different needs for consumers and are diverse, including Meta, Angie's List, and S&P Global.
- **Job Title Variety:** Even amongst Data Scientist roles, there's multiple types. In Denver, CO, specifically, Data Scientist roles are at Manager or Director levels and some roles require active government clearance.

### Skills Required
If the jobs didn't require skills, they be quite easy to get into! However, looking at the data, they do have multiple skills.

The query used:
```sql
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
        job_title_short = 'Data Scientist' --Title filter, case sensitive
        AND job_location = 'Denver, CO' --Location filter, case sensitive
        AND salary_year_avg IS NOT NULL --removes null values from results
    ORDER BY
        salary_year_avg DESC -- DESC = High to low

    LIMIT 10 --saves sanity on test queries    
)

--Final "query" (copy paste the above query as well)
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

**Insights:**

- **Python** dominates as the most in-demand skill, reflecting its central role in data science and machine learning.

- Cloud and infrastructure-related tools like **AWS** and **Terraform** are commonly required, indicating a need for deployment and scalability skills.

- Programming diversity is valued, with **R, C, and SQL** also appearing multiple times.

### In Demand Skills
We know certain skills are in demand, and we can cherry pick a few just from the previous query. If wanted to know all of the skills, though, it requires more finesse and data wrangling.

Because it's a post-COVID era, I also included in-demand skills from remote jobs as well. Denver's a pretty nice place and I may not want to move for whatever reason, such as comfort, kids, etc.

Query below:
```sql
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
```

Throwing the info into ChatGPT provides the following chart. Python and SQL are important, which matches up with our earlier findings, but data visualization tools like Tableau and specific Python packages like pandas are also in demand.

![Highest demanded skills for Data Scientists](https://files.oaiusercontent.com/file-Ud3wcM7Lyu3EXQFc9jqBQV?se=2025-04-12T22%3A36%3A31Z&sp=r&sv=2024-08-04&sr=b&rscc=max-age%3D299%2C%20immutable%2C%20private&rscd=attachment%3B%20filename%3Db77977e5-8296-4503-b468-1b6a73ffe653&sig=wSGjBm9a3Hp15dwbAp9kGgZs5Doqr7o4lygbG1NpRRs%3D)

### Best Skills by Salary
Some skills are worth more than others, which means prospective employees may favor learning those over less valuable skills.

Query:
```sql
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
```

| Skill         | Average Salary ($) |
| ------------- | ------------------ |
| gdpr          | 217,738            |
| golang        | 208,750            |
| atlassian     | 189,700            |
| selenium      | 180,000            |
| opencv        | 172,500            |
| neo4j         | 171,655            |
| microstrategy | 171,147            |
| dynamodb      | 169,670            |
| c             | 166,270            |
| solidity      | 165,000            |
| datarobot     | 164,500            |
| go            | 163,463            |
| hugging face  | 163,088            |
| redis         | 162,500            |
| terraform     | 161,714            |

**To summarize:**

- **Niche expertise** pays off — Skills that are specialized (like GDPR or Neo4j) often yield higher average salaries than more common ones like Python or SQL.

- **Data privacy**, scalable backend systems, and cloud orchestration are big pay boosters.

- **Advanced ML/NLP skills** (e.g., Hugging Face, Datarobot) are being richly rewarded in the evolving AI landscape.
*/

### Optimal Skills
The previous query serves as proof we can find skills based on their salary, so now it boils down to optimization--figuring out the bestest skill for our buck.

While CTEs could work, they'd vastly increase the length of the query. Inner Joins are preferred because I'm searching for values that match across both tables.

```sql
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
```

**Takeaways:**
Across all the various skills and salaries associated with them, there are several standout contenders inside of Data Scientist roles.

- **PyTorch, TensorFlow, Pandas, and Spark** are top contenders—ideal for machine learning and big data roles.

- **C, Go, and Qlik** command high salaries despite lower demand, likely due to niche use cases or a shortage of skilled professionals.

- **Python, SQL, and AWS** dominate demand, making them valuable for job security and flexibility, though they may not offer top-tier salaries alone.


# What I Learned

There's much I learned from this particular project.

- **A Refresher in SQL:** My work history up to this point focused on personnel and soft skills, like management and communication, so a chance to work with a tool is greatly appreciated and helps perform these tasks more effectively and efficiently.
- **Query Crafting:** It's a case of "know what I want but cannot put it on paper" which this project gave me more confidence in and better knowledge on how to find--and more important analyze and communicate--information
- **Analytics:** I've had an interest in Data Science for a while, and this is the first time I looked into jobs through SQL queries.

# Conclusions

### Quick Recap (Copy+Paste Galore)

- **PyTorch, TensorFlow, Pandas, and Spark** are top contenders—ideal for machine learning and big data roles.

- **C, Go, and Qlik** command high salaries despite lower demand, likely due to niche use cases or a shortage of skilled professionals.

- **Python, SQL, and AWS** dominate demand, making them valuable for job security and flexibility, though they may not offer top-tier salaries alone.

- **Niche expertise** pays off — Skills that are specialized (like GDPR or Neo4j) often yield higher average salaries than more common ones like Python or SQL.

- **Data privacy**, scalable backend systems, and cloud orchestration are big pay boosters.

- **Advanced ML/NLP skills** (e.g., Hugging Face, Datarobot) are being richly rewarded in the evolving AI landscape.

### Closing Thoughts (NOT Copy+Paste Galore)

This project highlights to me how important it is to keep up with technology and interpret its functions and purposes. While Excel can most certainly do significant analysis, SQL can take significantly vaster quantities of information and aggregate it down at a fraction of the time. Aspiring job seekers can better position themselves as well in a job market with analysis like this and find out what to focus on without wasting as much time.

Time is, after all, a valuable resource.