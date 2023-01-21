# Institutional Research Projects for Data Reporting
Welcome! This repository holds R codes for institutional research (IR) projects in Data Reporting. You will find R codes for the processes of data extraction, data cleaning of discrepancies, data merging, and data analysis.

The R scripts/markdowns are developed for reporting to the following external agencies and internal reporting purposes:

## Integrated Postsecondary Education Data System (IPEDS)
- The IPEDScomplete.cached.Rmd file include R codes for merging historical graduate data from databse. The merged dataset can be used for one year or multiple year's graduated students' demography, major, and program information. 
- The IPEDS_GradRates.Outcome.qmd file include R codes for graduation rate, graduation rate 200, and graduate outcome reports for IPEDS.
- The IPEDSfallenrollment.qmd file include R codes for reporting fall enrollment.
- The enrollment report.Rmd include R codes for reporting 12-month enrollment.

## Common Dataset
- The CommonDataset_report.qmd file include R codes for reporting enrollments, completion, financial aid, and class size questions in the common dataset.

## National Student Clearinghouse (NSC)
- The NationalStudentClearinghosue.Rmd include R codes for creating list of students to be uploaded on the NSC website for using the StudentTracker tool. The file made strictly followed the [NSC guidelines for uploading data files](https://www.studentclearinghouse.org/blog/ufaqs/what-is-the-file-layout-for-the-studenttracker-request-file/).

## Princeton Review
- The ranking-specific.R and EnrollDatamartReporting files include codes to extract enrollment data and course information from the university database. The files are made for reporting to [the Princeton Review Entreprenueurship Program Ranking](https://www.princetonreview.com/college-rankings/top-entrepreneur).
- The rankingsurvey.Rmd include course data for the US News and Princeton Review.
- The

## Internal reporting
- The datafreeze.Rmd file include R codes for identifying data discrepancies between multiple internal databases ([datamart](https://www.oracle.com/autonomous-database/what-is-data-mart/#:~:text=A%20data%20mart%20is%20a%20simple%20form%20of%20a%20data,fewer%20sources%20than%20data%20warehouses.) and Registrar's database). Results from cross-databases checking lead to updates and corrections of codes in the database systems.
- The AggregateData.Viz.md file include both R codes and visualization output of a project using course enrollment data. The project compares different [placement methods' impact](https://ss.marin.edu/assessment/placement-english) on student enrollment in English courses of different levels. Findings around the differential effect across racial groups is also presented.
- The FacultyTenureAnalysis.shiny.Rmd include R codes for a project about "How has the proportion of tenure-line faculty changed during 2016-2021 for faculty with different rank, racial, sex, and across departments?" The data used for this project is fake and for demonstration only. 
