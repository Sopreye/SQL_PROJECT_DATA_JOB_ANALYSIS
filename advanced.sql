--UNIONS

SELECT  job_title_short
       ,company_id
       ,job_location
FROM january_jobs

-- ALL is usually used
UNION

SELECT  job_title_short
       ,company_id
       ,job_location
FROM february_jobs

UNION

SELECT  job_title_short
       ,company_id
       ,job_location
FROM march_jobs;


SELECT * FROM skills_job_dim LIMIT 20;

-- Problem
--Supposed to use UNION but i didn't create the table for each month
WITH vvv AS(
    SELECT job_id,
        skills_dim.skills,
        skills_dim.type
    FROM skills_dim
        LEFT JOIN skills_job_dim AS skills_to_job ON skills_to_job.skill_id = skills_dim.skill_id
)
SELECT job_posted_date,
    skills,
    type,
    salary_year_avg
FROM vvv
    LEFT JOIN job_postings_fact AS job_postings ON job_postings.job_id = vvv.job_id
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) <= 3
    AND salary_year_avg > 70000;

-- Practice Problem

SELECT quater1_postings.job_title_short,
    quater1_postings.job_location,
    quater1_postings.job_via,
    quater1_postings.job_posted_date::DATE,
    quater1_postings.salary_year_avg
FROM (
        SELECT *
        FROM job_postings_fact
        WHERE EXTRACT(
                MONTH
                FROM job_posted_date
            ) <= 3
    ) AS quater1_postings
WHERE quater1_postings.salary_year_avg >70000 AND quater1_postings.job_title_short = 'Data Analyst'
ORDER BY quater1_postings.salary_year_avg DESC