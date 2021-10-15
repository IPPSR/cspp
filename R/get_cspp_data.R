#' Load CSPP data into the R environment
#'
#' \code{get_cspp_data} loads either a full or subsetted version of the full
#' CSPP dataset into the R environment as a dataframe.
#'
#'@name get_cspp_data
#'
#' @param vars Default is NULL. If left blank, returns all variables within the
#'   dataset. Takes a string or vector of strings. See
#'   \code{\link{get_var_info}} for pulling variable names and
#'   \code{\link{get_cites}} for citations of specific variables and datasets.
#'   Names of variables must be exact matches to variables in the dataset.
#' @param var_category Default is NA. If left blank, returns all datasets. Takes
#'   a string or vector of strings.
#'
#'   Options are one of, or a combination of: "demographics", "economic-fiscal",
#'   "government", "elections", "policy_ideology", "criminal justice",
#'   "education", "healthcare", "welfare", "rights", "environment",
#'   "drug-alcohol", "gun control", "labor", "transportation", "misc.
#'   regulation"
#' @param states Default is NULL. If left blank, returns all states. Takes a
#'   string or vector of strings of state abbreviations. Use \code{state.abb} to
#'   load state abbreviations into the R environment.
#' @param years Default is NULL. If left blank, returns all years. Coverage
#'   begins at 1900 and runs to 2019. However, coverage depends on the specific
#'   variable -- see \code{get_var_info}.
#'
#'   Input can be a vector of years (or a singular year), such as c(2000, 2001,
#'   2002, 2012) or seq(2000, 2012).
#' @param core Default is FALSE. If TRUE, merge the core CSPP data (approximately 70 common and important variables) with the search result.
#' @param output Default is NULL. One of "csv", "dta", "rdata". Optional
#'   parameter for writing the resulting dataframe to a file.
#' @param path The directory to write the file to. Default is blank, so writes to
#'   working directory. Exclude final slash: e.g., \code{path = "dir1/dir2"}
#'
#' @seealso \code{\link{get_var_info}}, \code{\link{get_cites}}, \code{\link{generate_map}}
#'
#' @importFrom dplyr "%>%" filter arrange left_join full_join bind_rows group_by
#'   if_else mutate distinct rename n summarize
#' @importFrom tidyselect all_of any_of
#'
#' @export
#'
#' @examples
#'
#' ## returns full dataset
#' data <- get_cspp_data()
#'
#' ## use variable names from get_var_info
#' data <- get_cspp_data(vars = get_var_info(var_names="pctpop")$variable)
#'
#' ## return subsets
#' # note: this returns the specific variables listed as well as those in the
#' # var_category argument
#' data <- get_cspp_data(vars = c("sess_length", "hou_majority", "term_length"),
#'                       var_category = "demographics",
#'                       states = c("NC", "VA", "GA"),
#'                       years = seq(1995, 2004))
#'
#'

