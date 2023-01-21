---
title: "LMSCanvasAccuracy"
author: "Linli Zhou"
date: "2022-09-02"
output: 
  html_document:
    keep_md: true
---






















# Executive Summary

In Summer 2022, the Institutional Research (IR) Office collaborated with the Teaching and Learning Center (TLC) to compare grade consistency between two systems -- Canvas ^[Canvas is a learning management system used for instruction and advising.] and the Registrar's Office ^[Registrar's Office is a data management system used by the Registrar office for generating student transcripts and administrative reports.]. Comparing students' grades in Canvas with Registrar is important for providing accurate advising and intervention for students. 

We examined 15116 grades which has valid scores range from 0-110 in Canvas and has a match in Registrar's GPA systems. ^[Appendix details the process of converting grades from the two systems to comparable scales.] We explored the following research questions: 1) How consistent are grades between Canvas and Registrar's Office for undergraduate and graduate courses? 2) How grade consistency in undergraduate and graduate courses vary by school, semester and session, and year? The main findings are:

* Many courses’ grades (GPA) are 3.7 and 4.0 in both Registrar and Canvas for undergraduate and graduate courses. However, graduate courses have 20% more 4.0 GPA than undergraduate courses.

* 85% of graduate and 71% of undergraduate courses grades matched exactly. Only 4% of graduate and 2% of undergraduate courses’ grades have a significant difference (more than 1.0 GPA difference) between Registrar and Canvas.

* Courses in  Lasell Works and the Honors Program had over 90% grade consistency. Courses in multidisciplinary studies have the lowest percentage (55%) exact match. 

* In 2021 Summer, session 2 perform the worst (64% for undergraduate courses and 79% for undergraduate courses). However, in 2021 Fall and 2022 Spring, session 2 perform the best (above 90% for both undergraduate and graduate courses). Undergraduate courses have the least grade consistency (around 70%) in main sessions in 2021 Fall and 2022 Spring. 

* Graduate courses' grade consistency in 2021 Fall and 2022 Spring is above 80%, which is almost 10% higher than previous years (data date back to 2018 Spring).


# Patterns of grades distribution



```r
#prep long data for plotting bar graph

canvrp_ugg_long<-canvrp_ugg_match%>%pivot_longer(cols=c(registrargpa_match,canvasgpa_match),names_to = "WhichSystem",values_to = "Grade2System")
#check
canvrp_ugg_long%>%group_by(WhichSystem,Grade2System)%>%count()
```

```
## # A tibble: 24 × 3
## # Groups:   WhichSystem, Grade2System [24]
##    WhichSystem     Grade2System     n
##    <chr>                  <dbl> <int>
##  1 canvasgpa_match          0     791
##  2 canvasgpa_match          0.7   136
##  3 canvasgpa_match          1     183
##  4 canvasgpa_match          1.3   231
##  5 canvasgpa_match          1.7   318
##  6 canvasgpa_match          2     548
##  7 canvasgpa_match          2.3   542
##  8 canvasgpa_match          2.7   816
##  9 canvasgpa_match          3    1409
## 10 canvasgpa_match          3.3  1497
## # … with 14 more rows
```

```r
#looks right

#check the order, looks right
canvrp_ugg_long%>%group_by(WhichSystem)%>%count()
```

```
## # A tibble: 2 × 2
## # Groups:   WhichSystem [2]
##   WhichSystem            n
##   <chr>              <int>
## 1 canvasgpa_match    15116
## 2 registrargpa_match 15116
```

```r
#plot bar graph with different groups side by side
plot_stuprt<-
  canvrp_ugg_long%>%group_by(Program, WhichSystem,Grade2System)%>%summarise(cnt=n())%>%mutate(prt=cnt/sum(cnt))%>% #create a pivot table including all variables that will be used in plot
  
  ggplot(aes(x=factor(Grade2System), y=percent(prt,digit=0), fill=WhichSystem))+ 
  geom_bar(stat="identity",position=position_dodge(),width = 0.8)+
  facet_grid(~Program)+
  
  scale_fill_manual(values = c(mycolors[2],mycolors[3]), labels=c("Canvas","Registrar"), name="")+#change legend color, lable, and title
  scale_y_continuous(breaks = seq(0, 0.7, by = 0.2) ,labels = scales::percent)+#present y axis label as percentage
  geom_text_repel(aes(label= ifelse(Grade2System==4,paste(round(100*prt, 0), "%", sep=""),"")),size=3)+
  labs(x = "GPA", y = "Distribution")+
  theme_lz()+theme(panel.grid.major.y = element_line(colour = "grey95"))
```

```r
plot_stuprt
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/plot_stuprt-1.png" alt="Similar Patterns of Canvas and Registrar Course GPA \label{fig:stuprt}"  />
<p class="caption">Similar Patterns of Canvas and Registrar Course GPA \label{fig:stuprt}</p>
</div>

As shown in Figure \ref{fig:stuprt}, the Registrar and Canvas systems have similar patterns of GPA distribution. In both systems, grades are concentrated towards the higher GPA (i.e., 3.7 and 4.0) and the number of grades decrease towards lower GPA. However, for 4.0 GPA, there are 20% less undergraduate course grades (n=11611) than graduate course grades(n=3505). ^[40% undergraduate course grades have 4.0 GPA. 60% graduate course grades have 4.0 GPA.]


# Overall grade consistency
  

```r
plot_GPAmap<-canvrp_ugg_match %>% ggplot(aes(x=factor(canvasgpa_match),y=factor(registrargpa_match), color=diff_cat)) +
  geom_point(position = "jitter") +
  geom_smooth(aes(group=1, color="Trend"), size=0.5)+ #add a trend line; cannot do factor(x or y); aes(group=diff_cat) will produce a trend line for each group
  facet_wrap(~Program)+
   scale_color_manual (values = c(
     "Exact match"=mycolors[1],"Slight difference"=mycolors[3],"Significant difference"=mycolors[6],"Trend"="red" #only add one value in scale_corlor_manual for lines then facet them, not need to add two values which will produe not two trend line not two same lines for faceted graph
                                 ), 
                      name = 'Difference between systems')+
  
    new_scale_color() +#for second scale_corlor_manual that are needed to display legend on this abline
  geom_abline(aes(color="Exact match line",slope = 1, intercept = 0))+ #add an abline
  scale_color_manual(name='firstline', values="yellow")+
  
 
  labs(x="Canvas GPA",y="Registrar GPA")+
  theme_lz()
  
  
