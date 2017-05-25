# EECS 395/495: Personal Health Systems - Final Project
Repository for EECS 395/495: Personal Health Systems Final Project

SPRING 2017, NORTHWESTERN UNIVERSITY

Instructor : Professor Nicos Maglaveras

A PHS using for monitoring and visualization of daily activities of normal and CAD subjects

# Background:
Physiological monitoring devices enable capture and transmission of comprehensive physiological data on the user via mobile and fixed data networks. During the recent years, multiple wrist sensor have been available in the market and they have been valuable for fitness-orientated individuals. These devices are able to monitoring the daily activities of the patients which is achieved through embedded sensor for activity tracking, HR detection, through photoplethysmography (PPG) techniques, etc. In order to achieve more reliable recordings, especially during exercise, several devices are available which can among other record accurately ECG signals.

# Data: 
In the context of the present project, at least 9 users of several age categories have used one commercially available wrist sensor in order to track their daily activities for 2 different days. Additionally, the users followed a physical activity program during which the ECG was recorded by a wearable device. As a result 9 patients were recruited. 

The data include:
1. during aerobic exercise
a. ECG (250Hz)
b. Activity (<0.2-low activity, <0.8-moderate activity, >0.8 high activity), posture, Peak and min values of the accelerometers in X,Y,Z axes, acceleration in all three axis (1Hz)
2. During daily activities (with non fixed sampling frequency, each signal includes the time stamp in UNIX format)
a. Heart rate
b. Activity type (0: "Silent",  1: "Walking", 2: "Running", 3: "Non wear", 4: "REM", 5: "NREM", 6: "Charging", other: “undefined”)
c. Steps

# Aim: 
The aim of the present study is to design and implement a mobile and web application which may serve as an assisting tool for a clinician in order to monitor the patients and for the patients’ empowerment. In this respect, through the application, the clinician will be able to select a patient, perform an analysis on the desired information and finally present the results in dashboards for further interventions and DSS. The analysis possibilities should include among others analytics of HRV measures for the morning hours (06:00 – 14:00), afternoon-evening hours (14:00-22:00) and night hours (22:00-06:00).

As an example, one may want to visualize progress in amount of activity in aerobic zones per day, maximum HR and recovery rate, and potentially correlate them with amount of daily activity and night rem/non-rem sleep. Analysis and visualization can be performed on a daily basis or longitudinally.

User Interfaces should be designed according to the basic scenario described above. The usability of these I/Fs should be addressed.
