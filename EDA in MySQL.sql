-- EXPLORATORY DATA ANALYSIS

SELECT * FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
where total_laid_off = 12000;

SELECT * FROM layoffs_staging2
where percentage_laid_off = 0;

SELECT company, sum(total_laid_off)
FROM layoffs_staging2
group by company
order by sum(total_laid_off) desc;

SELECT country, sum(total_laid_off)
FROM layoffs_staging2
group by country
order by sum(total_laid_off) desc;

SELECT `date`, sum(total_laid_off)
FROM layoffs_staging2
group by `date`
order by sum(total_laid_off) desc;

SELECT *
FROM layoffs_staging2;

SELECT substring(`date`, 1, 7) as `month`,(total_laid_off)
FROM layoffs_staging2
;

SELECT substring(`date`, 1, 7) as `month`, sum(total_laid_off)
FROM layoffs_staging2
group by `month`
;

SELECT substring(`date`, 1, 7) as `month`, sum(total_laid_off)
FROM layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by `month`
;

with Rolling_Total as
(
SELECT substring(`date`, 1, 7) as `month`, sum(total_laid_off) as sum_laid
FROM layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by `month`
)
select `month`, sum_laid,
sum(sum_laid) over (order by `month`) as Rolling_Total
from Rolling_Total
order by Rolling_Total
;

SELECT *
FROM layoffs_staging2;

SELECT sum(total_laid_off)
FROM layoffs_staging2;

select company, year(`date`), total_laid_off
FROM layoffs_staging2;

select company, year(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company, year(`date`)
;

with company_year as
(
select company, year(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company, year(`date`)
)
select *
from company_year
;

with company_year(company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company, year(`date`)
)
select *, dense_rank() over( partition by years order by total_laid_off desc) as ranking
from company_year
where total_laid_off is not null and years is not null
order by ranking asc;

with company_year(company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
FROM layoffs_staging2
group by company, year(`date`)
), company_year_rank as
(
select *, dense_rank() over( partition by years order by total_laid_off desc) as ranking
from company_year

)
select *
from company_year_rank
where ranking <6 and years is not null
;















































































































































































