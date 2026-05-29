-- DATA CLEANING
-- REMOVING DUPLICATES
-- POPULATING AND REMOVING NULL VALUES
-- STANDARDIZING
-- REMOVING UNNEEDED COLUMNS


select *
from layoffs;

-- CREATE A DUPLICATE TABLE TO WORK ON FOR BACKUP AND SAFETY

create table layoffs_staging
like layoffs;

select * from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

select * from layoffs_staging;

-- REMOVING DUPLICATE ROWS

select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

with duplicate_cte as (
select *,
row_number() over(
partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num>1
;

select * from layoffs_staging
where company = 'Casper';

-- CREATE NEW TABLE, SECOND BACKUP

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

-- INSERT DATA INTO THE NEW TABLE

insert into layoffs_staging2
select *,
row_number() over(
partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

SELECT * FROM layoffs_staging2;

select *
from layoffs_staging2
where row_num>1;

DELETE
from layoffs_staging2
where row_num>1;

select *
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct company
from layoffs_staging2;

-- STANDARDIZING DATA

select distinct industry
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry = 'crypto'
where industry like 'crypto%';

select distinct industry
from layoffs_staging2;

select distinct country
from layoffs_staging2
where country like 'United States%';

update layoffs_staging2
set country = 'United States'
where country like 'United States%';

SELECT * FROM layoffs_staging2
;

-- STANDARDIZING DATE

select `date`, str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2
;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT * FROM layoffs_staging2
;
alter table layoffs_staging2
modify column `date` date;

-- HANDLING EMPTY AND NULL VALUES

SELECT * FROM layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null
;

SELECT * FROM layoffs_staging2
where industry is null 
or industry = ''
;

update layoffs_staging2
set industry = null
where industry = ''
;
select * from layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
where t1.industry is null
and t2.industry is not null
;

select t1.industry,t2.industry from layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
where t1.industry is null
and t2.industry is not null
;
update layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company = t2.company
set t1.industry=t2.industry
where t1.industry is null
and t2.industry is not null
;

SELECT * FROM layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

-- DELETING UNNEEDED DATA

delete
 FROM layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

SELECT * FROM layoffs_staging2;

alter table layoffs_staging2
drop row_num;

-- alter table layoffs_staging2
-- drop column row_num
-- that is another way of writing the syntax

