# scatter canvas on registrar jittering with smooth line
#library(tidyr)
#library(ggnewscale)#for 2 scale_corlor_manual which is for 2 legend both based colors
#plot_GPAmap<-canvrp_ugg_match %>%
  
#  ggplot(aes(x=factor(canvasgpa_match),y=factor(registrargpa_match), color=diff_cat)) +
#  geom_point(position = "jitter") + #points
#        geom_smooth(aes(group=1), color="red",size=0.5, method="lm", se=FALSE)+ #add a trend line; cannot do factor(x or y); aes(group=diff_cat) will produce a trend line for each group
#  facet_wrap(~Program)+
#  scale_color_manual (values = c("Exact match"=mycolors[1],
                              #   "Slight difference"=mycolors[3],
                               #  "Significant difference"=mycolors[6]), #adding geom_smooth into the legend together with points groups' legend
             #         name = 'Difference between systems')+


  
  
 # new_scale_color() +#for second scale_corlor_manual that are needed to display legend on this abline
#  geom_abline(aes(color="abline",slope = 1, intercept = 0))+ #add an abline
#  scale_color_manual(name='firstline', values="yellow")+
  
 
#  labs(x="Canvas GPA",y="Registrar GPA")+
#  theme_lz()
```

```r
plot_GPAmap #display 
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/mapping GPA-1.png" alt="Difference between Canvas and Registrar Course GPA \label{fig:gpamap}"  />
<p class="caption">Difference between Canvas and Registrar Course GPA \label{fig:gpamap}</p>
</div>

As shown in Figure \ref{fig:gpamap}, more courses have higher grades in Registrar than in Canvas (we have more red dots above the yellow line than below the line). For undergraduate courses (n=11611), grades spread across different GPAs. For graduate course (n=3505), grades concentrated on 2.7 or higher. The trend line (red line) of undergraduate course grade has is closer to the exact match lines (yellow line) towards the 3.7 GPA. The trend line (red line) of graduate course grade almost overlaps with the exact match trend line (yellow line) since 2.7 GPA and higher GPAs.



```r
# diff_cat variables bar graph
plot_GPAdiff<-
  canvrp_ugg_match%>%group_by(Program,diff_cat)%>%#have to put program before diff_cat to make program add to 100%. In other words, Program is treated as the larger group. Diff_cat is treated within the different program group.
  summarise(cnt=n())%>%mutate(prt=cnt/sum(cnt))%>%
  
  ggplot(aes(x=prt,y=Program,fill=diff_cat)) +
  geom_bar(stat="identity", width=0.8)+
 
  
  geom_text(aes(label=percent(prt,digits=0)),color="white",size=3, hjust=0.1,vjust=0.3)+#v=0 is the middle of horizontal bar; h=0 is the top of the horizontal bar; increase to move left and down
  scale_x_continuous(labels = scales::percent)+
  scale_fill_manual(values = c(mycolors[1],mycolors[3],mycolors[6]))+
  labs(x="Difference Categories", y="")+
  theme_lz() +
  theme(axis.text.x=element_blank(),axis.title = element_blank())
```

```r
plot_GPAdiff #display 
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/plot GPA difference-1.png" alt="Percentage of Grade Consistency \label{fig:gpadiff}"  />
<p class="caption">Percentage of Grade Consistency \label{fig:gpadiff}</p>
</div>

As shown in Figure \ref{fig:gpadiff}, 85% graduate courses and 71% undergraduate courses have exact match of grades between Registrar's Office and Canvas. Only 4% of undergraduate courses and 2% of graduate courses have significant differences (grade difference between the two systems are above 1.0). Graduate course grades has 14% more exact match than undergraduate course grades. 








# Grade consistency by School



```r
#compare x vs y by level of study in different faceted semester/session
canvrp_ugg_match %>% filter(school!="No School")%>%
  ggplot(aes(x=registrargpa_match,y=canvasgpa_match, color=diff_cat)) + 
  geom_point(position = "jitter") + #must have jitter to show density
  scale_color_manual(values = c(mycolors[1],mycolors[3],mycolors[6]))+
  labs(x='Registrar GPA',y='Canvas GPA')+theme_minimal()+facet_wrap(~school,ncol = 2)
```

<img src="LMSCanvasAccuracy_files/figure-html/school_scatter-1.png" style="display: block; margin: auto;" />


```r
school_pvttbl<-canvrp_ugg_match%>%filter(school!="No School")%>%filter(school!="Writing Program")%>%
  group_by(school,diff_cat)%>%summarise(cnt=n())%>%mutate(prt=(cnt/sum(cnt)))

#define school levels in factor() using the order that displayed/sorted based on exact match prt
set_order_school<-school_pvttbl%>%filter(diff_cat=="Exact match")%>%arrange(prt)%>%
  mutate(school_reorder=factor(school))

