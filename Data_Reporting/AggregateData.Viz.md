---
title: "CMarinExcercise"
author: "Linli Zhou"
date: "2022-08-29"
output: 
  html_document:
    keep_md: true
---

The dataset used for this project contains the number of students enrolling in their first English course at a university who enrolled in transfer-level or below transfer-level English by term and race/ethnicity. 

Context: Assembly Bill 705 (Title 5, § 55003 and 55522) requires all California Community Colleges to
design placement methods that maximize the probability that students will enter and complete
transfer-level coursework in English and math/quantitative reasoning within one year of their
first enrollment in the discipline. In the databset, the university's methods used to determine placement changed from a placement test in fall 2015 and 2016, to multiple measures in fall 2017 and 2018, to AB705 in fall 2019. 

Research Question" How did the change in placement methods impact placement into transfer-level English?







```r
data<-read_excel("/Users/linlizhou/Documents/LASELL/CMarinExcercise.xlsx",sheet = "raw")
```


```r
#transform pivot table into one observation each row
data.l<-pivot_longer(data,cols = `Fall 2015 (placement test)`:`Fall 2019 (AB705)`,names_to = "Term.Method",values_to = "NumberPlacement")
```


```r
#Year col
data.l<-data.l%>%mutate(Year=case_when(
  Term.Method=="Fall 2015 (placement test)"~"2015",
  Term.Method=="Fall 2016 (placement test)"~"2016",
  Term.Method=="Fall 2017 (Multiple measures)"~"2017",
  Term.Method=="Fall 2018 (Multiple measures)"~"2018",
  Term.Method=="Fall 2019 (AB705)"~"2019"
))

#method col
data.l<-data.l%>%mutate(Method=case_when(
  Term.Method=="Fall 2015 (placement test)"~"Placement test",
  Term.Method=="Fall 2016 (placement test)"~"Placement test",
  Term.Method=="Fall 2017 (Multiple measures)"~"Multiple measures",
  Term.Method=="Fall 2018 (Multiple measures)"~"Multiple measures",
  Term.Method=="Fall 2019 (AB705)"~"AB705"
))

#save raw and tidy sheets in the same excel workbook
write.xlsx(list("tidy"=data.l,"raw"=data), file="/Users/linlizhou/Documents/LASELL/CMarinExcercise.xlsx")
```


```r
data.l$Method=factor(data.l$Method, levels=c("Placement test","Multiple measures","AB705"),labels=c("Placement Test (2015/16)","Multiple Measures (2017/18)","AB705 (2019)")) #recode the levels  
```



```r
aggregate(data.l$NumberPlacement,by=list(Method=data.l$Method,Level=data.l$Course),FUN="sum")%>%#aggragated table with all vars needed
  group_by(Method)%>%mutate(prt=x/sum(x)) %>% #group by whatever is going to be the larger groups (adds up to 100%)
ggplot(aes(x=Level,y=percent(prt,digit=0),fill=Method))+
   geom_bar(stat="identity",position=position_dodge(),width = 0.8)+
  geom_text_repel(aes(label=percent(prt,digits=0)),color="black",size=4,position = position_dodge(width = 1),vjust=.9)+# hjust = 1.5 positions them inside the end of the bars. An hjust of 0.5 and a vjust of 0.5 center the box on the reference point. hjust=0, the left edge;;; For vertical, less is up and more is down
  theme_lz()+
    scale_fill_manual(values = c(mycolors[3],mycolors[2],mycolors[1]), name="Placement Methods")+#change legend color, lable, and title
  scale_y_continuous(breaks = seq(0, 0.3, by = 0.1) ,labels = scales::percent)+#present y axis label as percentage
  #geom_text_repel(aes(label= ifelse(Grade2System==4,paste(round(100*prt, 0), "%", sep=""),"")),size=3)+
  labs(x = "English Course Level", y = "", title="Students in Different English Courses by Placement Methods")+
   theme(axis.text.y=element_blank())
```

<img src="AggregateData.Viz_files/figure-html/within method-group-1.png" style="display: block; margin: auto;" />

Conclusion: Each time we change placement methods, there have been around 13% more students to
be placed into transfer level than below transfer English course. For example, the latest
placement methods (AB705) put 13% more students into transfer level English course
than its predecessors (Multiple Measures).




```r
aggregate(data.l$NumberPlacement,by=list(Method=data.l$Method,Level=data.l$Course, Race=data.l$Race),FUN="sum")%>%#aggragated table with all vars needed
  group_by(Method)%>%mutate(prt=x/sum(x)) %>% #group by whatever is going to be the larger groups (adds up to 100%)
ggplot(aes(x=Level,y=percent(prt,digit=0),fill=Method))+
   geom_bar(stat="identity",position=position_dodge(),width = 0.8)+
  facet_wrap(~Race,ncol=2)+
  #geom_text_repel(aes(label=percent(prt,digits=0)),color="black",size=4,position = position_dodge(width = 1),vjust=.9)+# hjust = 1.5 positions them inside the end of the bars. An hjust of 0.5 and a vjust of 0.5 center the box on the reference point. hjust=0, the left edge;;; For vertical, less is up and more is down
  theme_lz()+
    scale_fill_manual(values = c(mycolors[3],mycolors[2],mycolors[1]), name="Placement Methods")+#change legend color, lable, and title
  scale_y_continuous(breaks = seq(0, 0.3, by = 0.1) ,labels = scales::percent)+#present y axis label as percentage
  #geom_text_repel(aes(label= ifelse(Grade2System==4,paste(round(100*prt, 0), "%", sep=""),"")),size=3)+
  labs(x = "English Course Level", y = "", title="Students in Different English Courses by Placement Methods for Different Racial Groups")+
  theme(panel.grid.major.y = element_line(colour = "grey95"))
```

<img src="AggregateData.Viz_files/figure-html/within method-group by race-1.png" style="display: block; margin: auto;" />


Conclusion: One-year throughput increased among all race/ethnic groups, during MMAP and AB705,
particularly among Hispanic/Latinx students, though a large throughput gap between
White students and Hispanic/Latinx, Asian, and Black/African-American students
remained in fall 2019.

