---
title: "CourseReqreuimentImpact"
author: "Linli Zhou"
date: "2022-08-23"
output: 
  html_document:
    keep_md: true
---



# Set Up Data

```r
#which sheet
excel_sheets("/Users/linlizhou/Documents/LASELL/data/enrollment/All Course Requirements.xlsx")
```

```
## [1] "2018-19 Enrollment" "Long Sec Tally"     "Data"              
## [4] "Course Filter"      "Program Filter"     "Summary"
```

```r
#read data
data<-read_excel("/Users/linlizhou/Documents/LASELL/data/enrollment/All Course Requirements.xlsx",sheet = "Data")
```


```r
#remove mutated summary col 3-6; remove minors
dat.major<-data%>%select(-names(data)[3:6],-ends_with("Minor"))

#remove NA rows in section
dat.major<-dat.major[!is.na(dat.major$Section),]#removed last several NA rows, change from 941 to 935 row
```


# 43 Majors

## Accounting


```r
#read html and parse it into R readable contents
#pg<-htmlParse(getURL("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/accounting-21-22.html"))
#look at all names and counts of names
#summary(pg)
#read the table within html contents and save it as a tibble
#crs.tbl<-readHTMLTable(pg,stringsAsFactors = FALSE)%>%as_tibble() #a tibble of 30 observation of 1 var

#make a course list
#names(crs.tbl)="course" #rename tibble from NULL to "course" so that I can call it by its name without causing error
#df<-crs.tbl$course#finally got a dataframe of 3 vars

#needs to confirm if the last item is blank, if yes, select the 1:length-1 for crs
#crs<-df$`Course Code`[1:length(df$`Course Code`)-1]#character not a list; remove the last item -- which is a blank row
#crs.df<-data.frame(Section=crs)%>%filter(!grepl("School",Section),!grepl("Core Courses",Section))#remove first two lables that separate all requried courese
#now we got the list of all html courses (with a label separator between required vs elective courses)
```


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/accounting-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using nodes (html tags or css class) and print text
# #pg %>% html_nodes("body")%>%html_text()#indeed all contents of body
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104"  "BUSS105"  "BUSS205"  "BUSS220"  "BUSS227"  "BUSS440" 
##  [7] "BUSS497"  "DSCI202"  "ECON101"  "MATH209"  "BUSS101"  "BUSS203" 
## [13] "BUSS226"  "BUSS301"  "BUSS302"  "BUSS306"  "BUSS349"  "BUSS410" 
## [19] "BUSS413"  "CFP304X"  "ECON102"  "BUSS208"  "BUSS235"  "BUSS308" 
## [25] "BUSS499C" "MATH202"
```



```r
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 26 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+3) )  {#must (any calculation)
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes

  #add one to go to next index
  i<-i+1
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Financial Management"
## 
## [[15]]
## [1] "Financial Accounting"
## 
## [[16]]
## [1] "Intermediate Accounting I"
## 
## [[17]]
## [1] "Intermediate Accounting II"
## 
## [[18]]
## [1] "Accounting Information Systems"
## 
## [[19]]
## [1] "Cost Accounting"
## 
## [[20]]
## [1] "Auditing"
## 
## [[21]]
## [1] "Advanced Accounting"
## 
## [[22]]
## [1] "Tax Planning"
## 
## [[23]]
## [1] "Principles of Econ-Macro"
## 
## [[24]]
## character(0)
## 
## [[25]]
## [1] "Financial Statement Analysis"
## 
## [[26]]
## [1] "Ethics in Business"
## 
## [[27]]
## [1] "Government & Not-for-Profit Accounting"
## 
## [[28]]
## [1] "Business Internship & Seminar II"
## 
## [[29]]
## [1] "Applied Mathematics for Business"
```

```r
#remove empty -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```



```r
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#change from 935 to 947 with appended rows
```

```
## Joining by: Section, Course Title
```



```r
#investigate
dat.major%>%group_by(Accounting)%>%count()
```

```
## # A tibble: 4 × 2
## # Groups:   Accounting [4]
##   Accounting     n
##   <chr>      <int>
## 1 C              7
## 2 E              6
## 3 X             22
## 4 <NA>         912
```

```r
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(Accounting=case_when(
    Accounting=="C"~"Core",
    Section %in% crs.df$Section[1:21] ~"Required",
    Section %in% crs.df$Section[23:27] ~"Elective"))#%>%group_by(Accounting)%>%count()#check directly after mutate, before assign it to df
```

## Entrepreneurship


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/Entrepreneurship-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using nodes (html tags or css class) and print text
 #pg %>% html_nodes("body")%>%html_text()#indeed all contents of body
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "BUSS101" "BUSS203" "BUSS224" "BUSS231"
## [15] "BUSS329" "BUSS337" "BUSS425" "ECON102" "BUSS208" "BUSS211" "BUSS232"
## [22] "BUSS235" "BUSS313" "BUSS320" "BUSS325" "BUSS330" "BUSS341" "BUSS407"
## [29] "MATH202"
```



```r
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```




```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Financial Management"
## 
## [[15]]
## [1] "Org Behavior in the Global Workplace"
## 
## [[16]]
## [1] "Entrepreneurship & Venture Creation"
## 
## [[17]]
## [1] "New Product Development"
## 
## [[18]]
## [1] "Managing the Growing Company"
## 
## [[19]]
## [1] "Special Topics in Entrepreneurship"
## 
## [[20]]
## [1] "Principles of Econ-Macro"
## 
## [[21]]
## character(0)
## 
## [[22]]
## [1] "Financial Statement Analysis"
## 
## [[23]]
## [1] "Fundamentals of Financial Modeling"
## 
## [[24]]
## character(0)
## 
## [[25]]
## [1] "Global Operation Strategies"
## 
## [[26]]
## [1] "Ethics in Business"
## 
## [[27]]
## [1] "Business Negotiations"
## 
## [[28]]
## [1] "Consumer Behavior"
## 
## [[29]]
## [1] "Sales Principles"
## 
## [[30]]
## [1] "Managing Change in a Global Marketplace"
## 
## [[31]]
## [1] "Social Media Marketing"
## 
## [[32]]
## [1] "Digital Branding"
## 
## [[33]]
## [1] "Applied Mathematics for Business"
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#change from 947 to 948 with appended rows BUSS407
```

```
## Joining by: Section, Course Title
```


```r
#investigate
dat.major%>%group_by(Entrepreneurship)%>%count()
```

```
## # A tibble: 4 × 2
## # Groups:   Entrepreneurship [4]
##   Entrepreneurship     n
##   <chr>            <int>
## 1 C                    7
## 2 E                   12
## 3 X                   19
## 4 <NA>               910
```

```r
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(Entrepreneurship=case_when(
    Entrepreneurship=="C"~"Core",
    Section %in% crs.df$Section[1:18] ~"Required",
    Section %in% crs.df$Section[19:29] ~"Elective"))#%>%group_by(Entrepreneurship)%>%count()#check directly after mutate, before assign it to df
```

## Event Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/event-management21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "HEM101"  "HEM102"  "HEM208"  "HEM215" 
## [15] "HEM299"  "HEM301"  "HEM303"  "HEM321"  "HEM401"  "HEM403"  "BUSS231"
## [22] "BUSS332" "BUSS334" "COM208"  "ENV205"  "HEM103"  "HEM205"  "HEM206" 
## [29] "HEM207"  "HEM399"  "MATH202" "PSYC104" "SMGT301" "SPAN111" "SPAN112"
```



```r
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Hospitality Management"
## 
## [[14]]
## [1] "Fundamentals of Event Management"
## 
## [[15]]
## [1] "Human Resources in Hospitality "
## 
## [[16]]
## [1] "Meeting & Convention Sales & Planning"
## 
## [[17]]
## [1] "Field Experience I"
## 
## [[18]]
## [1] "Social Event Management"
## 
## [[19]]
## [1] "Law & Ethics in Hospitality"
## 
## [[20]]
## [1] "Revenue Management & Technology"
## 
## [[21]]
## [1] "Managing Quality in Hospitality"
## 
## [[22]]
## [1] "Food & Beverage Management"
## 
## [[23]]
## character(0)
## 
## [[24]]
## [1] "Entrepreneurship & Venture Creation"
## 
## [[25]]
## [1] "Cross Cultural Management"
## 
## [[26]]
## [1] "Nonprofit Management"
## 
## [[27]]
## [1] "Public Relations"
## 
## [[28]]
## [1] "Green Business"
## 
## [[29]]
## [1] "Economic Development & Mgmt in Tourism"
## 
## [[30]]
## [1] "Private Club Management"
## 
## [[31]]
## [1] "Lodging Management"
## 
## [[32]]
## [1] "Resort & Casino Management"
## 
## [[33]]
## [1] "Field Experience II"
## 
## [[34]]
## [1] "Applied Mathematics for Business"
## 
## [[35]]
## [1] "Positive Psychology"
## 
## [[36]]
## [1] "Sport Facility & Event Management"
## 
## [[37]]
## [1] "Elementary Spanish I"
## 
## [[38]]
## [1] "Elementary Spanish II"
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
## 
## [[41]]
## character(0)
## 
## [[42]]
## character(0)
## 
## [[43]]
## character(0)
## 
## [[44]]
## character(0)
## 
## [[45]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#no change 948
```

```
## Joining by: Section, Course Title
```


```r
#investigate
dat.major%>%group_by(`Event Management`)%>%count()
```

```
## # A tibble: 4 × 2
## # Groups:   Event Management [4]
##   `Event Management`     n
##   <chr>              <int>
## 1 C                      7
## 2 E                     25
## 3 X                     20
## 4 <NA>                 896
```

```r
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Event Management`=case_when(
    `Event Management`=="C"~"Core",
    Section %in% crs.df$Section[1:20] ~"Required",
    Section %in% crs.df$Section[21:35] ~"Elective"))#%>%group_by(`Event Management`)%>%count()#check directly after mutate, before assign it to df
```


## Business Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/business-management-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "BUSS101" "BUSS203" "BUSS224" "BUSS232"
## [15] "BUSS330" "BUSS332" "BUSS336" "ECON102" "BUSS208" "BUSS231" "BUSS235"
## [22] "BUSS237" "BUSS313" "BUSS315" "BUSS325" "BUSS329" "BUSS334" "BUSS337"
## [29] "BUSS341" "BUSS407" "BUSS497" "CFP302X" "ENV205"  "HEM401"  "MATH202"
```



```r
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Financial Management"
## 
## [[15]]
## [1] "Org Behavior in the Global Workplace"
## 
## [[16]]
## [1] "Global Operation Strategies"
## 
## [[17]]
## [1] "Managing Change in a Global Marketplace"
## 
## [[18]]
## [1] "Cross Cultural Management"
## 
## [[19]]
## [1] "Human Resource Management"
## 
## [[20]]
## [1] "Principles of Econ-Macro"
## 
## [[21]]
## character(0)
## 
## [[22]]
## [1] "Financial Statement Analysis"
## 
## [[23]]
## [1] "Entrepreneurship & Venture Creation"
## 
## [[24]]
## [1] "Ethics in Business"
## 
## [[25]]
## [1] "Global Leadership"
## 
## [[26]]
## [1] "Business Negotiations"
## 
## [[27]]
## [1] "Emerging Global Markets"
## 
## [[28]]
## [1] "Sales Principles"
## 
## [[29]]
## [1] "New Product Development"
## 
## [[30]]
## [1] "Nonprofit Management"
## 
## [[31]]
## [1] "Managing the Growing Company"
## 
## [[32]]
## [1] "Social Media Marketing"
## 
## [[33]]
## [1] "Digital Branding"
## 
## [[34]]
## [1] "Business Internship & Seminar"
## 
## [[35]]
## [1] "Risk Management & Insurance Planning"
## 
## [[36]]
## [1] "Green Business"
## 
## [[37]]
## [1] "Managing Quality in Hospitality"
## 
## [[38]]
## [1] "Applied Mathematics for Business"
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
## 
## [[41]]
## character(0)
## 
## [[42]]
## character(0)
## 
## [[43]]
## character(0)
## 
## [[44]]
## character(0)
## 
## [[45]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#no change 948
```

```
## Joining by: Section, Course Title
```