school_bar<-school_pvttbl%>%
  ggplot(aes(y=school,x=prt,fill=diff_cat))+
           geom_bar(stat="identity", width=0.8)+
  labs(x="",y="")+
  scale_fill_manual(values=c(mycolors[1],mycolors[3],mycolors[6]))+scale_x_continuous(labels = scales::percent)+
  #reorder y lables based on pre-defined levels 
  scale_y_discrete(limit=set_order_school$school_reorder)+
  geom_text(aes(label=paste(round(prt*100,0),"%",sep="")),color="white",size=3,hjust=0.2,vjust=0.3)+
  theme_lz()+theme(legend.title = element_blank(),axis.text.x = element_blank())
```

```r
school_bar
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/present school_bar-1.png" alt="Grade Consistency for Each School \label{fig.schoolbar}"  />
<p class="caption">Grade Consistency for Each School \label{fig.schoolbar}</p>
</div>


```r
canvrp_ugg_match%>%group_by(school)%>%count()
```

```
## # A tibble: 7 × 2
## # Groups:   school [7]
##   school                                                         n
##   <chr>                                                      <int>
## 1 No School                                                    795
## 2 School of Business                                          4149
## 3 School of Communication & the Arts                          2228
## 4 School of Fashion                                           1101
## 5 School of Health Sciences                                   2210
## 6 School of Humanities, Education, Justice & Social Sciences  3956
## 7 Writing Program                                              677
```

```r
nsof<-sum(canvrp_ugg_match$school=="School of Fashion")
nsob<-sum(canvrp_ugg_match$school=="School of Business")
nsoc<-sum(canvrp_ugg_match$school=="School of Communication & the Arts")
nhs<-sum(canvrp_ugg_match$school=="School of Health Sciences")
nhejss<-sum(canvrp_ugg_match$school=="School of Humanities, Education, Justice & Social Sciences")
```

As shown in Figure \ref{fig.schoolbar}, School of Fashion (n=1101) has the highest grade consistency (i.e., 83% exact match). School of Business (n=4149), School of Health Sciences (n=2210), School of Humanities, Education, Justice and Social Sciences (n=3956), and School of Communication and the Arts (n=2228) are between 72%-76%. 



```r
canvrp_ugg_match%>% filter(school=="No School")%>%group_by(department)%>%summarise(cnt=n())%>%arrange(desc(cnt))
```

```
## # A tibble: 7 × 2
##   department                    cnt
##   <chr>                       <int>
## 1 First Year Seminar            266
## 2 Multidisciplinary Studies     239
## 3 Honors                        140
## 4 Lasell Works                  134
## 5 Academic Achievement Center     9
## 6 Service Learning                5
## 7 Individualized Studies          2
```


```r
dpt_pvttbl<-canvrp_ugg_match%>%filter(school=="No School" |school== "Writing Program")%>% filter(department != "Service Learning") %>% filter( department != "Individualized Studies") %>% filter( department != "Academic Achievement Center")%>%
  group_by(department,diff_cat)%>%summarise(cnt=n())%>%mutate(prt=(cnt/sum(cnt)))

#use value "exact match" within variable "diff_cat" to be the rule for reordering/ factoring another variable "department" that will later become the y axis labels
set_order <- dpt_pvttbl%>%
  filter(diff_cat == "Exact match") %>% 
  arrange(prt) %>% 
  mutate(department_reorder = factor(department))


no_school_department_bar<-dpt_pvttbl%>%
  ggplot(aes(y=department,x=prt,fill=diff_cat))+
           geom_bar(stat="identity", width=0.8)+
  labs(x="",y="")+
  #reorder y axis labels using pre-defined factor levels using the set_order object (created from order of the "exact match" values within the diff_cat variable)
  scale_y_discrete(limits = set_order$department_reorder)+
  scale_fill_manual(values=c(mycolors[1],mycolors[3],mycolors[6]))+scale_x_continuous(labels = scales::percent)+
  geom_text(aes(label=paste(round(prt*100,0),"%",sep="")),color="white",size=3,hjust=0.2,vjust=0.3)+
  theme_lz()+theme(legend.title = element_blank(),axis.text.x = element_blank())
```


```r
no_school_department_bar
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/show department bar-1.png" alt="Grade Consistency in Non-School-Affiliated Programs \label{fig.noschool}"  />
<p class="caption">Grade Consistency in Non-School-Affiliated Programs \label{fig.noschool}</p>
</div>


```r
canvrp_ugg_match%>%filter(school=="No School"|school=="Writing Program")%>%
  group_by(department)%>%dplyr::count()
```

```
## # A tibble: 8 × 2
## # Groups:   department [8]
##   department                      n
##   <chr>                       <int>
## 1 Academic Achievement Center     9
## 2 First Year Seminar            266
## 3 Honors                        140
## 4 Individualized Studies          2
## 5 Lasell Works                  134
## 6 Multidisciplinary Studies     239
## 7 Service Learning                5
## 8 Writing                       677
```

```r
nhonors<-sum(canvrp_ugg_match$department=="Honors")
nwriting<-sum(canvrp_ugg_match$department=="Writing")
nfys<-sum(canvrp_ugg_match$department=="First Year Seminar")
nmulti<-sum(canvrp_ugg_match$department=="Multidisciplinary Studies")
nlw<-sum(canvrp_ugg_match$department=="Lasell Works")
```


```r
canvrp_ugg_match %>% filter(department=="Multidisciplinary Studies")%>%group_by(`Course Name`)%>%count()
```

```
## # A tibble: 7 × 2
## # Groups:   Course Name [7]
##   `Course Name`                               n
##   <chr>                                   <int>
## 1 Democracy                                  12
## 2 Digital Society                            43
## 3 Entrepreneurship, Sport & Entertainment    34
## 4 Fighting Injustice Through Art             32
## 5 Immigrant Stories                          37
## 6 Immigration Stories                        41
## 7 Persuading People Preserving Planet        40
```

```r
canvrp_ugg_match %>% filter(department=="Multidisciplinary Studies")%>%group_by(`Course ID`)%>%count()
```

```
## # A tibble: 1 × 2
## # Groups:   Course ID [1]
##   `Course ID`     n
##   <chr>       <int>
## 1 MDSC203       239
```




As shown in Figure \ref{fig.noschool}, Lasell Works (n=134) has the highest grade consistency (i.e., 90%), followed by the Honors Program (n=140), which is 85%. The Writing Program (n=677) and First Year Seminar (n=266) has 75% grades match between the Registrar and Canvas systems. Multidiscplineary Studies (n=239) has the lowest grade consistency, which is 55%. 



# Grade consistency by writing program

```r
writing_pvttbl<-canvrp_ugg_match %>% filter(school=="Writing Program")%>%filter(`Course ID`!="WRT190D") %>%#have one obervation for WRT190D
group_by(`Course ID`,diff_cat)%>%summarise(cnt=n())%>%mutate(prt=cnt/sum(cnt))

