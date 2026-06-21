SELECT
    company.name AS company_name,
    ROUND(AVG(job_postings.salary_year_avg),0) AS average_salary,
    COUNT(*) AS total_jobs
FROM
    job_postings_fact AS job_postings
        INNER JOIN company_dim AS company
            ON job_postings.company_id = company.company_id
WHERE
    job_postings.job_title_short = 'Data Analyst' AND
    job_postings.job_location = 'Anywhere' AND
    job_postings.salary_year_avg IS NOT NULL
GROUP BY
    company.name
HAVING
    COUNT(*) >= 3
ORDER BY
    average_salary DESC
LIMIT 10;