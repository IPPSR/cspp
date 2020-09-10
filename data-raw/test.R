library(tidyverse)

test <- get_cspp_data(vars = "pctpopfemale", var_category = "gun control", states = c("NC", "VA"), years = seq(1999, 2006))

?get_cspp_data


get_var_info(related_to = "term")$variable

data <- get_cspp_data()

data <- get_cspp_data(vars = get_var_info(var_names="pctpop")$variable)

data <- get_cspp_data(vars = c("sess_length", "hou_majority", "term_length"),
                      var_category = c("demographics", "gun control"),
                      states = c("NC", "VA", "GA"),
                      years = seq(1999, 2004))

data <- get_cspp_data(vars = get_var_info(related_to = "term")$variable,
                      var_category = c("demographics", "gun control"),
                      states = c("NC", "VA", "GA"),
                      years = seq(1999, 2004),
                      output="rdata",
                      path="../state policy")



var_names_db %>% filter(!(var_names %in% codebook$var_names) & !(var_names %in% c("year", "st.abb", "state", "state_fips", "state_icpsr", "st", "stateno"))) %>% View

cspp_data <- get_cspp_data(var_category = "demographics", year = 2005)

cspp_data <- cspp_data %>% filter(st.abb %in% c("VA", "NC", "SC"))

generate_map(cspp_data %>% filter(st.abb %in% c("VA", "NC", "SC")), poly_args = list(color = "black"), drop_NA_states = TRUE)

generate_map(get_cspp_data(var_category = "demographics"),
             var_name = "pctpopover65",
             poly_args = list(color = "black"),
             drop_NA_states = TRUE) +
  scale_fill_gradient(low = "white", high = "red") +
  theme(legend.position = "none") +
  ggtitle("% Population Over 65")

generate_map(cspp_data)

cspp_data <- get_cspp_data(var_category = "demographics")