#define school levels in factor() using the order that displayed/sorted based on exact match prt
set_order_writing<-writing_pvttbl%>%filter(diff_cat=="Exact match")%>%arrange(prt)%>%
  mutate(writing_reorder=factor(`Course ID`))

writing_bar<-writing_pvttbl%>%
  ggplot(aes(y=`Course ID`,x=prt,fill=diff_cat))+
           geom_bar(stat="identity", width=0.8)+
  labs(x="",y="")+
  scale_fill_manual(values=c(mycolors[1],mycolors[3],mycolors[6]))+scale_x_continuous(labels = scales::percent)+
  #reorder y lables based on pre-defined levels 
  scale_y_discrete(limit=set_order_writing$writing_reorder)+
  geom_text(aes(label=paste(round(prt*100,0),"%",sep="")),color="white",size=3,hjust=0.2,vjust=0.3)+
  theme_lz()+theme(legend.title = element_blank(),axis.text.x = element_blank())
```


```r
canvrp_ugg_match%>%filter(school=="Writing Program")%>%
  group_by(department)%>%count()
```

```
## # A tibble: 1 × 2
## # Groups:   department [1]
##   department     n
##   <chr>      <int>
## 1 Writing      677
```

```r
nwrt101<-sum(canvrp_ugg_match$`Course ID`=="WRT101")
nwrt102<-sum(canvrp_ugg_match$`Course ID`=="WRT102")
```


```r
writing_bar
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/show writing bar-1.png" alt="Grade Consistency in Writing Programs \label{fig.writing}"  />
<p class="caption">Grade Consistency in Writing Programs \label{fig.writing}</p>
</div>
As shown in Figure \ref{fig.writing}, Writing 101 (n=342) and 102 (n=334) has similar exact match, but Writing 101 has 8% significant difference than Writing 102 which is 4%. 



# Grade consistency by semester and sessions in 2021-2022


```r
plot_term<-canvrp_ugg_match%>%group_by(Program,`Academic Term`,diff_cat)%>%summarise(cnt=n())%>%mutate(prt=cnt/sum(cnt))%>%
  ggplot(aes(y=`Academic Term`,x=percent(prt,digit=0),fill=diff_cat))+
  geom_bar(stat="identity",width=.8)+
  facet_grid(~Program)+
  scale_x_continuous(labels = scales::percent)+
  scale_y_discrete(limits=rev)+
  scale_fill_manual(values = c(mycolors[1],mycolors[3],mycolors[6]))+
  labs(x="",y="")+
  geom_text(aes(label=percent(prt,digits=0)),color="white",size=3,hjust=0.2,vjust=0.3)+
  theme_lz()+theme(axis.text.x = element_blank())
```

```r
plot_term
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/diff_cat by term-1.png" alt="Grade Consistency in Different Terms \label{fig:term}"  />
<p class="caption">Grade Consistency in Different Terms \label{fig:term}</p>
</div>

As shown in Figure \ref{fig:term}, exact match between Canvas and Registrar are between 71%- 87% across different terms (spring, fall, summer) in academic year 2021-2022. There are less than 4% significant difference between Canvas and Registrar grades for both undergraduate and graduate courses. However, the exact match of graduate course grades are more than 10% higher than undergraduate courses. In spring, graduate course have 18% more exact-matched grades than undergraduate courses. 



```r
s21m<-sum(canvrp_ugg_match$Program=="Undergraduate Course"&canvrp_ugg_match$`Academic Term`=="2022 Spring"&canvrp_ugg_match$`Academic Session`=="Main")
s21.1<-sum(canvrp_ugg_match$Program=="Undergraduate Course"&canvrp_ugg_match$`Academic Term`=="2021 Summer"&canvrp_ugg_match$`Academic Session`=="Session 1")
s21.2<-sum(canvrp_ugg_match$Program=="Undergraduate Course"&canvrp_ugg_match$`Academic Term`=="2021 Summer"&canvrp_ugg_match$`Academic Session`=="Session 2")

f21m<-sum( canvrp_ugg_match$Program=="Undergraduate Course" & canvrp_ugg_match$`Academic Term`=="2021 Fall" & canvrp_ugg_match$`Academic Session`=="Main")
f21.1<-sum(canvrp_ugg_match$Program=="Undergraduate Course"&canvrp_ugg_match$`Academic Term`=="2021 Fall"&canvrp_ugg_match$`Academic Session`=="Session 1")
f21.2<-sum(canvrp_ugg_match$Program=="Undergraduate Course"&canvrp_ugg_match$`Academic Term`=="2021 Fall"&canvrp_ugg_match$`Academic Session`=="Session 2")

