#------------load package--------------
library(readxl) #for read_excel
library(readr) #for read_csv
library(dplyr) #for select, rename, join, etc.
library(tidyverse) #for pipes
library(ggplot2) #for making charts
library(stringr)  #for working with strings/texts/qualitative data
library("writexl")#for save data frame as excel files
library(gt) #for get/print table
library(gtsummary) #count categorical var as shown as table

#------working directory --------
getwd()
setwd("-/Documents/Rprojects/data/student_satisfaction_survey")
list.files()

#============data files ===========

#------main data file--------------

#read data files, initial exploration
sss21<-read_excel("2021 SSS Raw.xlsx")
names(sss21)
#glimpse(sss21$`Invite Custom Field 1`)
#select (and rename) variables to build separate data frames
#

#create the main data file (qualitative)
sss21.qual<-select(sss21, starts_with("Please explain"), starts_with("Please provide explanations"), starts_with("Please provide any additional details"), names(sss21)[153])
names(sss21.qual)

#select variables to create the main quantitative data file
sss21.slct<-sss21 %>% select(`Invite Custom Field 1`,  `Which of the following describes your status for the 2021 fall semester?`, contains(":Please rate"), contains(":Â Please rate"), contains(":If it applies to you, please rate"), contains(":Â   Please estimate"), names(sss21)[126:137], names(sss21)[81:87], names(sss21)[138:152]) 


#check what are selected***
names(sss21) %in% c(names(sss21.slct), names(sss21.qual)) 
#names(sss21)[81:87]%in% c(names(sss21.slct), names(sss21.qual)) #for false output, investigate and add back to select for sss21.slct***
#names(sss21)[126:137]%in% c(names(sss21.slct), names(sss21.qual)) #same as above

#rename/clean raw column names
names(sss21.slct) [1]<-"pc_id"
names(sss21.slct)<- gsub(":[A-Za-z]*.*$", "", names(sss21.slct))
#unique names for each column***
names(sss21.slct)[51]<-"hours_work_oncampus"
names(sss21.slct)[53]<-"hours_work_offcampus"
names(sss21.slct)[55]<-"hours_study"
names(sss21.slct)[57]<-"hours_volunteer"
names(sss21.slct)[59]<-"hours_club"
names(sss21.slct)[61]<-"hours_anthletics"
names(sss21.slct) [76]<-"Other_use_computer"
names(sss21.slct) [78]<-"Other_access_textbook"

names(sss21.slct)


#revert to data frame to make variables and detect values for each variable
df_sss21<-as.data.frame(sss21.slct)
str(df_sss21)
names(df_sss21)
rm(sss21.slct)

#check if all raw data variables are reflected in newly created data frames***
ncol(df_sss21) + ncol(sss21.qual) 
ncol(sss21)-length(names(sss21)[1:52])

#----end of selecting main data file---

#======merge 2021 student background data========
#check primary key
df_sss21 %>% group_by(pc_id) %>% summarise(n_per_key=n()) %>% ungroup %>% count(n_per_key)

#-----------datamart file-----------------------
#read file
datamart21<- read_excel("Datamart21Fall.xlsx")
names(datamart21)
#select variables
df_datamart21 <- datamart21 %>% select (PC_ID, GENDER_CODE, ETHNICITY_REPORT_DESC, ADMIT_REGION, CITIZENSHIP, RESIDENT_YN, PARENTS_DEGREE, ADMIT_TYPE, TRANSFER_YN, COHORT, CLASS_LEVEL_RPT_LABEL, ACADEMIC_DEPT, CIP_CATEGORY, MAJOR_1, REG_PRIOR_CUM_GPA) %>% as.data.frame() #check
names(df_datamart21)<- tolower(names(df_datamart21))
#

# merge with data mart 
df_sss21_full<-left_join(df_sss21,df_datamart21,by = "pc_id")
#check
ncol(df_sss21_full)
ncol(df_sss21)

#--------------registar data-----------
#read data
reg21<- read_excel("Registar21Fall.xlsx")
names(reg21)
#select variables
df_reg21 <- reg21 %>% select (CumGPA, `FT/PT`, `People Code Id`) %>% as.data.frame() 
names(df_reg21)[3] <- "pc_id"
names(df_reg21)<- tolower(names(df_reg21))

# merge with registar data
df_sss21_full<-left_join(df_sss21_full,df_reg21, by = "pc_id")
#check
ncol(df_sss21_full)
ncol(df_sss21)

#remove unnecessary objects
rm(datamart21, df_datamart21, reg21, df_reg21)


#========merge historical data========
setwd("~/Documents/Rprojects/student_satisfaction_survey")
list.files()
source("sss_17-20_matched.R")  #run code from saved r script
names(sss17.slct2)[1]<-"pc_id"
names(sss18.slct2)[1]<-"pc_id"
names(sss19.slct2)[1]<-"pc_id"
names(sss20.slct2)[1]<-"pc_id"

