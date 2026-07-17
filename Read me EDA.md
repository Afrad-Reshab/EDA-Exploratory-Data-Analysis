# Layoffs Dataset — Exploratory Data Analysis (SQL)

Exploratory analysis of global tech layoffs using MySQL. This project covers
aggregation, industry and funding-stage breakdowns, date-based trend analysis,
and window functions to answer questions about which companies, industries,
and countries were hit hardest — and how layoffs trended over time.

## Dataset

- **Source:** [Layoffs 2022 dataset, Kaggle] <!-- replace with actual link -->
- **Tables used:**
  - `layoffs_3` — cleaned dataset (duplicates removed, nulls handled) used for all analysis
  - `layoffs_2` — intermediate cleaning stage, kept for reference <!-- edit/remove if not accurate -->
- **Key columns:** `company`, `industry`, `country`, `date`, `stage`,
  `total_laid_off`, `percentage_laid_off`, `funds_raised_millions`

> Note: `total_laid_off` and `percentage_laid_off` are not always both populated
> for a given row — some layoff events only report one or the other. Queries
> that use both columns filter to rows where both are present, which means a
> few rows are excluded from those specific results. This is a known gap in
> the source data, not a query error.

## Tools

- MySQL / MySQL Workbench
- SQL features used: `GROUP BY`, CTEs, `DENSE_RANK()`, window aggregates (`SUM() OVER`), `ROUND()`, `COALESCE()`

## Questions Answered

1. **Which companies had the single largest layoff event?**
   Max `total_laid_off` per company, ranked descending.

2. **Which companies laid off the most people in total?**
   Sum of `total_laid_off` per company.

3. **Which industries were hit hardest, and what's the average layoff size per industry?**
   Sum and average `total_laid_off` grouped by `industry`.

4. **How did layoffs trend month over month?**
   Layoffs aggregated by year-month.

5. **What was the cumulative (rolling) layoff trend over time?**
   Monthly totals with a running total using a window function.

6. **Which companies laid off the most people each year?**
   Sum of layoffs by company and year.

7. **Top 5 companies by layoffs, per year**
   Using `DENSE_RANK()` partitioned by year to surface the top 5 companies annually.

8. **Top 5 countries by layoffs, per year**
   Same ranking approach applied at the country level.

9. **Which funding stages saw the most layoffs?**
   Total layoffs grouped by `stage` (Seed, Series A–C, IPO, etc.) — shows whether
   early-stage startups or later-stage/public companies were hit harder.

10. **Which companies laid off the largest share of their workforce, regardless of size?**
    Combines `total_laid_off` and `percentage_laid_off` to surface companies where
    layoffs were proportionally severe, not just numerically large — e.g., a small
    company that cut its entire staff shows up here even if a giant like Amazon
    cut a much bigger raw number.

11. **Did heavily-funded companies still lay off large portions of staff?**
    Compares `funds_raised_millions` against `total_laid_off` and `percentage_laid_off`,
    filtered to companies that raised over $500M — tests the assumption that
    strong funding protected companies from deep cuts.

## Key Insights

<!-- Fill these in with your actual findings once you run the queries —
     3-4 bullets turns this from "a file of queries" into "an analysis" -->
- e.g., "Layoffs peaked in [Month/Year], coinciding with [macro event]."
- e.g., "The [Industry] sector had the highest total layoffs, while [Industry] had the highest average per event."
- e.g., "[Company], despite raising over $500M, still laid off X% of its workforce — showing funding didn't guarantee stability."
- e.g., "Post-IPO / late-stage companies accounted for the largest share of total layoffs, not early-stage startups."

## File Structure

```
layoffs_eda.sql   -- all exploratory queries, organized by question
README.md         -- this file
```

## How to Run

1. Import the layoffs dataset into a MySQL instance.
2. Run any cleaning/staging scripts to produce `layoffs_3`.
3. Execute queries in `layoffs_eda.sql` individually — each section is
   self-contained and commented.

---
*Part of my data analytics portfolio. Feedback welcome.*
