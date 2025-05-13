/*Hospital Management System SQL Project - Analytical Questions

Doctor Performance & Specialization */

-- 1-Which doctor has handled the most appointments?
/*
;with cte as(
select Doc.doctor_id, Doc.first_name,
COUNT(1) AS no_of_appointments, 
RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk
from Doctors$ Doc
JOIN Appointments$ a on a.doctor_id = Doc.doctor_id
WHERE a.status = 'Completed' OR a.status = 'Scheduled'
GROUP BY Doc.doctor_id, Doc.first_name
)

select cte.first_name,cte.no_of_appointments
from cte
WHERE cte.rnk = 1
*/

--2. Which specialization attracts the highest number of appointments?
/*
;with cte as(
select Doc.specialization,
COUNT(1) AS no_of_appointments, 
RANK() OVER(ORDER BY COUNT(1) DESC) AS rnk
from Doctors$ Doc
JOIN Appointments$ a on a.doctor_id = Doc.doctor_id
WHERE a.status = 'Completed' OR a.status = 'Scheduled'
GROUP BY Doc.specialization
)

select cte.specialization,cte.no_of_appointments
from cte
WHERE cte.rnk = 1
*/

--3. Which doctor has the highest average consultation fee?
/*
;with cte as(
select Doc.doctor_id, Doc.first_name, Doc.consultation_fee,
DENSE_RANK() OVER(ORDER BY Doc.consultation_fee DESC) AS rnk
from Doctors$ Doc
)

select cte.doctor_id, cte.first_name, cte.consultation_fee from cte
WHERE cte.rnk = 1
*/

--4. What is the monthly trend of appointments?
/*
select 
	DATEPART(YEAR, a.appointment_date) AS year,
	DATEPART(MONTH, a.appointment_date) AS month,
	COUNT(*) AS total_appointments
from Appointments$ a
WHERE a.status IN ('Completed', 'Scheduled')
GROUP BY DATEPART(YEAR, a.appointment_date), DATEPART(MONTH, a.appointment_date)
ORDER BY year, month
*/


--5. What is the appointment no-show rate (i.e., how many appointments were not attended)?
/*
select a.status, 
COUNT(1) as no_of_appointments_canceled
from Appointments$ a
WHERE a.status IN ('Canceled')
GROUP BY a.status
*/


--6. Find the peak appointment hours (i.e., what time slot has the most appointments?)

/*
SELECT TOP 1 
    DATEPART(HOUR, a.appointment_date) AS hour,
    COUNT(*) AS total_appointments
FROM Appointments$ a
WHERE a.status IN ('Completed', 'Scheduled')
GROUP BY DATEPART(HOUR, a.appointment_date)
ORDER BY total_appointments DESC
*/


--7. How many appointments were scheduled per doctor in the last month?
/*
select doc.first_name, 
COUNT(1) as no_of_appointment
from Appointments$ a
JOIN Doctors$ doc on doc.doctor_id = a.doctor_id
--Extract the current month and year and moves one month back, then constructs the first day
WHERE a.appointment_date >= DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
--Get appointments before the first day of the current month
AND a.appointment_date < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
GROUP BY doc.first_name
ORDER BY no_of_appointment DESC
*/



--8. What is the average age of patients?
/*
--DATEPART() – Extracts a Specific Part of a Date
;with cte as(
select p.date_of_birth, DATEPART(YEAR, p.date_of_birth) AS Patient_Year,
YEAR(GETDATE()) AS Current_year
from Patients$ p
)
--This query calculates the average based on years, but it ignores exact birthdates.
select AVG((cte.Current_year - cte.Patient_Year)) AS Patient_AVG_Age
from cte

--This query ensures accuracy in cases where a patient hasn't yet had their birthday this year.
--DATEDIFF() – Calculates the Difference Between Two Dates
SELECT AVG(DATEDIFF(YEAR, p.date_of_birth, GETDATE())) AS Patient_AVG_Age
FROM Patients$ p;
*/


--9. What percentage of patients book appointments on the same day compared to those who scheduled ahead?
--NOTE: check query again
/*
;with cte as(
select p.patient_id, p.first_name, a.status, DATEPART(DAY, a.appointment_date) AS Appointment_day,
COUNT(*) OVER(PARTITION BY DATEPART(DAY, a.appointment_date)) AS appointment_count
from Patients$ p
JOIN Appointments$ a on a.patient_id = p.patient_id
)

SELECT 
    SUM(CASE WHEN cte.status IN ('Completed', 'Canceled') THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Same_Day_Percentage,
    SUM(CASE WHEN cte.status IN ('Scheduled') THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Scheduled_Ahead_Percentage
FROM cte
WHERE cte.appointment_count > 1;
*/

--10. What are the top 5 most common diagnoses given to patients?
--NOTE: check query again
/*
select DISTINCT TOP(5) t.diagnosis,
COUNT(*) OVER(PARTITION BY p.patient_id) AS Top_Most_Common_Dignoses
from Treatments$ t
JOIN Appointments$ a on a.appointment_id = t.appointment_id
JOIN Patients$ p on p.patient_id = a.patient_id
group by p.patient_id, t.diagnosis
ORDER BY Top_Most_Common_Dignoses desc
*/

--11. Find the most prescribed medications
/*
select t.prescribed_medication, COUNT(*) AS no
from Treatments$ t
group by t.prescribed_medication
order by no desc
*/

--12. How many treatments were provided per doctor in the past 3 months?
/*
select  *
from Treatments$ t
JOIN Appointments$ a on a.appointment_id = t.appointment_id
JOIN Doctors$ doc on doc.doctor_id = a.doctor_id
*/

/*
---This is the ideal answer for the question
select doc.first_name,
COUNT(t.treatment_id) AS treatment_done_in_past_3_months
from Treatments$ t
JOIN Appointments$ a on a.appointment_id = t.appointment_id
JOIN Doctors$ doc on doc.doctor_id = a.doctor_id
WHERE a.appointment_date >= DATEADD(MONTH, -3, GETDATE())
GROUP BY  doc.first_name
*/

--13. What is the average number of treatments per patient?

/*
select AVG(patient_treatment_count) AS avg_treatments_per_patient
from(
	select a.patient_id, p.email,
	COUNT(t.treatment_id) AS patient_treatment_count
	from Treatments$ t
	JOIN Appointments$ a on a.appointment_id = t.appointment_id
	JOIN Patients$ p on p.patient_id = a.patient_id
	GROUP BY a.patient_id, p.email
) AS patient_treatment_count
*/

--14. Is there any relationship between diagnosis and medication prescribed?

/*
--Need To review question
SELECT t.diagnosis, t.prescribed_medication, COUNT(*) AS occurrence_count
FROM Treatments$ t
GROUP BY t.diagnosis, t.prescribed_medication
ORDER BY t.diagnosis, occurrence_count DESC;
*/

--15. Which doctors prescribe the most medications?
/*
select doc.first_name,
COUNT(t.prescribed_medication) AS no_of_precribed_meds_per_doc
from Treatments$ t
JOIN Appointments$ a on a.appointment_id = t.appointment_id
JOIN Doctors$ doc on doc.doctor_id = a.doctor_id
GROUP BY doc.first_name
ORDER BY no_of_precribed_meds_per_doc DESC
*/
