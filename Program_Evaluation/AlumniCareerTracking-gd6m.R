#This file is a simplified version of "AlumniCareerTracking-grad6m.R". It merges only linkedin and survey data (i.e., disregarding historical data).

#############################load package#############################
library(readxl)
library(dplyr)
library(writexl)
#############################read data files##########################
#survey
survey<-read_excel("/Users/linlizhou/Documents/LASELL/data/alumni/Grad 6-month survey Results 2021.xlsx")

###########################################################################
######################survey data: to match db cols########################
######remove auto-generated survey cols (timestart, status, etc.)
#find out the index
names(survey)
#remove auto-generated survey cols (timestart, status, etc.)
survey<-survey%>%select(c(`First Name`,`Last Name`,`Invite Custom Field 1`,53:94))%>%rename(PCID="Invite Custom Field 1")

#############matching survey degree info in pop
#read data
pop<-read_excel("/Users/linlizhou/Documents/LASELL/data/alumni/Class of 2021 GR Population.xlsx")
#select useful cols
pop<-pop%>%select(`Power Campus ID`,`Degree: Alumni Degree Name`)%>%rename(PCID="Power Campus ID")
#merge to have degree name
survey<-left_join(survey,pop)
#name of survey
names(survey)

###########################################################################
###################linkedin data: to match survey cols########################
#read data
linkedin<-read_excel("/Users/linlizhou/Documents/LASELL/data/alumni/Grad 6-month Population for LinkedIn.xlsx")
#check names
names(linkedin)#far too many names, after 13th are not variables
#select existed cols
linkedin<-linkedin%>%select(c(1:13))
#copy names to be matched with db
names(linkedin)
#names(survey) vs names(linkedin) eyeballing matching
names(linkedin)[1]=names(survey)[3]
names(linkedin)[2]=names(survey)[1]
names(linkedin)[3]=names(survey)[2]
names(linkedin)[5]=names(survey)[4]
names(linkedin)[7]=names(survey)[46]
names(linkedin)[8]=names(survey)[7]
names(linkedin)[9]=names(survey)[9]
names(linkedin)[10]=names(survey)[10]
names(linkedin)[11]=names(survey)[17]
names(linkedin)[12]=names(survey)[19]
names(linkedin)[13]=names(survey)[20]

###########################################################################
###################merge linkedin, survey#################################
full_join(survey,linkedin)
