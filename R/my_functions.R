read_experiment_data <- function(day) {
  day <- str_pad(day, pad = 0, width = 2)
  paths <- fs::dir_ls(paste0("./data/",day,"/"))

  gapminder <- map_df(paths, read_csv, .id = "continent") %>% 
    mutate(continent = str_extract(continent, "(?<=/)\\w+(?=\\.csv)"))

  gapminder
}


