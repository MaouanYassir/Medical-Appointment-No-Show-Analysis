/*
==================================================
Medical Appointment No-Show Analysis
Author: Yassir Maouan

Description:
This script contains all analytical views used
for SQL analysis and Power BI reporting.

Tools:
- SQL Server
- Power BI
- DAX

Dataset:
Medical Appointment No Shows (Brazil)
==================================================
*/



-- ============================================
-- 1. vw_fact_appointments
-- ============================================
create or alter view vw_fact_appointments as 
select
	AppointmentID,
	PatientId,
	Gender,
	Age,
	Neighbourhood,
	Scholarship,
	Hipertension,
	Diabetes,
	Alcoholism,
	Handcap as handicap_level,
	SMS_received,
	No_show,
	cast(ScheduledDay as date) as scheduled_date,
	cast(AppointmentDay as date) as appointment_date,
	datediff(day, cast(ScheduledDay as date), cast(AppointmentDay as date)) as waiting_days,
	case
		when Age < 18 then 'Child'
		when Age between 18 and 59 then 'Adult'
		else 'Senior'
	end as age_group,
	case
		when datediff(day, cast(ScheduledDay as date), cast(AppointmentDay as date)) > 30 then 'Long Wait'
		else 'Normal Wait'
	end as is_waiting_long
from raw_appointments
where Age >= 0;
GO




-- ============================================
-- 2. vw_dim_neighbourhood
-- ============================================
create or alter view vw_dim_neighbourhood as 
select distinct
	Neighbourhood as neighbourhood_name
from vw_fact_appointments
where Neighbourhood is not null;
GO




-- ============================================
-- 3. vw_no_show_overview
-- ============================================
create or alter view vw_no_show_overview as
select
	count(*) as total_appointments,
	sum(cast(No_show as int)) as total_no_show,
	count(*) - sum(cast(No_show as int)) as total_show_up,
	round(cast(sum(cast(No_show as int)) as float) / nullif(count(*), 0) * 100, 2) as no_show_percentage,
	round((cast(count(*) - sum(cast(No_show as int)) as float)) / nullif(count(*), 0) * 100, 2) as show_up_percentage,
	round(avg(cast(waiting_days as float)), 2) as avg_waiting_days
from vw_fact_appointments;
GO




-- ============================================
-- 4. vw_no_show_by_age_group
-- ============================================
create or alter view vw_no_show_by_age_group as
select
	age_group,
	count(*) as total_appointments,
	sum(cast(no_show as int)) as total_no_show,
	round(cast(sum(cast(No_show as int)) as float) / nullif(count(*), 0) * 100, 2) as no_show_percentage,
	round(avg(cast(waiting_days as float)), 2) as avg_waiting_days
from vw_fact_appointments
group by age_group;
GO




-- ============================================
-- 5. vw_no_show_by_gender
-- ============================================
create or alter view vw_no_show_by_gender as
select
	Gender,
	count(*) as total_appointments,
	sum(cast(no_show as int)) as total_no_show,
	round(cast(sum(cast(No_show as int)) as float) / nullif(count(*), 0) * 100, 2) as no_show_percentage,
	round(avg(cast(waiting_days as float)), 2) as avg_waiting_days
from vw_fact_appointments
group by Gender;
GO




-- ============================================
-- 6. vw_no_show_by_sms
-- ============================================
create or alter view vw_no_show_by_sms as 
select
	SMS_received,
	count(*) as total_appointments,
	sum(cast(no_show as int)) as total_no_show,
	round(cast(sum(cast(No_show as int)) as float) / nullif(count(*), 0) * 100, 2) as no_show_percentage
from vw_fact_appointments
group by SMS_received;
GO




-- ============================================
-- 7. vw_no_show_by_waiting_type
-- ============================================
create or alter view vw_no_show_by_waiting_type as 
select
	is_waiting_long,
	count(*) as total_appointments,
	sum(cast(no_show as int)) as total_no_show,
	round(cast(sum(cast(No_show as int)) as float) / nullif(count(*), 0) * 100, 2) as no_show_percentage,
	round(avg(cast(waiting_days as float)), 2) as avg_waiting_days