```r
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Business Management`=case_when(
   # `Business Management`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:18] ~"Required",
    Section %in% crs.df$Section[19:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Business Management`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Business Management`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Business Management [3]
##   `Business Management`     n
##   <chr>                 <int>
## 1 Elective                 16
## 2 Required                 18
## 3 <NA>                    914
```








## Esports and Gaming Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/esports-and-gaming-management-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104"  "BUSS105"  "BUSS205"  "BUSS220"  "BUSS227"  "BUSS440" 
##  [7] "BUSS497"  "DSCI202"  "ECON101"  "MATH209"  "BUSS101"  "BUSS215" 
## [13] "BUSS240"  "BUSS318"  "BUSS319"  "BUSS328"  "BUSS351"  "COM246"  
## [19] "COM307"   "BUSS224"  "BUSS313"  "COM230"   "COM231"   "SMGT306" 
## [25] "SMGT403X"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Introduction to Esports Management"
## 
## [[15]]
## [1] "PMM I Intro to Project Management"
## 
## [[16]]
## [1] "Convention, Event & Trade Show Planning"
## 
## [[17]]
## [1] "Cost Accounting"
## 
## [[18]]
## [1] "Entertainment Marketing "
## 
## [[19]]
## [1] "Distribution of Games"
## 
## [[20]]
## [1] "Introduction to Game Design"
## 
## [[21]]
## [1] "Understanding Video Games"
## 
## [[22]]
## character(0)
## 
## [[23]]
## [1] "Org Behavior in the Global Workplace"
## 
## [[24]]
## [1] "Business Negotiations"
## 
## [[25]]
## [1] "Media, Sports & Society "
## 
## [[26]]
## [1] "Sports Communication"
## 
## [[27]]
## [1] "Sport Leadership"
## 
## [[28]]
## [1] "Managing Diversity in Sport Org"
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Esports and Gaming Management`=case_when(
   # `Esports and Gaming Management`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:19] ~"Required",
    Section %in% crs.df$Section[20:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Esports and Gaming Management`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Esports and Gaming Management`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Esports and Gaming Management [3]
##   `Esports and Gaming Management`     n
##   <chr>                           <int>
## 1 Elective                            6
## 2 Required                           19
## 3 <NA>                              928
```










## Corporate Finance


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/finance-21-22/corporate-finance21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "BUSS101" "BUSS203" "BUSS208" "BUSS211"
## [15] "BUSS226" "BUSS310" "CFP302X" "CFP303X" "ECON102" "MATH202" "BUSS307"
## [22] "BUSS331"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Financial Management"
## 
## [[15]]
## [1] "Financial Statement Analysis"
## 
## [[16]]
## [1] "Fundamentals of Financial Modeling"
## 
## [[17]]
## [1] "Financial Accounting"
## 
## [[18]]
## [1] "Advanced Financial Management"
## 
## [[19]]
## [1] "Risk Management & Insurance Planning"
## 
## [[20]]
## [1] "Investment Planning"
## 
## [[21]]
## [1] "Principles of Econ-Macro"
## 
## [[22]]
## [1] "Applied Mathematics for Business"
## 
## [[23]]
## character(0)
## 
## [[24]]
## [1] "International Finance"
## 
## [[25]]
## [1] "Money and Capital Markets"
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Corporate Finance`=case_when(
   # `Corporate Finance`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Corporate Finance`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Corporate Finance`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Corporate Finance [2]
##   `Corporate Finance`     n
##   <chr>               <int>
## 1 Required               22
## 2 <NA>                  932
```











## Personal Finance


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/finance-21-22/personal-finance-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "BUSS101" "BUSS203" "BUSS208" "BUSS211"
## [15] "BUSS226" "BUSS310" "CFP302X" "CFP303X" "ECON102" "MATH202" "CFP301X"
## [22] "CFP304X" "CFP305X" "CFP306X"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Financial Management"
## 
## [[15]]
## [1] "Financial Statement Analysis"
## 
## [[16]]
## [1] "Fundamentals of Financial Modeling"
## 
## [[17]]
## [1] "Financial Accounting"
## 
## [[18]]
## [1] "Advanced Financial Management"
## 
## [[19]]
## [1] "Risk Management & Insurance Planning"
## 
## [[20]]
## [1] "Investment Planning"
## 
## [[21]]
## [1] "Principles of Econ-Macro"
## 
## [[22]]
## [1] "Applied Mathematics for Business"
## 
## [[23]]
## character(0)
## 
## [[24]]
## [1] "Principles of Financial Planning"
## 
## [[25]]
## [1] "Tax Planning"
## 
## [[26]]
## [1] "Retirement Savings and Income Planning "
## 
## [[27]]
## [1] "Estate Planning"
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Personal Finance`=case_when(
   # `Personal Finance`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Personal Finance`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Personal Finance`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Personal Finance [2]
##   `Personal Finance`     n
##   <chr>              <int>
## 1 Required              24
## 2 <NA>                 932
```









## Hospitality Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/hospitality-management-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "HEM101"  "HEM103"  "HEM206"  "HEM208" 
## [15] "HEM299"  "HEM321"  "HEM399"  "HEM401"  "HEM403"  "HEM405"  "BUSS224"
## [22] "BUSS332" "ENV205"  "HEM102"  "HEM205"  "HEM207"  "HEM215"  "MATH202"
## [29] "SPAN111" "SPAN112"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Hospitality Management"
## 
## [[14]]
## [1] "Economic Development & Mgmt in Tourism"
## 
## [[15]]
## [1] "Lodging Management"
## 
## [[16]]
## [1] "Human Resources in Hospitality "
## 
## [[17]]
## [1] "Field Experience I"
## 
## [[18]]
## [1] "Revenue Management & Technology"
## 
## [[19]]
## [1] "Field Experience II"
## 
## [[20]]
## [1] "Managing Quality in Hospitality"
## 
## [[21]]
## [1] "Food & Beverage Management"
## 
## [[22]]
## [1] "Hotel Franchising & Brand Management"
## 
## [[23]]
## character(0)
## 
## [[24]]
## [1] "Org Behavior in the Global Workplace"
## 
## [[25]]
## [1] "Cross Cultural Management"
## 
## [[26]]
## [1] "Green Business"
## 
## [[27]]
## [1] "Fundamentals of Event Management"
## 
## [[28]]
## [1] "Private Club Management"
## 
## [[29]]
## [1] "Resort & Casino Management"
## 
## [[30]]
## [1] "Meeting & Convention Sales & Planning"
## 
## [[31]]
## [1] "Applied Mathematics for Business"
## 
## [[32]]
## [1] "Elementary Spanish I"
## 
## [[33]]
## [1] "Elementary Spanish II"
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Hospitality Management`=case_when(
   # `Hospitality Management`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:20] ~"Required",
    Section %in% crs.df$Section[21:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Hospitality Management`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Hospitality Management`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Hospitality Management [3]
##   `Hospitality Management`     n
##   <chr>                    <int>
## 1 Elective                    10
## 2 Required                    20
## 3 <NA>                       926
```








## Human Resource Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/human-resource-management-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "BUSS101" "BUSS224" "BUSS332" "BUSS336"
## [15] "BUSS342" "BUSS343" "BUSS344" "BUSS345"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Org Behavior in the Global Workplace"
## 
## [[15]]
## [1] "Cross Cultural Management"
## 
## [[16]]
## [1] "Human Resource Management"
## 
## [[17]]
## [1] "Total Compensation Management"
## 
## [[18]]
## [1] "Human Resource Risk Management"
## 
## [[19]]
## [1] "Training and Development"
## 
## [[20]]
## [1] "Employment & Labor Law"
## 
## [[21]]
## character(0)
## 
## [[22]]
## character(0)
## 
## [[23]]
## character(0)
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Human Resource Management`=case_when(
   # `Human Resource Management`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Human Resource Management`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Human Resource Management`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Human Resource Management [2]
##   `Human Resource Management`     n
##   <chr>                       <int>
## 1 Required                       18
## 2 <NA>                          942
```






## Marketing


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/marketing-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "BUSS101" "BUSS224" "BUSS322" "BUSS329"
## [15] "BUSS420" "BUSS422" "BUSS432" "ECON102" "BUSS203" "BUSS232" "BUSS235"
## [22] "BUSS237" "BUSS313" "BUSS320" "BUSS325" "BUSS334" "BUSS341" "BUSS407"
## [29] "ENV205"  "FASH211" "HEM401"  "MATH202"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Org Behavior in the Global Workplace"
## 
## [[15]]
## [1] "Marketing Communications"
## 
## [[16]]
## [1] "New Product Development"
## 
## [[17]]
## [1] "Marketing Research"
## 
## [[18]]
## [1] "Global Marketing"
## 
## [[19]]
## [1] "Marketing Strategy"
## 
## [[20]]
## [1] "Principles of Econ-Macro"
## 
## [[21]]
## character(0)
## 
## [[22]]
## [1] "Financial Management"
## 
## [[23]]
## [1] "Global Operation Strategies"
## 
## [[24]]
## [1] "Ethics in Business"
## 
## [[25]]
## [1] "Global Leadership"
## 
## [[26]]
## [1] "Business Negotiations"
## 
## [[27]]
## [1] "Consumer Behavior"
## 
## [[28]]
## [1] "Sales Principles"
## 
## [[29]]
## [1] "Nonprofit Management"
## 
## [[30]]
## [1] "Social Media Marketing"
## 
## [[31]]
## [1] "Digital Branding"
## 
## [[32]]
## [1] "Green Business"
## 
## [[33]]
## [1] "Omnichannel Management and Operations"
## 
## [[34]]
## [1] "Managing Quality in Hospitality"
## 
## [[35]]
## [1] "Applied Mathematics for Business"
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
## 
## [[41]]
## character(0)
## 
## [[42]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Marketing`=case_when(
   # `Marketing`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:18] ~"Required",
    Section %in% crs.df$Section[19:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Marketing`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Marketing`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Marketing [3]
##   Marketing     n
##   <chr>     <int>
## 1 Elective     14
## 2 Required     18
## 3 <NA>        928
```








## Professional Sales


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/professional-sales-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "BUSS101" "BUSS313" "BUSS320" "BUSS322"
## [15] "BUSS325" "BUSS203" "BUSS235" "BUSS237" "BUSS407" "COM208"  "ECON102"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Business Negotiations"
## 
## [[15]]
## [1] "Consumer Behavior"
## 
## [[16]]
## [1] "Marketing Communications"
## 
## [[17]]
## [1] "Sales Principles"
## 
## [[18]]
## character(0)
## 
## [[19]]
## [1] "Financial Management"
## 
## [[20]]
## [1] "Ethics in Business"
## 
## [[21]]
## [1] "Global Leadership"
## 
## [[22]]
## [1] "Digital Branding"
## 
## [[23]]
## [1] "Public Relations"
## 
## [[24]]
## [1] "Principles of Econ-Macro"
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Professional Sales`=case_when(
   # `Professional Sales`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:15] ~"Required",
    Section %in% crs.df$Section[16:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Professional Sales`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Professional Sales`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Professional Sales [3]
##   `Professional Sales`     n
##   <chr>                <int>
## 1 Elective                 6
## 2 Required                15
## 3 <NA>                   939
```






## Resort and Casino Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/resort-and-casino-management-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104" "BUSS105" "BUSS205" "BUSS220" "BUSS227" "BUSS440" "BUSS497"
##  [8] "DSCI202" "ECON101" "MATH209" "HEM101"  "HEM206"  "HEM207"  "HEM208" 
## [15] "HEM209"  "HEM299"  "HEM302"  "HEM305"  "HEM307"  "HEM321"  "HEM401" 
## [22] "HEM402"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Hospitality Management"
## 
## [[14]]
## [1] "Lodging Management"
## 
## [[15]]
## [1] "Resort & Casino Management"
## 
## [[16]]
## [1] "Human Resources in Hospitality "
## 
## [[17]]
## [1] "Exploration of the Global Casino Market"
## 
## [[18]]
## [1] "Field Experience I"
## 
## [[19]]
## [1] "Casino Regulation & Security"
## 
## [[20]]
## [1] "Resort Management & Development"
## 
## [[21]]
## [1] "Tech for Resort & Casino Management"
## 
## [[22]]
## [1] "Revenue Management & Technology"
## 
## [[23]]
## [1] "Managing Quality in Hospitality"
## 
## [[24]]
## [1] "Casino & Gaming Operations"
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Resort and Casino Management`=case_when(
   # `Resort and Casino Management`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Resort and Casino Management`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Resort and Casino Management`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Resort and Casino Management [2]
##   `Resort and Casino Management`     n
##   <chr>                          <int>
## 1 Required                          22
## 2 <NA>                             938
```









## Sport Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/sport-management-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104"  "BUSS105"  "BUSS205"  "BUSS220"  "BUSS227"  "BUSS440" 
##  [7] "DSCI202"  "ECON101"  "MATH209"  "SMGT407"  "SMGT102"  "SMGT206" 
## [13] "SMGT211"  "SMGT215"  "SMGT301"  "SMGT302"  "SMGT303"  "SMGT304" 
## [19] "SMGT306"  "SMGT396"  "SMGT412"  "COM321"   "HEM102"   "PSYC240" 
## [25] "SMGT203X" "SMGT207"  "SMGT208"  "SMGT307"  "SMGT313X" "SMGT401" 
## [31] "SMGT403X" "SMGT408"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Analytics"
## 
## [[9]]
## [1] "Principles of Econ-Micro"
## 
## [[10]]
## [1] "Business Statistics"
## 
## [[11]]
## [1] "Sport Management Internship I"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Contemporary Sport Management"
## 
## [[14]]
## [1] "Sports Administration"
## 
## [[15]]
## [1] "Sport & Society "
## 
## [[16]]
## [1] "Pre-Practicum"
## 
## [[17]]
## [1] "Sport Facility & Event Management"
## 
## [[18]]
## [1] "Sport Marketing"
## 
## [[19]]
## [1] "Sport Finance"
## 
## [[20]]
## [1] "Sports Information & Communication"
## 
## [[21]]
## [1] "Sport Leadership"
## 
## [[22]]
## [1] "Research in Sport Industry"
## 
## [[23]]
## [1] "Sport Analytics"
## 
## [[24]]
## character(0)
## 
## [[25]]
## [1] "Media & Children"
## 
## [[26]]
## [1] "Fundamentals of Event Management"
## 
## [[27]]
## [1] "Sport Psychology"
## 
## [[28]]
## [1] "Intro to Parks Recreation & Tourism"
## 
## [[29]]
## [1] "Special Topics in History of Sport"
## 
## [[30]]
## [1] "Sport Governance"
## 
## [[31]]
## [1] "Sport Sponsorship"
## 
## [[32]]
## [1] "Parks & Recreation Management"
## 
## [[33]]
## [1] "Special Topics in Sport Management"
## 
## [[34]]
## [1] "Managing Diversity in Sport Org"
## 
## [[35]]
## [1] "Sport Management Internship II"
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
## 
## [[41]]
## character(0)
## 
## [[42]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Sport Management`=case_when(
   # `Sport Management`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:21] ~"Required",
    Section %in% crs.df$Section[22:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Sport Management`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Sport Management`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Sport Management [3]
##   `Sport Management`     n
##   <chr>              <int>
## 1 Elective              11
## 2 Required              21
## 3 <NA>                 930
```






















## Supply Chain Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/supply-chain-management-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BUSS104"  "BUSS105"  "BUSS205"  "BUSS220"  "BUSS227"  "BUSS440" 
##  [7] "BUSS497"  "DSCI202"  "ECON101"  "MATH209"  "BUSS101"  "BUSS225X"
## [13] "BUSS229"  "BUSS232"  "BUSS319"  "BUSS340"  "CFP302X"  "ECON102" 
## [19] "BUSS203"  "BUSS313"  "BUSS325"  "BUSS330"  "BUSS337"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Professional Development in Business"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Business Law"
## 
## [[5]]
## [1] "Principles of Marketing"
## 
## [[6]]
## [1] "Managerial Accounting"
## 
## [[7]]
## [1] "Business Capstone"
## 
## [[8]]
## [1] "Business Internship & Seminar"
## 
## [[9]]
## [1] "Business Analytics"
## 
## [[10]]
## [1] "Principles of Econ-Micro"
## 
## [[11]]
## [1] "Business Statistics"
## 
## [[12]]
## character(0)
## 
## [[13]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[14]]
## [1] "Supply Chain Mgmt 1:Log & Forecasting"
## 
## [[15]]
## [1] "Supply Chain Mgmt II:Sourcing/Operations"
## 
## [[16]]
## [1] "Global Operation Strategies"
## 
## [[17]]
## [1] "Cost Accounting"
## 
## [[18]]
## [1] "Supply Chain Management III - Practicum"
## 
## [[19]]
## [1] "Risk Management & Insurance Planning"
## 
## [[20]]
## [1] "Principles of Econ-Macro"
## 
## [[21]]
## character(0)
## 
## [[22]]
## [1] "Financial Management"
## 
## [[23]]
## [1] "Business Negotiations"
## 
## [[24]]
## [1] "Sales Principles"
## 
## [[25]]
## [1] "Managing Change in a Global Marketplace"
## 
## [[26]]
## [1] "Managing the Growing Company"
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Supply Chain Management`=case_when(
   # `Supply Chain Management`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:18] ~"Required",
    Section %in% crs.df$Section[19:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Supply Chain Management`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Supply Chain Management`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Supply Chain Management [3]
##   `Supply Chain Management`     n
##   <chr>                     <int>
## 1 Elective                      5
## 2 Required                     18
## 3 <NA>                        942
```











## Communication


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/communication--21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "COM101" "COM102" "COM103" "COM105" "COM203" "COM212" "COM219" "COM315"
##  [9] "COM327" "COM331" "COM399" "COM400" "COM495" "COM206" "COM221" "COM208"
## [17] "COM209" "COM208" "COM209" "COM215" "COM217" "COM218" "COM304"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Understanding Mass Media"
## 
## [[3]]
## [1] "Visual Media Toolkit"
## 
## [[4]]
## [1] "Human Communication (KP)"
## 
## [[5]]
## [1] "Writing for The Media"
## 
## [[6]]
## [1] "Effective Speaking"
## 
## [[7]]
## [1] "Intercultural Communication"
## 
## [[8]]
## [1] "Social Media Management"
## 
## [[9]]
## [1] "Communication Research"
## 
## [[10]]
## [1] "Digital Storytelling"
## 
## [[11]]
## [1] "Media Literacy & Ethics"
## 
## [[12]]
## [1] "Pre-Internship Seminar"
## 
## [[13]]
## [1] "Field Experience I"
## 
## [[14]]
## [1] "Capstone Project & Portfolio "
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Professional Communication"
## 
## [[17]]
## [1] "Advertising"
## 
## [[18]]
## character(0)
## 
## [[19]]
## [1] "Public Relations"
## 
## [[20]]
## [1] "Journalism"
## 
## [[21]]
## character(0)
## 
## [[22]]
## [1] "Public Relations"
## 
## [[23]]
## [1] "Journalism"
## 
## [[24]]
## character(0)
## 
## [[25]]
## [1] "Radio Production"
## 
## [[26]]
## [1] "Video Production"
## 
## [[27]]
## [1] "Digital Video Editing"
## 
## [[28]]
## [1] "TV Studio Production"
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Communication`=case_when(
   # `Communication`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:15] ~"Required",
    Section %in% crs.df$Section[16:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Communication`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Communication`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Communication [3]
##   Communication     n
##   <chr>         <int>
## 1 Elective          6
## 2 Required         15
## 3 <NA>            948
```














## Entertainment Media


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/entertainment-media-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "COM101" "COM102" "COM103" "COM105" "COM203" "COM212" "COM219" "COM315"
##  [9] "COM327" "COM331" "COM399" "COM400" "COM495" "COM206" "COM208" "COM216"
## [17] "COM225" "COM307" "COM330" "COM332" "COM215" "COM217" "COM218" "COM304"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Understanding Mass Media"
## 
## [[3]]
## [1] "Visual Media Toolkit"
## 
## [[4]]
## [1] "Human Communication (KP)"
## 
## [[5]]
## [1] "Writing for The Media"
## 
## [[6]]
## [1] "Effective Speaking"
## 
## [[7]]
## [1] "Intercultural Communication"
## 
## [[8]]
## [1] "Social Media Management"
## 
## [[9]]
## [1] "Communication Research"
## 
## [[10]]
## [1] "Digital Storytelling"
## 
## [[11]]
## [1] "Media Literacy & Ethics"
## 
## [[12]]
## [1] "Pre-Internship Seminar"
## 
## [[13]]
## [1] "Field Experience I"
## 
## [[14]]
## [1] "Capstone Project & Portfolio "
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Professional Communication"
## 
## [[17]]
## [1] "Public Relations"
## 
## [[18]]
## [1] "Entertainment Media "
## 
## [[19]]
## [1] "Producing"
## 
## [[20]]
## [1] "Understanding Video Games"
## 
## [[21]]
## [1] "Strategic Campaigns"
## 
## [[22]]
## [1] "Television & Film Studies"
## 
## [[23]]
## character(0)
## 
## [[24]]
## [1] "Radio Production"
## 
## [[25]]
## [1] "Video Production"
## 
## [[26]]
## [1] "Digital Video Editing"
## 
## [[27]]
## [1] "TV Studio Production"
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Entertainment Media`=case_when(
   # `Entertainment Media`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:20] ~"Required",
    Section %in% crs.df$Section[21:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Entertainment Media`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Entertainment Media`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Entertainment Media [3]
##   `Entertainment Media`     n
##   <chr>                 <int>
## 1 Elective                  4
## 2 Required                 20
## 3 <NA>                    945
```















## Graphic Design


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/graphic-design-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "ARTH107" "ARTS101" "ARTS126" "ARTS201" "ARTS219" "ARTS319" "GRAP105"
##  [8] "GRAP201" "GRAP204" "GRAP205" "GRAP207" "GRAP208" "GRAP301" "GRAP302"
## [15] "GRAP307" "GRAP308" "GRAP309" "GRAP311" "GRAP322" "GRAP399" "GRAP400"
## [22] "GRAP401" "GRAP403" "GRAP404" "GRAP406" "MATH107"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Special Topics in Art (KP)"
## 
## [[3]]
## [1] "Studio Drawing I"
## 
## [[4]]
## [1] "Fundamentals of Visual Art (KP)"
## 
## [[5]]
## [1] "Studio Drawing II"
## 
## [[6]]
## [1] "Digital Photography I"
## 
## [[7]]
## [1] "Digital Photography II"
## 
## [[8]]
## [1] "Digital Design Essentials"
## 
## [[9]]
## [1] "Imaging for Graphic Design"
## 
## [[10]]
## [1] "Graphic Design I"
## 
## [[11]]
## [1] "Graphic Design II"
## 
## [[12]]
## [1] "Web Design & Development"
## 
## [[13]]
## [1] "Graphic Design History"
## 
## [[14]]
## [1] "Typography I"
## 
## [[15]]
## [1] "Typography II"
## 
## [[16]]
## [1] "Motion Graphics"
## 
## [[17]]
## [1] "Interactive & UX Design"
## 
## [[18]]
## [1] "Graphic Design for the Marketplace"
## 
## [[19]]
## [1] "Digital 3D Design"
## 
## [[20]]
## [1] "Photography for Design"
## 
## [[21]]
## [1] "Internship Seminar"
## 
## [[22]]
## [1] "Field Experience"
## 
## [[23]]
## [1] "Publication Design"
## 
## [[24]]
## [1] "Senior Portfolio Development"
## 
## [[25]]
## [1] "Senior Thesis Assignment"
## 
## [[26]]
## [1] "Senior Practicum Project"
## 
## [[27]]
## [1] "College Geometry"
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Graphic Design`=case_when(
   # `Graphic Design`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Graphic Design`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Graphic Design`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Graphic Design [2]
##   `Graphic Design`     n
##   <chr>            <int>
## 1 Required            26
## 2 <NA>               944
```












## Journalism


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/journalism-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "COM101"  "COM102"  "COM103"  "COM105"  "COM203"  "COM212"  "COM219" 
##  [8] "COM315"  "COM327"  "COM331"  "COM399"  "COM400"  "COM495"  "ARTS219"
## [15] "COM208"  "COM209"  "COM306"  "COM314"  "COM324"  "COM215"  "COM217" 
## [22] "COM218"  "COM304"  "LS214"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Understanding Mass Media"
## 
## [[3]]
## [1] "Visual Media Toolkit"
## 
## [[4]]
## [1] "Human Communication (KP)"
## 
## [[5]]
## [1] "Writing for The Media"
## 
## [[6]]
## [1] "Effective Speaking"
## 
## [[7]]
## [1] "Intercultural Communication"
## 
## [[8]]
## [1] "Social Media Management"
## 
## [[9]]
## [1] "Communication Research"
## 
## [[10]]
## [1] "Digital Storytelling"
## 
## [[11]]
## [1] "Media Literacy & Ethics"
## 
## [[12]]
## [1] "Pre-Internship Seminar"
## 
## [[13]]
## [1] "Field Experience I"
## 
## [[14]]
## [1] "Capstone Project & Portfolio "
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Digital Photography I"
## 
## [[17]]
## [1] "Public Relations"
## 
## [[18]]
## [1] "Journalism"
## 
## [[19]]
## [1] "Broadcast Journalism"
## 
## [[20]]
## [1] "Magazine and Digital Content"
## 
## [[21]]
## [1] "Investigative and Beat Reporting"
## 
## [[22]]
## character(0)
## 
## [[23]]
## [1] "Radio Production"
## 
## [[24]]
## [1] "Video Production"
## 
## [[25]]
## [1] "Digital Video Editing"
## 
## [[26]]
## [1] "TV Studio Production"
## 
## [[27]]
## character(0)
## 
## [[28]]
## [1] "Communication Law"
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Journalism`=case_when(
   # `Journalism`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:19] ~"Required",
    Section %in% crs.df$Section[20:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Journalism`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Journalism`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Journalism [3]
##   Journalism     n
##   <chr>      <int>
## 1 Elective       5
## 2 Required      19
## 3 <NA>         946
```











## Public Relations


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/public-relations-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "COM101" "COM102" "COM103" "COM105" "COM203" "COM212" "COM219" "COM315"
##  [9] "COM327" "COM331" "COM399" "COM400" "COM495" "COM206" "COM208" "COM221"
## [17] "COM317" "COM320" "COM330" "COM335" "LS214"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Understanding Mass Media"
## 
## [[3]]
## [1] "Visual Media Toolkit"
## 
## [[4]]
## [1] "Human Communication (KP)"
## 
## [[5]]
## [1] "Writing for The Media"
## 
## [[6]]
## [1] "Effective Speaking"
## 
## [[7]]
## [1] "Intercultural Communication"
## 
## [[8]]
## [1] "Social Media Management"
## 
## [[9]]
## [1] "Communication Research"
## 
## [[10]]
## [1] "Digital Storytelling"
## 
## [[11]]
## [1] "Media Literacy & Ethics"
## 
## [[12]]
## [1] "Pre-Internship Seminar"
## 
## [[13]]
## [1] "Field Experience I"
## 
## [[14]]
## [1] "Capstone Project & Portfolio "
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Professional Communication"
## 
## [[17]]
## [1] "Public Relations"
## 
## [[18]]
## [1] "Advertising"
## 
## [[19]]
## [1] "Media Relations"
## 
## [[20]]
## [1] "Organizational Communication"
## 
## [[21]]
## [1] "Strategic Campaigns"
## 
## [[22]]
## [1] "Corporate and Nonprofit Public Relations"
## 
## [[23]]
## character(0)
## 
## [[24]]
## [1] "Communication Law"
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Public Relations`=case_when(
   # `Public Relations`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:20] ~"Required",
    Section %in% crs.df$Section[length(crs.df$Section)] ~"Elective"))#%>%group_by(`Public Relations`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Public Relations`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Public Relations [3]
##   `Public Relations`     n
##   <chr>              <int>
## 1 Elective               1
## 2 Required              20
## 3 <NA>                 950
```






















## Radio and Video Production


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/radio-and-video-production-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "COM101"  "COM102"  "COM103"  "COM105"  "COM203"  "COM212"  "COM219" 
##  [8] "COM315"  "COM331"  "COM332"  "COM399"  "COM400"  "COM495"  "COM215" 
## [15] "COM217"  "COM218"  "COM225"  "COM304"  "COM312"  "COM313"  "GRAP307"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Understanding Mass Media"
## 
## [[3]]
## [1] "Visual Media Toolkit"
## 
## [[4]]
## [1] "Human Communication (KP)"
## 
## [[5]]
## [1] "Writing for The Media"
## 
## [[6]]
## [1] "Effective Speaking"
## 
## [[7]]
## [1] "Intercultural Communication"
## 
## [[8]]
## [1] "Social Media Management"
## 
## [[9]]
## [1] "Communication Research"
## 
## [[10]]
## [1] "Media Literacy & Ethics"
## 
## [[11]]
## [1] "Television & Film Studies"
## 
## [[12]]
## [1] "Pre-Internship Seminar"
## 
## [[13]]
## [1] "Field Experience I"
## 
## [[14]]
## [1] "Capstone Project & Portfolio "
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Radio Production"
## 
## [[17]]
## [1] "Video Production"
## 
## [[18]]
## [1] "Digital Video Editing"
## 
## [[19]]
## [1] "Producing"
## 
## [[20]]
## [1] "TV Studio Production"
## 
## [[21]]
## [1] "Digital Audio Production"
## 
## [[22]]
## [1] "Digital Filmmaking"
## 
## [[23]]
## [1] "Motion Graphics"
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`RadioVideoProdu`=case_when(
   # `RadioVideoProdu`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`RadioVideoProdu`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`RadioVideoProdu`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   RadioVideoProdu [2]
##   RadioVideoProdu     n
##   <chr>           <int>
## 1 Required           21
## 2 <NA>              950
```

```r
#rename
dat.major<-dat.major%>%rename(`Radio and Video Production`=RadioVideoProdu)#using rename to add the major name as is
```























## Sport Communication


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/sport-communication-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "COM101"  "COM102"  "COM103"  "COM105"  "COM203"  "COM212"  "COM219" 
##  [8] "COM315"  "COM327"  "COM331"  "COM399"  "COM400"  "COM495"  "BUSS220"
## [15] "COM209"  "COM230"  "COM231"  "SMGT102" "SMGT302" "SMGT304" "COM215" 
## [22] "COM217"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Understanding Mass Media"
## 
## [[3]]
## [1] "Visual Media Toolkit"
## 
## [[4]]
## [1] "Human Communication (KP)"
## 
## [[5]]
## [1] "Writing for The Media"
## 
## [[6]]
## [1] "Effective Speaking"
## 
## [[7]]
## [1] "Intercultural Communication"
## 
## [[8]]
## [1] "Social Media Management"
## 
## [[9]]
## [1] "Communication Research"
## 
## [[10]]
## [1] "Digital Storytelling"
## 
## [[11]]
## [1] "Media Literacy & Ethics"
## 
## [[12]]
## [1] "Pre-Internship Seminar"
## 
## [[13]]
## [1] "Field Experience I"
## 
## [[14]]
## [1] "Capstone Project & Portfolio "
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Principles of Marketing"
## 
## [[17]]
## [1] "Journalism"
## 
## [[18]]
## [1] "Media, Sports & Society "
## 
## [[19]]
## [1] "Sports Communication"
## 
## [[20]]
## [1] "Contemporary Sport Management"
## 
## [[21]]
## [1] "Sport Marketing"
## 
## [[22]]
## [1] "Sports Information & Communication"
## 
## [[23]]
## character(0)
## 
## [[24]]
## [1] "Radio Production"
## 
## [[25]]
## [1] "Video Production"
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Sport Communication`=case_when(
   # `Sport Communication`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:20] ~"Required",
    Section %in% crs.df$Section[21:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Sport Communication`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Sport Communication`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Sport Communication [3]
##   `Sport Communication`     n
##   <chr>                 <int>
## 1 Elective                  2
## 2 Required                 20
## 3 <NA>                    949
```













## Fashion Media and Marketing


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/fashion-21-22/fashion-media-and-marketing21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "ARTS126" "BUSS220" "COM101"  "COM208"  "COM209"  "FASH101" "FASH102"
##  [8] "FASH105" "FASH200" "FASH207" "FASH210" "FASH219" "FASH307" "FASH308"
## [15] "FASH315" "FASH415" "FASH427" "FASM218" "FASM306" "FASM310" "FASM411"
## [22] "FASM412" "GRAP308" "MATH106" "MATH208" "BUSS341" "FASH407"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Fundamentals of Visual Art (KP)"
## 
## [[3]]
## [1] "Principles of Marketing"
## 
## [[4]]
## [1] "Understanding Mass Media"
## 
## [[5]]
## [1] "Public Relations"
## 
## [[6]]
## [1] "Journalism"
## 
## [[7]]
## [1] "The Business of Fashion"
## 
## [[8]]
## [1] "The Fashion Consumer"
## 
## [[9]]
## [1] "Excel for the Industry"
## 
## [[10]]
## [1] "Fashion History I:Imperial Societies to Industrial Revolution"
## 
## [[11]]
## [1] "Digital Tools for Fashion "
## 
## [[12]]
## [1] "Textiles"
## 
## [[13]]
## [1] "Fashion Industry Professional Development"
## 
## [[14]]
## [1] "Fashion Brand Management "
## 
## [[15]]
## [1] "Fashion Event Production "
## 
## [[16]]
## [1] "Trend Forecasting and Analytics "
## 
## [[17]]
## [1] "Fashion Industry Internship Seminar "
## 
## [[18]]
## [1] "Fashion Industry Capstone "
## 
## [[19]]
## [1] "Fashion Content Development"
## 
## [[20]]
## [1] "Fashion Styling & Photography"
## 
## [[21]]
## [1] "Digital Marketing"
## 
## [[22]]
## [1] "Social and Mobile Strategies"
## 
## [[23]]
## [1] "Editorial Fashion Production"
## 
## [[24]]
## [1] "Interactive & UX Design"
## 
## [[25]]
## [1] "Mathematical Reasoning"
## 
## [[26]]
## [1] "Statistics"
## 
## [[27]]
## character(0)
## 
## [[28]]
## [1] "Social Media Marketing"
## 
## [[29]]
## [1] "Digital Commerce and Analytics "
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Fashion Media and Marketing`=case_when(
   # `Fashion Media and Marketing`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:25] ~"Required",
    Section %in% crs.df$Section[26:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Fashion Media and Marketing`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Fashion Media and Marketing`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Fashion Media and Marketing [3]
##   `Fashion Media and Marketing`     n
##   <chr>                         <int>
## 1 Elective                          2
## 2 Required                         25
## 3 <NA>                            949
```


















## Fashion Design and Production


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/fashion-21-22/fashion-design-and-production-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "ARTS126"  "ARTS207"  "FASD103"  "FASD104"  "FASD107"  "FASD201" 
##  [7] "FASD202"  "FASD205"  "FASD206"  "FASD214"  "FASD215"  "FASD220" 
## [13] "FASD301"  "FASD307"  "FASD313"  "FASD322"  "FASD327"  "FASD409" 
## [19] "FASD410"  "FASD465"  "FASD466"  "FASH200"  "FASH210"  "FASH303" 
## [25] "FASH309"  "FASH415"  "MATH108X"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Fundamentals of Visual Art (KP)"
## 
## [[3]]
## [1] "Figure Drawing"
## 
## [[4]]
## [1] "Apparel Construction Techniques I"
## 
## [[5]]
## [1] "Apparel Construction Techniques II"
## 
## [[6]]
## [1] "Draping I - Fundamentals"
## 
## [[7]]
## [1] "Flat Pattern Design I"
## 
## [[8]]
## [1] "Flat Pattern Design II"
## 
## [[9]]
## [1] "Digital Design for Apparel"
## 
## [[10]]
## [1] "Cut & Sew Stretch Knits"
## 
## [[11]]
## [1] "Pattern Grading & Fit Techniques"
## 
## [[12]]
## [1] "Fashion Illustration"
## 
## [[13]]
## [1] "Fashion Design Concepts"
## 
## [[14]]
## [1] "Professional Presentation Methods"
## 
## [[15]]
## [1] "Flat Pattern III - Tailoring"
## 
## [[16]]
## [1] "Draping II - Couture"
## 
## [[17]]
## [1] "Sweater Knit Design"
## 
## [[18]]
## [1] "Market of Specialization "
## 
## [[19]]
## [1] "Fashion Design Capstone: Collection Development"
## 
## [[20]]
## [1] "Fashion Design Capstone: Collection Production"
## 
## [[21]]
## [1] "Cad I- Lectra"
## 
## [[22]]
## [1] "Cad II- Lectra"
## 
## [[23]]
## [1] "Fashion History I:Imperial Societies to Industrial Revolution"
## 
## [[24]]
## [1] "Textiles"
## 
## [[25]]
## [1] "Fashion History II:Modernity to Globalization "
## 
## [[26]]
## [1] "Apparel Product Development"
## 
## [[27]]
## [1] "Fashion Industry Internship Seminar "
## 
## [[28]]
## [1] "Mathematics of Design"
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Fashion Design and Production`=case_when(
   # `Fashion Design and Production`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Fashion Design and Production`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Fashion Design and Production`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Fashion Design and Production [2]
##   `Fashion Design and Production`     n
##   <chr>                           <int>
## 1 Required                           27
## 2 <NA>                              951
```


















## Fashion Merchandising and Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/fashion-21-22/fashion-merchandising-and-management21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "ARTS126" "BUSS105" "BUSS220" "BUSS325" "DSCI202" "ECON101" "FASH101"
##  [8] "FASH102" "FASH200" "FASH201" "FASH207" "FASH210" "FASH211" "FASH212"
## [15] "FASH219" "FASH307" "FASH308" "FASH309" "FASH315" "FASH406" "FASH407"
## [22] "FASH410" "FASH415" "FASH427" "MATH116" "MATH209"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Fundamentals of Visual Art (KP)"
## 
## [[3]]
## [1] "Excel for Business"
## 
## [[4]]
## [1] "Principles of Marketing"
## 
## [[5]]
## [1] "Sales Principles"
## 
## [[6]]
## [1] "Business Analytics"
## 
## [[7]]
## [1] "Principles of Econ-Micro"
## 
## [[8]]
## [1] "The Business of Fashion"
## 
## [[9]]
## [1] "The Fashion Consumer"
## 
## [[10]]
## [1] "Fashion History I:Imperial Societies to Industrial Revolution"
## 
## [[11]]
## [1] "Merchandise Planning and Control "
## 
## [[12]]
## [1] "Digital Tools for Fashion "
## 
## [[13]]
## [1] "Textiles"
## 
## [[14]]
## [1] "Omnichannel Management and Operations"
## 
## [[15]]
## [1] "Visual and Digital Merchandising "
## 
## [[16]]
## [1] "Fashion Industry Professional Development"
## 
## [[17]]
## [1] "Fashion Brand Management "
## 
## [[18]]
## [1] "Fashion Event Production "
## 
## [[19]]
## [1] "Apparel Product Development"
## 
## [[20]]
## [1] "Trend Forecasting and Analytics "
## 
## [[21]]
## [1] "Global Perspectives and Markets in the Fashion Industry"
## 
## [[22]]
## [1] "Digital Commerce and Analytics "
## 
## [[23]]
## [1] "Fashion Supply Chain Management"
## 
## [[24]]
## [1] "Fashion Industry Internship Seminar "
## 
## [[25]]
## [1] "Fashion Industry Capstone "
## 
## [[26]]
## [1] "Merchandising and Financial Mathematics"
## 
## [[27]]
## [1] "Business Statistics"
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Fashion Merchandising and Management`=case_when(
   # `Fashion Merchandising and Management`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Fashion Merchandising and Management`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Fashion Merchandising and Management`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Fashion Merchandising and Management [2]
##   `Fashion Merchandising and Management`     n
##   <chr>                                  <int>
## 1 Required                                  26
## 2 <NA>                                     953
```



















## Applied Mathematics


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/applied-mathematics-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "DSCI102"  "DSCI306"  "DSCI309"  "MATH205"  "MATH206"  "MATH208" 
##  [7] "MATH212"  "MATH215"  "MATH305X" "MATH307"  "MATH325"  "MATH399" 
## [13] "MATH499"  "PHYS111"  "PHYS112"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Introduction to Computer Science"
## 
## [[3]]
## [1] "Advanced Python Programming"
## 
## [[4]]
## [1] "Biostatistics"
## 
## [[5]]
## [1] "Calculus I"
## 
## [[6]]
## [1] "Calculus II"
## 
## [[7]]
## [1] "Statistics"
## 
## [[8]]
## [1] "Finite Mathematics"
## 
## [[9]]
## [1] "Discrete Math"
## 
## [[10]]
## [1] "Advanced Statistics"
## 
## [[11]]
## [1] "Calculus III"
## 
## [[12]]
## [1] "Linear Algebra"
## 
## [[13]]
## [1] "Capstone Seminar"
## 
## [[14]]
## [1] "Internship"
## 
## [[15]]
## [1] "General Physics I (KP)"
## 
## [[16]]
## [1] "General Physics II (KP)"
## 
## [[17]]
## character(0)
## 
## [[18]]
## character(0)
## 
## [[19]]
## character(0)
## 
## [[20]]
## character(0)
## 
## [[21]]
## character(0)
## 
## [[22]]
## character(0)
## 
## [[23]]
## character(0)
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Applied Mathematics`=case_when(
   # `Applied Mathematics`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Applied Mathematics`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Applied Mathematics`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Applied Mathematics [2]
##   `Applied Mathematics`     n
##   <chr>                 <int>
## 1 Required                 15
## 2 <NA>                    969
```










## Biochemistry


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/biochemistry-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BIO101"           "BIO102"           "BIO209"           "BIO211"          
##  [5] "BIO310"           "BIO430"           "CHEM203"          "CHEM204"         
##  [9] "CHEM301"          "CHEM303"          "CHEM304"          "CHEM305"         
## [13] "CHEM405"          "Field Experience" "MATH203"          "MATH205"         
## [17] "MATH206"          "MATH208"          "PHYS111"          "PHYS112"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Principles of Biology I (KP)"
## 
## [[3]]
## [1] "Principles of Biology II (KP)"
## 
## [[4]]
## [1] "Molecular Biology"
## 
## [[5]]
## [1] "Microbiology"
## 
## [[6]]
## [1] "Genetics"
## 
## [[7]]
## [1] "Health Science Capstone"
## 
## [[8]]
## [1] "General Chemistry I (KP)"
## 
## [[9]]
## [1] "General Chemistry II"
## 
## [[10]]
## [1] "Biochemistry"
## 
## [[11]]
## [1] "Organic Chemistry"
## 
## [[12]]
## [1] "Organic Chemistry II"
## 
## [[13]]
## [1] "Analytical Chemistry"
## 
## [[14]]
## [1] "Physical Chemistry"
## 
## [[15]]
## [1] "CHEM407"
## 
## [[16]]
## [1] "Precalculus"
## 
## [[17]]
## [1] "Calculus I"
## 
## [[18]]
## [1] "Calculus II"
## 
## [[19]]
## [1] "Statistics"
## 
## [[20]]
## [1] "General Physics I (KP)"
## 
## [[21]]
## [1] "General Physics II (KP)"
## 
## [[22]]
## character(0)
## 
## [[23]]
## character(0)
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Biochemistry`=case_when(
   # `Biochemistry`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Biochemistry`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Biochemistry`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Biochemistry [2]
##   Biochemistry     n
##   <chr>        <int>
## 1 Required        20
## 2 <NA>           967
```




















## Cybersecurity


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/cybersecurity-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "DSCI102" "DSCI103" "DSCI409" "DSCI499" "MATH208" "MATH215" "MATH305"
##  [8] "BUSS101" "BUSS105" "BUSS205" "CJ315"   "DSCI203" "DSCI205" "DSCI207"
## [15] "DSCI302" "DSCI305" "DSCI310" "DSCI405"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Introduction to Computer Science"
## 
## [[3]]
## [1] "Fundamentals of Information Technology"
## 
## [[4]]
## [1] "Project & Program Management"
## 
## [[5]]
## [1] "Internship Data Science"
## 
## [[6]]
## [1] "Statistics"
## 
## [[7]]
## [1] "Discrete Math"
## 
## [[8]]
## [1] "Advanced Statistics"
## 
## [[9]]
## character(0)
## 
## [[10]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[11]]
## [1] "Excel for Business"
## 
## [[12]]
## [1] "Business Law"
## 
## [[13]]
## [1] "Global Technology & Crime"
## 
## [[14]]
## [1] "OS + Algorithms"
## 
## [[15]]
## [1] "Data Communication & Networks"
## 
## [[16]]
## [1] "Cryptology"
## 
## [[17]]
## [1] "IT Security & Risk Management"
## 
## [[18]]
## [1] "Information Assurance and Management"
## 
## [[19]]
## [1] "Cyberlaw & Cybercrime"
## 
## [[20]]
## [1] "Computer Forensics"
## 
## [[21]]
## character(0)
## 
## [[22]]
## character(0)
## 
## [[23]]
## character(0)
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Cybersecurity`=case_when(
   # `Cybersecurity`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Cybersecurity`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Cybersecurity`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Cybersecurity [2]
##   Cybersecurity     n
##   <chr>         <int>
## 1 Required         18
## 2 <NA>            980
```











## Data Analytics


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/data-analytics-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "DSCI102" "DSCI103" "DSCI409" "DSCI499" "MATH208" "MATH215" "MATH305"
##  [8] "BUSS105" "DSCI105" "DSCI201" "DSCI202" "DSCI203" "DSCI204" "DSCI301"
## [15] "DSCI306" "DSCI402" "MATH205" "DSCI303" "DSCI307" "DSCI308"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Introduction to Computer Science"
## 
## [[3]]
## [1] "Fundamentals of Information Technology"
## 
## [[4]]
## [1] "Project & Program Management"
## 
## [[5]]
## [1] "Internship Data Science"
## 
## [[6]]
## [1] "Statistics"
## 
## [[7]]
## [1] "Discrete Math"
## 
## [[8]]
## [1] "Advanced Statistics"
## 
## [[9]]
## character(0)
## 
## [[10]]
## [1] "Excel for Business"
## 
## [[11]]
## [1] "Data Warehouse and Business Intelligence"
## 
## [[12]]
## [1] "Analytics using SAS Visual Analytics"
## 
## [[13]]
## [1] "Business Analytics"
## 
## [[14]]
## [1] "OS + Algorithms"
## 
## [[15]]
## [1] "How to Think Like a Data Scientist"
## 
## [[16]]
## [1] "Big Data Analytics"
## 
## [[17]]
## [1] "Advanced Python Programming"
## 
## [[18]]
## [1] "Analytics with R"
## 
## [[19]]
## [1] "Calculus I"
## 
## [[20]]
## character(0)
## 
## [[21]]
## [1] "Machine Learning"
## 
## [[22]]
## [1] "Analytics Elec w/SAS"
## 
## [[23]]
## [1] "Predictive & Prescriptive Analytics"
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Data Analytics`=case_when(
   # `Data Analytics`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:17] ~"Required",
    Section %in% crs.df$Section[18:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Data Analytics`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Data Analytics`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Data Analytics [3]
##   `Data Analytics`     n
##   <chr>            <int>
## 1 Elective             3
## 2 Required            17
## 3 <NA>               986
```












## Exercise Science


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/exercise-science-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BIO104"  "BIO205"  "BIO206"  "BIO301"  "EXSC103" "EXSC106" "EXSC107"
##  [8] "EXSC209" "EXSC211" "EXSC222" "EXSC302" "EXSC304" "EXSC305" "EXSC340"
## [15] "EXSC401" "EXSC403" "EXSC405" "EXSC410" "EXSC425" "EXSC430" "IDS399" 
## [22] "MATH203" "MATH208" "PHYS111" "PSYC101" "PSYC220" "PSYC221" "PSYC223"
## [29] "PSYC240" "EXSC307" "EXSC406"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Foundations in the Health Professions"
## 
## [[3]]
## [1] "Anatomy & Physiology I"
## 
## [[4]]
## [1] "Anatomy & Physiology II"
## 
## [[5]]
## [1] "Pathophysiology"
## 
## [[6]]
## [1] "Skills & Techniques for the Exercise Sci"
## 
## [[7]]
## [1] "Functional Anatomy & Resistance Trainig"
## 
## [[8]]
## [1] "Healthy Lifestyles and Human Behavior"
## 
## [[9]]
## [1] "Performance Nutrition"
## 
## [[10]]
## [1] "Principles of Personal Training "
## 
## [[11]]
## [1] "Kinesiology"
## 
## [[12]]
## [1] "Exercise Physiology"
## 
## [[13]]
## [1] "Exercise Testing & Prescription"
## 
## [[14]]
## [1] "Strength Training & Conditioning"
## 
## [[15]]
## [1] "Research Concepts"
## 
## [[16]]
## [1] "Professional Development Seminar"
## 
## [[17]]
## [1] "Exercise for Special Populations"
## 
## [[18]]
## [1] "Org & Admin of Health & Sports Programs"
## 
## [[19]]
## [1] "Exercise Science Field Experience I"
## 
## [[20]]
## [1] "Exercise Science Field Experience III"
## 
## [[21]]
## [1] "Exercise Science Capstone"
## 
## [[22]]
## [1] "Internship Seminar"
## 
## [[23]]
## [1] "Precalculus"
## 
## [[24]]
## [1] "Statistics"
## 
## [[25]]
## [1] "General Physics I (KP)"
## 
## [[26]]
## [1] "Psychological Perspectives (KP)"
## 
## [[27]]
## character(0)
## 
## [[28]]
## [1] "Social Psychology"
## 
## [[29]]
## [1] "Child Development"
## 
## [[30]]
## [1] "Adolescent Psychology"
## 
## [[31]]
## [1] "Sport Psychology"
## 
## [[32]]
## character(0)
## 
## [[33]]
## [1] "Func Assessment & Corrective Exc Pres"
## 
## [[34]]
## [1] "Advanced Topics in Exercise Physiology "
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
## 
## [[41]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Exercise Science`=case_when(
   # `Exercise Science`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:25] ~"Required",
    Section %in% crs.df$Section[26:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Exercise Science`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Exercise Science`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Exercise Science [3]
##   `Exercise Science`     n
##   <chr>              <int>
## 1 Elective               6
## 2 Required              25
## 3 <NA>                 977
```










## Fitness Management


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/fitness-management-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BIO205"  "BIO206"  "BUSS101" "BUSS205" "BUSS220" "BUSS224" "BUSS226"
##  [8] "BUSS231" "BUSS232" "BUSS336" "COM103"  "ECON101" "EXSC103" "EXSC106"
## [15] "EXSC108" "EXSC209" "EXSC211" "EXSC340" "EXSC405" "EXSC410" "HEM205" 
## [22] "MATH208" "PSYC101" "BUSS440" "EXSC430" "PSYC218" "PSYC220" "PSYC240"
## [29] "PSYC302" "EXSC302" "EXSC305"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Anatomy & Physiology I"
## 
## [[3]]
## [1] "Anatomy & Physiology II"
## 
## [[4]]
## [1] "Fund of Bus in a Global Environment"
## 
## [[5]]
## [1] "Business Law"
## 
## [[6]]
## [1] "Principles of Marketing"
## 
## [[7]]
## [1] "Org Behavior in the Global Workplace"
## 
## [[8]]
## [1] "Financial Accounting"
## 
## [[9]]
## [1] "Entrepreneurship & Venture Creation"
## 
## [[10]]
## [1] "Global Operation Strategies"
## 
## [[11]]
## [1] "Human Resource Management"
## 
## [[12]]
## [1] "Human Communication (KP)"
## 
## [[13]]
## [1] "Principles of Econ-Micro"
## 
## [[14]]
## [1] "Skills & Techniques for the Exercise Sci"
## 
## [[15]]
## [1] "Functional Anatomy & Resistance Trainig"
## 
## [[16]]
## [1] "Group Exercise"
## 
## [[17]]
## [1] "Performance Nutrition"
## 
## [[18]]
## [1] "Principles of Personal Training "
## 
## [[19]]
## [1] "Research Concepts"
## 
## [[20]]
## [1] "Org & Admin of Health & Sports Programs"
## 
## [[21]]
## [1] "Exercise Science Field Experience I"
## 
## [[22]]
## [1] "Private Club Management"
## 
## [[23]]
## [1] "Statistics"
## 
## [[24]]
## [1] "Psychological Perspectives (KP)"
## 
## [[25]]
## character(0)
## 
## [[26]]
## [1] "Business Capstone"
## 
## [[27]]
## [1] "Exercise Science Capstone"
## 
## [[28]]
## character(0)
## 
## [[29]]
## [1] "Dynamics of Small Groups"
## 
## [[30]]
## [1] "Social Psychology"
## 
## [[31]]
## [1] "Sport Psychology"
## 
## [[32]]
## [1] "Biological Basis of Behavior"
## 
## [[33]]
## character(0)
## 
## [[34]]
## [1] "Exercise Physiology"
## 
## [[35]]
## [1] "Strength Training & Conditioning"
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
## 
## [[41]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Fitness Management`=case_when(
   # `Fitness Management`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:23] ~"Required",
    Section %in% crs.df$Section[24:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Fitness Management`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Fitness Management`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Fitness Management [3]
##   `Fitness Management`     n
##   <chr>                <int>
## 1 Elective                 8
## 2 Required                23
## 3 <NA>                   977
```









## Forensic Science


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/forensic-science-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BIO101"  "BIO209"  "BIO211"  "BIO310"  "CHEM203" "CHEM204" "CHEM301"
##  [8] "CHEM303" "CHEM304" "CJ101"   "CJ201"   "CJ207"   "CJ316"   "FSCI205"
## [15] "FSCI309" "FSCI407" "FSCI411" "FSCI413" "FSCI450" "FSCI480" "MATH203"
## [22] "MATH205" "MATH208" "PHYS111" "PHYS112"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Principles of Biology I (KP)"
## 
## [[3]]
## [1] "Molecular Biology"
## 
## [[4]]
## [1] "Microbiology"
## 
## [[5]]
## [1] "Genetics"
## 
## [[6]]
## [1] "General Chemistry I (KP)"
## 
## [[7]]
## [1] "General Chemistry II"
## 
## [[8]]
## [1] "Biochemistry"
## 
## [[9]]
## [1] "Organic Chemistry"
## 
## [[10]]
## [1] "Organic Chemistry II"
## 
## [[11]]
## [1] "Introduction to Criminal Justice (KP)"
## 
## [[12]]
## [1] "Criminology"
## 
## [[13]]
## [1] "Criminal Investigations"
## 
## [[14]]
## [1] "Criminal Procedure"
## 
## [[15]]
## [1] "Forensic Science I"
## 
## [[16]]
## [1] "Forensic Science II"
## 
## [[17]]
## [1] "Field Experience "
## 
## [[18]]
## [1] "Trace Evidence and Microscopy"
## 
## [[19]]
## [1] "Forensic DNA Analysis"
## 
## [[20]]
## [1] "SPT in Applied Forensic Science"
## 
## [[21]]
## [1] "Capstone in Applied Forensic Science "
## 
## [[22]]
## [1] "Precalculus"
## 
## [[23]]
## [1] "Calculus I"
## 
## [[24]]
## [1] "Statistics"
## 
## [[25]]
## [1] "General Physics I (KP)"
## 
## [[26]]
## [1] "General Physics II (KP)"
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Forensic Science`=case_when(
   # `Forensic Science`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:length(crs.df$Section)] ~"Required"))#%>%group_by(`Forensic Science`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Forensic Science`)%>%count()#non-existing major
```

```
## # A tibble: 2 × 2
## # Groups:   Forensic Science [2]
##   `Forensic Science`     n
##   <chr>              <int>
## 1 Required              25
## 2 <NA>                 986
```
















## Health Science


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/health-science-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BIO101"  "BIO102"  "BIO104"  "BIO205"  "BIO206"  "BIO211"  "BIO301" 
##  [8] "BIO340"  "BIO420"  "BIO430"  "CHEM203" "CHEM204" "CHEM301" "EXSC107"
## [15] "EXSC209" "EXSC302" "MATH203" "MATH208" "PHYS111" "PHYS112" "PSYC101"
## [22] "PSYC221" "PSYC223"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Principles of Biology I (KP)"
## 
## [[3]]
## [1] "Principles of Biology II (KP)"
## 
## [[4]]
## [1] "Foundations in the Health Professions"
## 
## [[5]]
## [1] "Anatomy & Physiology I"
## 
## [[6]]
## [1] "Anatomy & Physiology II"
## 
## [[7]]
## [1] "Microbiology"
## 
## [[8]]
## [1] "Pathophysiology"
## 
## [[9]]
## [1] "Research Methods"
## 
## [[10]]
## [1] "Field Experience  in Health Science"
## 
## [[11]]
## [1] "Health Science Capstone"
## 
## [[12]]
## [1] "General Chemistry I (KP)"
## 
## [[13]]
## [1] "General Chemistry II"
## 
## [[14]]
## [1] "Biochemistry"
## 
## [[15]]
## [1] "Healthy Lifestyles and Human Behavior"
## 
## [[16]]
## [1] "Performance Nutrition"
## 
## [[17]]
## [1] "Exercise Physiology"
## 
## [[18]]
## [1] "Precalculus"
## 
## [[19]]
## [1] "Statistics"
## 
## [[20]]
## [1] "General Physics I (KP)"
## 
## [[21]]
## [1] "General Physics II (KP)"
## 
## [[22]]
## [1] "Psychological Perspectives (KP)"
## 
## [[23]]
## character(0)
## 
## [[24]]
## [1] "Child Development"
## 
## [[25]]
## [1] "Adolescent Psychology"
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Health Science`=case_when(
   # `Health Science`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:21] ~"Required",
    Section %in% crs.df$Section[22:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Health Science`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Health Science`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Health Science [3]
##   `Health Science`     n
##   <chr>            <int>
## 1 Elective             2
## 2 Required            21
## 3 <NA>               988
```




























## Public and Community Health


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/public-and-community-health-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "BIO101"  "BIO102"  "BIO340"  "BIO420"  "BIO430"  "BUSS224" "COM212" 
##  [8] "HS101"   "HS210"   "MATH208" "PHLT205" "PHLT303" "PSYC101" "PSYC201"
## [15] "PSYC205" "SOC212"  "PSYC221" "PSYC223" "COM103"  "COM203"  "COM206"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Principles of Biology I (KP)"
## 
## [[3]]
## [1] "Principles of Biology II (KP)"
## 
## [[4]]
## [1] "Research Methods"
## 
## [[5]]
## [1] "Field Experience  in Health Science"
## 
## [[6]]
## [1] "Health Science Capstone"
## 
## [[7]]
## [1] "Org Behavior in the Global Workplace"
## 
## [[8]]
## [1] "Intercultural Communication"
## 
## [[9]]
## [1] "Human Services: Systems & Skills"
## 
## [[10]]
## [1] "Case Management & Counseling"
## 
## [[11]]
## [1] "Statistics"
## 
## [[12]]
## [1] "Health Promotion & Disease Prevention "
## 
## [[13]]
## [1] "Epidemiology "
## 
## [[14]]
## [1] "Psychological Perspectives (KP)"
## 
## [[15]]
## [1] "Psychology of Drugs & Behavior"
## 
## [[16]]
## [1] "Human Sexuality"
## 
## [[17]]
## [1] "Wellness & Society"
## 
## [[18]]
## character(0)
## 
## [[19]]
## [1] "Child Development"
## 
## [[20]]
## [1] "Adolescent Psychology"
## 
## [[21]]
## character(0)
## 
## [[22]]
## [1] "Human Communication (KP)"
## 
## [[23]]
## [1] "Effective Speaking"
## 
## [[24]]
## [1] "Professional Communication"
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Public and Community Health`=case_when(
   # `Public and Community Health`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:16] ~"Required",
    Section %in% crs.df$Section[17:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Public and Community Health`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Public and Community Health`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Public and Community Health [3]
##   `Public and Community Health`     n
##   <chr>                         <int>
## 1 Elective                          5
## 2 Required                         16
## 3 <NA>                            992
```


















## Criminal Justice


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/criminal-justice-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "CJ101"   "CJ201"   "CJ213"   "CJ312"   "CJ313"   "CJ316"   "CJ323"  
##  [8] "CJ331"   "CJ441"   "CJ442"   "CJ443"   "CJ444"   "LS204"   "LS311"  
## [15] "MATH208" "POLS201" "SOC101"  "LS101"   "POLS101"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Introduction to Criminal Justice (KP)"
## 
## [[3]]
## [1] "Criminology"
## 
## [[4]]
## [1] "Ethics in Criminal Justice"
## 
## [[5]]
## [1] "Corrections"
## 
## [[6]]
## [1] "Police & Society"
## 
## [[7]]
## [1] "Criminal Procedure"
## 
## [[8]]
## [1] "Justice, Class, Race & Gender"
## 
## [[9]]
## [1] "Research Methods in Criminal Justice"
## 
## [[10]]
## [1] "Topics in Crime & Public Policy I"
## 
## [[11]]
## [1] "Topics in Crime & Public Policy II"
## 
## [[12]]
## [1] "Justice Studies Internship & Seminar I"
## 
## [[13]]
## [1] "Justice Studies Internship & Seminar II"
## 
## [[14]]
## [1] "Criminal Law"
## 
## [[15]]
## [1] "The American Court System"
## 
## [[16]]
## [1] "Statistics"
## 
## [[17]]
## [1] "State & Local Government"
## 
## [[18]]
## [1] "Sociological Imagination (KP)"
## 
## [[19]]
## character(0)
## 
## [[20]]
## [1] "Foundations of American Legal System(KP)"
## 
## [[21]]
## [1] "American Government"
## 
## [[22]]
## character(0)
## 
## [[23]]
## character(0)
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Criminal Justice`=case_when(
   # `Criminal Justice`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:17] ~"Required",
    Section %in% crs.df$Section[18:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Criminal Justice`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Criminal Justice`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Criminal Justice [3]
##   `Criminal Justice`     n
##   <chr>              <int>
## 1 Elective               2
## 2 Required              17
## 3 <NA>                 994
```

















## Early Childhood Education


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/education21-22/early-childhood-education-(pre-kindergarten-grade-2)-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "ED109"   "ED110"   "ED206"   "ED208"   "ED219"   "ED309"   "ED327"  
##  [8] "ED335"   "ED338"   "ED342"   "ED417"   "ED420"   "ED421"   "ED494"  
## [15] "ED496"   "ENG208"  "ENG209"  "MATH107" "MATH304" "PSYC101" "PSYC221"
## [22] "SCI103"  "SCI104"  "ENG210"  "ENG211"  "ENG218"  "ENG222"  "ENG225" 
## [29] "ENG340"  "HIST123" "HIST124"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Invitation to Teaching"
## 
## [[3]]
## [1] "Teaching & Learning in American Schools"
## 
## [[4]]
## [1] "Early Literacy Teaching & Learning"
## 
## [[5]]
## [1] "Elem Literacy Teaching & Learning"
## 
## [[6]]
## [1] "Supporting Learner Variability"
## 
## [[7]]
## [1] "Sheltered English Immersion"
## 
## [[8]]
## [1] "Literacy Assessment & Instruction"
## 
## [[9]]
## [1] "Teaching Mathematics: PK - 2"
## 
## [[10]]
## [1] "Inclusive Education"
## 
## [[11]]
## [1] "Teaching Science Concepts: PK - 2"
## 
## [[12]]
## [1] "Pre-Practicum: PK - Grade 2"
## 
## [[13]]
## [1] "Integrated Instruction: PK - Grade 2"
## 
## [[14]]
## [1] "Curriculum Integration"
## 
## [[15]]
## [1] "Professional Standards & Ethics"
## 
## [[16]]
## [1] "Practicum: Early Childhood"
## 
## [[17]]
## [1] "The Structure of the English Language"
## 
## [[18]]
## [1] "Intro to Literature & Literary Studies"
## 
## [[19]]
## [1] "College Geometry"
## 
## [[20]]
## [1] "Mathematics for Educators"
## 
## [[21]]
## [1] "Psychological Perspectives (KP)"
## 
## [[22]]
## [1] "Child Development"
## 
## [[23]]
## [1] "Science for Educators I (KP)"
## 
## [[24]]
## [1] "Science for Educators II (KP)"
## 
## [[25]]
## character(0)
## 
## [[26]]
## [1] "Survey of American Literature (KP)"
## 
## [[27]]
## [1] "Modern Drama"
## 
## [[28]]
## [1] "British Literature (KP)"
## 
## [[29]]
## [1] "Lyric Poetry"
## 
## [[30]]
## [1] "The Short Story (KP)"
## 
## [[31]]
## [1] "Classics of World Literature"
## 
## [[32]]
## character(0)
## 
## [[33]]
## [1] "American Civilization I"
## 
## [[34]]
## [1] "American Civilization II"
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
## 
## [[41]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Early Childhood Education`=case_when(
   # `Early Childhood Education`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:23] ~"Required",
    Section %in% crs.df$Section[24:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Early Childhood Education`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Early Childhood Education`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Early Childhood Education [3]
##   `Early Childhood Education`     n
##   <chr>                       <int>
## 1 Elective                        8
## 2 Required                       23
## 3 <NA>                          982
```
















## Elementary Education


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/education21-22/elementary-education-(grades-1-6)21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "ED109"   "ED110"   "ED206"   "ED208"   "ED219"   "ED309"   "ED327"  
##  [8] "ED337"   "ED338"   "ED344"   "ED418"   "ED419"   "ED421"   "ED494"  
## [15] "ED498"   "ENG208"  "ENG209"  "MATH107" "MATH304" "PSYC101" "PSYC221"
## [22] "SCI103"  "SCI104"  "ENG210"  "ENG211"  "ENG218"  "ENG222"  "ENG225" 
## [29] "ENG340"  "HIST123" "HIST124"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Invitation to Teaching"
## 
## [[3]]
## [1] "Teaching & Learning in American Schools"
## 
## [[4]]
## [1] "Early Literacy Teaching & Learning"
## 
## [[5]]
## [1] "Elem Literacy Teaching & Learning"
## 
## [[6]]
## [1] "Supporting Learner Variability"
## 
## [[7]]
## [1] "Sheltered English Immersion"
## 
## [[8]]
## [1] "Literacy Assessment & Instruction"
## 
## [[9]]
## [1] "Teaching & Applying Mathematics: 1 - 6"
## 
## [[10]]
## [1] "Inclusive Education"
## 
## [[11]]
## [1] "Science Concepts & Curriculum: 1-6"
## 
## [[12]]
## [1] "Integrated Instruction: Elementary: 1-6"
## 
## [[13]]
## [1] "Pre-Practicum: Elementary (1 - 6)"
## 
## [[14]]
## [1] "Curriculum Integration"
## 
## [[15]]
## [1] "Professional Standards & Ethics"
## 
## [[16]]
## [1] "Practicum: Elementary (1 -6)"
## 
## [[17]]
## [1] "The Structure of the English Language"
## 
## [[18]]
## [1] "Intro to Literature & Literary Studies"
## 
## [[19]]
## [1] "College Geometry"
## 
## [[20]]
## [1] "Mathematics for Educators"
## 
## [[21]]
## [1] "Psychological Perspectives (KP)"
## 
## [[22]]
## [1] "Child Development"
## 
## [[23]]
## [1] "Science for Educators I (KP)"
## 
## [[24]]
## [1] "Science for Educators II (KP)"
## 
## [[25]]
## character(0)
## 
## [[26]]
## [1] "Survey of American Literature (KP)"
## 
## [[27]]
## [1] "Modern Drama"
## 
## [[28]]
## [1] "British Literature (KP)"
## 
## [[29]]
## [1] "Lyric Poetry"
## 
## [[30]]
## [1] "The Short Story (KP)"
## 
## [[31]]
## [1] "Classics of World Literature"
## 
## [[32]]
## character(0)
## 
## [[33]]
## [1] "American Civilization I"
## 
## [[34]]
## [1] "American Civilization II"
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
## 
## [[41]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Elementary Education`=case_when(
   # `Elementary Education`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:23] ~"Required",
    Section %in% crs.df$Section[24:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Elementary Education`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Elementary Education`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Elementary Education [3]
##   `Elementary Education`     n
##   <chr>                  <int>
## 1 Elective                   8
## 2 Required                  23
## 3 <NA>                     982
```




















## Secondary Education and English


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/education21-22/secondary-education-major-(grades-5-12)-and-english-major-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "ENG208"  "ENG209"  "ENG210"  "ENG218"  "ENG304"  "ENG312"  "ENG313" 
##  [8] "HUM419"  "HUM420"  "ED109"   "ED110"   "ED210"   "ED219"   "ED308"  
## [15] "ED309"   "ED433"   "ED482"   "ENG212"  "PSYC101" "PSYC223" "ENG211" 
## [22] "ENG214"  "ENG216"  "ENG217"  "ENG222"  "ENG224"  "ENG225"  "ENG340"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "The Structure of the English Language"
## 
## [[3]]
## [1] "Intro to Literature & Literary Studies"
## 
## [[4]]
## [1] "Survey of American Literature (KP)"
## 
## [[5]]
## [1] "British Literature (KP)"
## 
## [[6]]
## [1] "Stories of Origin"
## 
## [[7]]
## [1] "Literature of Postcolonial World"
## 
## [[8]]
## [1] "American Multiethnic Literature"
## 
## [[9]]
## [1] "Seminar in Hum: Readings & Research"
## 
## [[10]]
## [1] "Seminar in Humanities"
## 
## [[11]]
## character(0)
## 
## [[12]]
## [1] "Invitation to Teaching"
## 
## [[13]]
## [1] "Teaching & Learning in American Schools"
## 
## [[14]]
## [1] "Reading & Writing Across the Curriculum "
## 
## [[15]]
## [1] "Supporting Learner Variability"
## 
## [[16]]
## [1] "Responsive Teaching in Secondary Schools"
## 
## [[17]]
## [1] "Sheltered English Immersion"
## 
## [[18]]
## [1] "Pre-practicum: Secondary English"
## 
## [[19]]
## [1] "Practicum: Secondary English"
## 
## [[20]]
## [1] "Literature for Young Adults"
## 
## [[21]]
## [1] "Psychological Perspectives (KP)"
## 
## [[22]]
## [1] "Adolescent Psychology"
## 
## [[23]]
## character(0)
## 
## [[24]]
## [1] "Modern Drama"
## 
## [[25]]
## [1] "Special Topics in Literature"
## 
## [[26]]
## [1] "The Mystery Novel"
## 
## [[27]]
## [1] "Contemporary Global Literature (KP)"
## 
## [[28]]
## [1] "Lyric Poetry"
## 
## [[29]]
## [1] "Film & Literature"
## 
## [[30]]
## [1] "The Short Story (KP)"
## 
## [[31]]
## [1] "Classics of World Literature"
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Secondary Education and English`=case_when(
   # `Secondary Education and English`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:20] ~"Required",
    Section %in% crs.df$Section[21:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Secondary Education and English`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Secondary Education and English`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Secondary Education and English [3]
##   `Secondary Education and English`     n
##   <chr>                             <int>
## 1 Elective                              8
## 2 Required                             20
## 3 <NA>                                985
```















## Secondary Education and History


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/education21-22/secondary-education-major-(grades-5-12)and-history-major-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "HIST103" "HIST104" "HIST123" "HIST124" "HIST352" "HIST400" "HIST401"
##  [8] "POLS101" "SOC101"  "HIST207" "HIST209" "HIST210" "HIST211" "HIST212"
## [15] "ECON101" "ECON103" "ED109"   "ED110"   "ED210"   "ED219"   "ED308"  
## [22] "ED309"   "ED435"   "ED484"   "ENG212"  "PSYC101" "PSYC223"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "World Civilization I"
## 
## [[3]]
## [1] "World Civ II: "
## 
## [[4]]
## [1] "American Civilization I"
## 
## [[5]]
## [1] "American Civilization II"
## 
## [[6]]
## [1] "Nature & Meaning of History"
## 
## [[7]]
## [1] "Individual Seminar in Reading & Research"
## 
## [[8]]
## [1] "Tutorial in History"
## 
## [[9]]
## [1] "American Government"
## 
## [[10]]
## [1] "Sociological Imagination (KP)"
## 
## [[11]]
## character(0)
## 
## [[12]]
## [1] "African American History"
## 
## [[13]]
## [1] "China from 1600 to Present"
## 
## [[14]]
## [1] "Latin Amer Colonial Period to Present"
## 
## [[15]]
## [1] "Middle East & Islamic World Since 1800"
## 
## [[16]]
## [1] "Mod Japan: Culture & History"
## 
## [[17]]
## character(0)
## 
## [[18]]
## [1] "Principles of Econ-Micro"
## 
## [[19]]
## [1] "Economics of Social Issues"
## 
## [[20]]
## character(0)
## 
## [[21]]
## [1] "Invitation to Teaching"
## 
## [[22]]
## [1] "Teaching & Learning in American Schools"
## 
## [[23]]
## [1] "Reading & Writing Across the Curriculum "
## 
## [[24]]
## [1] "Supporting Learner Variability"
## 
## [[25]]
## [1] "Responsive Teaching in Secondary Schools"
## 
## [[26]]
## [1] "Sheltered English Immersion"
## 
## [[27]]
## [1] "Pre-practicum: Secondary History"
## 
## [[28]]
## [1] "Practicum: Secondary History"
## 
## [[29]]
## [1] "Literature for Young Adults"
## 
## [[30]]
## [1] "Psychological Perspectives (KP)"
## 
## [[31]]
## [1] "Adolescent Psychology"
## 
## [[32]]
## character(0)
## 
## [[33]]
## character(0)
## 
## [[34]]
## character(0)
## 
## [[35]]
## character(0)
## 
## [[36]]
## character(0)
## 
## [[37]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Secondary Education and History`=case_when(
   # `Secondary Education and History`=="C"~"Core", #hide for not-existing major
    Section %in% c(crs.df$Section[1:9],crs.df$Section[17:length(crs.df$Section)]) ~"Required",
    Section %in% crs.df$Section[10:16] ~"Elective"))#%>%group_by(`Secondary Education and History`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Secondary Education and History`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Secondary Education and History [3]
##   `Secondary Education and History`     n
##   <chr>                             <int>
## 1 Elective                              7
## 2 Required                             20
## 3 <NA>                                986
```











## Education, Curriculum and Instruction


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/education21-22/interdisciplinary-studies-education-curriculum-and-instruction-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "COM103"  "ENG208"  "HIST104" "MATH107" "PSYC101" "SCI104"  "SOC101" 
##  [8] "ED109"   "ED110"   "ED206"   "ED208"   "ED219"   "ED330"   "ED413"  
## [15] "ED427"   "ENG210"  "ENG218"  "ENG340"  "HIST123" "HIST124" "BIO101" 
## [22] "BIO102"  "BIO205"  "BIO206"  "CHEM203" "CHEM204" "PHYS111" "PHYS112"
## [29] "SCI103"  "PSYC221" "PSYC223"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Human Communication (KP)"
## 
## [[3]]
## [1] "The Structure of the English Language"
## 
## [[4]]
## [1] "World Civ II: "
## 
## [[5]]
## [1] "College Geometry"
## 
## [[6]]
## [1] "Psychological Perspectives (KP)"
## 
## [[7]]
## [1] "Science for Educators II (KP)"
## 
## [[8]]
## [1] "Sociological Imagination (KP)"
## 
## [[9]]
## character(0)
## 
## [[10]]
## [1] "Invitation to Teaching"
## 
## [[11]]
## [1] "Teaching & Learning in American Schools"
## 
## [[12]]
## [1] "Early Literacy Teaching & Learning"
## 
## [[13]]
## [1] "Elem Literacy Teaching & Learning"
## 
## [[14]]
## [1] "Supporting Learner Variability"
## 
## [[15]]
## [1] "Pre-Internship Seminar"
## 
## [[16]]
## [1] "Prof, Respon, & Ethics in Curr Instr"
## 
## [[17]]
## [1] "Curriculum & Instruction Internship"
## 
## [[18]]
## character(0)
## 
## [[19]]
## [1] "Survey of American Literature (KP)"
## 
## [[20]]
## [1] "British Literature (KP)"
## 
## [[21]]
## [1] "Classics of World Literature"
## 
## [[22]]
## character(0)
## 
## [[23]]
## [1] "American Civilization I"
## 
## [[24]]
## [1] "American Civilization II"
## 
## [[25]]
## character(0)
## 
## [[26]]
## [1] "Principles of Biology I (KP)"
## 
## [[27]]
## [1] "Principles of Biology II (KP)"
## 
## [[28]]
## [1] "Anatomy & Physiology I"
## 
## [[29]]
## [1] "Anatomy & Physiology II"
## 
## [[30]]
## [1] "General Chemistry I (KP)"
## 
## [[31]]
## [1] "General Chemistry II"
## 
## [[32]]
## [1] "General Physics I (KP)"
## 
## [[33]]
## [1] "General Physics II (KP)"
## 
## [[34]]
## [1] "Science for Educators I (KP)"
## 
## [[35]]
## character(0)
## 
## [[36]]
## [1] "Child Development"
## 
## [[37]]
## [1] "Adolescent Psychology"
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
## 
## [[40]]
## character(0)
## 
## [[41]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Education, Curriculum and Instruction`=case_when(
   # `Education, Curriculum and Instruction`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:15] ~"Required",
    Section %in% crs.df$Section[16:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Education, Curriculum and Instruction`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Education, Curriculum and Instruction`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Education, Curriculum and Instruction [3]
##   `Education, Curriculum and Instruction`     n
##   <chr>                                   <int>
## 1 Elective                                   16
## 2 Required                                   15
## 3 <NA>                                      982
```




















## English


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/english-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "ENG209" "ENG210" "ENG218" "HUM103" "HUM399" "HUM400" "ENG304" "ENG307"
##  [9] "ENG308" "ENG310" "ENG312" "ENG313" "ENG340" "ENG312" "ENG313" "ENG402"
## [17] "HUM419" "HUM420"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Intro to Literature & Literary Studies"
## 
## [[3]]
## [1] "Survey of American Literature (KP)"
## 
## [[4]]
## [1] "British Literature (KP)"
## 
## [[5]]
## [1] "Invitation to the Humanities"
## 
## [[6]]
## [1] "Humanities Internship Seminar"
## 
## [[7]]
## [1] "Humanities Field Experience"
## 
## [[8]]
## character(0)
## 
## [[9]]
## [1] "Stories of Origin"
## 
## [[10]]
## [1] "Creative Nonfiction Writing Workshop"
## 
## [[11]]
## [1] "Fiction Writing Workshop"
## 
## [[12]]
## [1] "Poetry Writing Workshop"
## 
## [[13]]
## [1] "Literature of Postcolonial World"
## 
## [[14]]
## [1] "American Multiethnic Literature"
## 
## [[15]]
## [1] "Classics of World Literature"
## 
## [[16]]
## character(0)
## 
## [[17]]
## [1] "Literature of Postcolonial World"
## 
## [[18]]
## [1] "American Multiethnic Literature"
## 
## [[19]]
## character(0)
## 
## [[20]]
## [1] "Advanced Writing Workshop"
## 
## [[21]]
## [1] "Seminar in Hum: Readings & Research"
## 
## [[22]]
## [1] "Seminar in Humanities"
## 
## [[23]]
## character(0)
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`English`=case_when(
   # `English`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:6] ~"Required",
    Section %in% crs.df$Section[7:length(crs.df$Section)] ~"Elective"))#%>%group_by(`English`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`English`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   English [3]
##   English      n
##   <chr>    <int>
## 1 Elective    10
## 2 Required     6
## 3 <NA>       998
```





















## Global Studies


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/global-studies-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "COM212"   "ECON206"  "ENG312"   "GLBS200X" "GLBS223"  "GLBS400" 
##  [7] "GLBS401"  "HUM399"   "HUM400"   "MATH208"  "POLS208"  "SOC102"  
## [13] "SOC212"   "HIST327X" "PHIL106"  "PHIL208"  "CJ103"    "COM308"  
## [19] "HIST105"  "HON150"   "BIO117"   "ENV201"   "ENV211"   "CJ323"   
## [25] "ENG217"   "ENG304"   "ENG340"   "HIST103"  "HIST209"  "HIST212" 
## [31] "HIST218"  "HIST323"  "PSYC308"  "PSYC316"  "SOC301"   "BUSS237" 
## [37] "BUSS315"  "BUSS332"  "CJ211"    "CJ305"    "CJ314"    "CJ315"   
## [43] "CJ317"    "COM308"   "COM329X"  "GLBS323X" "SOC223"   "SOC307"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Intercultural Communication"
## 
## [[3]]
## [1] "Global Economic Development"
## 
## [[4]]
## [1] "Literature of Postcolonial World"
## 
## [[5]]
## [1] "A Traveler's Guide to Global Studies"
## 
## [[6]]
## [1] "Special Topics in Global History"
## 
## [[7]]
## [1] "Reading & Research in Global Studies"
## 
## [[8]]
## [1] "Capstone in Global Studies"
## 
## [[9]]
## [1] "Humanities Internship Seminar"
## 
## [[10]]
## [1] "Humanities Field Experience"
## 
## [[11]]
## [1] "Statistics"
## 
## [[12]]
## [1] "Contemporary International Relations"
## 
## [[13]]
## [1] "Women and Gender in Social Context(KP)"
## 
## [[14]]
## [1] "Wellness & Society"
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Intelluctual Origins of Eastern Civ"
## 
## [[17]]
## [1] "World Religions"
## 
## [[18]]
## [1] "Knowing & Reality"
## 
## [[19]]
## character(0)
## 
## [[20]]
## [1] "Principles of Human Rights"
## 
## [[21]]
## [1] "Conflict Resolution & Negotiations"
## 
## [[22]]
## [1] "History of Human Rights"
## 
## [[23]]
## [1] "Spring Intro Seminar"
## 
## [[24]]
## character(0)
## 
## [[25]]
## [1] "Marine Biology (KP)"
## 
## [[26]]
## [1] "Environmental Law & Policy"
## 
## [[27]]
## [1] "Environmental Science (KP)"
## 
## [[28]]
## character(0)
## 
## [[29]]
## [1] "Justice, Class, Race & Gender"
## 
## [[30]]
## [1] "Contemporary Global Literature (KP)"
## 
## [[31]]
## [1] "Stories of Origin"
## 
## [[32]]
## [1] "Classics of World Literature"
## 
## [[33]]
## [1] "World Civilization I"
## 
## [[34]]
## [1] "China from 1600 to Present"
## 
## [[35]]
## [1] "Mod Japan: Culture & History"
## 
## [[36]]
## [1] "Global History of Childhood"
## 
## [[37]]
## [1] "Special Topics in Global History"
## 
## [[38]]
## [1] "Black Psychology"
## 
## [[39]]
## [1] "Psychology of Diversity"
## 
## [[40]]
## [1] "Race & Ethnicity"
## 
## [[41]]
## character(0)
## 
## [[42]]
## [1] "Global Leadership"
## 
## [[43]]
## [1] "Emerging Global Markets"
## 
## [[44]]
## [1] "Cross Cultural Management"
## 
## [[45]]
## [1] "Terrorism"
## 
## [[46]]
## [1] "Crime & Popular Culture"
## 
## [[47]]
## [1] "White Collar and Organized Crime"
## 
## [[48]]
## [1] "Global Technology & Crime"
## 
## [[49]]
## [1] "Comparative Justice Systems"
## 
## [[50]]
## [1] "Conflict Resolution & Negotiations"
## 
## [[51]]
## [1] "Marketing Communications for Non Profits"
## 
## [[52]]
## [1] "Special Topics in Global History"
## 
## [[53]]
## [1] "Social Movements"
## 
## [[54]]
## [1] "Action & Social Justice"
## 
## [[55]]
## character(0)
## 
## [[56]]
## character(0)
## 
## [[57]]
## character(0)
## 
## [[58]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Global Studies`=case_when(
   # `Global Studies`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:13] ~"Required",
    Section %in% crs.df$Section[14:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Global Studies`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Global Studies`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Global Studies [3]
##   `Global Studies`     n
##   <chr>            <int>
## 1 Elective            34
## 2 Required            13
## 3 <NA>               976
```





















## History


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/history-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "HIST103" "HIST352" "HIST400" "HIST401" "HUM103"  "HUM399"  "HUM400" 
##  [8] "PHIL101" "HIST123" "HIST124" "HIST203" "HIST204" "HIST207" "HIST210"
## [15] "HIST208" "HIST209" "HIST211" "HIST212"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "World Civilization I"
## 
## [[3]]
## [1] "Nature & Meaning of History"
## 
## [[4]]
## [1] "Individual Seminar in Reading & Research"
## 
## [[5]]
## [1] "Tutorial in History"
## 
## [[6]]
## [1] "Invitation to the Humanities"
## 
## [[7]]
## [1] "Humanities Internship Seminar"
## 
## [[8]]
## [1] "Humanities Field Experience"
## 
## [[9]]
## [1] "Introduction to Philosophy"
## 
## [[10]]
## character(0)
## 
## [[11]]
## [1] "American Civilization I"
## 
## [[12]]
## [1] "American Civilization II"
## 
## [[13]]
## [1] "The History of Women in U.S."
## 
## [[14]]
## [1] "Recent American History"
## 
## [[15]]
## [1] "African American History"
## 
## [[16]]
## [1] "Latin Amer Colonial Period to Present"
## 
## [[17]]
## character(0)
## 
## [[18]]
## [1] "Sub-Saharan Africa after 1800"
## 
## [[19]]
## [1] "China from 1600 to Present"
## 
## [[20]]
## [1] "Middle East & Islamic World Since 1800"
## 
## [[21]]
## [1] "Mod Japan: Culture & History"
## 
## [[22]]
## character(0)
## 
## [[23]]
## character(0)
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`History`=case_when(
   # `History`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:8] ~"Required",
    Section %in% crs.df$Section[9:length(crs.df$Section)] ~"Elective"))#%>%group_by(`History`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`History`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   History [3]
##   History      n
##   <chr>    <int>
## 1 Elective    10
## 2 Required     8
## 3 <NA>      1005
```























## Law and Public Affairs


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/law-and-public-affairs-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "CJ323"   "COM308"  "COM310"  "LS101"   "LS202"   "LS203"   "LS301"  
##  [8] "LS441"   "LS442"   "LS443"   "LS444"   "POLS101" "POLS201" "POLS210"
## [15] "POLS320" "SOC101"  "SOC221"  "CJ317"   "LS305"   "POLS208"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Justice, Class, Race & Gender"
## 
## [[3]]
## [1] "Conflict Resolution & Negotiations"
## 
## [[4]]
## [1] "Political Communication"
## 
## [[5]]
## [1] "Foundations of American Legal System(KP)"
## 
## [[6]]
## [1] "Legal Research & Analysis"
## 
## [[7]]
## [1] "Justice, Law & the Constitution"
## 
## [[8]]
## [1] "Legal Writing & Reasoning"
## 
## [[9]]
## [1] "Selected Topics in Justice & Law I"
## 
## [[10]]
## [1] "Selected Topics in Justice & Law II"
## 
## [[11]]
## [1] "Justice Studies Internship & Seminar I"
## 
## [[12]]
## [1] "Justice Studies Internship & Seminar II"
## 
## [[13]]
## [1] "American Government"
## 
## [[14]]
## [1] "State & Local Government"
## 
## [[15]]
## [1] "Political Theory"
## 
## [[16]]
## [1] "Policy Making & the Political Process"
## 
## [[17]]
## [1] "Sociological Imagination (KP)"
## 
## [[18]]
## [1] "Contemporary Social Problems"
## 
## [[19]]
## character(0)
## 
## [[20]]
## [1] "Comparative Justice Systems"
## 
## [[21]]
## [1] "Comparative Law & Legal Systems"
## 
## [[22]]
## [1] "Contemporary International Relations"
## 
## [[23]]
## character(0)
## 
## [[24]]
## character(0)
## 
## [[25]]
## character(0)
## 
## [[26]]
## character(0)
## 
## [[27]]
## character(0)
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Law and Public Affairs`=case_when(
   # `Law and Public Affairs`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:17] ~"Required",
    Section %in% crs.df$Section[18:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Law and Public Affairs`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Law and Public Affairs`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Law and Public Affairs [3]
##   `Law and Public Affairs`     n
##   <chr>                    <int>
## 1 Elective                     3
## 2 Required                    17
## 3 <NA>                      1003
```














## Legal Studies


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/legal-studies-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "LS101"   "LS202"   "LS203"   "LS301"   "LS325"   "LS441"   "LS442"  
##  [8] "LS443"   "LS444"   "POLS101" "POLS201" "POLS210" "SOC101"  "CJ323"  
## [15] "POLS202" "PSYC316" "SOC221"  "SOC301"  "CJ101"   "CJ201"   "CJ202"  
## [22] "CJ203"   "CJ205"   "CJ206"   "CJ207"   "CJ210"   "CJ303"   "CJ305"  
## [29] "CJ309"   "CJ312"   "CJ313"   "CJ314"   "CJ315"   "CJ316"   "CJ317"  
## [36] "CJ318"   "CJ319"   "CJ321"   "CJ335"   "LS204"   "LS210"   "LS213"  
## [43] "LS214"   "LS215"   "LS304"   "LS305"   "LS307"   "LS311"   "LS320"  
## [50] "POLS202" "POLS208" "POLS302" "POLS303" "POLS320"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Foundations of American Legal System(KP)"
## 
## [[3]]
## [1] "Legal Research & Analysis"
## 
## [[4]]
## [1] "Justice, Law & the Constitution"
## 
## [[5]]
## [1] "Legal Writing & Reasoning"
## 
## [[6]]
## [1] "Evidence"
## 
## [[7]]
## [1] "Selected Topics in Justice & Law I"
## 
## [[8]]
## [1] "Selected Topics in Justice & Law II"
## 
## [[9]]
## [1] "Justice Studies Internship & Seminar I"
## 
## [[10]]
## [1] "Justice Studies Internship & Seminar II"
## 
## [[11]]
## [1] "American Government"
## 
## [[12]]
## [1] "State & Local Government"
## 
## [[13]]
## [1] "Political Theory"
## 
## [[14]]
## [1] "Sociological Imagination (KP)"
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Justice, Class, Race & Gender"
## 
## [[17]]
## [1] "Issues in Contemporary Political Thought"
## 
## [[18]]
## [1] "Psychology of Diversity"
## 
## [[19]]
## [1] "Contemporary Social Problems"
## 
## [[20]]
## [1] "Race & Ethnicity"
## 
## [[21]]
## character(0)
## 
## [[22]]
## [1] "Introduction to Criminal Justice (KP)"
## 
## [[23]]
## [1] "Criminology"
## 
## [[24]]
## [1] "Juvenile Justice"
## 
## [[25]]
## [1] "Juvenile Delinquency & Gangs"
## 
## [[26]]
## [1] "Forensic Science I"
## 
## [[27]]
## [1] "Drugs & Society"
## 
## [[28]]
## [1] "Criminal Investigations"
## 
## [[29]]
## [1] "Special Topics in Criminal Justice"
## 
## [[30]]
## [1] "Domestic Violence"
## 
## [[31]]
## [1] "Crime & Popular Culture"
## 
## [[32]]
## [1] "Children & Violence"
## 
## [[33]]
## [1] "Corrections"
## 
## [[34]]
## [1] "Police & Society"
## 
## [[35]]
## [1] "White Collar and Organized Crime"
## 
## [[36]]
## [1] "Global Technology & Crime"
## 
## [[37]]
## [1] "Criminal Procedure"
## 
## [[38]]
## [1] "Comparative Justice Systems"
## 
## [[39]]
## [1] "Violence & Aggression"
## 
## [[40]]
## [1] "Victimology"
## 
## [[41]]
## [1] "Probation, Parole & Other Sanctions"
## 
## [[42]]
## [1] "Sexual Violence Advocacy "
## 
## [[43]]
## [1] "Criminal Law"
## 
## [[44]]
## [1] "Special Topics in Legal Studies"
## 
## [[45]]
## [1] "Mock Trial Practicum I"
## 
## [[46]]
## [1] "Communication Law"
## 
## [[47]]
## [1] "Entertainment Law "
## 
## [[48]]
## [1] "Litigation Practice"
## 
## [[49]]
## [1] "Comparative Law & Legal Systems"
## 
## [[50]]
## [1] "Tort & Personal Injury Law"
## 
## [[51]]
## [1] "The American Court System"
## 
## [[52]]
## [1] "Philosophy of Law"
## 
## [[53]]
## [1] "Issues in Contemporary Political Thought"
## 
## [[54]]
## [1] "Contemporary International Relations"
## 
## [[55]]
## [1] "The Conspiracy in American Politics"
## 
## [[56]]
## [1] "The American Presidency"
## 
## [[57]]
## [1] "Policy Making & the Political Process"
## 
## [[58]]
## character(0)
## 
## [[59]]
## character(0)
## 
## [[60]]
## character(0)
## 
## [[61]]
## character(0)
## 
## [[62]]
## character(0)
## 
## [[63]]
## character(0)
## 
## [[64]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Legal Studies`=case_when(
   # `Legal Studies`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:13] ~"Required",
    Section %in% crs.df$Section[14:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Legal Studies`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Legal Studies`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Legal Studies [3]
##   `Legal Studies`     n
##   <chr>           <int>
## 1 Elective           40
## 2 Required           13
## 3 <NA>              971
```


















## Psychology


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/psychology-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "HS101"   "HS210"   "HS215"   "HS217"   "HS415"   "HS417"   "HS425"  
##  [8] "HS427"   "MATH208" "PSYC101" "PSYC220" "PSYC318" "SOC101"  "PSYC331"
## [15] "SOC331"  "PSYC302" "PSYC323" "PSYC202" "PSYC345" "PSYC111" "PSYC221"
## [22] "PSYC223" "PSYC226" "PSYC308" "PSYC316" "SOC301"  "ENG235"  "PSYC304"
## [29] "PSYC328"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Human Services: Systems & Skills"
## 
## [[3]]
## [1] "Case Management & Counseling"
## 
## [[4]]
## [1] "Foundation Internship"
## 
## [[5]]
## [1] "Foundations of Ethical Fieldwork"
## 
## [[6]]
## [1] "Advanced Internship I"
## 
## [[7]]
## [1] "Field Intervention Strategies"
## 
## [[8]]
## [1] "Advanced Internship II"
## 
## [[9]]
## [1] "Systems & Organizational Change"
## 
## [[10]]
## [1] "Statistics"
## 
## [[11]]
## [1] "Psychological Perspectives (KP)"
## 
## [[12]]
## [1] "Social Psychology"
## 
## [[13]]
## [1] "Abnormal Psychology"
## 
## [[14]]
## [1] "Sociological Imagination (KP)"
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Experimental Design in Psychology"
## 
## [[17]]
## [1] "Research Methods in the Social Sciences"
## 
## [[18]]
## character(0)
## 
## [[19]]
## [1] "Biological Basis of Behavior"
## 
## [[20]]
## [1] "Brain Function & Dysfunction"
## 
## [[21]]
## character(0)
## 
## [[22]]
## [1] "Psychology of Personality"
## 
## [[23]]
## [1] "Assessment of Individual Differences"
## 
## [[24]]
## character(0)
## 
## [[25]]
## [1] "Generations in America "
## 
## [[26]]
## [1] "Child Development"
## 
## [[27]]
## [1] "Adolescent Psychology"
## 
## [[28]]
## [1] "Living & Learning with Dementia"
## 
## [[29]]
## character(0)
## 
## [[30]]
## [1] "Black Psychology"
## 
## [[31]]
## [1] "Psychology of Diversity"
## 
## [[32]]
## [1] "Race & Ethnicity"
## 
## [[33]]
## character(0)
## 
## [[34]]
## [1] "From Sounds to Sentences"
## 
## [[35]]
## [1] "Sensation & Perception"
## 
## [[36]]
## [1] "Cognitive Processes"
## 
## [[37]]
## character(0)
## 
## [[38]]
## character(0)
## 
## [[39]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Psychology`=case_when(
   # `Psychology`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:13] ~"Required",
    Section %in% crs.df$Section[14:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Psychology`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Psychology`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Psychology [3]
##   Psychology     n
##   <chr>      <int>
## 1 Elective      16
## 2 Required      13
## 3 <NA>         996
```





















## Sociology


```r
#read html and parse it into R readable contents
pg<-read_html("https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-/sociology-21-22.html#tab-2")
#look at it (a list object that contains the tree-like structure)
pg
```

```
## {html_document}
## <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="font-shift">\r\n    \r\n    \r\n\r\n    \r\n\r\n    <div id= ...
```

```r
#search using css class as nodes
pg %>% html_nodes(".mp-modal")%>%html_text()#we must add a . before the class name
```

```
##  [1] "HS415"   "HS417"   "HS425"   "HS427"   "MATH208" "PSYC220" "SOC101" 
##  [8] "SOC221"  "SOC223"  "SOC301"  "SOC307"  "SOC310"  "SOC331"  "SOC102" 
## [15] "SOC214"  "ECON103" "SOC207"  "CJ303"   "ENV303"  "SOC212"  "BUSS224"
## [22] "BUSS334"
```

```r
####  
#read the table within html contents and save it as a tibble
crs.tbl<-pg %>% html_nodes(".mp-modal")%>%html_text()%>%as_tibble() #a tibble of 30 observation of 1 var

#make data frame with named col
crs.df<-data.frame(Section=crs.tbl$value)
#now we got the list of all html courses
```



```r
###make a list of titles
my.title<-c()#initialize a empty list
for (i in 1:(nrow(crs.df)+10) )  {#must (any calculation)  #depends on the number (i.e., n) of category/label in the table on web, there would needs to be n+nrow to look at
  my.title[[i]]<-#have to use [[]] to indicate the list index
    pg%>%html_nodes(
    xpath=paste0("/html/body/div[1]/main/div/div/div[1]/div/div/div/div[2]/div[1]/table/tbody/tr[",i,"]/td[2]"#paste the xpath using i
      )) %>% html_text()# print out corresponding text to nodes
  i<-i+1 #add one to go to next index
}
#check
my.title
```

```
## [[1]]
## character(0)
## 
## [[2]]
## [1] "Advanced Internship I"
## 
## [[3]]
## [1] "Field Intervention Strategies"
## 
## [[4]]
## [1] "Advanced Internship II"
## 
## [[5]]
## [1] "Systems & Organizational Change"
## 
## [[6]]
## [1] "Statistics"
## 
## [[7]]
## [1] "Social Psychology"
## 
## [[8]]
## [1] "Sociological Imagination (KP)"
## 
## [[9]]
## [1] "Contemporary Social Problems"
## 
## [[10]]
## [1] "Social Movements"
## 
## [[11]]
## [1] "Race & Ethnicity"
## 
## [[12]]
## [1] "Action & Social Justice"
## 
## [[13]]
## [1] "Sociological Perspectives"
## 
## [[14]]
## [1] "Research Methods in the Social Sciences"
## 
## [[15]]
## character(0)
## 
## [[16]]
## [1] "Women and Gender in Social Context(KP)"
## 
## [[17]]
## [1] "Family Diversity"
## 
## [[18]]
## character(0)
## 
## [[19]]
## [1] "Economics of Social Issues"
## 
## [[20]]
## [1] "Wealth & Poverty"
## 
## [[21]]
## character(0)
## 
## [[22]]
## [1] "Domestic Violence"
## 
## [[23]]
## [1] "Environmental Justice"
## 
## [[24]]
## [1] "Wellness & Society"
## 
## [[25]]
## character(0)
## 
## [[26]]
## [1] "Org Behavior in the Global Workplace"
## 
## [[27]]
## [1] "Nonprofit Management"
## 
## [[28]]
## character(0)
## 
## [[29]]
## character(0)
## 
## [[30]]
## character(0)
## 
## [[31]]
## character(0)
## 
## [[32]]
## character(0)
```

```r
#remove empty and null -- using any letters
my.title<-my.title[str_detect(my.title,"[A-Z][a-z]")]
```

```
## Warning in stri_detect_regex(string, pattern, negate = negate, opts_regex =
## opts(pattern)): argument is not an atomic vector; coercing
```

```r
########mutate title into crs.df
crs.df<-
  crs.df%>%mutate(`Course Title`=my.title)
```


```r
######append new coureses
#inspect - filter out not in the dat.major courese and new those courese as new.crs.df; remove the last label patterns using filter grepl
new.crs.df<-crs.df%>%filter((crs.df$Section %in% dat.major$Section ) == FALSE)

#append new.df with dat.major
dat.major<-plyr::join_all(list(dat.major,new.crs.df),type = "full")#add to 954
```

```
## Joining by: Section, Course Title
```

```r
######keep core course and recode
#recode using case_when (new var= old var name)
dat.major<-
  dat.major%>%mutate(`Sociology`=case_when(
   # `Sociology`=="C"~"Core", #hide for not-existing major
    Section %in% crs.df$Section[1:13] ~"Required",
    Section %in% crs.df$Section[14:length(crs.df$Section)] ~"Elective"))#%>%group_by(`Sociology`)%>%count()#check directly after mutate, before assign it to df

#check
dat.major%>%group_by(`Sociology`)%>%count()#non-existing major
```

```
## # A tibble: 3 × 2
## # Groups:   Sociology [3]
##   Sociology     n
##   <chr>     <int>
## 1 Elective      9
## 2 Required     13
## 3 <NA>       1003
```




# Select only col in the web major list


```r
#define col names
major.col<-colnames(dat.major)
#define major list (from website: https://www.lasell.edu/academics/academic-catalog-21-22/undergraduate-catalog-21-22/programs-of-study-.html)
major.list<-c("Accounting",
"Business Management",
"Entrepreneurship",
"Esports and Gaming Management",
"Event Management",
"Finance",
"Corporate Finance",
"Personal Finance",
"Hospitality Management",
"Human Resource Management",
"Marketing",
"Professional Sales",
"Resort and Casino Management",
"Sport Management",
"Supply Chain Management",
"Communication",
"Entertainment Media",
"Graphic Design",
"Journalism",
"Public Relations",
"Radio and Video Production",
"Sport Communication",
"Fashion Media and Marketing",
"Fashion Design and Production",
"Fashion Merchandising and Management",
"Applied Mathematics",
"Biochemistry",
"Biology",
"Cybersecurity",
"Data Analytics",
"Exercise Science",
"Fitness Management",
"Forensic Science",
"Health Science",
"Public and Community Health",
"Criminal Justice",
"Early Childhood Education",
"Elementary Education",
"Secondary Education and English",
"Secondary Education and History",
"Education, Curriculum and Instruction",
"English",
"Global Studies",
"History",
"Law & Public Affairs",
"Legal Studies",
"Psychology",
"Sociology")%>%as.vector()
```


```r
#check any character not match
major.list[(major.list%in%major.col)==FALSE]#none, all major list from web are mutated into the dat.major df
```

```
## character(0)
```

```r
#select
dat.48major<-dat.major%>%select(Section,`Course Title`,major.list[1:length(major.list)])
```



```r
#check Course Title for Newly Added Course IDs
dat.48major[is.na(dat.48major$`Course Title`),1]#all courses have a title now
```

```
## character(0)
```

```r
#check
str(dat.48major)
```

```
## 'data.frame':	1025 obs. of  50 variables:
##  $ Section                              : chr  "AHLT101" "AHLT104" "AHLT107" "AHLT201" ...
##  $ Course Title                         : chr  "Intro Allied Health & Sport Studies" "Prof Interactions And Ethics" "Lifestyles & Human Behavior" "Medical Pathology" ...
##  $ Accounting                           : chr  NA NA NA NA ...
##  $ Business Management                  : chr  NA NA NA NA ...
##  $ Entrepreneurship                     : chr  NA NA NA NA ...
##  $ Esports and Gaming Management        : chr  NA NA NA NA ...
##  $ Event Management                     : chr  NA NA NA NA ...
##  $ Finance                              : chr  NA NA NA NA ...
##  $ Corporate Finance                    : chr  NA NA NA NA ...
##  $ Personal Finance                     : chr  NA NA NA NA ...
##  $ Hospitality Management               : chr  NA NA NA NA ...
##  $ Human Resource Management            : chr  NA NA NA NA ...
##  $ Marketing                            : chr  NA NA NA NA ...
##  $ Professional Sales                   : chr  NA NA NA NA ...
##  $ Resort and Casino Management         : chr  NA NA NA NA ...
##  $ Sport Management                     : chr  NA NA NA NA ...
##  $ Supply Chain Management              : chr  NA NA NA NA ...
##  $ Communication                        : chr  NA NA NA NA ...
##  $ Entertainment Media                  : chr  NA NA NA NA ...
##  $ Graphic Design                       : chr  NA NA NA NA ...
##  $ Journalism                           : chr  NA NA NA NA ...
##  $ Public Relations                     : chr  NA NA NA NA ...
##  $ Radio and Video Production           : chr  NA NA NA NA ...
##  $ Sport Communication                  : chr  NA NA NA NA ...
##  $ Fashion Media and Marketing          : chr  NA NA NA NA ...
##  $ Fashion Design and Production        : chr  NA NA NA NA ...
##  $ Fashion Merchandising and Management : chr  NA NA NA NA ...
##  $ Applied Mathematics                  : chr  NA NA NA NA ...
##  $ Biochemistry                         : chr  NA NA NA NA ...
##  $ Biology                              : chr  NA NA NA NA ...
##  $ Cybersecurity                        : chr  NA NA NA NA ...
##  $ Data Analytics                       : chr  NA NA NA NA ...
##  $ Exercise Science                     : chr  NA NA NA NA ...
##  $ Fitness Management                   : chr  NA NA NA NA ...
##  $ Forensic Science                     : chr  NA NA NA NA ...
##  $ Health Science                       : chr  NA NA NA NA ...
##  $ Public and Community Health          : chr  NA NA NA NA ...
##  $ Criminal Justice                     : chr  NA NA NA NA ...
##  $ Early Childhood Education            : chr  NA NA NA NA ...
##  $ Elementary Education                 : chr  NA NA NA NA ...
##  $ Secondary Education and English      : chr  NA NA NA NA ...
##  $ Secondary Education and History      : chr  NA NA NA NA ...
##  $ Education, Curriculum and Instruction: chr  NA NA NA NA ...
##  $ English                              : chr  NA NA NA NA ...
##  $ Global Studies                       : chr  NA NA NA NA ...
##  $ History                              : chr  NA NA NA NA ...
##  $ Law & Public Affairs                 : chr  NA NA NA NA ...
##  $ Legal Studies                        : chr  NA NA NA NA ...
##  $ Psychology                           : chr  NA NA NA NA ...
##  $ Sociology                            : chr  NA NA NA NA ...
```

```r
summary(dat.48major)
```

```
##    Section          Course Title        Accounting        Business Management
##  Length:1025        Length:1025        Length:1025        Length:1025        
##  Class :character   Class :character   Class :character   Class :character   
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character   
##  Entrepreneurship   Esports and Gaming Management Event Management  
##  Length:1025        Length:1025                   Length:1025       
##  Class :character   Class :character              Class :character  
##  Mode  :character   Mode  :character              Mode  :character  
##    Finance          Corporate Finance  Personal Finance  
##  Length:1025        Length:1025        Length:1025       
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##  Hospitality Management Human Resource Management  Marketing        
##  Length:1025            Length:1025               Length:1025       
##  Class :character       Class :character          Class :character  
##  Mode  :character       Mode  :character          Mode  :character  
##  Professional Sales Resort and Casino Management Sport Management  
##  Length:1025        Length:1025                  Length:1025       
##  Class :character   Class :character             Class :character  
##  Mode  :character   Mode  :character             Mode  :character  
##  Supply Chain Management Communication      Entertainment Media
##  Length:1025             Length:1025        Length:1025        
##  Class :character        Class :character   Class :character   
##  Mode  :character        Mode  :character   Mode  :character   
##  Graphic Design      Journalism        Public Relations  
##  Length:1025        Length:1025        Length:1025       
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##  Radio and Video Production Sport Communication Fashion Media and Marketing
##  Length:1025                Length:1025         Length:1025                
##  Class :character           Class :character    Class :character           
##  Mode  :character           Mode  :character    Mode  :character           
##  Fashion Design and Production Fashion Merchandising and Management
##  Length:1025                   Length:1025                         
##  Class :character              Class :character                    
##  Mode  :character              Mode  :character                    
##  Applied Mathematics Biochemistry         Biology          Cybersecurity     
##  Length:1025         Length:1025        Length:1025        Length:1025       
##  Class :character    Class :character   Class :character   Class :character  
##  Mode  :character    Mode  :character   Mode  :character   Mode  :character  
##  Data Analytics     Exercise Science   Fitness Management Forensic Science  
##  Length:1025        Length:1025        Length:1025        Length:1025       
##  Class :character   Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
##  Health Science     Public and Community Health Criminal Justice  
##  Length:1025        Length:1025                 Length:1025       
##  Class :character   Class :character            Class :character  
##  Mode  :character   Mode  :character            Mode  :character  
##  Early Childhood Education Elementary Education Secondary Education and English
##  Length:1025               Length:1025          Length:1025                    
##  Class :character          Class :character     Class :character               
##  Mode  :character          Mode  :character     Mode  :character               
##  Secondary Education and History Education, Curriculum and Instruction
##  Length:1025                     Length:1025                          
##  Class :character                Class :character                     
##  Mode  :character                Mode  :character                     
##    English          Global Studies       History          Law & Public Affairs
##  Length:1025        Length:1025        Length:1025        Length:1025         
##  Class :character   Class :character   Class :character   Class :character    
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character    
##  Legal Studies       Psychology         Sociology        
##  Length:1025        Length:1025        Length:1025       
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character
```

```r
#save
write_xlsx(dat.48major,"/Users/linlizhou/Documents/LASELL/data/enrollment/21-22CourseRequirements.xlsx")
```

