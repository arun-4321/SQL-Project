-- Exploratory Data Analysis

select*
from layoffs_staging2;


SELECT MAX(total_laid_off), MAX(percentage_laif_off)
from layoffs_staging2;


SELECT*
FROM layoffs_staging2
where percentage_laif_off = 1;

SELECT*
FROM layoffs_staging2
WHERE percentage_laif_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
order by 2 desc;

select min(`date`), max(`date`)
From layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
order by 2 desc;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
order by 2 desc;

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
order by 1 desc;

SELECT year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
where year(`date`) is not null
GROUP BY year(`date`)
order by 1 desc;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
order by 2 desc;

SELECT company, avg(percentage_laif_off)
FROM layoffs_staging2
GROUP BY company
order by 2 desc;

SELECT SUBSTRING(`date`,6,2) AS `MONTH`, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY  `MONTH` 
order by 1 asc;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, sum(total_laid_off)
FROM layoffs_staging2
Where substring(`date`,1,7) IS NOT NULL
GROUP BY  `MONTH` 
order by 1 asc;

-- rolling sum

with  Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, sum(total_laid_off) as total_off
FROM layoffs_staging2
Where substring(`date`,1,7) IS NOT NULL
GROUP BY  `MONTH` 
order by 1 asc
)
SELECT `MONTH`, total_off,
SUM(total_off) over(order by `MONTH`)
from Rolling_total;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
order by 2 desc;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
order by 3 desc;

with Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT*, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
From Company_Year
WHERE years IS NOT NULL
)
select*
FROM Company_Year_Rank
WHERE Ranking <= 5
;





