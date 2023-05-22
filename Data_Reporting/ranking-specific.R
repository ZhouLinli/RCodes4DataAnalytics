

######################################################################################
##############external reporting for the Princeton Review 2022-8-19 due##############
#Read local data files for course 2021-2022

course21_22<-read.csv("/Users/linlizhou/Documents/LASELL/working on/Student Info by Course and Fiscal Year.csv")
#course enrollment data for fall/spring/summer main, session1, and 2
#run from report manager: https://reports.lasell.edu/Reports/report/IR/Student%20Info%20by%20Course%20and%20Fiscal%20Year
#filter out unique rows
nrow(course21_22)
nrow(unique(course21_22))
course21_22_unqiue<-unique(course21_22)



#1.goal -question 10 and 11: confirm the following are offered as undergraduate course
dplyr::glimpse(course21_22_unqiue)
c("Entrepreneurial Leadership","Entrepreneurial Management","Introduction to Entrepreneurship","Introduction to New Business Ventures","New Product Development","New Venture Management","Venture Capital & Private Equity") %in% course21_22_unqiue$Course_Name
#cannot find exact match except "New Product Development"


#filter business and management school and see the courses offered there
library(dplyr)
#investigate department names
course21_22_unqiue %>% dplyr::group_by(Course_Department) %>% count()
#list business school courses
course21_22_unqiue%>%filter(Course_Department=="BUSS")%>%group_by(Course_Name)%>%count()
#find two courses that contains Entrepreneur: "Amer Entrepreneurs: Trends & Innovation" and "Special Topics in Entrepreneurship"
#then, need to confirm with Bruce for question 10 and 11


#let's investigate which courses does Bruce teach, since Bruce is the only faculty for the entreprenurship program
glimpse(course21_22_unqiue)
course21_22_unqiue %>% filter(Course_Department=="BUSS")%>%
  group_by(Instructors)%>%count() #find out McKinnon, Bruce

course21_22_unqiue%>% filter(Instructors=="McKinnon, Bruce" & Course_Department=="BUSS") %>%group_by(Course_Name) %>% count() #there are 7 courses
#asked Eric, "Amer Entrepreneurs: Trends & Innovation","Entrepreneurship & Venture Creation", "Managing the Growing Company" and "Special Topics in Entrepreneurship" are the four courese entrepreneurship-related.





#2.goal-question 15: What was the total enrollment (full-time and part-time) in your undergraduate entrepreneurship offerings for the 2021-2022 academic year?

#based on the 4 courses are related with entrepreneurship, I can count the enrollment based on the n in the following formula
t3<-course21_22_unqiue%>%filter(
  Course_Name %in% c("Amer Entrepreneurs: Trends & Innovation", "Entrepreneurship & Venture Creation", "Managing the Growing Company", "Special Topics in Entrepreneurship") 
) %>% group_by(Course_Name) %>% summarise(course_appearance=n())

sum(t3$course_appearance)#61 students



#goal-question 15a: within those students who enrolled in the entrepreneurship-related course, count their unique majors
glimpse(course21_22_unqiue)
course21_22_unqiue%>%filter(
  Course_Name %in% c("Amer Entrepreneurs: Trends & Innovation", "Entrepreneurship & Venture Creation", "Managing the Growing Company", "Special Topics in Entrepreneurship") 
) %>% group_by(Major) %>% summarise(major_appearance=n())#14 majors






####################################################################################
################## US NEWS ONLINE PROGRAM 07/01/2021-06/30-2022, due 2022-10-15########
#########################################COURSE QUESTIONS##############################

##############question: Amount of curriculum for undergrad completion/online program###########
library(rvest)
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/graduate-studies/academics/bsba.html#Curriculum-Section")
#look at it (a list object that contains the tree-like structure)
pg
#search using nodes (html tags or css class) and print text
#pg %>% html_nodes("body")%>%html_text()#indeed all contents of body
#search using css class as nodes
my.title<-pg %>% html_nodes(".code")%>%html_text() 
  my.title%>%length()#we must add a . before the class name
  
#save to df
my.df<-data.frame(BSBA=my.title)



