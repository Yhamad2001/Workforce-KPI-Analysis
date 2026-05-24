-- ============================================================
-- PROJECT 1: Workforce Operations & KPI Analysis
-- File: analysis_queries.sql
-- Description: All analytical SQL queries used in this project.
--              Each section corresponds to a tab in the Excel
--              dashboard (see workforce_dashboard.xlsx).
-- ============================================================


-- ============================================================
-- SECTION 1: HEADCOUNT & DEPARTMENT SUMMARY
-- Used in: Excel Tab "Dept Summary"
-- ============================================================

-- 1A. Headcount by department and employment type
SELECT
    department,
    employment_type,
    COUNT(*)                                    AS headcount,
    ROUND(AVG(hourly_rate), 2)                  AS avg_hourly_rate,
    ROUND(MIN(hourly_rate), 2)                  AS min_rate,
    ROUND(MAX(hourly_rate), 2)                  AS max_rate
FROM employees
GROUP BY department, employment_type
ORDER BY department, employment_type;

-- 1B. Tenure analysis — how long has each employee been with the company?
SELECT
    employee_id,
    full_name,
    department,
    hire_date,
    DATEDIFF(CURDATE(), hire_date)              AS tenure_days,
    FLOOR(DATEDIFF(CURDATE(), hire_date) / 365) AS tenure_years
FROM employees
ORDER BY tenure_days DESC;

-- 1C. Annual payroll cost per department (assuming 2080 hrs/year full-time, 1040 part-time)
SELECT
    department,
    SUM(
        CASE employment_type
            WHEN 'Full-Time' THEN hourly_rate * 2080
            WHEN 'Part-Time' THEN hourly_rate * 1040
        END
    )                                           AS estimated_annual_payroll
FROM employees
GROUP BY department
ORDER BY estimated_annual_payroll DESC;


-- ============================================================
-- SECTION 2: ATTENDANCE & RELIABILITY KPIs
-- Used in: Excel Tab "Attendance KPIs"
-- ============================================================

-- 2A. Attendance summary per employee (Jan–Mar 2024)
SELECT
    e.employee_id,
    e.full_name,
    e.department,
    COUNT(*)                                        AS total_logged_days,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_days,
    SUM(CASE WHEN a.status = 'Absent'  THEN 1 ELSE 0 END) AS absent_days,
    SUM(CASE WHEN a.status = 'Late'    THEN 1 ELSE 0 END) AS late_days,
    ROUND(
        SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        1
    )                                               AS attendance_rate_pct
FROM employees e
JOIN attendance a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.full_name, e.department
ORDER BY attendance_rate_pct DESC;

-- 2B. Monthly trend — absences by department
SELECT
    e.department,
    DATE_FORMAT(a.work_date, '%Y-%m')               AS month,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS absences,
    SUM(CASE WHEN a.status = 'Late'   THEN 1 ELSE 0 END) AS late_arrivals
FROM employees e
JOIN attendance a ON e.employee_id = a.employee_id
GROUP BY e.department, DATE_FORMAT(a.work_date, '%Y-%m')
ORDER BY e.department, month;

-- 2C. Flag employees with attendance rate below 80% — at-risk report
SELECT
    e.employee_id,
    e.full_name,
    e.department,
    e.manager_id,
    ROUND(
        SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        1
    )                                               AS attendance_rate_pct,
    'REVIEW NEEDED'                                 AS flag
FROM employees e
JOIN attendance a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.full_name, e.department, e.manager_id
HAVING attendance_rate_pct < 80
ORDER BY attendance_rate_pct ASC;

-- 2D. Average hours worked per day per employee
--     (only for days they clocked in)
SELECT
    e.employee_id,
    e.full_name,
    e.department,
    ROUND(
        AVG(
            TIMESTAMPDIFF(MINUTE, a.clock_in, a.clock_out) / 60.0
        ),
        2
    )                                               AS avg_hours_per_day
FROM employees e
JOIN attendance a ON e.employee_id = a.employee_id
WHERE a.clock_in IS NOT NULL AND a.clock_out IS NOT NULL
GROUP BY e.employee_id, e.full_name, e.department
ORDER BY avg_hours_per_day DESC;


-- ============================================================
-- SECTION 3: OVERTIME ANALYSIS
-- Used in: Excel Tab "Overtime"
-- ============================================================

-- 3A. Total overtime hours per employee (all time)
SELECT
    e.employee_id,
    e.full_name,
    e.department,
    e.hourly_rate,
    SUM(o.overtime_hours)                           AS total_ot_hours,
    -- Overtime typically paid at 1.5x rate
    ROUND(SUM(o.overtime_hours) * e.hourly_rate * 1.5, 2) AS total_ot_cost
