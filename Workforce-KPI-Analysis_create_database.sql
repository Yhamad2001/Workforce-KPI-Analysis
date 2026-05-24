-- ============================================================
-- PROJECT 1: Workforce Operations & KPI Analysis
-- File: create_database.sql
-- Description: Creates and populates the database used for
--              all analysis in this project.
-- ============================================================

-- Create the database (run this in your SQL client)
-- CREATE DATABASE workforce_analysis;
-- USE workforce_analysis;

-- ============================================================
-- TABLE 1: employees
-- ============================================================
CREATE TABLE IF NOT EXISTS employees (
    employee_id     INT PRIMARY KEY,
    full_name       VARCHAR(100),
    department      VARCHAR(50),
    job_title       VARCHAR(80),
    hire_date       DATE,
    hourly_rate     DECIMAL(6,2),
    employment_type VARCHAR(20),   -- Full-Time, Part-Time
    manager_id      INT,
    region          VARCHAR(30)
);

INSERT INTO employees VALUES
(1001, 'Marcus Reid',       'Operations',  'Operations Manager',      '2019-03-10', 42.50, 'Full-Time', NULL,  'East'),
(1002, 'Layla Hassan',      'Operations',  'Coordinator',             '2020-06-15', 22.00, 'Full-Time', 1001,  'East'),
(1003, 'Damon Price',       'Operations',  'Coordinator',             '2021-01-20', 21.50, 'Full-Time', 1001,  'West'),
(1004, 'Sofia Nguyen',      'Operations',  'Field Specialist',        '2022-04-01', 19.75, 'Part-Time', 1001,  'East'),
(1005, 'Andre Brooks',      'Logistics',   'Logistics Analyst',       '2020-09-08', 27.00, 'Full-Time', NULL,  'West'),
(1006, 'Priya Kapoor',      'Logistics',   'Driver Supervisor',       '2019-11-03', 30.00, 'Full-Time', 1005,  'West'),
(1007, 'James Osei',        'Logistics',   'Driver',                  '2021-07-22', 18.00, 'Full-Time', 1006,  'East'),
(1008, 'Hannah Cole',       'Logistics',   'Driver',                  '2022-02-14', 18.00, 'Part-Time', 1006,  'East'),
(1009, 'Tariq Saleh',       'Dispatch',    'Dispatch Manager',        '2018-05-30', 38.00, 'Full-Time', NULL,  'West'),
(1010, 'Chloe Martin',      'Dispatch',    'Dispatcher',              '2021-08-11', 24.00, 'Full-Time', 1009,  'East'),
(1011, 'Kevin Adler',       'Dispatch',    'Dispatcher',              '2022-05-19', 23.50, 'Full-Time', 1009,  'West'),
(1012, 'Amara Diallo',      'HR',          'HR Specialist',           '2020-03-25', 29.00, 'Full-Time', NULL,  'East'),
(1013, 'Liam Cheng',        'HR',          'Recruiter',               '2023-01-10', 25.00, 'Full-Time', 1012,  'West'),
(1014, 'Fatima Al-Rashid',  'Finance',     'Finance Analyst',         '2019-07-16', 34.00, 'Full-Time', NULL,  'East'),
(1015, 'Owen Murphy',       'Finance',     'Accounts Coordinator',    '2022-10-03', 26.50, 'Full-Time', 1014,  'West');

