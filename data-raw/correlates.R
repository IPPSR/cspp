## clean main correlates excel file, save as usable data for package functionality:
# this will provide data used in initial package installation

library(tidyverse)
library(readxl)


# eventually will need to add a check in here to see if there are multiple data versions
# then read the most update one

sheets <- excel_sheets("data-raw/correlatesofstatepolicyprojectv2_2.xlsx")

read_sheets <- function(sheet_name){

  df <- read_excel("data-raw/correlatesofstatepolicyprojectv2_2.xlsx", sheet = sheet_name)

  var_names <- data.frame(var_names = names(df)) %>%
    mutate(category = sheet_name)

  return(var_names)

}

var_names_db <- map_df(sheets, ~read_sheets(.))

var_names_db$var_names[var_names_db$var_names=="govname2...46"] <- "govname2"
var_names_db$var_names[var_names_db$var_names=="fcpi...384"] <- "fcpi"

var_names_db <- filter(var_names_db, !(var_names %in% c("fcpi...388", "govname2...47")))

note_vars <- c("bfh_cpi_multiplier", "gov_fin_fy", "housing_prices_quar",
               "noofvotes", "cartheftrate", "carthefttotal",
               "murderrate", "murdertotal", "propcrimerate",
               "propcrimetotal", "raperate", "rapetotal",
               "bus_energy_consum", "bus_energy_consum_pc")

var_names_db <- var_names_db %>%
  ungroup %>%
  mutate(addl_notes = ifelse(var_names %in% note_vars, "See codebook", NA))


# now read in full dataset and save to raw-data:

correlates <- read.csv("data-raw/correlatesofstatepolicyprojectv2_2.csv", stringsAsFactors = F)

names(correlates)[1] <- "year"

#--------------------#

correlates$years_left_before_limit_note <- stringr::str_replace_all(string = correlates$years_left_before_limit_note,
                                                                pattern = "Iâ€™m",
                                                                replacement = "I'm")

correlates$years_left_before_limit_note <- stringr::str_replace_all(string = correlates$years_left_before_limit_note,
                                                                pattern = "â€œ1â€",
                                                                replacement = "[]")

correlates$govname2_notes <- stringr::str_replace_all(string = correlates$govname2_notes,
                                                                pattern = "Agnewâ€™s",
                                                                replacement = "Agnew's")

correlates$govname2_notes <- stringr::str_replace_all(string = correlates$govname2_notes,
                                                  pattern = "oâ€™neill",
                                                  replacement = "o'neill")

correlates$years_left_before_limit_note <- stringr::str_replace_all(string = correlates$years_left_before_limit_note,
                                                  pattern = "Iâ€™m",
                                                  replacement = "I'm")

correlates$years_left_before_limit_note <- stringr::str_replace_all(string = correlates$years_left_before_limit_note,
                                                                pattern = "isnâ€™t",
                                                                replacement = "isn't")

correlates$years_left_before_limit_note <- stringr::str_replace_all(string = correlates$years_left_before_limit_note,
                                                                pattern = "Iâ€™m",
                                                                replacement = "I'm")

correlates$lame_duck_notes <- stringr::str_replace_all(string = correlates$lame_duck_notes,
                                                                pattern = "Iâ€™m",
                                                                replacement = "I'm")

#--------------------#

usethis::use_data(correlates,   overwrite = T, compress = 'xz')
usethis::use_data(var_names_db, overwrite = T, compress = 'xz')






