# clean networks data and save in appropriate format

library(tidyverse)
library(readxl)

sheets <- excel_sheets("data-raw/statenetworks.xlsx")

read_sheets <- function(sheet_name){

  df <- read_excel("data-raw/statenetworks.xlsx", sheet = sheet_name)

  var_names <- data.frame(var_names = names(df)) %>%
    mutate(category = sheet_name)

  return(var_names)

}

network_vars <- map_df(sheets, ~read_sheets(.))

network_vars <- network_vars %>%
  filter(category != "StateNetworks") %>%
  mutate(category = str_replace_all(category, "[:punct:]", " "))

network_vars <- filter(network_vars,
                       !(var_names %in% c("State1", "State2", "State1Abbr", "State2Abbr", "dyadid")))

usethis::use_data(network_vars, overwrite = T, compress = 'xz')


## clean full data:

network_data <- read_excel("data-raw/statenetworks.xlsx", sheet="StateNetworks")

network_data <- network_data %>%
  mutate_at(vars(S1region:S2HighlyReligious), list(~ifelse(. == "NA", NA, .)))

network_data <- type_convert(network_data)

network_data <- rename(network_data, st.abb1 = State1Abbr, st.abb2 = State2Abbr)

usethis::use_data(network_data, overwrite = T, compress = 'xz')
