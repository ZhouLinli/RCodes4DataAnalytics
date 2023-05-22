#define raw_tweets
raw_tweets<-dataedu::tt_tweets

#define tt_tweets
tt_tweets<-raw_tweets%>%select(text,status_id)%>%unnest_tokens(input=text,output=word)#texts and their ids cols

#define token
token<-raw_tweets%>%select(text,status_id)%>%#texts and their ids cols
  unnest_tokens(input=text,output=word) %>%#take text col to word col that has one word per row
  anti_join(stop_words, by = "word")%>%#remove meaningless words
  inner_join(get_sentiments("nrc")[get_sentiments("nrc")$sentiment%in%c("negative","positive"),], by="word") # nrc is a col of words; we get each nrc's sentiments (only care about neg vs pos so only filter those in the sentiment list for now






#summary: top sentiments
token%>%count(sentiment,sort = T)


#find the id that contains X word
# make sure the word exist: grep("^t",token$word,value = T)
xword<-"top"
x_tokens_id <- token %>% filter(word == xword) %>% distinct(status_id)

#get the id/text's associate words and sentiment
token%>%filter(status_id%in%x_tokens_id$status_id)%>%count(word,sentiment,sort = T)%>%filter(word!=xword)%>%
  pivot_wider(names_from = sentiment,values_from = n,values_fill = 0)%>%adorn_totals("row")%>%#mutate(across(2:3,~sum(.x,na.rm = T)))
  filter(positive>5 | negative >5)#top word associated, and sum pos vs neg in total
  

#single id invest/experiment
n<-sample(1:nrow(x_tokens_id),size = 1)
token%>%filter(status_id==x_tokens_id[n,"status_id"]$status_id)
t<-raw_tweets%>%filter(status_id==x_tokens_id[n,"status_id"]$status_id)%>%select(text);t




#explore conflict token
conflict_tk<-token%>%group_by(status_id)%>%count(sentiment)%>%
  #filter out status id that appeared twice , meaning they have two sentiment rows
  count(status_id)%>%filter(n>1)

#see those conflict token
token%>%filter(status_id%in% conflict_tk$status_id)%>%
  #summarize their sentiment
  group_by(status_id)%>%count(sentiment)%>%
  #calc neg vs pos
  pivot_wider(names_from = sentiment,values_from = n)#%>%#when negative is more: filter(negative>2)

#single id invest/expriment
token%>%filter(status_id=="1019678731571515392")
t<-raw_tweets%>%filter(status_id=="1019678731571515392")%>%select(text);t

#conclusion from conflict token investigation: n_pos vs n_neg might be a good enough indicator for the whole tweets/text/status_id's sentiment.



#explore "not" token (before removing stop words)
not_id<-raw_tweets%>%select(text,status_id)%>%unnest_tokens(input=text,output=word)%>% #texts and their ids cols
#select id that contain "not"
  filter(word == "not") %>% distinct(status_id)

#see those not in token
token%>%filter(status_id%in% not_id$status_id)%>%
  #summarize their sentiment
  group_by(status_id)%>%count(sentiment)%>%
  #calc neg vs pos
  pivot_wider(names_from = sentiment,values_from = n)#%>%#when negative is more: filter(negative>2)

#single id invest/expriment
token%>%filter(status_id=="1046504087397838848")
t<-raw_tweets%>%filter(status_id=="1046504087397838848")%>%select(text);t

#conclusion from "not" token investigation: n_pos vs n_neg might be a good enough indicator for the whole tweets/text/status_id's sentiment.


#questinoing the way the book identifies positive text id
#the book is Ryan A. Estrellado , Emily A. Freer - Data Science in Education Using R-Routledge (2021)
pos_tokens_id <- token %>% filter(sentiment=="positive") %>% distinct(status_id)#one pos is pos
#check what those id actual sentiment are
token%>%filter(status_id%in%pos_tokens_id$status_id)%>%
  group_by(status_id)%>%count(sentiment)%>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0)%>%
  mutate(dif=positive-negative)%>%filter(dif<0)
#conclusion: cannot filter any id that contains positive and regard that id is a positive text...


#viz1: wordcloud(words,countofwords,max.words=50,colors=colorset)
#viz2: tibble(words,countofwords)%>%top_n(50)%>%
#          ggplot(aes(x=reorder(words,countofwords),y=desc(countofwords)))+geom_col()
