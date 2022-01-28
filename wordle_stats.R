wordle_data <- chat_data %>%
  filter(channel %in% c('wordle-gods', 'other-sports'), str_detect(Content, 'Wordle [0-9]+ [0-9]/[0-9]'))  %>%
  mutate(content =  str_extract(Content, 'Wordle [0-9]+ [0-9]/[0-9]')) %>%
  separate(content, ' ', into = c('wordle', 'id', 'attempts')) %>%
  separate(attempts, '/', into = c('guesses', 'junk')) %>%
  select(author, date, guesses) %>%
  mutate(guesses = as.numeric(guesses))

wordle_data %>%
  group_by(author) %>%
  summarise(average_guesses = mean(guesses))


wordle_data %>%
  summarise(average_guesses = mean(guesses))
