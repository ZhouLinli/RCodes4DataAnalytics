knitr::opts_chunk$set(echo = FALSE, include = FALSE, warning=FALSE, message=FALSE) #show results only for specified chunks
options(knitr.kable.NA = '')#in kable, show NA as blank
#options(digits=1)

#common used library
#reading data
library(haven)
library(readxl)
#cleaning/wrangling data: include readr,tibble, stringr, forcats, dplyr, tidyr, purrr, ggplot2
library(tidyverse)
library(janitor)
library(pdftools)#read pdf
library(scales)
#text
library(tidytext)
library(rtweet) 
#library(dataedu) 
library(randomNames) 
library(tidygraph) 
library(ggraph)
#date
library(lubridate)
#save df
library(writexl)
library(openxlsx)
#viz
library(formattable)
library(ggrepel)
library(waffle)
library(patchwork)
library(wordcloud)
library(broom)
#viz table
library(gt)
library(kableExtra)#for good-looking static tables
library(DT)#for filtering/interactive tables
#web scrapping html
library(RCurl)
library(XML)
library(rvest)
#xaringan
library(renderthis)
library(countdown)
#for regression table
library(apaTables)#show cor/reg table
library(sjPlot)#show reg table
library(lme4)#multilevel modeling
library(performance)#calculate intra class correlation
#library(dummies)#lm already auto convert to dummy vars
library(caret)#creating predictive models: e.g. partitioning training vs test datasets
library(ranger)#random forest
library(tidylog)#see process of random forest
#data models
library(nnet)
library(rstan)
#library(rethinking)#with the help of first installing: remotes::install_github("stan-dev/cmdstanr")
library(GGally) #package to map cross-table of variables
library(leaps)#package for model selection
library(gvlma) #package to compare different model to select variables to include/exlude in model



#mycolors<-c("#13294b","#5c88da","#69b3e7","#da291c","#641F45","#fcb53b","#6C6F70")#1-3blue,4-5red,6yellow,7grey

color_bluedark<-"#13294b"
color_blue_lasell<-"#5c88da"
color_blue<-"#69b3e7"
color_bluelight<-"#a7d2f0"

color_reddark<-"#641F45"
color_red<-"#da291c"
color_redlight<-"#ff726f"
#color_redwhite<-"#ffc6c4"

#color_yellowdarker<-"#f59c04"
color_yellowdark<-"#fcb53b"
color_yellow<-"#FFCB4F"
color_yellowlight<-"#ffe099"
#color_yellowwhite<-"#ffe6bf"

color_greydark<-"#6C6F70"
color_grey<-"#aaaaaa"
color_greylight<-"#cccccc"

#define kable conditional formatting "colors based on condition function"
cf_color<-function(x,
                   a=.9,b=.8,c=.5,d=.3,
                   col1=color_yellow,#great
                   col2=color_yellowlight,#good
                   col3=color_greylight,#worry
                   col4=color_grey){#worrier
  ifelse(is.na(x),"white",ifelse(
    x>a,col1,ifelse(#if not na and >90%, then col1;
      x>b,col2,ifelse(#if <90% but >80%, then col2;
        x>c,"white",ifelse(#if <80% but >50%, then "white";
          x>d,col3,#if <50% but >30%, then col3;
          col4)))))}#if <30%, then col4

cf_color_blue<-function(x,
                       a=.9,b=.8,c=.5,d=.3,
                       col1=color_blue_lasell,#great
                       col2=color_blue,#good
                       col3=color_bluelight,#avg
                       col4=color_greylight){#ignore
  ifelse(is.na(x),"white",ifelse(
    x>a,col1,ifelse(#if not na and >90%, then col1;
      x>b,col2,ifelse(#if <90% but >80%, then col2;
        x>c,col3,ifelse(#if <80% but >50%, then col3;
          x>d,col4,#if <50% but >30%, then col4;
          "white")))))}#if <30%, then col4

cf_color_blue_abs<-function(x,
                        a=.9,b=.8,c=.5,d=.3,
                        col1=color_blue_lasell,#great
                        col2=color_blue,#good
                        col3=color_bluelight,#avg
                        col4=color_greylight){#ignore
  ifelse(is.na(x),"white",ifelse(
    abs(x)>a,col1,ifelse(#if not na and >90%, then col1;
      abs(x)>b,col2,ifelse(#if <90% but >80%, then col2;
        abs(x)>c,col3,ifelse(#if <80% but >50%, then col3;
          abs(x)>d,col4,#if <50% but >30%, then col4;
          "grey90")))))}#if <30%, then col4



#usage: 
#tab<-table%>%kable()
#column_spec(tab,column=2,
#             background =cf(tab[2],a=70,b=50,col1=color_grey,col2=color_greylight)

#usage in for loop: 
#for (i in 2:ncol(tab)){
#static_tab<-column_spec(
#kable_input=static_tab,
#column=i,background =cf(tab[i],a=70,b=50))
#i=i+1
#static_tab}


#define themes functions
#
theme_lz.html <- function(){ 
theme_minimal() %+replace%    #replace elements already strips axis lines, 
  theme(
    panel.grid.major = element_blank(),    #no major gridlines
    panel.grid.minor = element_blank(),    #no minor gridlines
    axis.ticks = element_blank(),          #strip axis ticks
    axis.text.y=element_blank(),
    legend.position="bottom",
    legend.direction = "horizontal",
    strip.background = element_blank()#facet background
  )}

