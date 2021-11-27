library(omdbapi)
library(tidyverse)

# <https://github.com/hrbrmstr/omdbapi>
res <- search_by_title("Star Wars")
ids <- res$imdbID

starwars_movies <- map_df(ids, find_by_id) %>%
  distinct(Title, .keep_all = TRUE) %>%
  mutate(year = parse_number(Year)) %>%
  select(-Year)

write_rds(starwars_movies, "data/07/starwars_movies.rds")



# library(glue)
# library(httr)
# 
# title <- "Star Wars"
# key <- "k_12345678"
# url <- glue("https://imdb-api.com/en/API/SearchTitle/{key}/{title}")
# res <- GET(url, )
# content(res)
# 