df_sss21_full<-full_join(df_sss21_full,sss17.slct2, by = "pc_id")
names(df_sss21_full)
df_sss21_full<-full_join(df_sss21_full,sss18.slct2, by = "pc_id")
names(df_sss21_full)
df_sss21_full<-full_join(df_sss21_full,sss19.slct2, by = "pc_id")
names(df_sss21_full)
df_sss21_full<-full_join(df_sss21_full,sss20.slct2, by = "pc_id")
names(df_sss21_full)
rm(sss17.slct2,sss18.slct2,sss19.slct2,sss20.slct2,df_sss21,sss21)


#========mutate and recode variables to work with========

#----prep factor  var---
#change to factor 19:49
##set function
change_to_fac <- function(df, n) {
  varname <- paste("fac", names(df[n]) , sep="_")
  df[varname] <- lapply(df[n], factor)
  #str(df[varname])
  df[varname]
}
##run function and check all
df_sss21_full <- df_sss21_full %>% mutate (change_to_fac(df_sss21_full,19:49))
ncol(df_sss21_full)
str(df_sss21_full[159:189])


#----prep value var---
df_sss21_full<- df_sss21_full %>% 
  mutate(across(c(names(df_sss21_full[19:49])), .fns=~ recode (.,"Strongly Agree" = 4, "Agree" = 3,"Disagree"=2, "Strongly Disagree"=1), .names="value_{.col}"))
ncol(df_sss21_full)
str(df_sss21_full[189:220])

#change to value at specific variables
#df_sss21_full<- df_sss21_full %>% 
#  mutate_at(vars(c(names(df_sss21_full[19:49]))), ~ recode (.,"Strongly Agree" = 4, "Agree" = 3,"Disagree"=2, "Strongly Disagree"=1))
#works
#str(df_sss21_full[19:49])

#----grouping answers---
df_sss21_full%>% group_by(`What is your sexual orientation?Definition`) %>% count()
df_sss21_full<- df_sss21_full %>% 
  mutate(sum_gender=recode(
    `What is your sexual orientation?Definition`,
    "Bisexual"="LGBTQ+",
    "Lesbian"="LGBTQ+",
    "Gay"="LGBTQ+",
    "Prefer to self-describe, e.g., Questioning, Queer or Pansexual (Please specify):"="LGBTQ+"
  ))
#check if recoded variable looks right***
df_sss21_full%>% group_by(sum_gender) %>% count()

#----grouping answers---
df_sss21_full%>% group_by(major_1) %>% count()
df_sss21_full<- df_sss21_full %>% mutate( major=major_1) 

df_sss21_full$major_1<- 
  recode (df_sss21_full$major_1,
"Criminal Justice" = "School of Humanities, Education, Justice, and Social Sciences",
"Early Childhood Education" = "School of Humanities, Education, Justice, and Social Sciences",
"Elementary Education" = "School of Humanities, Education, Justice, and Social Sciences",
"English" = "School of Humanities, Education, Justice, and Social Sciences",
"Global Studies" = "School of Humanities, Education, Justice, and Social Sciences",
"History" = "School of Humanities, Education, Justice, and Social Sciences",
"IDS Curriculum & Instruction" = "School of Humanities, Education, Justice, and Social Sciences",
"IDS Education Curriculum & Instruction" ="School of Humanities, Education, Justice, and Social Sciences",
"IDS Curriculum and Instruction" = "School of Humanities, Education, Justice, and Social Sciences",
"Law and Public Affairs" = "School of Humanities, Education, Justice, and Social Sciences",
"Legal Studies"= "School of Humanities, Education, Justice, and Social Sciences",
"Psychology" = "School of Humanities, Education, Justice, and Social Sciences",
"Secondary Education and English" = "School of Humanities, Education, Justice, and Social Sciences",
"Secondary Education and History" = "School of Humanities, Education, Justice, and Social Sciences",
"Sociology"= "School of Humanities, Education, Justice, and Social Sciences",
"Accounting" = "School of Business",
"Business Administration"= "School of Business",
"Business Management"= "School of Business",
"Entrepreneurship"= "School of Business",
"Esports & Gaming Management"= "School of Business",
"Event Management"= "School of Business",
"Finance"= "School of Business",
"Hospitality Management"= "School of Business",
"International Business"= "School of Business",
"Management"= "School of Business",
"Marketing"= "School of Business",
"Resort and Casino Management"= "School of Business",
"Sport Management"= "School of Business",
"Supply Chain Management"="School of Business",
"Communication" = "School of Communication and the Arts",
"Communication Bachelors Completion" = "School of Communication and the Arts",
"Communication Radio Video Production"= "School of Communication and the Arts",
"Entertainment Media"= "School of Communication and the Arts",
"Environmental Studies"= "School of Communication and the Arts",
"Graphic Design"= "School of Communication and the Arts",
"Journalism and Media Writing"= "School of Communication and the Arts",
"Sport Communication"= "School of Communication and the Arts",
"Fashion and Retail Merchandising"="School of Fashion",
"Fashion Communication & Promotion"="School of Fashion",
"Fashion Design and Production"="School of Fashion",
"Fashion Media and Marketing"="School of Fashion",
"Fashion Merchandising and Management"="School of Fashion",
"Applied Forensic Science"="School of Health Sciences",
"Athletic Training"="School of Health Sciences",
"Biochemistry"="School of Health Sciences",
"Biology"="School of Health Sciences",
"Cybersecurity"="School of Health Sciences",
"Data Analytics"="School of Health Sciences",
"Exercise Science"="School of Health Sciences",
"Fitness Management"="School of Health Sciences",
"Forensic Science"="School of Health Sciences",
"Health Science"="School of Health Sciences",
"Information Technology"="School of Health Sciences",
"Undeclared Option"="Undeclared"
)

