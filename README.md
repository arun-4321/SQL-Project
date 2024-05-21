# SQL-Project
The project is based on the data cleaning and EDA

select*
from layoffs;

# data cleaning
-- 1. Removing Duplicates
-- 2. Standardize the Data
-- 3. Null Values (or) blank Values
-- 4. Remove Any Columns

# always create new table from the raw data

create table layoffs_staging # create a new table from raw table,
like layoffs;

select*
from layoffs_staging;

INSERT layoffs_staging # inserting the values of layoffs in layoffs_staging
select*
FROM layoffs;


-- find the dupicates and remove those.

-- first give row_ numbers for each company.

Select *,
row_number()  over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
from layoffs_staging;

-- create a cte and then find the comapanies having row number greater than two

with duplicate_cte as
(
Select *,
row_number()  over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
from layoffs_staging
)

select*
from duplicate_cte
where row_num>1;

# we can't update or delete the cte, so you should copy the data present in the cte into another table.

create table layoffs_staging2
(company text, location text, industry text, total_laid_off int, percentage_laif_off text, `date` text, stage text, country text,funds_raised_millions int, row_num int
);

insert layoffs_staging2
Select *,
row_number()  over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
from layoffs_staging;

select*
from layoffs_staging2;

-- now delete the duplicates from the layoffs_staging2

select*
from layoffs_staging2
where row_num > 1;

-- now we deleted the duplicates from the table.

delete   
from layoffs_staging2
where row_num > 1;

----------------------------------------------------------------------------------------------------------------------------

-- standardizing the data
-- standardizing is the process of checking the  each column to find the vulnerabilities and removing those to increase the efficence of the data
select*
from layoffs_staging2;

select company, TRIM(company) -- TRIM is used to remove the white spaces from the given string.
FROM layoffs_staging2;

update layoffs_staging2   -- updating the changes in the layoffs_staging2
set company = TRIM(company);

select company
from layoffs_staging2;

-- industry ( same industries having the different names chaging them to same.)

select*                        -- here we have same industry with different name, setting them to a single industry name.
FROM layoffs_staging2
where industry LIKE 'Crypto%';
 
 
 UPDATE layoffs_staging2      -- updating the industry column in layoffs_staging2
 SET industry = 'Crypto'
 WHERE industry LIKE 'Crypto%';
 
 
 select distinct country
 from layoffs_staging2
 ORDER BY 1;
 
 
 select distinct country, TRIM(TRAILING '.' from country)  -- TRAILING is used to remove the characters from the end of string
 from layoffs_staging2
 ORDER BY 1;
 
 update layoffs_staging2
 set country = TRIM(TRAILING '.' from country)
 where country like 'United states%';
 
 -- chaging date data type from text to 'date'
 
 select `date`
 FROM layoffs_staging2;
 
 update layoffs_staging2
 set `date` = str_to_date(`date`,'%m/%d/%Y') ; -- 'string to date' is used ti convert the string characters into the date.
 
 select date 
 from layoffs_staging2;
 
 ALTER TABLE layoffs_staging2 -- chaging the date column from text data type to date data type
 MODIFY COLUMN `date` date;
 
 
 -----------------------------------------------------------------------------------------------------------------
 
 -- 3. removing the null and blank values
 
 select*                    -- selecting the  null values from total_laid_off and percentage_laif_off.
 FROM layoffs_staging2
 where total_laid_off IS NULL
 AND percentage_laif_off IS NULL;
 
 
 -- selecting the null values from the  industry column
 
 select*
 from layoffs_staging2
 where industry IS NULL 
 or industry = '';
 
 select*
 FROM layoffs_staging2
 WHERE company = 'Airbnb';
 
 UPDATE layoffs_staging2 -- setting the balnk values to null
 SET industry = NULL
 WHERE industry = '';
 
 SELECT t1.industry, t2.industry
 FROM layoffs_staging2 t1
 JOIN layoffs_staging2 t2
      on t1.company = t2.company
 WHERE (t1.industry IS NULL OR t1.industry = '') 
 AND t2.industry IS NOT NULL;
 
 UPDATE layoffs_staging2 t1
 JOIN layoffs_staging2 t2
      on t1.company = t2.company
 SET t1.industry = t2.industry
 WHERE (t1.industry IS NULL OR T1.industry = '')
 AND t2.industry IS NOT NULL;
 
 -- removing the columns that are having the null values and the columns ehiach are no longer nedded.alter
 
 select*
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
 AND percentage_laif_off IS NULL;
 
 -- deleting the companies that thave null values in total_laid_off and percentage_laif_off;
 
 delete 
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
 AND percentage_laif_off IS NULL;
 
 
 select*
 from layoffs_staging2;
 
 -- now row_number column is no longer nedded , deleting it.
 
 ALTER TABLE layoffs_staging2
 DROP COLUMN row_num;
 
 -- now the data is ready for the EDA
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
