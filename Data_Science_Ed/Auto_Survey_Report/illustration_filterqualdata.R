raw<-read_csv("SurveyExport.csv")
#check: colnames(raw)

#select open-ended questions/comments
qual<-raw%>%
  select(starts_with(c("Other","Please share","If applicable", "What", "If you", "Is there")))

#clean
qual<-qual%>%#remove col that has nrow-1 NA
  select(-which(colSums(is.na(.))==nrow(.)-1)) %>%
  #remove col/row that all NA
  janitor::remove_empty(c("rows", "cols"))

#save: save to csv, if the export is csv format (so that cells are properly blank)
qual%>%
  write.csv("/Users/linlizhou/Downloads/qual.csv")