from vw_fact_appointments
group by is_waiting_long;
GO




-- ============================================
-- 8. vw_no_show_by_weekday
-- ============================================
create or alter view vw_no_show_by_weekday as 
select 
	DATENAME(WEEKDAY, appointment_date) as day_name,
	DATEPART(WEEKDAY, appointment_date) as day_number,
	count(*) as total_appointments,
	sum(cast(no_show as int)) as total_no_show,
	round(cast(sum(cast(No_show as int)) as float) / nullif(count(*), 0) * 100, 2) as no_show_percentage
from vw_fact_appointments
group by 
	DATENAME(WEEKDAY, appointment_date),
	DATEPART(WEEKDAY, appointment_date);
GO




-- ============================================
-- 9. vw_no_show_by_neighbourhood
-- ============================================
create or alter view vw_no_show_by_neighbourhood as 
select
	Neighbourhood,
	count(*) as total_appointments,
	sum(cast(no_show as int)) as total_no_show,
	round(cast(sum(cast(No_show as int)) as float) / nullif(count(*), 0) * 100, 2) as no_show_percentage,
	round(avg(cast(waiting_days as float)), 2) as avg_waiting_days
from vw_fact_appointments
group by Neighbourhood
having count(*) > 100;
GO




-- ============================================
-- 10. vw_no_show_by_health_condition
-- ============================================
CREATE or alter VIEW vw_no_show_by_health_condition AS

SELECT
    'Diabetes' AS condition_name,
    CASE
        WHEN Diabetes = 1 THEN 'Yes'
        ELSE 'No'
    END AS condition_value,
    COUNT(*) AS total_appointments,
    SUM(CAST(No_show AS int)) AS total_no_show,
    ROUND(
        CAST(SUM(CAST(No_show AS int)) AS float)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS no_show_percentage,
    ROUND(AVG(CAST(waiting_days AS float)), 2) AS avg_waiting_days
FROM vw_fact_appointments
GROUP BY Diabetes

UNION ALL

SELECT
    'Hypertension' AS condition_name,
    CASE
        WHEN Hipertension = 1 THEN 'Yes'
        ELSE 'No'
    END AS condition_value,
    COUNT(*) AS total_appointments,
    SUM(CAST(No_show AS int)) AS total_no_show,
    ROUND(
        CAST(SUM(CAST(No_show AS int)) AS float)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS no_show_percentage,
    ROUND(AVG(CAST(waiting_days AS float)), 2) AS avg_waiting_days
FROM vw_fact_appointments
GROUP BY Hipertension

UNION ALL

SELECT
    'Alcoholism' AS condition_name,
    CASE
        WHEN Alcoholism = 1 THEN 'Yes'
        ELSE 'No'
    END AS condition_value,
    COUNT(*) AS total_appointments,
    SUM(CAST(No_show AS int)) AS total_no_show,
    ROUND(
        CAST(SUM(CAST(No_show AS int)) AS float)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS no_show_percentage,
    ROUND(AVG(CAST(waiting_days AS float)), 2) AS avg_waiting_days
FROM vw_fact_appointments
GROUP BY Alcoholism

UNION ALL

SELECT
    'Handicap' AS condition_name,
    CAST(handicap_level AS varchar) AS condition_value,
    COUNT(*) AS total_appointments,
    SUM(CAST(No_show AS int)) AS total_no_show,
    ROUND(
        CAST(SUM(CAST(No_show AS int)) AS float)
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS no_show_percentage,
    ROUND(AVG(CAST(waiting_days AS float)), 2) AS avg_waiting_days
FROM vw_fact_appointments
GROUP BY handicap_level;
GO



/*
==================================================
End of Script
Total Views Created: 10

1. vw_fact_appointments
2. vw_dim_neighbourhood
3. vw_no_show_overview
4. vw_no_show_by_age_group
5. vw_no_show_by_gender
6. vw_no_show_by_sms
7. vw_no_show_by_waiting_type
8. vw_no_show_by_weekday
9. vw_no_show_by_neighbourhood
10. vw_no_show_by_health_condition
==================================================
*/