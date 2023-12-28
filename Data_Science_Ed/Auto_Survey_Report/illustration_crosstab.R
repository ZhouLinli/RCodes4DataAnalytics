raw<-read_csv("SurveyExport.csv")
df<-raw%>%
  rename(Frequency=`How often do you think we should meet?`,
         Length=`How long should we meet?`)%>%
  select(Frequency,Length)

df%>%
  group_by(Frequency,Length)%>%
  summarize(n=n())%>%
  #formatting
  mutate(Percentage=formattable::percent(n/sum(n),digits=0))%>%select(-n)%>%
  arrange(-Percentage)%>%
  kbl(align = "l") %>%kable_styling(latex_options = c('HOLD_position'), full_width = F, fixed_thead = T, font_size = 12)%>%row_spec(0, bold = TRUE)

