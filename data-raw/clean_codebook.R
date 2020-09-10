library(readr)
library(dplyr)

codebook <- read_csv("data-raw/Corcodebook_table.csv")

# arrange the columns in a sensible order
codebook <- codebook[, c("variablename","years","short.description","longer.description","sources")]
colnames(codebook) <- c("var_names","years","short_desc","long_desc","sources")

codebook <- codebook %>%
  ungroup %>%
  mutate(var_names = str_replace_all(var_names, "\n|\r", "") %>% str_trim)

var_names_db %>% filter(!(var_names %in% codebook$var_names) & !(var_names %in% c("year", "st.abb", "state", "state_fips", "state_icpsr", "st", "stateno"))) %>% View

## clean up some bad variable names:
codebook$var_names[codebook$var_names=="ranney_alt_4yrs"] <- "ranney_4yrs_alt"
codebook$var_names[codebook$var_names=="ranney_alt_6yrs"] <- "ranney_6yrs_alt"
codebook$var_names[codebook$var_names=="ranney_alt_8yrs"] <- "ranney_8yrs_alt"
codebook$var_names[codebook$var_names=="ranney_alt_10yrs"] <- "ranney_10yrs_alt"
codebook$var_names[codebook$var_names=="stateleg_sour"] <- "stateleg_source"
codebook$var_names[codebook$var_names=="corruption_convict"] <- "corrupt_convict"
codebook$var_names[codebook$var_names=="famlimit"] <- "famlim"
codebook$var_names[codebook$var_names=="candlimit"] <- "candlim"
codebook$var_names[codebook$var_names=="corplimits"] <- "corporlimits"
codebook$var_names[codebook$var_names=="contrib_comm_elec"] <- "contrib_comm_elect"
codebook$var_names[codebook$var_names=="contrib_ideo_singiss"] <- "cotrib_ideo_singiss"
codebook$var_names[codebook$var_names=="audio_visualdeposition"] <- "audio_visual_deposition"
codebook$var_names[codebook$var_names=="regulation_forced_sterlizations"] <- "regulation_forced_sterilizations"
codebook$var_names[codebook$var_names=="x_chip_pregnantwomen_prebba"] <- "x_chip_pregntwomen_prebba"
codebook$var_names[codebook$var_names=="ucc_article_9_secured_transacti"] <- "ucc_article_9__secured_transacti"

codebook <- codebook %>%
  bind_rows(codebook %>% filter(var_names == "avgsoc_mid") %>% mutate(var_names="avgsoc_high"))


# merge the categories using the var_name
load("data/var_names_db.rda")
codebook <- left_join(codebook,var_names_db)
colnames(codebook)[colnames(codebook) == "var_names"] <- "variable"

var_names_db %>% filter(!(var_names %in% codebook$variable) & !(var_names %in% c("year", "st.abb", "state", "state_fips", "state_icpsr", "st", "stateno"))) %>% View

#save("~/Dropbox/cspp/data/codebook.rda")

usethis::use_data(codebook, overwrite = T, compress = 'xz')
