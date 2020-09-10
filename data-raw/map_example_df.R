# generate dataframe as example for generate_map

library(tidyverse)

map_example <- correlates %>%
  dplyr::filter(!is.na(poptotal)) %>%
  dplyr::select(state, year, poptotal) %>%
  dplyr::group_by(state) %>%
  dplyr::arrange(year) %>%
  dplyr::filter(row_number()==n())

usethis::use_data(map_example)
