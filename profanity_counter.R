swears <- c('bad', words)

swear_df <- map_df(swears, function(swear){
  
  chat_data %>%
    mutate(swear_count = str_count(tolower(Content), swear)
           , swear_word = swear) %>%
    group_by(author, swear_word) %>%
    summarise(swear_count = sum(swear_count, na.rm = TRUE))
})

swear_df %>%
  group_by(swear_word) %>%
  summarise(times_used = sum(swear_count)) %>%
  arrange(-times_used)

swear_df %>%
  group_by(author, swear_word) %>%
  summarise(times_used = sum(swear_count)) %>%
  arrange(author, -times_used) %>%
  group_by(author) %>%
  slice(1) %>%
  filter(times_used > 0) %>%
  View
