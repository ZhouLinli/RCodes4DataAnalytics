# Institutional Research Projects on Program Evaluation 

Welcome! This repository holds R codes for institutional research (IR) projects on Program Evaluation. You will find R codes for the processes of data cleaning, analysis, and reporting of program outcomes. 

Several projects are developed to support university's strategic planning: 

## Tracking alumni career and further education outcomes 
- The AlumTrack.Rmd file made a clean dataset from three different data sources: survey, LinkedIn, national student clearinghouse, and ipedscomplete. The dataset includes all students graduated from the university since 2013. I used [flexdashbaord](https://cran.r-project.org/web/packages/flexdashboard/index.html) and [shinyapps.io](https://shiny.rstudio.com/) to create dashboard to show students' employment/further education by students' characteristics (level, major, demography). 

## Impact of courses requirement for course restructuring 
- The CourseReq.Rmd file used [WebSraping using rvest package](https://rvest.tidyverse.org/) to compile dataset from HTML. This project systematically scrapped university website focusing on courses requirements for 54 majors.

## Review Coure Performances
- The aacCourse_Report.pdf file reviewed students enrollment, GPA, and pass rate for several key courses. The report also examines the impact of retaking those courses on students' pass rate.
- The CoreCourseReview_cleandf.Rmd and CoreCourseRev_report.qmd files include R codes to clean and report course data for a 5-year course enrollment and student performance review.

## Learning Management System (Canvas) for student advising improvement 
- The report_grade_aligning.Rmd contains codes to make [a full project report](https://github.com/ZhouLinli/IR-Projects/blob/main/Program%20Evaluation/report_grade_aligning.pdf) for assessing the data integrity, accuracy, and validity of Canvas database. I compared Canvas' grade discrepancies with Registrar measured by exact/slight/significant differences metrics.
- The dataprep_clean_merge_grades_2021-2022.Rmd contains data cleaning process for Canvas versus Registrar database.
