#############################load package#############################
library(readxl)
library(dplyr)
library(writexl)

#############################read data files##########################
#dashbaord
db<-read_excel("/Users/linlizhou/Documents/LASELL/data/alumni/2021Grad6m_historic.xlsx")
#survey
survey<-read_excel("/Users/linlizhou/Documents/LASELL/data/alumni/Grad 6-month survey Results 2021.xlsx")


###########################################################################
##################renaming 2021 data based on db names#####################
###########################################################################

######################survey data: to match db cols
######remove auto-generated survey cols (timestart, status, etc.)#######
#find out the index
names(survey)
survey<-survey%>%select(c(`First Name`,`Last Name`,`Invite Custom Field 1`,53:94))

###############view(data) check value for var correspondence#############
#rename prep
names(db)#saved to an excel for quick index reference
names(survey)#saved to an excel for quick index reference
#view(data) side by side (eyeballing value) for var correspondence

#rename
names(survey)[3]<-names(db)[1]
names(survey)[4]<-names(db)[86]#corrected from grad data to year - need to rerun
names(survey)[5]<-names(db)[6]
names(survey)[6]<-names(db)[7]
names(survey)[16]<-names(db)[45]
names(survey)[7]<-names(db)[4]
names(survey)[8]<-names(db)[5]
names(survey)[10]<-names(db)[20]
names(survey)[9]<-names(db)[22]
names(survey)[11]<-names(db)[26]
names(survey)[15]<-names(db)[30]
names(survey)[17]<-names(db)[35]
names(survey)[19]<-names(db)[36]
names(survey)[20]<-names(db)[38]
names(survey)[22]<-names(db)[42]
names(survey)[34:37]<-names(db)[73:76]
names(survey)[39:45]<-names(db)[77:83]

#check what are not used in survey data
names(survey)[names(survey)%in%names(db)=="FALSE"]
#19 names not used - no match in db data - that's the best I can do, those 19 cols will remain in appended data as new cols

#save renamed file
write_xlsx(survey,"/Users/linlizhou/Documents/LASELL/data/alumni/2021Gd6mSurvey_renamed.xlsx")


###################linkedin data: to match db cols
#read data
linkedin<-read_excel("/Users/linlizhou/Documents/LASELL/data/alumni/Grad 6-month Population for LinkedIn.xlsx")
#check names
names(linkedin)#far too many names, after 13th are not variables
#select existed cols
linkedin<-linkedin%>%select(c(1:13))
#copy names to be matched with db
names(linkedin)
#rename
names(linkedin)[1]=names(db)[1]
names(linkedin)[5]=names(db)[85]
names(linkedin)[6]=names(db)[86]
names(linkedin)[8]=names(db)[4]
names(linkedin)[9]=names(db)[22]
names(linkedin)[10]=names(db)[20]
names(linkedin)[11]=names(db)[35]
names(linkedin)[12]=names(db)[36]
names(linkedin)[13]=names(db)[38]

#save the matched var data
write_xlsx(linkedin,"/Users/linlizhou/Documents/LASELL/data/alumni/2021Gd6mLinkedin_rename.xlsx")







########################################################
#####matching degree/rpgraom w/t ipeds.complete ########
########################################################
#skip data manipulation and read saved file directly:
#survey<-read_excel("/Users/linlizhou/Documents/LASELL/data/alumni/2021Gd6mLinkedin_rename.xlsx")
#############matching survey degree info in ipeds.complete#
#which year of ipeds.complete do we need:
survey%>%dplyr::group_by(GradYear)%>%summarise(n = n())#it is 20-21 graduates
count(survey$GradYear)
# load ipeds.complete data
ipeds.complete<-read_excel("/Users/linlizhou/Documents/LASELL/data/completion/17f-current.xlsx")
# check if find all pcid in survey for degree
survey$PC_ID %in% ipeds.complete$PCID#all true
#check if zero not in
sum(survey$PC_ID %in% ipeds.complete$PCID=="FALSE")

#can vlookup now by merging ipeds.complete with survey, but only those have a match in survey
survey<-left_join(survey,ipeds.complete,by=c("PC_ID"="PCID"))
#the newly appended degree match names with db degree
names(survey)[46]<-names(db)[3]
#check
names(survey)
#now we have degree info in survey (successfully lookedup in ipeds.complete20/21f)


#############################create program info based on degree
#recode based on the degree-program pairs in db data
survey<-survey%>%mutate(Program=case_when(
  Degree=="CER"~"Certificate",
  Degree=="MEDEL"~"Degree Elementary Education MED",
  Degree=="MEDMD"~"Degree Moderate Disabilities",
  Degree=="MSC"~"Degree Communication",
  Degree=="MSM"~"Degree Management",
  Degree=="MBA"~"Degree Management",
  Degree=="MSHR"~"Degree Management",
  Degree=="MSSM"~"Degree Sport Management",
  Degree=="PMBA"~"Degree Business Administration",
  Degree=="MSCJ"~"Degree Criminal Justice"
))
#check
survey%>%group_by(Degree,Program)%>%count()#have 29 NAs
#need to find the correct codes for those NAs, but remain NAs doesn't matter since they're not covered in historical codes


#save the matched (survey-ipeds) var data
write_xlsx(survey,"/Users/linlizhou/Documents/LASELL/data/alumni/Gd6mSurvey_matchvars.xlsx")






########################################################
#############merge linkedin, survey, db ################
########################################################

survey.linkedin_fj<-full_join(linkedin,survey)#matched 10 common cols, 
#13+47-10=50

#survey.linkedin_br<-bind_rows(linkedin,survey)#worked
#survey.linkedin_rb<-rbind(linkedin,survey)#rbinds needs exact same col numbers and col names
#survey.linkedin_mg<-merge(linkedin,survey)#must have "by=intersect"
#survey.linkedin_mgby<-merge(linkedin,survey,by=intersect(names(linkedin),names(survey)),all = TRUE)#must have keep all
#IN CONCLUSION, FULL JOIN DO NOT NEED TO SPECIFY "BY" AND CAN AUTO-DETECT/MATCH/MERGE FOR SAME COL NAMES

db.svy.lkn<-full_join(db,survey.linkedin_fj)#merged 29 matched variables
#88+50-29=109; db to be the first so that it followed the structure of db

#full_join(db,survey)#107 vars: 47+88-28=107; so there are 28 matched col between survey and db

#save full join
write_xlsx(db.svy.lkn,"/Users/linlizhou/Documents/LASELL/data/alumni/grad6m_full.xlsx")
#created a dataset that match the original ("messy") historical data table