##############web2
pg.2<-read_html("https://www.lasell.edu/graduate-studies/academics/psychology.html#Curriculum-Section")
#make a list of course titles
my.title2<-c()#initialize a empty list
for (i in 1:30 )  { #estimate 30 i
  my.title2[[i]]<-#have to use [[]] to indicate the list index
    pg.2%>%html_nodes(
      xpath=paste0("/html/body/div[1]/main/div/div[1]/div[2]/div[2]/table/tbody/tr[",i,"]/td[1]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}

library(stringr)
#remove empty and not in format of -- using any capital letters follow by any number
my.title2<-my.title2[str_detect(my.title2,"[A-Z][0-9]")]
my.title2%>%length()

#save to df
length(my.title2)=length(my.title)
my.df<-my.df%>%mutate(Psych=my.title2)

##############web3
pg.3<-read_html("https://www.lasell.edu/graduate-studies/academics/communication.html")
#make a list of course titles
my.title3<-c()#initialize a empty list
for (i in 1:30 )  { #estimate 30 i
  my.title3[[i]]<-#have to use [[]] to indicate the list index
    pg.3%>%html_nodes(
      xpath=paste0("/html/body/div[1]/main/div/div[1]/div[2]/div[2]/table/tbody/tr[",i,"]/td[1]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}

library(stringr)
#remove empty and not in format of -- using any capital letters follow by any number
my.title3<-my.title3[str_detect(my.title3,"[A-Z][0-9]")]
my.title3%>%length()


#save to df
length(my.title3)=length(my.title)
my.df<-my.df%>%mutate(Com=my.title3)








####################################################################################
################## US NEWS ONLINE PROGRAM 07/01/2021-06/30-2022, due 2022-10-15########
#####################################ENROLLMENT QUESTIONS##############################
###########prep data and function
ug.gd<-read_excel("/Volumes/lasellshare/Faculty_Staff_Shares$/IR/Surveys/IPEDS/2022-2023/Fall Collection/12-month enrollment/ug.gd_21-22_rerun.xlsx")

age.calc <- function(dob, age.day = "2021-07-01", units = "years", floor = TRUE) {
  calc.age = interval(dob, age.day) / duration(num = 1, units = units)
  if (floor) return(as.integer(floor(calc.age))) #floor=round down to the nearest interger
  return(calc.age)}#return has to be its own row

###########create USNEWS online program dataset

##search for business administration
#ug.gd%>%filter(grepl("[Bb][Uu]",ug.gd$Program))%>%group_by(Program)%>%count()#see "Business Administration"
##search for completion programs
#ug.gd%>%filter(grepl("[Cc]omp",ug.gd$Program))%>%group_by(Program)%>%count()#see completion programs

#filter using searched results and crete usn.enroll
usn.enroll<-ug.gd%>%
  filter(Program %in% c("MSCJ","MSM","MBA","Business Administration","Communication Bachelors Completion","Interdisciplinary Bachelors Completion","Psychology Bachelors Completion"))%>%
  mutate(Program=factor(Program,levels = c("Business Administration","Communication Bachelors Completion","Interdisciplinary Bachelors Completion","Psychology Bachelors Completion","MSCJ","MSM","MBA")))%>%
  select(`People Code Id`,`gov id`,Level,Program,`Birth Date`,Ethnicity,`Transfer YN`,`Cum Credits`,Gender,term,`New Ret Term YN`)%>%unique()#remove duplicated rows; 779 rows


###########de-duplication
#goal: usn.enroll%>%distinct(`People Code Id`,.keep_all = TRUE)%>%nrow()#unique 316 ppid (and keep all other variables)

###investigate duplicated ppid
dup.id<-usn.enroll[duplicated(usn.enroll$`People Code Id`),]
usn.enroll[usn.enroll$`People Code Id` %in% dup.id$`People Code Id`,]#show all duplicated ppid - conflict b/c cum credits

#keep one for duplicated ids
usn.enroll<-usn.enroll%>%#aim: assign one value for duplicated id (to resolve conflict)    
  arrange(desc(`Cum Credits`))%>%#largest cumcredit at the top
  arrange(`People Code Id`)%>%#same id group and has large-low cumcredit
  distinct(`People Code Id`,.keep_all = TRUE)#distinct will keep the !first row! (the correct cum credit), 316 rows


###########add cols needed
usn.enroll<-usn.enroll%>%mutate(
  age= age.calc(`Birth Date`),
  age.cat=case_when(age<=22 ~ "22 or younger",age>=23 & age<=29 ~ "23-29",age>=30 & age <=39 ~ "30-39", age>=40 & age <=49 ~ "40-49",age>=50 & age <=59 ~ "50-59",age>-60 ~"60 or older"),
  age.cat=factor(age.cat),
  
  #calculate progress based on cum credits
  CreditPrt=`Cum Credits`/120,#total is 120 credits for most programs NEEDS TO CONFIRM WITH ERIC
  CreditPrt=case_when(CreditPrt<.25~"<25%",CreditPrt>=.25 & CreditPrt<.50~"25-49%",CreditPrt>=.50 & CreditPrt<=.74~"50-74%",CreditPrt>.75~">75%"),
  CreditPrt=factor(CreditPrt,levels = c("<25%","25-49%","50-74%",">75%")))%>%select(-`Birth Date`)
#str(usn.enroll)
#usn.enroll%>%group_by(CreditPrt)%>%count()#78 NAs from NA cum credits

#save list of students and send to financial aid
#write.xlsx(list("PPID"=usn.enroll), file="/Volumes/lasellshare/Faculty_Staff_Shares$/IR/Fin Aid Sharing/2022 US News/StudentLoanInfo_USNewsReport.xlsx")


##########age/birth date of UG, question 70###########
#calculate age from birth date
usn.enroll%>%filter(Level=="UG")%>%group_by(age.cat)%>%count()

##########GD age question 49 or 52############
usn.enroll%>%filter(Level=="GD")%>%group_by(Program)%>%summarise(mean.age=mean(age,na.rm = TRUE))#auto remove NA

##########international students of UG, question 53,54###########
usn.enroll%>%filter(Level=="UG")%>%group_by(Ethnicity)%>%count()

##########non-transfer of UG, question 55###########
usn.enroll%>%filter(Level=="UG")%>%group_by(`Transfer YN`)%>%count()

##########cum credit progress out of 120 credits of UG, question 57###########
usn.enroll%>%filter(Level=="UG")%>%group_by(CreditPrt)%>%count()

##########GD gender question 47 or 50############
usn.enroll%>%filter(Level=="GD")%>%group_by(Program,Gender)%>%count()%>%arrange(Program)







####################################################################################
################## US NEWS ONLINE PROGRAM 07/01/2021-06/30-2022, due 2022-10-15########
#####################################VETERAN QUESTIONS##############################

usn.vet<-read_excel("/Volumes/lasellshare/Faculty_Staff_Shares$/IR/Surveys/US News/Online Bachelor's/2022/Veteran Student Benefits 2021-22.xlsx")

usn.vet<-usn.vet%>%mutate(prg.cur=paste0(program,Curriculum))
ls1<-usn.vet%>%count(prg.cur); View(ls1)
usn.vet%>%filter(prg.cur=="UNDERBusiness Administration")%>%group_by(program)%>%count()#Bachelor completion
usn.vet%>%filter(prg.cur=="GRADCriminal Justice")%>%group_by(program)%>%count()#MSCJ
usn.vet%>%filter(prg.cur%in% c("GRADEmergency & Crisis Management",#Hospitality & Event Management (MSM)
                               "GRADHuman Resources Management",#Human Resources (MSHR)
                               "GRADManagement",#Management (MSM)
                               "GRADMarketing",#Marketing (MSMK)
                               "GRADProject Management",#Project Management (MSPM)
                               "GRADSport Management"
                               ))%>%group_by(program)%>%count()#MSM
usn.vet%>%filter(prg.cur=="GRADBusiness Administration")%>%group_by(program)%>%count()#MBA

ls<-usn.vet%>%group_by(Curriculum)%>%count(); View(ls)
##search for business administration
#usn.vet%>%filter(grepl("[Bb][Uu]",usn.vet$Curriculum))%>%group_by(Curriculum)%>%count()#see "Business Administration"
##search for completion programs
#usn.vet%>%filter(grepl("[Cc]omp",usn.vet$Curriculum))%>%group_by(Curriculum)%>%count()#non

#filter using searched results and crete usn.enroll
usn.enroll<-ug.gd%>%
  filter(Program %in% c("MSCJ","MSM","MBA","Business Administration","Communication Bachelors Completion","Interdisciplinary Bachelors Completion","Psychology Bachelors Completion"))%>%
  mutate(Program=factor(Program,levels = c("Business Administration","Communication Bachelors Completion","Interdisciplinary Bachelors Completion","Psychology Bachelors Completion","MSCJ","MSM","MBA")))%>%
  select(`People Code Id`,`gov id`,Level,Program,`Birth Date`,Ethnicity,`Transfer YN`,`Cum Credits`,Gender,term,`New Ret Term YN`)%>%unique()#remove duplicated rows; 779 rows

