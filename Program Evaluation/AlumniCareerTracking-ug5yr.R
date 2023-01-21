#explore
excel_sheets("/Users/linlizhou/Documents/LASELL/data/alumni/ug5y/Class of 2017 UG Population.xlsx")
pop<-read_excel("/Users/linlizhou/Documents/LASELL/data/alumni/ug5y/Class of 2017 UG Population.xlsx")
pop%>%group_by(`Degree: Alumni Degree Name`)%>%count()

