library(dplyr)
library(readr)
library(purrr)
library(stringr)
library(lubridate)
library(ggplot2)

chat_data <- list.files('data') %>%
  map_df(function(filename){
    channel_name <- filename %>%
      str_split('- ') %>%
      unlist %>%
      pluck(3) %>%
      str_split(' ') %>%
      unlist %>%
      pluck(1)
    
    channel_category <-  filename %>%
      str_split('- ') %>%
      unlist %>%
      pluck(2) 
    
    read_csv(paste0('data/', filename)) %>%
      mutate(channel = channel_name)  %>%
      mutate(date = dmy_hm(Date)
             , hour = hour(date)
             , date = as_date(date)
             , author = word(Author, sep = '#')
             , channel_category = channel_category) 
  })



#most popular channels
chat_data %>%
  group_by(channel) %>%
  tally(name = 'number_of_messages') %>%
  arrange(-number_of_messages)

chat_data %>%
  group_by(channel, date) %>%
  tally(name = 'number_of_messages') %>%
  group_by(channel) %>%
  summarise(avg_messages_per_day = mean(number_of_messages)) %>%
  arrange(-avg_messages_per_day) %>%
  View

#king of each channel
chat_data %>%
  group_by(channel, author) %>%
  tally(name = 'number_of_messages') %>%
  arrange(-number_of_messages) %>%
  group_by(channel) %>%
  slice(1) %>%
  View


#each person's favorite channel
chat_data %>%
  filter(channel != 'general') %>%
  group_by(channel, author) %>%
  tally(name = 'number_of_messages') %>%
  arrange(-number_of_messages) %>%
  group_by(author) %>%
  slice(1:3) %>%
  View

chat_data %>%
  group_by(channel) %>%
  mutate(total_messages = sum(n())) %>%
  ungroup() %>%
  mutate(rank = dense_rank(-total_messages)) %>%
  filter(rank <= 5) %>%
  group_by(channel, channel_category, date) %>%
  tally() %>%
  ggplot(aes(x = date, y = n, colour = channel)) + 
  geom_line()


chat_data %>%
  group_by(channel) %>%
  mutate(total_messages = sum(n())) %>%
  ungroup() %>%
  mutate(rank = dense_rank(-total_messages)) %>%
  group_by(channel, channel_category, date) %>%
  tally() %>%
  ggplot(aes(x = date, y = n, colour = channel) ) + 
  geom_line(show.legend = FALSE) +
  facet_wrap(vars(channel), ncol = 2) 
  
covid_cases <- read_csv('us.csv') %>%
  mutate(date = ymd(date)
         , covid_case_increase = cases - lag(cases))

chat_data %>%
  group_by(date) %>%
  tally(name = 'number_of_messages') %>%
  inner_join(covid_cases, by = 'date') %>%
  select(date, number_of_messages, covid_case_increase) %>%
  pivot_longer(-date) %>%
  ggplot() + 
    geom_line(aes(x = date, y = value, colour = name)) +
    facet_grid(vars(name), scales = 'free_y')

