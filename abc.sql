-- Practice Problem 1 on CTE's--
WITH skill_count AS (
    SELECT skill_id,
        COUNT(*) AS total_skills
    FROM skills_job_dim
    GROUP BY skill_id
)
SELECT skills_dim.skills AS skill_name,
    skill_count.total_skills
FROM skills_dim
    LEFT JOIN skill_count ON skill_count.skill_id = skills_dim.skill_id;
-- Practice Problem 2 on CTE's--


SELECT name AS company_name,
    COUNT(*) AS posts
FROM company_dim
WHERE company_id IN (
        SELECT company_id,
            COUNT(*) AS posts,
            CASE
                WHEN posts < 10 THEN 'Small'
                WHEN posts > 10
                AND posts < 50 THEN 'Medium'
                ELSE 'Large'
            END AS size_category
        FROM job_postings_fact
        GROUP BY company_id
    );

-- AI 1

SELECT 
    name AS company_name,
    COUNT(*) AS posts,
    CASE
        WHEN COUNT(*) < 10 THEN 'Small'
        WHEN COUNT(*) >= 10 AND COUNT(*) < 50 THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM 
    company_dim
JOIN 
    job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
GROUP BY 
    company_dim.name
ORDER BY
    posts DESC;

-- AI 2

SELECT 
    cd.name AS company_name,
    COUNT(*) AS posts
FROM 
    company_dim cd
WHERE 
    cd.company_id IN (
        SELECT 
            jpf.company_id
        FROM 
            job_postings_fact jpf
        GROUP BY 
            jpf.company_id
        HAVING 
            COUNT(*) < 10
    )
GROUP BY 
    cd.name;


-- Problem
WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE job_postings.job_work_from_home = True
    GROUP BY skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;