get_cspp_data <- function(vars = NULL,
                          var_category = NULL,
                          states = NULL,
                          years = NULL,
                          core = FALSE,
                          output = NULL,
                          path = ""){

  correlates <- csppData::correlates
  codebook   <- csppData::codebook

  data <- correlates

  #---- vars ----
  if(!is.null(vars) & is.null(var_category)) {

    # check user input
    if(!all(vars %in% codebook$variable)) {

      bad <- vars[!(vars %in% codebook$variable)]
      message(paste("Bad variable(s): ", paste(bad, collapse=", "), sep=" "))
      stop("Invalid variable name. Use get_var_info to select variables.")

    } else {

      data <- data %>%
        dplyr::select(tidyselect::all_of(c("st","stateno","state","state_fips",
                                           "state_icpsr","year")),
                      tidyselect::all_of(vars))

    }

  }

  #---- category ----
  if(!is.null(var_category) & is.null(vars)) {

    # check user input
    if(!(all(var_category %in% unique(codebook$category)))) {

      message(paste("Bad category: ", paste(var_category[!(var_category %in% unique(codebook$category))], collapse=", "), sep=" "))
      stop("Invalid category name.")

    } else {

      var_cat <- codebook %>%
        dplyr::filter(category %in% var_category)

      data <- data %>%
        dplyr::select(tidyselect::all_of(c("st","stateno","state","state_fips",
                                           "state_icpsr","year")),
                      tidyselect::all_of(var_cat$variable))

    }

  }

  #---- when both category and vars take values ----
  # need this check so as not
  # to double filter functionally, this means the returned dataframe can result
  # in variables NOT in the category the user specified

  if(!is.null(var_category) & !is.null(vars)) {

    # check user input
    if(!(all(var_category %in% unique(codebook$category)))) {

      message(paste("Bad category: ", paste(var_category[!(var_category %in% unique(codebook$category))], collapse=", "), sep=" "))
      stop("Invalid category name.")

    }
    if(!all(vars %in% codebook$variable)) {

      bad <- vars[!(vars %in% codebook$variable)]
      message(paste("Bad variable(s): ", paste(bad, collapse=", "), sep=" "))
      stop("Invalid variable name. Use get_var_info to select variables.")

    }

    var_cat <- codebook %>%
      dplyr::filter(category %in% var_category)

    var_cat <- c(var_cat$variable, vars)

    data <- data %>%
      dplyr::select(tidyselect::all_of(c("st","stateno","state","state_fips",
                                         "state_icpsr","year")),
                    tidyselect::all_of(var_cat))

  }

  #---- states ----
  if(!is.null(states)) {

    states <- stringr::str_to_upper(states)

    # check user input:
    if(!all((states %in% state.abb))) {

      message(paste("Bad state(s): ", paste(states[!(states %in% unique(correlates$st))], collapse=", "), sep=" "))
      stop("Invalid state abbreviation(s).")

    } else {

    data <- data %>%
      dplyr::filter(st %in% states) %>%
      dplyr::arrange(state)

    }

  }

  #---- years ----
  if(!is.null(years)) {

    # check user input
    if(!all(years %in% seq(1900, 2020))) {

      stop("Years must be within seq(1900, 2020)")

    } else {

      data <- data %>%
        dplyr::filter(year %in% years)

    }

  }

  # stop if empty dataframe
  if(nrow(data) == 0) {

    stop("Your request returned an empty dataframe.")

  } else {

    if(is.null(output) & path != "") {
      message("File not written: output cannot be empty.")
    }

    if(!is.null(output)) {

      if(path != "") {
        path <- paste(path, "/", sep="")
      }


      if(!(output %in% c("dta", "csv", "rdata"))) {
        stop("Value must be one of 'dta', 'csv', 'rdata'.")
      }

      if(output == "dta") {

        names(data) <- gsub("-|\\.|\\/|'|\\[|\\]", "", names(data))
        names(data) <- gsub(" ", "_", names(data))
        haven::write_dta(data, paste(path, "cspp_data.dta", sep=""))
        message("File saved to ", paste(path, "cspp_data.dta", sep=""))

      }

      if(output == "csv") {

        readr::write_csv(data, paste(path, "cspp_data.csv", sep=""))
        message("File saved to ", paste(path, "cspp_data.dta", sep=""))

      }

      if(output == "rdata") {

        save(data, file = paste(path, "cspp_data.RData", sep=""))
        message("File saved to ", paste(path, "cspp_data.dta", sep=""))

      }

    }

    # check if any of the variables have additional footnotes in the codebook:
    note_vars <- c("bfh_cpi_multiplier", "gov_fin_fy", "housing_prices_quar",
                   "noofvotes", "cartheftrate", "carthefttotal",
                   "murderrate", "murdertotal", "propcrimerate",
                   "propcrimetotal", "raperate", "rapetotal",
                   "bus_energy_consum", "bus_energy_consum_pc")

    if(length(names(data)[names(data) %in% note_vars]) > 0) {
      message("Note: the following variables have additional footnotes in the codebook (https://ippsr.msu.edu/sites/default/files/CorrelatesCodebook.pdf):\n",
              paste(names(data)[names(data) %in% note_vars], collapse = ", "))
    }

    if(core){
      core_data_vars <- c("year"
                          ,"st"
                          ,"stateno"
                          ,"state"
                          ,"state_fips"
                          ,"state_icpsr"
                          ,"poptotal"
                          ,"evangelical_pop"
                          ,"nonwhite"
                          ,"gini_coef"
                          ,"region"
                          ,"total_expenditure"
                          ,"total_revenue"
                          ,"gsppcap"
                          ,"incomepcap"
                          ,"unemployment"
                          ,"povrate"
                          ,"earned_income_taxcredit"
                          ,"x_sales_taxes"
                          ,"x_tax_burden"
                          ,"x_top_corporateincometaxrate"
                          ,"prez_election_year"
                          ,"hou_chamber"
                          ,"sen_chamber"
                          ,"h_diffs"
                          ,"s_diffs"
                          ,"inst6014_nom"
                          ,"bowen_legprof_firstdim"
                          ,"bowen_legprof_seconddim"
                          ,"speaker_power"
                          ,"pctfemaleleg"
                          ,"efna_index"
                          ,"vepvotingrate"
                          ,"ranney4_control"
                          ,"overall_fin_reg"
                          ,"oelecsc"
                          ,"opartsc"
                          ,"nonindiv_contrib"
                          ,"union_density"
                          ,"pollib_median"
                          ,"innovatescore_boehmkeskinner"
                          ,"soc_capital_ma"
                          ,"citi6013"
                          ,"wpid"
                          ,"mood"
                          ,"anti_environment"
                          ,"anti_aid"
                          ,"anti_defense"
                          ,"anti_education"
                          ,"anti_welfare"
                          ,"anti_race"
                          ,"death_penalty"
                          ,"guncontrol_stand_your_ground"
                          ,"vcrimerate"
                          ,"z_education_expenditures_per_pup"
                          ,"mathscore4th"
                          ,"readscore4th"
                          ,"sqli"
                          ,"health_rank"
                          ,"genderrights_state_eras"
                          ,"infconsent"
                          ,"w_ec_access"
                          ,"solaw"
                          ,"vaaban"
                          ,"w_environment_solar_taxcredit"
                          ,"frps"
                          ,"drugs_medical_marijuana"
                          ,"gambling_lottery_adoption"
                          ,"guncontrol_assaultweapon_ban"
                          ,"guncontrol_opencarry"
                          ,"labor_minwage_abovefed"
                          ,"labor_right_to_work"
                          )

      core <- correlates[, colnames(correlates) %in% core_data_vars]
      # core <- core %>%
      #   dplyr::rename(st.abb = st)

      return(left_join(data, core,
                       # use 'by' to suppress the dplyr joining message
                       by =  intersect(colnames(data),
                                       colnames(core)
                                       )
                       )
             )
    } else {
      return(data)
    }
  }
}