s22m<-sum(canvrp_ugg_match$Program=="Undergraduate Course"&canvrp_ugg_match$`Academic Term`=="2022 Spring"&canvrp_ugg_match$`Academic Session`=="Main")
s22.1<-sum(canvrp_ugg_match$Program=="Undergraduate Course"&canvrp_ugg_match$`Academic Term`=="2022 Spring"&canvrp_ugg_match$`Academic Session`=="Session 1")
s22.2<-sum(canvrp_ugg_match$Program=="Undergraduate Course"&canvrp_ugg_match$`Academic Term`=="2022 Spring"&canvrp_ugg_match$`Academic Session`=="Session 2")
```


```r
gs21m<-sum(canvrp_ugg_match$Program=="Graduate Course"&canvrp_ugg_match$`Academic Term`=="2022 Spring"&canvrp_ugg_match$`Academic Session`=="Main")
gs21.1<-sum(canvrp_ugg_match$Program=="Graduate Course"&canvrp_ugg_match$`Academic Term`=="2021 Summer"&canvrp_ugg_match$`Academic Session`=="Session 1")
gs21.2<-sum(canvrp_ugg_match$Program=="Graduate Course"&canvrp_ugg_match$`Academic Term`=="2021 Summer"&canvrp_ugg_match$`Academic Session`=="Session 2")

gf21m<-sum( canvrp_ugg_match$Program=="Graduate Course" & canvrp_ugg_match$`Academic Term`=="2021 Fall" & canvrp_ugg_match$`Academic Session`=="Main")
gf21.1<-sum(canvrp_ugg_match$Program=="Graduate Course"&canvrp_ugg_match$`Academic Term`=="2021 Fall"&canvrp_ugg_match$`Academic Session`=="Session 1")
gf21.2<-sum(canvrp_ugg_match$Program=="Graduate Course"&canvrp_ugg_match$`Academic Term`=="2021 Fall"&canvrp_ugg_match$`Academic Session`=="Session 2")

gs22m<-sum(canvrp_ugg_match$Program=="Graduate Course"&canvrp_ugg_match$`Academic Term`=="2022 Spring"&canvrp_ugg_match$`Academic Session`=="Main")
gs22.1<-sum(canvrp_ugg_match$Program=="Graduate Course"&canvrp_ugg_match$`Academic Term`=="2022 Spring"&canvrp_ugg_match$`Academic Session`=="Session 1")
gs22.2<-sum(canvrp_ugg_match$Program=="Graduate Course"&canvrp_ugg_match$`Academic Term`=="2022 Spring"&canvrp_ugg_match$`Academic Session`=="Session 2")
```


```r
plot_session_frmt<-canvrp_ugg_match%>%
  group_by(Program, `Academic Term`,`Academic Session`,diff_cat)%>%summarise(cnt=n())%>%mutate(prt=cnt/sum(cnt))%>%
  
  ggplot(aes(x=percent(prt,digit=0),y=`Academic Session`,fill=diff_cat))+
  geom_bar(stat="identity",width=.8)+
  facet_grid(`Academic Term`~Program)+
  scale_x_continuous(labels = scales::percent)+
  scale_y_discrete(limits=rev)+
  scale_fill_manual(values = c(mycolors[1],mycolors[3],mycolors[6]))+
  labs(x="",y="")+
  geom_text(aes(label=ifelse(diff_cat=="Exact match",paste(round(prt*100,0),"%",sep=""),"")),color="white",size=3,hjust=0.8,vjust=0.3)+
  theme_lz()+theme(axis.text.x = element_blank())
```


```r
plot_session<-canvrp_ugg_match%>%
  group_by(Program, `Academic Term`,`Academic Session`,diff_cat)%>%summarise(cnt=n())%>%mutate(prt=cnt/sum(cnt))%>%
  
  ggplot(aes(x=percent(prt,digit=0),y=`Academic Session`,fill=diff_cat))+
  geom_bar(stat="identity",width=.8)+
  facet_grid(Program~`Academic Term`)+
  scale_x_continuous(labels = scales::percent)+
  scale_fill_manual(values = c(mycolors[1],mycolors[3],mycolors[6]))+
  labs(title="Registrar-Canvas Matched Grades in Undergraduate and Graduate Courses across Terms and Sessions",x="",y="")+
  geom_text(aes(label=ifelse(diff_cat=="Exact match",paste(round(prt*100,0),"%",sep=""),"")),color="white",size=3,hjust=0.8,vjust=0.3)+
  theme_lz()+theme(axis.text.x = element_blank())
```


```r
plot_session_frmt
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/diff_cat by session-1.png" alt="Grade Consistency across Sessions of Different Terms \label{fig:session}"  />
<p class="caption">Grade Consistency across Sessions of Different Terms \label{fig:session}</p>
</div>

As shown in Figure \ref{fig:session}, for undergraduate courses, the lowest grade consistency appears in the main session of 2021 Fall (n=5869) and 2022 Spring (n=5253), which is only 70%. Then, the grade consistency increases in session 1 of Fall (n=31) and Spring (n=22). The grade consistency is the best for session2 in Fall (n=15) and Spring (n=25), which are above 90%. 

For undergraduate courses in 2021 summer, the main session (n=5253) is the highest, which is 81%. It decreases when it moves to session 1 (n=181) and session 2 (n=181) which is only 76% and 64% respectively.

For graduate courses, session 2 has the highest grade consistency of 90% in Fall (n=511) and Spring (n=498). Similar grade consistency were observed for main and session 1 in Fall and Spring. In summer, main session (n=195) and session 1 (n=477) is similar, but session 2 (n=496) has lower grade consistency.















# Grade Consistency by Year