-- ============================================================
-- TABLE 2: attendance
-- Tracks daily clock-in / clock-out for each employee
-- ============================================================
CREATE TABLE IF NOT EXISTS attendance (
    record_id       INT PRIMARY KEY AUTO_INCREMENT,
    employee_id     INT,
    work_date       DATE,
    clock_in        TIME,
    clock_out       TIME,
    status          VARCHAR(20),  -- Present, Absent, Late, Half-Day
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Insert 3 months of attendance data (sample — Jan to Mar 2024)
-- For brevity, inserting representative rows; a real dataset would have ~65 rows/employee
INSERT INTO attendance (employee_id, work_date, clock_in, clock_out, status) VALUES
-- January
(1002, '2024-01-02', '08:55', '17:05', 'Present'),
(1002, '2024-01-03', '09:20', '17:00', 'Late'),
(1002, '2024-01-04', '08:58', '17:02', 'Present'),
(1002, '2024-01-08', '08:50', '17:00', 'Present'),
(1002, '2024-01-09', NULL,    NULL,    'Absent'),
(1003, '2024-01-02', '08:45', '17:15', 'Present'),
(1003, '2024-01-03', '09:05', '17:00', 'Present'),
(1003, '2024-01-04', '09:35', '17:00', 'Late'),
(1003, '2024-01-08', '08:55', '17:10', 'Present'),
(1003, '2024-01-09', '08:50', '17:00', 'Present'),
(1007, '2024-01-02', '07:00', '15:05', 'Present'),
(1007, '2024-01-03', '07:00', '15:00', 'Present'),
(1007, '2024-01-04', NULL,    NULL,    'Absent'),
(1007, '2024-01-08', '07:15', '15:00', 'Late'),
(1007, '2024-01-09', '07:00', '15:05', 'Present'),
(1010, '2024-01-02', '08:00', '16:00', 'Present'),
(1010, '2024-01-03', '08:00', '16:00', 'Present'),
(1010, '2024-01-04', '08:20', '16:00', 'Late'),
(1010, '2024-01-08', '08:00', '16:05', 'Present'),
(1010, '2024-01-09', NULL,    NULL,    'Absent'),
-- February
(1002, '2024-02-01', '08:52', '17:00', 'Present'),
(1002, '2024-02-05', '09:40', '17:00', 'Late'),
(1002, '2024-02-06', '08:55', '17:05', 'Present'),
(1002, '2024-02-07', NULL,    NULL,    'Absent'),
(1002, '2024-02-08', '08:50', '17:00', 'Present'),
(1003, '2024-02-01', '08:45', '17:00', 'Present'),
(1003, '2024-02-05', '08:50', '17:05', 'Present'),
(1003, '2024-02-06', '09:10', '17:00', 'Late'),
(1003, '2024-02-07', '08:48', '17:00', 'Present'),
(1003, '2024-02-08', NULL,    NULL,    'Absent'),
(1007, '2024-02-01', '07:00', '15:00', 'Present'),
(1007, '2024-02-05', '07:20', '15:00', 'Late'),
(1007, '2024-02-06', '07:00', '15:10', 'Present'),
(1007, '2024-02-07', NULL,    NULL,    'Absent'),
(1007, '2024-02-08', '07:00', '15:00', 'Present'),
(1010, '2024-02-01', '08:00', '16:00', 'Present'),
(1010, '2024-02-05', '08:00', '16:05', 'Present'),
(1010, '2024-02-06', '08:25', '16:00', 'Late'),
(1010, '2024-02-07', '08:00', '16:00', 'Present'),
(1010, '2024-02-08', NULL,    NULL,    'Absent'),
-- March
(1002, '2024-03-04', '08:53', '17:00', 'Present'),
(1002, '2024-03-05', '08:50', '17:05', 'Present'),
(1002, '2024-03-06', '09:30', '17:00', 'Late'),
(1002, '2024-03-07', NULL,    NULL,    'Absent'),
(1002, '2024-03-11', '08:55', '17:00', 'Present'),
(1003, '2024-03-04', '08:45', '17:10', 'Present'),
(1003, '2024-03-05', '08:50', '17:00', 'Present'),
(1003, '2024-03-06', '08:55', '17:05', 'Present'),
(1003, '2024-03-07', '09:45', '17:00', 'Late'),
(1003, '2024-03-11', NULL,    NULL,    'Absent'),
(1007, '2024-03-04', '07:00', '15:05', 'Present'),
(1007, '2024-03-05', '07:30', '15:00', 'Late'),
(1007, '2024-03-06', '07:00', '15:00', 'Present'),
(1007, '2024-03-07', '07:00', '15:10', 'Present'),
(1007, '2024-03-11', NULL,    NULL,    'Absent'),
(1010, '2024-03-04', '08:00', '16:05', 'Present'),
(1010, '2024-03-05', '08:00', '16:00', 'Present'),
(1010, '2024-03-06', NULL,    NULL,    'Absent'),
(1010, '2024-03-07', '08:20', '16:00', 'Late'),
(1010, '2024-03-11', '08:00', '16:05', 'Present');

-- ============================================================
-- TABLE 3: performance_reviews
-- Quarterly scores per employee (scale 1–5)
-- ============================================================
CREATE TABLE IF NOT EXISTS performance_reviews (
    review_id       INT PRIMARY KEY AUTO_INCREMENT,
    employee_id     INT,
    review_quarter  VARCHAR(10),  -- e.g. 'Q1 2024'
    score           DECIMAL(3,1),
    reviewer_id     INT,
    review_date     DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO performance_reviews (employee_id, review_quarter, score, reviewer_id, review_date) VALUES
(1002, 'Q1 2024', 3.8, 1001, '2024-04-05'),
(1002, 'Q2 2024', 4.1, 1001, '2024-07-08'),
(1003, 'Q1 2024', 4.4, 1001, '2024-04-05'),
(1003, 'Q2 2024', 4.6, 1001, '2024-07-08'),
(1004, 'Q1 2024', 3.2, 1001, '2024-04-05'),
(1004, 'Q2 2024', 3.5, 1001, '2024-07-08'),
(1005, 'Q1 2024', 4.0, NULL,  '2024-04-06'),
(1005, 'Q2 2024', 4.2, NULL,  '2024-07-09'),
(1006, 'Q1 2024', 3.9, 1005, '2024-04-06'),
(1006, 'Q2 2024', 4.3, 1005, '2024-07-09'),
(1007, 'Q1 2024', 3.5, 1006, '2024-04-06'),
(1007, 'Q2 2024', 3.7, 1006, '2024-07-09'),
(1008, 'Q1 2024', 2.9, 1006, '2024-04-06'),
(1008, 'Q2 2024', 3.1, 1006, '2024-07-09'),
(1009, 'Q1 2024', 4.5, NULL,  '2024-04-07'),
(1009, 'Q2 2024', 4.7, NULL,  '2024-07-10'),
(1010, 'Q1 2024', 3.6, 1009, '2024-04-07'),
(1010, 'Q2 2024', 3.9, 1009, '2024-07-10'),
(1011, 'Q1 2024', 4.0, 1009, '2024-04-07'),
(1011, 'Q2 2024', 4.2, 1009, '2024-07-10'),
(1012, 'Q1 2024', 4.3, NULL,  '2024-04-08'),
(1012, 'Q2 2024', 4.5, NULL,  '2024-07-11'),
(1013, 'Q1 2024', 3.7, 1012, '2024-04-08'),
(1013, 'Q2 2024', 3.9, 1012, '2024-07-11'),
(1014, 'Q1 2024', 4.2, NULL,  '2024-04-08'),
(1014, 'Q2 2024', 4.4, NULL,  '2024-07-11'),
(1015, 'Q1 2024', 3.3, 1014, '2024-04-08'),
(1015, 'Q2 2024', 3.6, 1014, '2024-07-11');

-- ============================================================
-- TABLE 4: overtime_log
-- Tracks overtime hours per employee per week
-- ============================================================
CREATE TABLE IF NOT EXISTS overtime_log (
    log_id          INT PRIMARY KEY AUTO_INCREMENT,
    employee_id     INT,
    week_start      DATE,
    overtime_hours  DECIMAL(4,1),
    approved_by     INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO overtime_log (employee_id, week_start, overtime_hours, approved_by) VALUES
(1002, '2024-01-08', 4.5, 1001),
(1002, '2024-01-15', 3.0, 1001),
(1002, '2024-02-05', 5.0, 1001),
(1002, '2024-03-04', 2.5, 1001),
(1003, '2024-01-08', 6.0, 1001),
(1003, '2024-02-12', 4.0, 1001),
(1003, '2024-03-11', 3.5, 1001),
(1007, '2024-01-15', 8.0, 1006),
(1007, '2024-02-05', 7.5, 1006),
(1007, '2024-03-04', 6.0, 1006),
(1010, '2024-01-08', 3.0, 1009),
(1010, '2024-02-19', 4.5, 1009),
(1010, '2024-03-11', 5.0, 1009),
(1011, '2024-01-22', 2.0, 1009),
(1011, '2024-02-12', 3.5, 1009),
(1006, '2024-01-08', 5.5, 1005),
(1006, '2024-02-05', 4.0, 1005),
(1006, '2024-03-04', 6.5, 1005);
