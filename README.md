# Introduction

📊 This project explores the global data job market using SQL and focuses on uncovering valuable insights from real-world job posting data.

The dataset contains information about various technical roles, including job titles, companies, locations, salaries, required skills, and job posting dates. By analyzing this data, I investigated industry trends, high-paying opportunities, and the skills that employers value most in the data analytics field.

🎯 The primary objective of this project was to strengthen my SQL skills while applying them to real-world business questions. Throughout the analysis, I used SQL to explore salary trends, identify in-demand skills, and examine the relationship between skill demand and earning potential.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql)

💡 This project allowed me to practice working with multiple tables, joins, aggregations, subqueries, Common Table Expressions (CTEs), and other core SQL concepts that are commonly used in data analytics and business intelligence roles.

# Background

📈 As part of my SQL learning journey, I wanted to apply core SQL concepts to a real-world dataset and gain hands-on experience with data analysis.

This project uses job posting data from the global technology job market to explore salary trends, in-demand skills, and career opportunities within data-related roles. By analyzing this dataset, I was able to practice solving business-focused questions and transform raw data into meaningful insights.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used

🛠️ For this project, I used the following tools to analyze job market data and extract meaningful insights:

- **SQL** : The primary tool used for querying, filtering, joining, and analyzing data. SQL was used to answer business questions and uncover trends within the dataset.
- **PostgreSQL** : Used as the database management system to store and manage the job posting data efficiently.
- **Visual Studio Code** : Used as the development environment for writing, testing, and executing SQL queries.
- **Git & GitHub** : Used for version control, project organization, and showcasing the completed analysis as part of my data analytics portfolio.

# The Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market.
Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```

Here's the breakdown of the top data analyst jobs in 2023:

- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries. -**Job Title Variety:** There's a high diversity in job titles, from Data Analyst, reflecting varied roles and specializations within data analystics.

![Top Paying Roles](assets\Top_Paying_Jobs.png)
_Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results_

### 2. To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON  skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

- **SQL** is leading with a bold count of 8.
- **Python** follows closely wiht a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6. Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

![Top Paying Skills](assets\Top_Paying_Skills.png)
_Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from my SQL query results_

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

Here's the breakdown of the most demanded skills for data analysts in 2023

- **SQL** and **EXCEL** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization** Tools like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

![In-demand Jobs](assets\In-Demand_Jobs.png)
_Table of the demand for the top 5 skills in data analyst job postings_

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

Here's breakdown of the results for top paying skills for Data Analysts:

- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data (PySpark, Couchbase), machine learning tools (DataRobot, Jypyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools(GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

![Skills based on Salary](assets\skills_based_salaries.png)
_Table of the average salary for the top 10 paying skills for data analysts_

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
 SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
    HAVING
        COUNT(skills_job_dim.job_id) > 10
    ORDER BY
        avg_salary DESC,
        demand_count DESC
    LIMIT 25;
```

![optimal skills](assets\optimal_skills.png)
_Table of the most optimal skills for data analyst sorted by salary_

Here's a breakdown of the most optimal skills for Data Analysts in 2023:

- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL database (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# What I Learned

🚀 This project marked an important milestone in my SQL learning journey and gave me the opportunity to apply theoretical concepts to a real-world dataset.

Throughout this project, I strengthened my understanding of several core SQL concepts, including:

- **Data Retrieval & Filtering:** Used SELECT, WHERE, ORDER BY, and LIMIT to extract relevant information from large datasets.
- **Data Aggregation:** Applied GROUP BY, HAVING, COUNT(), AVG(), and other aggregate functions to summarize and analyze data.
- **Joins:** Combined data from multiple tables using INNER JOIN and LEFT JOIN to uncover deeper insights.
- **Advanced Querying:** Practiced writing subqueries and Common Table Expressions (CTEs) to solve more complex analytical problems.
- **Data Analysis Thinking:** Learned how to translate business questions into SQL queries and use data to support decision-making.
- **Real-World Problem Solving:** Gained experience working with job market data to identify salary trends, in-demand skills, and valuable career insights.

💡 Most importantly, this project helped me understand how SQL is used by Data Analysts to transform raw data into meaningful information and actionable insights.

# Conclusions

### Insights

From this analysis, several key insights emerged:

1. #### 💰 High Salary Potential in Data Analytics
   Remote Data Analyst roles can offer exceptionally high salaries, with some positions exceeding $200,000 per year and top roles reaching $650,000 annually.
2. #### 📊 SQL Remains a Core Skill
   SQL consistently appeared among the most requested skills across job postings, highlighting its importance for aspiring Data Analysts.
3. #### 🚀 Technical Skills Increase Market Value
   Skills such as Python, Tableau, Power BI, Snowflake, and cloud technologies were frequently associated with higher-paying opportunities.
4. #### 🏢 Demand Exists Across Multiple Industries\*\*
   Companies from various sectors, including technology, finance, healthcare, and marketing, actively seek data professionals to support data-driven decision-making.
5. #### 🎯 Specialized Skills Can Lead to Better Opportunities\*\*
   Professionals with expertise in advanced analytics, data visualization, cloud platforms, and data engineering tools often have access to higher-paying roles.

### Closing Thoughts

This project provided valuable hands-on experience in applying SQL to a real-world dataset and strengthened my understanding of how data can be used to answer business questions. Beyond improving my technical SQL skills, the project helped me develop an analytical mindset by transforming raw data into meaningful insights.

As my first SQL portfolio project, it marks an important step in my journey toward becoming a Data Analyst. Moving forward, I plan to continue building projects, expanding my knowledge of data visualization and analytics tools, and developing the skills needed to solve increasingly complex business problems using data.