```r
#ask eric/heidi if undergrad difference-prt historical data available
#confirm if historical data in chen's report is grad level course only
#historical data only exist for graduate level courses; manually added 2021 fall and 2022 spring data/grade for graduate level courses
exactm_g<-c(.63,.78,.66,.61,.73,.74,.75,.83,.87)
slightd_g<-c(.21,.16,.20,.21,.21,.15,.14,.14,.11)
sigd_g<-c(.16,.05,.14,.18,.06,.11,.11,.03,.01)
histerm_g<-c("2018 Spring","2018 Fall","2019 Spring","2019 Fall","2020 Spring","2020 Fall","2021 Spring","2021 Fall","2022 Spring") %>% factor(levels=c("2018 Spring","2018 Fall","2019 Spring","2019 Fall","2020 Spring","2020 Fall","2021 Spring","2021 Fall","2022 Spring"))#preserve the order of values
#check
length(exactm_g)
```

```
## [1] 9
```

```r
length(slightd_g)
```

```
## [1] 9
```

```r
length(sigd_g)
```

```
## [1] 9
```

```r
length(histerm_g)
```

```
## [1] 9
```

```r
#looks right, all have 9 observations
#check add up to 100%
exactm_g+slightd_g+sigd_g
```

```
## [1] 1 1 1 1 1 1 1 1 1
```

```r
#make list a data frame or tibble
histdata<-tibble(histerm_g,exactm_g,slightd_g,sigd_g)
#check
str(histdata)
```

```
## tibble [9 × 4] (S3: tbl_df/tbl/data.frame)
##  $ histerm_g: Factor w/ 9 levels "2018 Spring",..: 1 2 3 4 5 6 7 8 9
##  $ exactm_g : num [1:9] 0.63 0.78 0.66 0.61 0.73 0.74 0.75 0.83 0.87
##  $ slightd_g: num [1:9] 0.21 0.16 0.2 0.21 0.21 0.15 0.14 0.14 0.11
##  $ sigd_g   : num [1:9] 0.16 0.05 0.14 0.18 0.06 0.11 0.11 0.03 0.01
```

```r
#make wide data long
histdata_long<-histdata%>%pivot_longer(cols = c(exactm_g,slightd_g,sigd_g),names_to = "cat_hist", values_to = "cat_hist_prt")
#check
glimpse(histdata_long)
```

```
## Rows: 27
## Columns: 3
## $ histerm_g    <fct> 2018 Spring, 2018 Spring, 2018 Spring, 2018 Fall, 2018 Fa…
## $ cat_hist     <chr> "exactm_g", "slightd_g", "sigd_g", "exactm_g", "slightd_g…
## $ cat_hist_prt <dbl> 0.63, 0.21, 0.16, 0.78, 0.16, 0.05, 0.66, 0.20, 0.14, 0.6…
```

```r
#factor and recode the cat_his variable
histdata_long$cat_hist=factor(histdata_long$cat_hist,levels = c("exactm_g","slightd_g","sigd_g"),labels = c("Exact match","Slight difference","Significant difference"))
#check
histdata_long%>%group_by(cat_hist)%>%count()
```

```
## # A tibble: 3 × 2
## # Groups:   cat_hist [3]
##   cat_hist                   n
##   <fct>                  <int>
## 1 Exact match                9
## 2 Slight difference          9
## 3 Significant difference     9
```

```r
histdata_long%>%group_by(histerm_g)%>%count()
```

```
## # A tibble: 9 × 2
## # Groups:   histerm_g [9]
##   histerm_g       n
##   <fct>       <int>
## 1 2018 Spring     3
## 2 2018 Fall       3
## 3 2019 Spring     3
## 4 2019 Fall       3
## 5 2020 Spring     3
## 6 2020 Fall       3
## 7 2021 Spring     3
## 8 2021 Fall       3
## 9 2022 Spring     3
```

```r
#line graph
hist_line<-histdata_long%>%ggplot(aes(x=histerm_g,y=cat_hist_prt,color=cat_hist,group=cat_hist))+
  geom_line()+
  scale_color_manual(values = c(mycolors[1],mycolors[3],mycolors[6]))+
  labs(x="", y="")+ theme_lz()+ theme(axis.text.y = element_blank(),legend.position = "bottom")+
  geom_text_repel(aes(label=percent(cat_hist_prt,digits=0)),size=3, hjust=1,vjust=0)
```

```r
hist_line
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/hist_line-1.png" alt="Historical Comparison of Grade Consistency 2018-2022 (Graduate Course Grades) \label{fig:hist}"  />
<p class="caption">Historical Comparison of Grade Consistency 2018-2022 (Graduate Course Grades) \label{fig:hist}</p>
</div>

As shown in Figure \ref{fig:hist}, the canvas-registrar grade consistency for graduate level courses has been improving since 2019 Fall, and reached the highest percentage (87%) in 2022 Spring. However, there are still 10% of courses with significant differences between Canvas and Registrar. 


# Appendix: 

## Method: Preparation for Data Analysis

To make the grades comparable, we convert grades in Canvas (i.e., numeric grade in scale of 0-110) and Registrar's Office (i.e.,letter grade in scale of A-F) to GPA grades (i.e. numeric grade in scale of 0-4.0). Figure \ref{fig:conversion} shows the distribution of grades in the Canvas and Registrar system before and after conversion.


```r
p1<-canvrp%>%ggplot(aes(x=`current score`,y=canvasgpa))+
  geom_point()+xlim(0,110)+
  theme_classic()+xlab("Canvas Scores")+ylab("Canvas GPA")

p2<-canvrp%>%ggplot(aes(x=`Final Grade`,y=registrargpa))+
  geom_count()+
  theme_classic()+theme(legend.position="none")+
  xlab("Registrar Letter Grades")+ylab("Registrar GPA")
