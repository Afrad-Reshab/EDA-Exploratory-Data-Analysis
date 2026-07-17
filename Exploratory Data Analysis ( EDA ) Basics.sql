SELECT * FROM world_layoffs.layoffs_3;

# ======================================-
# Company and Max layoffs at once #
select company ,max(total_laid_off)
from layoffs_3
where total_laid_off is not null
group by company
order by 2 desc;
#============================================-

# Company and Sum of layoffs #
select company ,sum(total_laid_off)
from layoffs_3
where total_laid_off is not null
group by company
order by 2 desc;
#==========================================================

# Industry and Sum & Avg of layoffs #
select count(*) as Layoff_events,industry,sum(total_laid_off) as Total_offs, round(avg(total_laid_off),0) as Avg_layoffs
from layoffs_3
where total_laid_off is not null
group by industry
order by 3 desc;


#=============================================
# Sum of  Monthly layoffs #
select substring( `date`, 1,7) as Months, sum(total_laid_off)
from layoffs_3
where substring( `date`, 1,7) is not null
group by Months
order by 1 asc;

 #=============================================================================
# Year & Month Layoffs and Rolling Sum #
WITH rolling_total AS
(
    SELECT
        SUBSTRING(`date`,1,7) AS Month,
        SUM(total_laid_off) as Monthly_total
    FROM layoffs_3
    WHERE `date` IS NOT NULL
    GROUP BY Month
    order by 1 asc
)

SELECT
    Month,
    monthly_total,
    SUM(Monthly_total) OVER (ORDER BY Month) AS rolling_sum
FROM rolling_total
;
#=====================================================================

# Sum of company layoffs by Year #
select company, Year( `date`) ,sum(total_laid_off) as Laid_offs
from layoffs_3
where total_laid_off is not null
group by company, Year( `date`)
order by 3 desc;

#+====================

# ================================================================= #
#  By these we find top 5 ranks of company laid off by years #      

with Company_Year (Company, Years, Laid_off)as 
(
select company, year(`date`) ,sum(total_laid_off) as Laid_offs
from layoffs_3
where total_laid_off is not null
group by company, Year(`date`)
), Company_Ranks as 
(
select *,
dense_rank() over( partition by Years order by Laid_off desc) as Rankings
from Company_Year
where Years is not null
)
select * from Company_Ranks
where Rankings <= 5;


#==============================================
#  By these we find top 5 ranks of company laid off by years #

with Country_Year (Country, Years, Laid_off)as 
(
select country, year(`date`) ,sum(total_laid_off) as Laid_offs
from layoffs_3
where total_laid_off is not null
group by country, Year(`date`)
), Country_Ranks as 
(
select *,
dense_rank() over( partition by Years order by Laid_off desc) as Rankings
from Country_Year
where Years is not null
)
select * from Country_Ranks
where Rankings <= 5;

#=========================================
#  Funding stage — total layoffs by stage #
select stage, sum(total_laid_off) as Total_offs, count(*) as Layoff_events
from layoffs_3
where total_laid_off is not null and stage is not null
group by stage
order by 2 desc;

 #==========================

# % laid off vs headcount impact#
select company, stage, total_laid_off, percentage_laid_off
from layoffs_3
where percentage_laid_off is not null
and total_laid_off is not null
order by percentage_laid_off desc
limit 10;

# raw size vs. % impact #
select company,
       total_laid_off,
       round(percentage_laid_off*100,1) as Pct_laid_off,
       stage
from layoffs_3
where total_laid_off is not null and percentage_laid_off is not null
order by percentage_laid_off desc;
#===========================================================

 # Layoffs vs. actual funds raised (in millions) #
select company, 
       funds_raised_millions, 
       total_laid_off, 
       round(percentage_laid_off*100,1) as Pct_laid_off
from layoffs_3
where funds_raised_millions is not null and total_laid_off is not null 
order by funds_raised_millions desc;

# % of Company layoffs where funds raised above #
select company, 
       funds_raised_millions, 
       round(percentage_laid_off*100,1) as Pct_laid_off
from layoffs_3
where funds_raised_millions is not null 
  and percentage_laid_off is not null
  and funds_raised_millions > 500  
order by percentage_laid_off desc;

#============== END =================