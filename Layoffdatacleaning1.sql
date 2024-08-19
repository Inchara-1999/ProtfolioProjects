select *
from layoffs

create table layoffs_staging
like layoffs

select *
from layoffs_staging

insert layoffs_staging
select *
from layoffs

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, date) AS row_num
FROM layoffs_staging;

with duplicate_cte as 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
delete 
from duplicate_cte
where row_num > 1

create table layoffs_staging2
like layoffs_staging

alter table layoffs_staging2
add column row_num int 

select *
from layoffs_staging2

INSERT INTO layoffs_staging2
SELECT *,
       ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
                          percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

select * 
from layoffs_staging2

select company, trim(company)
from layoffs_staging2

update layoffs_staging2
set company = trim(company)


select distinct industry
from layoffs_staging2
Order by 1

select *
from layoffs_staging2
where industry like 'crypto%' 

update layoffs_staging2
set industry = 'crypto'
where industry = 'crypto currency'


select distinct country
from layoffs_staging2
order by 1

select *
from layoffs_staging2
where country like 'united states.'

update layoffs_staging2
set country = 'United states'
where country = 'united states.'


select *
from layoffs_staging2

-- or

select distinct country, trim(trailing '.'from country)
from layoffs_staging2
order by 1;


select date
from layoffs_staging2

SELECT
    `date`,
    STR_TO_DATE(`date`, '%m/%d/%Y') AS converted_date
FROM
    layoffs_staging2;
    
   
update layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y')

-- joining date from layoffs_staging to layoffs_staging2 due to an error

UPDATE layoffs_staging2 AS ls2
JOIN layoffs_staging AS ls1
ON ls2.company = ls1.company 
SET ls2.`date` = ls1.`date`;

SELECT ls2.company, ls2.`date` AS date_staging2, ls1.`date` AS date_staging
FROM layoffs_staging2 AS ls2
JOIN layoffs_staging AS ls1
ON ls2.company = ls1.company
LIMIT 10;


select date
from layoffs_staging2

update layoffs_staging2
set date = null 
where date = '0'

select *
from layoffs_staging2
where industry is null
or industry = '0' or industry = ' '

select *
from layoffs_staging2
where company = 'Bally\'s Interactive'

update layoffs_staging2
set industry = null
where industry = '0'

select T1.industry, T2.industry, T1.company
from layoffs_staging2 T1
join layoffs_staging2 T2
on T1.company = T2.company
where T1.industry is null 

Update layoffs_staging2
Set industry = CASE
When company = 'airbnb' THEN 'Travel'
When company = 'Juul' THEN 'Manufacturing'
When company = 'Bally''s Interactive' THEN 'Gambling'
else industry 
end
where company in ('airbnb', 'Juul', 'Bally\'s Interactive');


select *
from layoffs_staging2
where total_laid_off = '0'
and percentage_laid_off = '0.0000'

Delete 
from layoffs_staging2
where total_laid_off = '0'
and percentage_laid_off = '0.0000'

select *
from layoffs_staging2
where company = 'Amazon'

update layoffs_staging2
set total_laid_off = '18150'
where company = 'Amazon'

Alter table layoffs_staging2
Drop column Row_num,
Drop column Temp_date; 


select Max(total_laid_off), Max(percentage_laid_off)
from layoffs_staging2

select *
from layoffs_staging2
where percentage_laid_off = 1
order by Funds_raised_millions desc


select company, Sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc

select country, Sum(total_laid_off)
FROM layoffs_staging2
GROUP BY 
order by 2 desc

select *
from layoffs_staging2


ALTER TABLE layoffs_staging2
ADD COLUMN `date_temp` DATE NULL DEFAULT NULL;

UPDATE layoffs_staging2
SET `date_temp` = STR_TO_DATE(`date`, '%m/%d/%Y')

ALTER TABLE layoffs_staging2
DROP COLUMN `date`;

ALTER TABLE layoffs_staging2
CHANGE COLUMN `date_temp` `date` DATE NULL DEFAULT NULL;


select year(`date`), Sum(total_laid_off)
FROM layoffs_staging2
GROUP BY year(`date`)
order by 1 desc

