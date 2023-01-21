#setting up
setwd("~/Documents/Rprojects/data/student_satisfaction_survey")
getwd()
list.files()
options("digits" = 4)   # two decimal

#load package
library(readxl) #for read_excel
library(readr) #for read_csv
library(dplyr) #for select, rename, join, etc.
library(tidyverse) #for pipes
library(ggplot2)

#---------2017 data------------
#read data
sss17<-read_excel("2017SSSRaw.xlsx")
#check
names(sss17)
glimpse(sss17$`Invite Custom Field 1`)
#select variables
sss17.slct<-sss17 %>% select(`Invite Custom Field 1`, contains(":Please rate your level of ")) 
#rename variables
names(sss17.slct) [1]<-"pc_id"
names(sss17.slct)<- gsub(":[A-Za-z]*.*$", "", names(sss17.slct))
names(sss17.slct)
#select matched variables
sss17.slct2<- sss17.slct %>% select_if(  names(sss17.slct) %in% names(df_sss21_full) ) %>% as.data.frame()
names(sss17.slct2)


#add a suffix
colnames(sss17.slct2) <- paste(colnames(sss17.slct2), "2017", sep = "_")
#check
names(sss17.slct2)
#remove unnecessary data
rm(sss17,sss17.slct)

#--------2018 data -----------
#read data
sss18<-read_csv("2018SSSRaw.csv")
#check
names(sss18)
glimpse(sss18$`Invite Custom Field 1`)

#select variables
sss18.slct<-sss18 %>% select(`Invite Custom Field 1`, contains(":Please rate")) 
#rename variables
names(sss18.slct) [1]<-"pc_id"
names(sss18.slct)<- gsub(":[A-Za-z]*.*$", "", names(sss18.slct))
#check
names(sss18.slct)

#select matched variables
sss18.slct2<- sss18.slct %>% select_if(  names(sss18.slct) %in% names(df_sss21_full) ) %>% as.data.frame()
names(sss18.slct2)

#add a suffix
colnames(sss18.slct2) <- paste(colnames(sss18.slct2), "2018", sep = "_")
names(sss18.slct2)
#remove unnecessary data
rm(sss18, sss18.slct)


#--------2019 data -----------
list.files()
#read data
sss19<-read_csv("2019SSSRaw.csv")
#check
names(sss19)
glimpse(sss19$`Invite Custom Field 1`)

#select variables
sss19.slct<-sss19 %>% select(`Invite Custom Field 1`, contains(":Please rate")) 
#rename variables
names(sss19.slct) [1]<-"pc_id"
names(sss19.slct)<- gsub(":[A-Za-z]*.*$", "", names(sss19.slct))
#check
names(sss19.slct)

#select matched variables
sss19.slct2<- sss19.slct %>% select_if(  names(sss19.slct) %in% names(df_sss21_full) ) %>% as.data.frame()
names(sss19.slct2)

#add a suffix
colnames(sss19.slct2) <- paste(colnames(sss19.slct2), "2019", sep = "_")
names(sss19.slct2)
#remove unnecessary data
rm(sss19, sss19.slct)


#--------2020 data -----------
list.files()
#read data
sss20<-read_csv("2020SSSRaw.csv")
#check
names(sss20)
glimpse(sss20$`Invite Custom Field 1`)

#select variables
sss20.slct<-sss20 %>% select(`Invite Custom Field 1`, contains(":Please rate")) 
#rename variables
names(sss20.slct) [1]<-"pc_id"
names(sss20.slct)<- gsub(":[A-Za-z]*.*$", "", names(sss20.slct))
#check
names(sss20.slct)

#select matched variables
sss20.slct2<- sss20.slct %>% select_if(  names(sss20.slct) %in% names(df_sss21_full) ) %>% as.data.frame()
names(sss20.slct2)

#add a suffix
colnames(sss20.slct2) <- paste(colnames(sss20.slct2), "2020", sep = "_")
names(sss20.slct2)
#remove unnecessary data
rm(sss20, sss20.slct)

#===========merging==============
#prepare the primary key
#sss17.slct2<- rename(sss17.slct2, pc_id = pc_id_2017)
#sss18.slct2<- rename(sss18.slct2, pc_id = pc_id_2018)
#sss19.slct2<- rename(sss19.slct2, pc_id = pc_id_2019)
#sss20.slct2<- rename(sss20.slct2, pc_id = pc_id_2020)

#check
#names(sss17.slct2)[1]
#names(sss18.slct2)[1]
#names(sss19.slct2)[1]
#names(sss20.slct2)[1]

#merge 17&18
#sss_history<-full_join(sss17.slct2, sss18.slct2, by="pc_id")
#check
#ncol(sss_history)
#merge 19
#sss_history<-full_join(sss_history, sss19.slct2, by="pc_id")
#check
#ncol(sss_history)
#merge 20
#sss_history<-full_join(sss_history, sss20.slct2, by="pc_id")
#check
#ncol(sss_history)
#check all 
#names(sss_history)

#remove unnecessary data frames
#rm(sss20.slct2,sss19.slct2,sss18.slct2,sss17.slct2)

#sort variable names
#df_sss_history <- sss_history %>% 
# select(sort(tidyselect::peek_vars()))
#check
#names(df_sss_history)
#remove used data
#rm(sss_history)
#save data
#write_xlsx(df_sss_history,"sss17-20_matched.xlsx")












