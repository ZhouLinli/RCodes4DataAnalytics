#Read local data files for datamart

datamart_ug<-readxl::read_excel("/Users/linlizhou/Documents/LASELL/working on/Final Datamart up to Date 06022022.xlsx")
#datamart, created by IT in the freeze process, contains more variables including major 2 and minor 1/2
#shared drive path name: /Volumes/lasellshare-1/Faculty_Staff_Shares$/IR/Datamart Files/DataMart To Date/Final Datamart up to Date 06022022.xlsx
dplyr::glimpse(datamart_ug)


#filter out only undergraduate students
datamart_ug%>%group_by(ADMIT_TYPE)%>%count()
datamart_ug%>%group_by(CLASS_LEVEL_RPT_LABEL)%>%count()
datamart_ug<-datamart_ug%>%filter(
  CLASS_LEVEL_RPT_LABEL%in%c("Freshman","Sophomore","Junior","Senior")
)
#check
datamart_ug%>%group_by(PROGRAM_1)%>%count()#all undergrad, looks right



#filter out only enrolled students
datamart_ug%>%group_by(ENROLL_SEP_DESC)%>%count()
datamart_ug<-datamart_ug%>%filter(ENROLL_SEP_DESC=="Enrolled")
#check
datamart_ug%>%group_by(ENROLL_SEP_DESC)%>%count()#only enrolled, looks right


library(dplyr)
datamart_ug%>%group_by(`FA_EFC_FM`)%>%count()#o is blacnk; 0.01 is real 0 contribution -neediest student ; around <$5200 is pell eligible (federal $5000 each year; ) 

#transfer
# 

#filter out full and part time students
datamart_ug%>%group_by(ADMIT_ENROLL_TIME)%>%count()#ask eric what about the not listed
datamart_ug<-datamart_ug%>%filter(
  ADMIT_ENROLL_TIME%in%c("Full-time","Full-Time","Part-time","Part-Time"))
#check
datamart_ug%>%group_by(FTPT_TOP_LEVEL)%>%count()#still contain NL=not listed are lasell village students (when credit is less than 12, lasell village students are considered as part-time undergrads)
#filter out NL
datamart_ug<-datamart_ug%>%filter(FTPT_TOP_LEVEL%in%c("FT","PT"))
#check
datamart_ug%>%group_by(FTPT_TOP_LEVEL)%>%count()#looks right



#filter out students in academic year 2021-2022
#academic year needs to be combined with academic term and academic session to filter out 2021 summer session 2, 2021 fall (main, 1,2), 2022 winter (main), 2022 spring (main,1,2), 2022 summer (main, 1) 

datamart21_22 <-datamart_ug%>%filter(
  (ACADEMIC_YEAR == 2021 & ACADEMIC_TERM == "SUMMER" & ACADEMIC_SESSION == "SES2") | #2021 summer session 2
  (ACADEMIC_YEAR == 2021 & ACADEMIC_TERM == "FALL") | #2021 fall (main, 1,2)
  (ACADEMIC_YEAR == 2022 & ACADEMIC_TERM %in% c("WINTER","SPRING")) | #2022 winter (main), #2022 spring (main,1,2)
  (ACADEMIC_YEAR == 2022 & ACADEMIC_TERM == "SUMMER" & ACADEMIC_SESSION %in% c("SES1", "MAIN"))  # 2022 summer (main, 1) 
)
#check
datamart21_22%>%group_by(ACADEMIC_YEAR,ACADEMIC_TERM,ACADEMIC_SESSION)%>%count() # looks right











#external reporting for the Princeton Review 2022-8-19 due



#goal - question 16: What percentage of the total eligible degree-seeking undergraduate student body (full-time and part-time) were enrolled in an entrepreneurship offering (as defined Question 11) during the 2021-2022 academic year?

#take the 61 number of entrepreneurship course registered students (from the course21_22 data) divide by total registered undergrad
#the question becomes how many registered undergrad in 2021-2022

#check if ppid is unique (if students are appeared once, one student one row)
t1<-datamart21_22%>%group_by(PC_ID)%>%summarise(time_appear=n())%>%count(time_appear) %>% arrange(desc(time_appear))
#find duplicated: this is likely to be because students enrolled in multiple sessions in one semester
#unless counting the credits (need to add credits in all sessions), I can remove session1, 2 data and only keep the main session

#n number of students appeared n_per_key times
#subset tibble[rows,cols]
total<-t1[,2]%>% unlist() %>% sum()# we got 8308 unique students, all appeared once
61/total







#goal-question14:What was the total enrollment (full-time and part-time) in your undergraduate entrepreneurship degree(s), major(s), minor(s), and certificate(s) for the 2021-2022 academic year? Students should only be counted once.
# concentrations, sub-level of major, no need; certificate no var.

# count unique students (for multiple appearance, only count one appearance) that enrolled in entrepreneurship major/minor1/2
datamart21_22%>%filter(MAJOR_1=="Entrepreneurship"|MAJOR_2=="Entrepreneurship"|MINOR_1=="Entrepreneurship"|MINOR_2=="Entrepreneurship")%>%
  group_by(PC_ID)%>%count()%>%arrange(desc(n))%>%nrow()

#alternatively:
t2<-datamart21_22%>%filter(MAJOR_1=="Entrepreneurship"|MAJOR_2=="Entrepreneurship"|MINOR_1=="Entrepreneurship"|MINOR_2=="Entrepreneurship")%>%
  group_by(PC_ID)%>%summarise(time_appear=n())%>%count(time_appear)
t2[,2]%>% unlist() %>% sum()



