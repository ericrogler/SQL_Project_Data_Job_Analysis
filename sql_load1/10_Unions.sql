-- combine results from two or more columns
-- Select -> union -> Select -> union -> repeat
-- They need to have the same number of columns


--Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

--Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

    --Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

-- UNION ALL
-- Unlike UNION, it also returns duplicates