#font_import("/Users/linlizhou/Library/Fonts/Georgia.ttf")
#library(extrafont)
#extrafont::loadfonts()
theme_lz <- function(){ 
  font <- "Helvetica"   #assign font family up front
  theme_minimal() %+replace%    #replace elements already strips axis lines, 
    theme(
      #plot.margin = margin(t = 20, r = 10, b = 40,l = 10,unit = "pt"), 
      plot.margin=unit(c(0,0,
                    0,0),"cm"),#plot margin is how the whole (title,legend,viz all included) show on page
      panel.grid.major = element_blank(),    #no major gridlines
      panel.grid.minor = element_blank(),    #no minor gridlines
      plot.title = element_text(family = font, size = 8, face = 'bold',hjust = 0, vjust = 0,margin = margin(t=0,b=10)),#hjust=0 left, vjust=-1 close to graph (move to the bottom)
      plot.subtitle=element_text(size=8, hjust=0.5, face="italic", color="black"),
      axis.title = element_text(family = font, size = 9), 
      axis.text = element_text(family = font, size = 9), 
      axis.text.x = element_blank(),#element_text(family = font, size = 9, margin = margin(t=5,b=10)),
      axis.ticks = element_blank(),          #strip axis ticks
      axis.text.y=element_blank(),
      legend.title = element_text(family = font, size=9),
      legend.margin=margin(t=-25),
      legend.text = element_text(family = font, size=7),
      legend.position="top",
      legend.direction = "horizontal",
      strip.text = element_text(family = font, size = 9, margin = margin(t=5,b=10)),#facet label text, move up is + 1
      #strip.position = "bottom",
      strip.background = element_blank(),#facet background
      strip.text.y.left = element_text(family = font, size = 9, angle=0)#when facet label on the left, read horizontally with angel=0
    )}


theme_lz_xy <- function(){ 
  font <- "Helvetica"   #assign font family up front
  theme_minimal() %+replace%    #replace elements already strips axis lines, 
    theme(
      #plot.margin = margin(t = 40, r = 10, b = 40,l = 10,unit = "pt"), 
      panel.grid.major = element_blank(),    #no major gridlines
      panel.grid.minor = element_blank(),    #no minor gridlines
      plot.title = element_text(family = font, size = 9, face = 'bold',hjust = 0, vjust = ,
                                margin = margin(t=0,b=10)),
      #hjust=0 left, vjust=-1 close to graph (move to the bottom)
      plot.subtitle=element_text(size=8, hjust=0.5, face="italic", color="black"),
      axis.title = element_blank(),#element_text(family = font, size = 9), 
      axis.text = element_text(family = font, size = 8), 
      axis.text.x = element_text(family = font, size = 8),
      axis.ticks = element_blank(),          #strip axis ticks
      axis.text.y=element_text(family = font, size=8),
      legend.title = element_blank(),
      legend.margin=margin(t=10),
      legend.text = element_text(family = font, size=7),
      legend.position="right",
      legend.direction = "vertical",
      strip.text = element_text(family = font, size = 8),#facet label text, move up is + 1
      #strip.position = "bottom",
      strip.background = element_blank(),#facet background
      strip.text.y.left = element_text(family = font, size = 8, angle=0)#when facet label on the left, read horizontally with angel=0
    )}

theme_lz_x<-function(){ 
  font <- "Helvetica"   #assign font family up front
  theme_minimal() %+replace%    #replace elements already strips axis lines, 
    theme(
      #plot.margin = margin(t = 40, r = 10, b = 40,l = 10,unit = "pt"), 
      panel.grid.major = element_blank(),    #no major gridlines
      panel.grid.minor = element_blank(),    #no minor gridlines
      plot.title = element_text(family = font, size = 9, face = 'bold',hjust = 0, vjust = ,
                                margin = margin(t=0,b=10)),
      #hjust=0 left, vjust=-1 close to graph (move to the bottom)
      plot.subtitle=element_text(size=8, hjust=0.5, face="italic", color="black"),
      axis.title = element_blank(),#element_text(family = font, size = 9), 
      axis.text = element_text(family = font, size = 8), 
      axis.text.x = element_text(family = font, size = 8),
      axis.ticks = element_blank(),          #strip axis ticks
      axis.text.y=element_blank(),
      legend.title = element_blank(),
      legend.margin=margin(t=10),
      legend.text = element_text(family = font, size=7),
      legend.position="top",
      legend.direction = "horizontal",
      strip.text = element_text(family = font, size = 8),#facet label text, move up is + 1
      #strip.position = "bottom",
      strip.background = element_blank(),#facet background
      strip.text.y.left = element_text(family = font, size = 8, angle=0)#when facet label on the left, read horizontally with angel=0
    )}



theme_lz_ppt <- function(){
  font <- "Helvetica" #assign font family up front
  theme_minimal() %+replace% #replace elements already strips axis lines,
    theme(
      panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(), 
      plot.title = element_text(family = font, size = 28, hjust = 0.5, vjust = 2),
      axis.title = element_text(family = font, size = 20),
      axis.text = element_text(family = font, size = 20),
      axis.text.x = element_text(family = font, size = 20, margin = margin(t=5,b=10)),
      axis.ticks = element_blank(), #strip axis ticks
      axis.text.y=element_blank(),
      legend.title = element_text(family = font, size = 20),
      legend.text = element_text(family = font, size = 20),
      legend.position="bottom",
      legend.direction = "horizontal",
      strip.text = element_text(family = font, size = 20, margin = margin(t=5,b=10)),
      strip.background = element_blank()
    )}