```


```r
ggarrange(p1,p2)
```

<div class="figure" style="text-align: center">
<img src="LMSCanvasAccuracy_files/figure-html/convert score/grade to gpa plot-1.png" alt="Canvas and Registrar Grades Before and After Conversion \label{fig:conversion}"  />
<p class="caption">Canvas and Registrar Grades Before and After Conversion \label{fig:conversion}</p>
</div>

## Grades that included and excluded from the analysis
We used Table \ref{tab:convert} to convert scores and grades.


```r
tibble(
  GPA=c(4,3.7,3.3,3,2.7,2.3,2,1.7,1.3,1,0.7,0),
 "Registrar grade"=c("A","A-","B+","B","B-","C+","C","C-","D+","D","D-","F"),
  "Canvas score"=c("93-110","90~93","87~90","83-87","80~83","77~80","73~77","70~73","67~70","63~67","59~63","0-59"))%>% kable(caption = "Converting GPA Scales \\label{tab:convert}") %>%kable_styling(latex_options = "HOLD_position")
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>Converting GPA Scales \label{tab:convert}</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> GPA </th>
   <th style="text-align:left;"> Registrar grade </th>
   <th style="text-align:left;"> Canvas score </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 4.0 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 93-110 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.7 </td>
   <td style="text-align:left;"> A- </td>
   <td style="text-align:left;"> 90~93 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:left;"> B+ </td>
   <td style="text-align:left;"> 87~90 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.0 </td>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 83-87 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.7 </td>
   <td style="text-align:left;"> B- </td>
   <td style="text-align:left;"> 80~83 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.3 </td>
   <td style="text-align:left;"> C+ </td>
   <td style="text-align:left;"> 77~80 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.0 </td>
   <td style="text-align:left;"> C </td>
   <td style="text-align:left;"> 73~77 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.7 </td>
   <td style="text-align:left;"> C- </td>
   <td style="text-align:left;"> 70~73 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.3 </td>
   <td style="text-align:left;"> D+ </td>
   <td style="text-align:left;"> 67~70 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:left;"> D </td>
   <td style="text-align:left;"> 63~67 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.7 </td>
   <td style="text-align:left;"> D- </td>
   <td style="text-align:left;"> 59~63 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> 0-59 </td>
  </tr>
</tbody>
</table>


For grades that are excluded from this analysis, Table \ref{tab:outlier} is a description of the number of scores that are excluded from analysis (table hidden).

Besides, we did not report programs and courses that has small number of observations. That exclusion help to protect students' privacy from possibly individual identifiable students data. Specifically, the following programs are omitted from this report: Service Learning (n=5), Individualized Studies (n=2), Academic Achievement Center (n=9), and WRT109 (n=1).

```r
#read raw data
canvas21<-read_excel("/Users/linlizhou/Documents/LASELL/data/progameval/canvas.raw.20-21.xlsx")
outliertb<-canvas21%>%filter(`current score`>100)%>%group_by(course)%>%summarise(`Grades>110`=n())%>%arrange(desc(`Grades>110`))
```