FROM employees e
JOIN overtime_log o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.full_name, e.department, e.hourly_rate
ORDER BY total_ot_hours DESC;

-- 3B. Overtime cost by department
SELECT
    e.department,
    ROUND(SUM(o.overtime_hours), 1)                 AS dept_ot_hours,
    ROUND(SUM(o.overtime_hours * e.hourly_rate * 1.5), 2) AS dept_ot_cost
FROM employees e
JOIN overtime_log o ON e.employee_id = o.employee_id
GROUP BY e.department
ORDER BY dept_ot_cost DESC;

-- 3C. Weekly overtime trend — which weeks had the most OT?
SELECT
    week_start,
    COUNT(DISTINCT employee_id)                     AS employees_with_ot,
    SUM(overtime_hours)                             AS total_ot_hours
FROM overtime_log
GROUP BY week_start
ORDER BY week_start;

-- 3D. Employees who worked overtime AND had absences in the same period
--     This may signal burnout or understaffing
SELECT
    e.employee_id,
    e.full_name,
    e.department,
    SUM(o.overtime_hours)                           AS total_ot_hours,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS total_absences
FROM employees e
JOIN overtime_log o   ON e.employee_id = o.employee_id
JOIN attendance  a    ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.full_name, e.department
HAVING total_ot_hours > 0 AND total_absences > 0
ORDER BY total_ot_hours DESC;


-- ============================================================
-- SECTION 4: PERFORMANCE REVIEW ANALYSIS
-- Used in: Excel Tab "Performance"
-- ============================================================

-- 4A. Average performance score per department per quarter
SELECT
    e.department,
    pr.review_quarter,
    ROUND(AVG(pr.score), 2)                         AS avg_score,
    COUNT(*)                                        AS reviews_completed
FROM employees e
JOIN performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY e.department, pr.review_quarter
ORDER BY e.department, pr.review_quarter;

-- 4B. Score improvement from Q1 to Q2 per employee
SELECT
    e.employee_id,
    e.full_name,
    e.department,
    q1.score                                        AS q1_score,
    q2.score                                        AS q2_score,
    ROUND(q2.score - q1.score, 1)                   AS score_change,
    CASE
        WHEN q2.score - q1.score > 0  THEN 'Improved'
        WHEN q2.score - q1.score < 0  THEN 'Declined'
        ELSE 'No Change'
    END                                             AS trend
FROM employees e
JOIN performance_reviews q1 ON e.employee_id = q1.employee_id AND q1.review_quarter = 'Q1 2024'
JOIN performance_reviews q2 ON e.employee_id = q2.employee_id AND q2.review_quarter = 'Q2 2024'
ORDER BY score_change DESC;

-- 4C. Top performers (average score >= 4.0 across both quarters)
SELECT
    e.employee_id,
    e.full_name,
    e.department,
    e.job_title,
    ROUND(AVG(pr.score), 2)                         AS avg_score
FROM employees e
JOIN performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY e.employee_id, e.full_name, e.department, e.job_title
HAVING avg_score >= 4.0
ORDER BY avg_score DESC;

-- 4D. Correlation view — attendance rate vs. performance score
--     Export this to Excel to plot as a scatter chart
SELECT
    e.employee_id,
    e.full_name,
    e.department,
    ROUND(
        SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        1
    )                                               AS attendance_rate_pct,
    ROUND(AVG(pr.score), 2)                         AS avg_performance_score
FROM employees e
JOIN attendance          a  ON e.employee_id = a.employee_id
JOIN performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY e.employee_id, e.full_name, e.department
ORDER BY attendance_rate_pct DESC;


-- ============================================================
-- SECTION 5: EXECUTIVE SUMMARY VIEW
-- Used in: Excel Tab "Summary Dashboard" (paste as values)
-- ============================================================

-- 5A. One-row-per-department KPI rollup
SELECT
    e.department,
    COUNT(DISTINCT e.employee_id)                   AS headcount,
    ROUND(AVG(e.hourly_rate), 2)                    AS avg_hourly_rate,
    ROUND(
        SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.record_id),
        1
    )                                               AS avg_attendance_pct,
    ROUND(AVG(pr.score), 2)                         AS avg_perf_score,
    ROUND(SUM(o.overtime_hours), 1)                 AS total_ot_hours
FROM employees e
LEFT JOIN attendance          a  ON e.employee_id = a.employee_id
LEFT JOIN performance_reviews pr ON e.employee_id = pr.employee_id
LEFT JOIN overtime_log        o  ON e.employee_id = o.employee_id
GROUP BY e.department
ORDER BY e.department;
