# Medical Appointment No-Show Analysis

## Project Overview

This project analyzes patient appointment attendance patterns and identifies factors associated with medical appointment no-shows.

The objective is to help healthcare providers better understand patient behavior and improve appointment attendance through data-driven insights.

---

## Business Problem

Missed appointments create operational inefficiencies, increase healthcare costs, and reduce healthcare accessibility.

This project investigates:

- Which patient groups are more likely to miss appointments
- The impact of waiting time on attendance
- The influence of SMS reminders
- Geographic attendance patterns
- The relationship between health conditions and no-show behavior

---

## Dataset

**Medical Appointment No Shows (Brazil)**

- 110,527 medical appointments
- Period covered: April–May 2016

Source:

https://www.kaggle.com/datasets/joniarroba/noshowappointments

---

## Tools Used

- SQL Server
- Power BI
- DAX
- GitHub

---

## SQL Data Preparation

The dataset was transformed using SQL Server.

Main components:

- vw_fact_appointments
- vw_dim_neighbourhood
- vw_no_show_overview
- vw_no_show_by_age_group
- vw_no_show_by_gender
- vw_no_show_by_sms
- vw_no_show_by_waiting_type
- vw_no_show_by_weekday
- vw_no_show_by_neighbourhood
- vw_no_show_by_health_condition

---

## Dashboard Pages

### Executive Overview

Key KPIs:

- Total Appointments
- Total No Show
- No Show Percentage
- Average Waiting Days

Analysis:

- No Show Percentage by Age Group
- No Show Percentage by Gender
- No Show Percentage by SMS Received
- No Show Percentage by Waiting Type

![Executive Overview](Images/executive_overview.png)

---

### Health & Geographic Analysis

Analysis:

- Health Conditions Overview
- No Show Percentage by Weekday
- Top Neighbourhoods by No Show Percentage
- Top Neighbourhoods by Total Appointments

![Health & Geographic Analysis](Images/health_geographic_analysis.png)

---

### Insights & Recommendations

![Insights & Recommendations](Images/insights_recommendations.png)

---

## Key Findings

### Waiting time is the strongest predictor of no-show

Patients with long waiting times exhibited significantly higher no-show rates compared to patients with normal waiting times.

### Senior patients are more reliable

Senior patients demonstrated the lowest no-show rates among all age groups.

### Gender has limited impact

Male and female patients exhibited very similar attendance patterns.

### Geographic differences exist

No-show rates varied significantly across neighbourhoods.

### SMS reminders require further investigation

Patients receiving SMS reminders showed higher no-show rates, suggesting correlation rather than causation.

---

## Business Recommendations

1. Reduce appointment waiting times whenever possible.
2. Monitor high-risk neighbourhoods.
3. Review SMS reminder strategies.
4. Develop predictive models to identify high-risk patients.

---

## Repository Structure

```text
Medical-Appointment-No-Show-Analysis
│
├── README.md
├── medical_appointment_views.sql
├── PowerBI
│   └── Medical_Appointment_No_Show.pbix
│
└── Images
    ├── executive_overview.png
    ├── health_geographic_analysis.png
    └── insights_recommendations.png
```

---

## Author

**Yassir Maouan**

SQL Server • Power BI • DAX
