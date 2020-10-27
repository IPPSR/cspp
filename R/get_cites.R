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
#'
#' get_cites("poptotal")
#'
#'\dontrun{
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
  dataset_cite <- c("Jordan, Marty P. and Matt Grossmann. 2020. The Correlates of State Policy Project v.2.2. East Lansing, MI: Institute for Public Policy and Social Research (IPPSR).")
  dataset_bib  <- c("@misc{cspp_data, title = {The Correlates of State Policy Project v.2.2}, author = {Marty P. Jordan and Matt Grossmann}, year = {2020}, howpublished= {http://ippsr.msu.edu/public-policy/correlates-state-policy}, note = {East Lansing, MI: Institute for Public Policy and Social Research (IPPSR)}}")

  package_cite <- c("Caleb Lucas and Joshua McCrain (2020). cspp: A Package for The Correlates of State Policy Project Data. R package version 0.1.0.")
  package_bib  <- c("@Manual{cspp_package, title = {cspp: A Package for The Correlates of State Policy Project Data}, author = {Caleb Lucas and Josh McCrain}, year = {2020}, note = {R package version 0.1.0}, url = {http://ippsr.msu.edu/public-policy/correlates-state-policy}}")

  cites_df <- codebook %>%
    dplyr::filter(.data$variable %in% var_names) %>%
    dplyr::add_row(variable = "cspp_dataset",
                   plaintext_cite = dataset_cite,
                   bibtex_cite = dataset_bib) %>%
    dplyr::add_row(variable = "cspp_package",
                   plaintext_cite = package_cite,
                   bibtex_cite = package_bib) %>%
    as.data.frame()


  cites_df <- cites_df[,c("variable","plaintext_cite","bibtex_cite","plaintext_cite2","bibtex_cite2","plaintext_cite3",
                          "bibtex_cite3","years","short_desc","long_desc","sources","category")]

  get_citevec <- function(cites_col1,cites_col2){
    cites_vec1 <- as.vector(cites_col1)
    cites_vec2 <- as.vector(cites_col2)
    cites_vec  <- c(cites_vec1,cites_vec2)
    cites_vec  <- cites_vec[!is.na(cites_vec)]
  }

  cites_vec <- get_citevec(cites_df$plaintext_cite, cites_df$plaintext_cite2)
  cites_vecbib <- get_citevec(cites_df$bibtex_cite, cites_df$bibtex_cite2)

  if(print_cites == TRUE){
    # cat(paste(cites_vec,collapse = "\n\n"))
    # cat(paste(cites_df$variable," = ",cites_df$plaintext_cite,collapse = "\n\n"))
    for(i in 1:nrow(cites_df)){
      cat("----------\n")
      cat("variable = ",cites_df$variable[i], collapse = "\n")
      cat("first cite = ",cites_df$plaintext_cite[i], collapse = "\n\n")
      cat("second cite (might not be applicable) = ", cites_df$plaintext_cite2[i], collapse = "\n\n")
    }
    # cat(paste(cites_df$variable," = ",cites_df$plaintext_cite,collapse = "\n\n"))
  }

  if(write_out == TRUE){
    cat("Note that some citations might be missing. Please ensure you match the variables you use to the correct citation.")
    if(format == "bib"){
      readr::write_lines(x = cites_vecbib, path = file_path, sep = "\n\n")
    }
    if(format == "csv"){
      if(!endsWith(tolower(file_path), ".csv")){
        warning("You specified a .csv file but the provided filepath does not end with '.csv'")
      }
      readr::write_csv(x = cites_df, file_path)
    }
    if(format == "txt"){
      if(!endsWith(tolower(file_path), ".txt")){
        warning("You specified a .txt file but the provided filepath does not end with '.txt'")
      }
      readr::write_lines(x = cites_vec, path = file_path, sep = "\n\n")
    }
  }
  return(cites_df)
}