select substring( `date`, 1,7) as `month`, Sum(total_laid_off)
from layoffs_staging2
group by `month`
order by 1 asc

with rolling_total as (
select substring( `date`, 1,7) as `month`, Sum(total_laid_off) as total_off
from layoffs_staging2
group by `month`
order by 1 asc ) 
select `month`,total_off, sum(total_off) over(order by `month`) as rolling_total
from rolling_total


select company, Sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc


select company,year(`date`), Sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc


with company_year (company, years,total_laid_off) as (
select company,year(`date`), Sum(total_laid_off) as total_laid
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as
(select *, dense_rank () over(partition by years order by total_laid_off desc) as ranking
from company_year)
select *
from company_year_rank
where ranking <= 5


select *
from layoffs_staging2

-- Average Percentage Laid Off by Industry

SELECT industry, 
AVG(percentage_laid_off) AS avg_percentage_laid_off
FROM layoffs_staging2
GROUP BY industry;

SELECT company, percentage_laid_off
FROM layoffs_staging2
ORDER BY percentage_laid_off DESC
LIMIT 10;

-- grouping company by percentage laid off brackets

SELECT 
    CASE 
        When percentage_laid_off < 0.10 THEN '0-10%'
        When percentage_laid_off < 0.25 THEN '10-25%'
        When percentage_laid_off < 0.50 THEN '25-50%'
        When percentage_laid_off < 0.75 THEN '50-75%'
        else '75%+'
    END AS percentage_bracket,
    COUNT(*) AS num_companies
FROM 
    layoffs_staging2
GROUP BY 
    percentage_bracket;
    
-- Track Percentage Laid Off Over Time
    
SELECT `date`, AVG(percentage_laid_off) AS avg_percentage_laid_off
FROM layoffs_staging2
GROUP BY `date`
ORDER BY `date`;

-- Compare Percentage Laid Off by Location

SELECT location, 
AVG(percentage_laid_off) AS avg_percentage_laid_off
FROM layoffs_staging2
GROUP BY location;

-- Distribution of Percentage Laid Off

SELECT percentage_laid_off, 
COUNT(*) AS num_companies
FROM layoffs_staging2
GROUP BY percentage_laid_off
ORDER BY percentage_laid_off;

--  Weighted Average of Percentage Laid Off by Industry

select industry,SUM(TOTAL_LAID_OFF * percentage_laid_off)/ sum(total_laid_off) as weighted_avg_percentage_laid_off
from layoffs_staging2
group by industry 
order by 2 desc 


-- Top Industries by Funds Raised but High Layoff Percentage

select industry, sum(funds_raised_millions) as total_fund_raised, avg(percentage_laid_off) as avg_percentage_laid_off
from layoffs_staging2
group by industry
having total_fund_raised > 1000 and avg_percentage_laid_off > 0.20
order by total_fund_raised desc


select *
from layoffs_staging2


select date_format(`date`,'%Y-%m') as month, sum(total_laid_off), sum(funds_raised_millions),
avg(percentage_laid_off)
from layoffs_staging2
group by month
order by month


select company, total_laid_off, percentage_laid_off
from layoffs_staging2
where percentage_laid_off > 0.5
AND Total_laid_off < 100
order by percentage_laid_off desc

--  Layoff Severity Index by Country

SELECT 
    country,
    SUM(total_laid_off * percentage_laid_off) AS layoff_severity_index,
    SUM(total_laid_off) AS total_laid_off,
    AVG(percentage_laid_off) AS avg_percentage_laid_off
FROM 
    layoffs_staging2
GROUP BY 
    country
ORDER BY 
    layoff_severity_index DESC;
    
-- Outliers Detection in Layoffs Based on Funding

SELECT 
    company,
    funds_raised_millions,
    percentage_laid_off,
    total_laid_off,
    CASE 
        WHEN percentage_laid_off > 0.5 AND funds_raised_millions > 500 THEN 'High Layoff, High Funding'
        WHEN percentage_laid_off < 0.1 AND funds_raised_millions < 100 THEN 'Low Layoff, Low Funding'
        ELSE 'Other'
    END AS outlier_category
FROM 
    layoffs_staging2
ORDER BY 
    outlier_category DESC, percentage_laid_off DESC;































