```r
tibble(outliertb)%>% kable(caption = "Outlier Grades and Corresponding Courses \\label{tab:outlier}") %>%kable_styling(latex_options = "HOLD_position")
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>Outlier Grades and Corresponding Courses \label{tab:outlier}</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> course </th>
   <th style="text-align:right;"> Grades&gt;110 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> HIST104.CKP-2021.FAMAIN World Civ II:Science &amp; Medicine </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.EKP-2021.FAMAIN World Civ II:Magic &amp; Religion </td>
   <td style="text-align:right;"> 23 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS332.A-2021.FAMAIN Cross Cultural Management </td>
   <td style="text-align:right;"> 19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> POLS101.A-2021.FAMAIN American Government </td>
   <td style="text-align:right;"> 17 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ED335.A-2022.SPMAIN Teaching Mathematics: PK - 2 </td>
   <td style="text-align:right;"> 16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.CKP-2022.SPMAIN World Civ II: Science &amp; Medicine </td>
   <td style="text-align:right;"> 16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS310.A-2022.SPMAIN Advanced Financial Management </td>
   <td style="text-align:right;"> 14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST124.A-2021.FAMAIN Amer Civ II: Nineteenth Century New York </td>
   <td style="text-align:right;"> 14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS101.C-2021.FAMAIN Fund of Bus in a Global Environment </td>
   <td style="text-align:right;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CJ702.A-2021.SUSES1 Critical Legal Issues in Crim Justice </td>
   <td style="text-align:right;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> COM105.A-2022.SPMAIN Writing for The Media </td>
   <td style="text-align:right;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GRAP207.A-2022.SPMAIN Web Design &amp; Development </td>
   <td style="text-align:right;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PSYC101.BKP-2021.FAMAIN Psychological Perspectives (KP) </td>
   <td style="text-align:right;"> 13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CJ702.B-2021.FASES2 Critical Legal Issues in Crim Justice </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> COM105.B-2022.SPMAIN Writing for The Media </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.FKP-2022.SPMAIN World Civ II: Magic &amp; Religion </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PSYC111.A-2022.SPMAIN Generations in America </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GRAP308.A-2022.SPMAIN Interactive &amp; UX Design </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS101.D-2021.FAMAIN Fund of Bus in a Global Environment </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS497.A-2021.FAMAIN Business Internship &amp; Seminar </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.EKP-2022.SPMAIN World Civ II: The Maritime World </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.FKP-2021.FAMAIN World Civ II:The Maritime World </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.KP-2021FAMAIN: ALL (KP) </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ARTS126.FKP-2021.FAMAIN Fund of Visual Art (KP) Grap Majors Only </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIO104.A-2022.SPMAIN Foundations in the Health Professions </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MGMT707.B-2022.SPSES1 Operations Strategy </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS105.B-2021.FAMAIN Excel for Business </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.BKP-2021.FAMAIN World Civ II:Introduction to East Asia </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.DKP-2021.FAMAIN World Civ II: Intro to the Middle East </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.KP-2022SPMAIN: ALL (KP) </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SPED711.A-2021.FASES1 Learners with Special Needs </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ARTH107.BKP-2022.SPMAIN SPT:Rennaissance to Modern Art Treasures </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS319.A-2021.FAMAIN Cost Accounting </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FASH206.A-2021.FAMAIN Sustainability in the Fashion Industry </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIO102L.AKP-2022.SPMAIN Princ of Bio II Lab (KP) </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIO211.A-2021.FAMAIN Microbiology </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS224.B-2021.FAMAIN Org Behavior in the Global Workplace </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GRAP105.A-2022.SPMAIN Digital Design Essentials </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.AKP-2021.FAMAIN World Civ II: World Wars </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MGMT751.A-2022.SPMAIN Business Strategy </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ARTS126.CKP-2021.FAMAIN Fundamentals of Visual Art (KP) </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIO102L.B-2022.SPMAIN Princ of Bio II Lab (KP) </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS105.A-2022.SPMAIN Excel for Business </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FYS103.D-2021.FAMAIN The Three Pillars of Transformation </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FYS103.N-2021.FAMAIN The Three Pillars of Transformation </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST212.A-2022.SPMAIN Mod Japan: Culture &amp; History </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MGMT707.A-2021.FASES2 Operations Strategy </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PSYC318.A-2022.SPMAIN Abnormal Psychology </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WRT101.Q-2021.FAMAIN Writing I </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ARTH107.AKP-2022.SPMAIN SPT: Global Art Treasures (KP) </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIO102.AKP-2022.SPMAIN Principles of Biology II (KP) </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS105.A-2021.FAMAIN Excel for Business </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BUSS332.A-2021.SUSES1 Cross Cultural Management </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CHEM204L.A-2022.SPMAIN General Chemistry II Lab </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CJ101.AKP-2021.FAMAIN Introduction to Criminal Justice (KP) </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> COM101.B-2021.FAMAIN Understanding Mass Media </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> COM219.LWS-2022.SPMAIN Social Media Management </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> COM315.A-2022.SPMAIN Communication Research </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> COM742.A-2021.SUSES1 Integrated Marketing Communications </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ECON101.A-2022.SPMAIN Principles of Econ-Micro </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ED418.A-2022.SPMAIN Integrated Instruction: Elementary: 1-6 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EXSC410.A-2021.FAMAIN Exercise Science Field Experience I </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FASH219.A-2022.SPMAIN Fash Industry Professional Development </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FYS103.O-2021.FAMAIN Identity and Connecting Across Differenc </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GRAP310X.A-2022.SPMAIN UX Explorations </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.AKP-2022.SPMAIN World Civ II:  World Wars </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST104.BKP-2022.SPMAIN World Civ II:  Introduction to East Asia </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HIST323.A-2021.FAMAIN Special Topics in Global History </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LS101.AKP-2021.FAMAIN Foundations of American Legal System(KP) </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MATH205.A-2021.FAMAIN Calculus I </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MDSC203.E-2021.FAMAIN Entrepreneurship Sport &amp; Entertainment </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PSYC101.CKP-2022.SPMAIN Psychological Perspectives (KP) </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PSYC318.LWS-2021.FAMAIN Abnormal Psychology </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SMGT203X.A-2021.FAMAIN Intro to Parks Recreation &amp; Tourism </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SOC104.FKP-2022.SPMAIN Equity &amp; Intersectionality(KP) </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SOC221.A-2021.FAMAIN Contemporary Social Problems </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SOC301.A-2022.SPMAIN Race &amp; Ethnicity </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SOC331.A-2021.FAMAIN Research Methods in the Social Sciences </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WRT102.C-2021.FAMAIN Writing II </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WRT102.L-2022.SPMAIN WRT II: Sports and Wellness </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

## A few more explanation of Codes
Table \ref{tab.mdsc} shows what's included in Multidisciplinary Studies: table hidden


```r
canvrp_ugg_match %>% filter(department=="Multidisciplinary Studies")%>%group_by(`Course ID`, `Course Name`)%>%count()%>%kable(caption = "Multidisciplinary Studies Courses \\label{tab.mdsc}") %>%kable_styling(latex_options = "HOLD_position")
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>Multidisciplinary Studies Courses \label{tab.mdsc}</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Course ID </th>
   <th style="text-align:left;"> Course Name </th>
   <th style="text-align:right;"> n </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> MDSC203 </td>
   <td style="text-align:left;"> Democracy </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MDSC203 </td>
   <td style="text-align:left;"> Digital Society </td>
   <td style="text-align:right;"> 43 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MDSC203 </td>
   <td style="text-align:left;"> Entrepreneurship, Sport &amp; Entertainment </td>
   <td style="text-align:right;"> 34 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MDSC203 </td>
   <td style="text-align:left;"> Fighting Injustice Through Art </td>
   <td style="text-align:right;"> 32 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MDSC203 </td>
   <td style="text-align:left;"> Immigrant Stories </td>
   <td style="text-align:right;"> 37 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MDSC203 </td>
   <td style="text-align:left;"> Immigration Stories </td>
   <td style="text-align:right;"> 41 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MDSC203 </td>
   <td style="text-align:left;"> Persuading People Preserving Planet </td>
   <td style="text-align:right;"> 40 </td>
  </tr>
</tbody>
</table>

