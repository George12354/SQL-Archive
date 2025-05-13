# Hospital Management System SQL Project

[![SQL Server](https://img.shields.io/badge/SQL-Server-blue)](https://www.microsoft.com/sql-server)
[![License: MIT](https://img.shields.io/badge/License-MIT-green)](LICENSE)

A comprehensive SQL-based analysis of hospital operations designed to provide actionable insights into doctor performance, appointment trends, patient demographics, and treatment outcomes. Follow this guide to set up the environment, explore the dataset schema, run queries, and review key findings.

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Getting Started](#getting-started)
3. [Dataset Schema](#dataset-schema)
4. [SQL Queries & Insights](#sql-queries--insights)
   - [Doctor Performance](#doctor-performance)
   - [Appointment Trends](#appointment-trends)
   - [Patient Demographics](#patient-demographics)
   - [Treatment Analytics](#treatment-analytics)
5. [Key Findings](#key-findings)
6. [Future Enhancements](#future-enhancements)
7. [License](#license)

---

##  Project Overview

This project leverages SQL Server to analyze a hospital management database, aiming to:

- Evaluate **doctor performance** by appointment volume and consultation fees.
- Identify **appointment patterns**, including monthly trends and cancellation rates.
- Examine **patient demographics**, such as average age and booking behavior.
- Analyze **treatment data** to uncover common diagnoses and prescribed medications.

---

##  Getting Started

### Prerequisites

- **SQL Server** (or Azure SQL Database)
- **SQL Server Management Studio (SSMS)** or **Azure Data Studio**
- **Power BI** or **Tableau** (optional, for visualization)

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/sai-forge/hospital-sql-project.git
   cd hospital-sql-project

2. Import the dataset:

   * Open SSMS/Azure Data Studio
   * Import `hospital_management_dataset.xlsx` into a new database
3. Execute the SQL script:

   ```sql
   -- Run all queries
   :r HOSPITAL_MANAGEMENT_SYSTEM_SQL_PROJECT.sql
   ```

## 🗂 DATASET SCHEMA

The database comprises four core tables:

**Patients**

| Column               | Type    | Description               |
| -------------------- | ------- | ------------------------- |
|  patient_id          | INT     | Unique patient identifier |
|  date_of_birth       | DATE    | Date of birth             |
|  gender              | VARCHAR | Gender                    |
|  insurance_provider  | VARCHAR | Insurance company         |

**Doctors**

| Column             | Type    | Description                  |
| ------------------ | ------- | ---------------------------- |
|  doctor_id         | INT     | Unique doctor identifier     |
|  first_name        | VARCHAR | Doctor's first name          |
|  specialization    | VARCHAR | Medical specialty            |
|  consultation_fee  | DECIMAL | Fee charged per consultation |

**Appointments**

| Column             | Type     | Description                             |
| ------------------ | -------- | --------------------------------------- |
|  appointment_id    | INT      | Unique appointment identifier           |
|  patient_id        | INT      | References `Patients(patient_id)`       |
|  doctor_id         | INT      | References `Doctors(doctor_id)`         |
|  appointment_date  | DATETIME | Date and time of appointment            |
|  status            | VARCHAR  | `Completed`, `Scheduled`, or `Canceled` |

**Treatments**

| Column                  | Type    | Description                               |
| ----------------------- | ------- | ----------------------------------------- |
|  appointment_id         | INT     | References `Appointments(appointment_id)` |
|  diagnosis              | VARCHAR | Diagnosis details                         |
|  prescribed_medication  | VARCHAR | Medication prescribed                     |



## 💡 SQL Queries & Insights

### Doctor Performance

Retrieve the top doctor by total appointments handled (completed or scheduled):

```sql
WITH ranked_doctors AS (
  SELECT
    d.doctor_id,
    d.first_name,
    COUNT(*) AS appointment_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
  FROM Doctors d
  JOIN Appointments a ON a.doctor_id = d.doctor_id
  WHERE a.status IN ('Completed', 'Scheduled')
  GROUP BY d.doctor_id, d.first_name
)
SELECT first_name, appointment_count
FROM ranked_doctors
WHERE rank = 1;
```

### Appointment Trends

Analyze monthly booking volumes to spot seasonal patterns:

```sql
SELECT
  YEAR(appointment_date) AS year,
  MONTH(appointment_date) AS month,
  COUNT(*) AS total_appointments
FROM Appointments
WHERE status IN ('Completed', 'Scheduled')
GROUP BY YEAR(appointment_date), MONTH(appointment_date)
ORDER BY year, month;
```

### Patient Demographics

Calculate the average age of patients:

```sql
SELECT
  AVG(DATEDIFF(YEAR, date_of_birth, GETDATE())) AS average_age
FROM Patients;
```

### Treatment Analytics

Identify the most common diagnosis-medication combinations:

```sql
SELECT
  diagnosis,
  prescribed_medication,
  COUNT(*) AS occurrences
FROM Treatments
GROUP BY diagnosis, prescribed_medication
ORDER BY occurrences DESC;
```

---

## Final Result

1. **Doctor Performance:**

   * Top performer: Dr. Heather White (15 appointments).
   * Cardiology leads in total visits.
2. **Appointment Trends:**

   * Peak booking hours: 2–4 PM.
   * Cancellation rate: 12.5%.
3. **Patient Demographics:**

   * Average age: 47 years.
   * Advance bookings (≥7 days): 65%.
4. **Treatment Insights:**

   * Leading diagnosis: "Evening point job ready clear majority" (placeholder).
   * Most prescribed medication: "skin" (placeholder).

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE] file for details.
