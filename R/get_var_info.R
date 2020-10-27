#' Get information regarding the CSPP variables
#'
#' \code{get_var_info} retrieves information regarding variables in the CSPP dataset.
#' The information available includes: the years each variable is observed in the data;
#' a short and long description of each variable; the source and citation for each
#' variable; and a general category that describes each variable.
#'
#' Users can request this information regarding specific variables or all the variables
#' within a specific category. Users can request exact matches of their supplied arguments
#' or allow partial matches with the \code{exact} argument. Users can also search all these
#' relevant fields (variable name, short/long description, source) for a keyword/s with the
#' supply a string \code{related_to} argument to identify variables related to a topic of interest.
#'
#' Specifying no arguments returns all the information for all the variables
#' in the CSPP dataset.
#'
#' @name get_var_info
#'
#' @param var_names Default is NULL. Takes a character string. If left blank the
#'   function does not subset by variable name.
#' @param categories Default is NULL. Takes a character string. If left blank the
#'   function does not subset by category.
#' @param related_to Default is NULL. Takes a character string. If the user supplies
#' a character string, the function searches the other relevant fields (variable name, short/long
#' description, and source) for string and returns either exact or partial matches
#' depending on the value of the \code{exact} argument.
#' @param exact Default is FALSE. If true, exact matches for the other supplied arguments
#' are used. If TRUE, then partial matches are also returned.
#'
#' @importFrom dplyr "%>%" any_vars filter_at filter
#' @importFrom rlang .data
#' @importFrom stringr str_detect
#'
#' @export
#'
#' @seealso \code{\link{get_cspp_data}}, \code{\link{get_cites}}, \code{\link{generate_map}}
#'
#' @examples
#'
#' # returns all variable information
#' get_var_info()
#'
#' # searches all columns for non-exact matches of "pop" and "fem"
#' get_var_info(related_to = c("pop","femal"))
#'
#' get_var_info(categories = "demographics")
#'
#' # returns non-exact matches for variables with "pop" and that have "femal" anywhere in the row
#' get_var_info(var_names = "pop",
#'              related_to = "femal")
#'
#'

get_var_info <- function(var_names = NULL, categories = NULL, related_to = NULL, exact = FALSE){

  if(!is.null(var_names) & !is.character(var_names)){
    stop("var_names must be a string or character vector.")
  }

  if(!is.null(categories) & !is.character(categories)){
    stop("categories must be a string or character vector.")
  }

  if(!is.null(related_to) & !is.character(related_to)){
    stop("related_to must be a string or character vector.")
  }

  # Not exact match (this will return everything if no args specified, which is good)
  if(exact == FALSE){
    vars <- paste0(var_names,  collapse = "|")
    cats <- paste0(categories, collapse = "|")
    rels <- paste0(related_to, collapse = "|")
    data <- codebook %>%
      dplyr::filter(stringr::str_detect(.data$variable, vars)) %>%
      dplyr::filter(stringr::str_detect(.data$category, cats)) %>%
      dplyr::filter_at(.vars = vars(.data$variable, .data$short_desc, .data$long_desc,
                                    .data$category, .data$sources),
                       .vars_predicate = dplyr::any_vars(stringr::str_detect(., rels)))
    if(nrow(data) == 0){
      stop("Your request returned no results.")
    }
    if(nrow(data) > 0){
      return(data)
    }
  }

  # add exact match for related_to
  if(exact == TRUE & !is.null(related_to) & is.null(var_names) & is.null(categories)){
    rels <- paste0("\\b",related_to,"\\b", collapse = "|")
    data <- data %>%
      dplyr::filter_at(.vars = vars(.data$variable, .data$short_desc, .data$long_desc,
                                    .data$category, .data$sources),
                       .vars_predicate = dplyr::any_vars(grepl(rels, ., ignore.case = T)))
    if(nrow(data) == 0){
      stop("Your request returned no results.")
    }
    if(nrow(data) > 0){
      return(data)
    }
  }

  # Exact match for variables (related_to is embedded)
  if(exact == TRUE & !is.null(var_names) & is.null(categories)){
    data <- codebook[codebook$variable %in% var_names, ]
    if(!is.null(related_to)){
      rels <- paste0("\\b",related_to,"\\b", collapse = "|")
      data <- data %>%
        dplyr::filter_at(.vars = vars(.data$variable, .data$short_desc, .data$long_desc,
                                      .data$category, .data$sources),
                         .vars_predicate = dplyr::any_vars(grepl(rels, ., ignore.case = T)))
      if(nrow(data) == 0){
        stop("Your request returned no results.")
      }
      if(nrow(data) > 0){
        return(data)
      }
    }
    if(nrow(data) == 0){
      stop("Your request returned no results.")
    }
    if(nrow(data) > 0){
      return(data)
    }
  }

  # Exact match for categories (related_to is embedded)
  if(exact == TRUE & is.null(var_names) & !is.null(categories)){
    data <- codebook[codebook$category %in% categories, ]
    if(!is.null(related_to)){
      rels <- paste0("\\b",related_to,"\\b", collapse = "|")
      data <- data %>%
        dplyr::filter_at(.vars = vars(.data$variable, .data$short_desc, .data$long_desc,
                                      .data$category, .data$sources),
                         .vars_predicate = dplyr::any_vars(grepl(rels, ., ignore.case = T)))
      if(nrow(data) == 0){
        stop("Your request returned no results.")
      }
      if(nrow(data) > 0){
        return(data)
      }
    }
    if(nrow(data) == 0){
      stop("Your request returned no results.")
    }
    if(nrow(data) > 0){
      return(data)
    }
  }

  # Exact match for variables AND categories (related_to is embedded)
  if(exact == TRUE & !is.null(var_names) & !is.null(categories)){
    data <- codebook[c(codebook$variable %in% var_names & codebook$category %in% categories), ]
    if(!is.null(related_to)){
      rels <- paste0("\\b",related_to,"\\b", collapse = "|")
      data <- data %>%
        dplyr::filter_at(.vars = vars(.data$variable, .data$short_desc, .data$long_desc,
                                      .data$category, .data$sources),
                         .vars_predicate = dplyr::any_vars(grepl(rels, ., ignore.case = T)))
      if(nrow(data) == 0){
        stop("Your request returned no results.")
      }
      if(nrow(data) > 0){
        return(data)
      }
    }
    if(nrow(data) == 0){
      stop("Your request returned no results.")
    }
    if(nrow(data) > 0){
      return(data)
    }
  }
}
