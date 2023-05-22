#source for graduation data
##report manager - IR - Graduation Term Snapshot Including Certs and Double Majors for "race and gender"
##report manager - IR - Final List of Graduates By Degree Term for "major"
##report manager - IR - Graduation Term Snapshot for "PCID,level,degree,major,gradd,race,gender"

#ipeds reporting
##16-17 graduates are in 2017 fall ipeds.complete report
##17-18 graduates are in 2018 fall ipeds.compelte
##19-20 graduates are in 2020 fall ipeds.compelte
##20-21 graduates are in 2021 fall ipeds.complete


###########################load R package###########################
library(readxl)
library(dplyr)
library(plyr)#for join_all
library(writexl)

#################################################################
#####################merge term for annual data##################
#################################################################

#####################ipeds.complete2022fall

#######basic cols: pcid,level,degree,major,gradd#####
#read term data (from report manager-IR-Final List of Graduates By Degree Term)
grad21.8<-read.csv("/Users/linlizhou/Documents/LASELL/data/completion/RptMgr.grdbydg/2021.8.gradreport.csv")
grad21.12<-read.csv("/Users/linlizhou/Documents/LASELL/data/completion/RptMgr.grdbydg/2021.12.gradreport.csv")
grad22.5<-read.csv("/Users/linlizhou/Documents/LASELL/data/completion/RptMgr.grdbydg/2022.5.gradreport.csv")

#check names
names(c(grad21.8,grad21.12,grad22.5))#needs rename

#merge first (since all have same names)
ipeds.complete22f<-join_all(list(grad21.8,grad21.12,grad22.5),type="full",match="first")#548 observations
#check
sum(sapply(list(grad21.12,grad21.8,grad22.5), nrow))#matched 548 observations

#then rename (rename the merged dataset can avoid rename each separately)
ipeds.complete22f<-ipeds.complete22f%>%
select(textbox41,textbox14,DEGREE,major,textbox4)%>%
  dplyr::rename(PCID=textbox41,level=textbox14,degree=DEGREE,gradd=textbox4)#have the basic cols, missing race and gender
#remove
rm(grad21.12,grad21.8,grad22.5)

######find race and gender cols#####
#read  data (from report manager-IR-Graduation Term Snapshot Including Certs and Double Majors)
grad21sum<-read.csv("/Users/linlizhou/Documents/LASELL/data/completion/RptMgr.grdbydg/21sum.csv")
grad21f<-read.csv("/Users/linlizhou/Documents/LASELL/data/completion/RptMgr.grdbydg/21f.csv")
grad22spr<-read.csv("/Users/linlizhou/Documents/LASELL/data/completion/RptMgr.grdbydg/22spr.csv")
#merge
grad21.22t<-join_all(list(grad21sum,grad22spr,grad21f),type="full",match="first")#548 observations
#rename
grad21.22t<-grad21.22t%>%
  select(people_code_id,Race,gender)%>%
  dplyr::rename(PCID=people_code_id,race=Race)
#merge to add race and gender
ipeds.complete22f<-left_join(ipeds.complete22f,grad21.22t)%>%unique()#unique observations, remove duplicated

#save
write_xlsx(ipeds.complete22f,"/Users/linlizhou/Documents/LASELL/data/completion/2022IPEDScompletions.xlsx")