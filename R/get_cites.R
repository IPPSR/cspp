#' Get citations for CSPP variables
#'
#' \code{get_cites} retrieves citations for variables in the CSPP dataset. Users
#' can print the citations to the console, save them as dataframes, and write
#' them to multiple file types (csv, txt). Citations can be written in one of
#' multiple formats (plaintext, bib). Supply variable names that need to be
#' cited with the \code{var_names} argument. The function prints user-supplied
#' variable names that do not match any in the CSPP dataset by default (\code{print_nomatch}).
#' The function also returns the citation for the \code{cspp} package and the
#' CSPP dataset as a whole. We request you cite both if you use this package
#' for your research.
#'
#' @name get_cites
#'
#' @param var_names Default is NULL. Takes a character string. Should be one
#'   or more variables from the CSPP dataset. A citation for each variable
#'   is returned.
#' @param write_out Default is FALSE. Takes a logical. If FALSE the function
#'   does not write the citations out to a file.
#' @param file_path Default is NULL. Takes a character string. If \code{write_out = T}
#'   then the file will be saved to this filepath.
#' @param format Default is bib. Takes a character string. If \code{write_out = T} then
#'   the resulting file will be in this format. User must supply "bib", "csv", or "txt".
#' @param print_cites Default is FALSE. Takes a logical value. If TRUE then the
#'   function prints the citations to the console.
#' @param print_nomatch Default is TRUE. Takes a logical value. If FALSE then
#'   the function does not print variables the user supplied that had no match
#'   in CSPP.
#'
#' @importFrom readr write_lines write_csv
#' @importFrom rlang .data
#' @importFrom dplyr "%>%" filter add_row
#'
#' @export
#'
#' @seealso \code{\link{get_cspp_data}}, \code{\link{get_var_info}}, \code{\link{generate_map}}
#'
#' @examples
#'\dontrun{
#' get_cites("poptotal")
#'
#' get_cites(var_names = "poptotal",
#'           write_out = TRUE,
#'           file_path = "~/path/to/file.csv",
#'           format = "csv")
#'}

get_cites <- function(var_names, write_out = FALSE, file_path = NULL, format = "bib", print_cites = FALSE, print_nomatch = TRUE){

  if(is.data.frame(var_names)){
    var_names <- colnames(var_names)
  }
  
  if(!(format %in% c("bib","csv","txt"))){
    stop("Please choose to write the cites to a bib, csv, or txt file.")
  }

  if(sum(var_names %in% codebook$variable) == 0){
    stop("None of the provided variables match any of the CSPP variables. Please use the same variable names from CSPP.")
  }

  if(write_out == TRUE & is.null(file_path)){
    stop("Please choose a file path if you want to save the citations as a file.")
  }

  # add a 'didnt match these supplied vars' return
  if(print_nomatch == TRUE){
    no_match <- subset(var_names, !var_names %in% codebook$variable)
    if(!identical(no_match, character(0))){
      cat("The following",length(no_match),"variable/s did not match any in the CSPP dataset:\n\n")
      cat(paste0(no_match,collapse = "\n"))
      cat("\n---------------------------------\n")
    }
  }

  # Add package and dataset cite to the cite list
  package_cite <- c("Caleb Lucas and Joshua McCrain (2020). cspp: cspp: A Packge for The Correlates of State Policy Project Data. R package version 0.1.0.")
  dataset_cite <- c("Jordan, Marty P. and Matt Grossmann. 2020. The Correlates of State Policy Project v.2.2. East Lansing, MI: Institute for Public Policy and Social Research (IPPSR).")

  # change to 'cite' later, use 'sources' now
  cites_df <- codebook %>%
    dplyr::filter(.data$variable %in% var_names) %>%
    dplyr::add_row(sources = package_cite) %>%
    dplyr::add_row(sources = dataset_cite) %>%
    as.data.frame()

  cites_vec <- as.vector(cites_df$sources)

  if(print_cites == TRUE){
    cat(paste(cites_vec,collapse = "\n\n"))
  }

  cites_df <- data.frame(var_name = c("cspp","CSPP Dataset",na.omit(cites_df$variable)),
                         citation = cites_vec)

  if(write_out == TRUE){
    if(format == "bib"){
      readr::write_lines(x = cites_vec, path = file_path, sep = "\n\n")
    }
    if(format == "csv"){
      # make sure file_path ends in .csv
      readr::write_csv(x = cites_df, file_path)
    }
    if(format == "txt"){
      # make sure file_path ends in .txt
      readr::write_lines(x = cites_vec, path = file_path, sep = "\n\n")
    }
  }
  return(cites_df)
}