#check if recoded variable looks right***
df_sss21_full%>% group_by(major_1) %>% count()


#========save merged and recoded main files =====
write_xlsx(df_sss21_full,"sss21_full.xlsx")
write_xlsx(sss21.qual,"sss21_qual.xlsx")
#write_xlsx(df_sss_history,"sss17-20_matched.xlsx")

#save data in one excel
#require(openxlsx)
#list_of_datasets <- list("data_21quan" = df_sss21_full, "data_21qual" = sss21.qual, "data_17"=sss17.slct2, "data_18"=sss18.slct2, "data_19"=sss19.slct2, "data_20"=sss20.slct2)
#write.xlsx(list_of_datasets, file = "fulldata.xlsx")

#check
#list.files()
#read_excel("fulldata.xlsx", sheet = "data_21quan")
#read_excel("fulldata.xlsx", sheet = "data_21qual")
#read_excel("fulldata.xlsx", sheet = "data_17")
#read_excel("fulldata.xlsx", sheet = "data_18")
#read_excel("fulldata.xlsx", sheet = "data_19")
#read_excel("fulldata.xlsx", sheet = "data_20")

#ncol(df_sss21_full)
#names(df_sss21_full)


#==========================investigate data============
#
df_sss21_full %>% group_by(sum_gender)%>% count()
#
names(df_sss21_full)
#note: [19:49] are raw data, [159:189] are factored, [190:220] are value



#----value var calcualte----
#try single group count
df_sss21_full %>% group_by(df_sss21_full[190])%>% count()

#mean of value vars
#df_sss21_full %>% summarize_at(
#  .vars = c(names(df_sss21_full[190:220])), 
#  .funs = list (mean=mean),
#  na.rm=TRUE) #can't figure out how to display by descending order

#mean of value vars
df_sss21_full %>% 
  summarize(across(c(names(df_sss21_full[190:220])), 
                   .fns=~mean(.x, na.rm=TRUE)) )
#sd of value vars
df_sss21_full %>% 
  summarize(across(c(names(df_sss21_full[190:220])), 
                   .fns=~sd(.x, na.rm=TRUE)) )
#combine mean and sd not working
#df_sss21_full %>% 
#  summarize(
#    across(
#      .cols=c(names(df_sss21_full[190:220])), 
#      .fns=list(mean=mean, sd=sd)),
#    na.rm=TRUE)
#combine mean and sd not working
#df_sss21_full[190:220]%>%tbl_summary(statistic = list(all_continuous()~"{mean} {sd}"))

#--by group--
#mean of value vars by group
df_sss21_full %>% group_by(major_1)%>%
  summarize_at(
  .vars = c(names(df_sss21_full[190:220])), 
  .funs = list (mean=mean),
  na.rm=TRUE)%>% gt()


#----factor var count----
#df_sss21_full %>% group_by(df_sss21_full[159])%>% count()
#df_sss21_full %>% group_by(df_sss21_full[159])%>% summarize(n=n(),na.rm=T)
#count and frequency of one factor vars
df_sss21_full[159:189]%>% tbl_summary()


#scatterplot
# install.packages("ggplot2")
library(ggplot2)

# Scatter plot by group
ggplot(df_sss21_full, aes(x = `fac_I feel a sense of pride about Lasell.`,y=`class_level_rpt_label`, color = `class_level_rpt_label`)) +
  geom_point()

#------ANOVA test ---
names(df_sss21_full)
df_sss21_full%>% aov(df_sss21_full[157]~`class_level_rpt_label`)
aov(df_sss21_full[183]~df_sss21_full[184])
CrossTable(df_sss21_full[183]~df_sss21_full[184])

#---CHI SQUARE TEST---
library(crosstable)
library(gmodels)
df_sss21_full%>% CrossTable(df_sss21_full[157]~`class_level_rpt_label`)

