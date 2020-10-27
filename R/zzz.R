
# prints when the package is attached using library()
.onAttach <- function(libname, pkgname) {
  # inform user if there is updated data? tell them their local version?
  # only do this if they have an outdated version of the package?
  # print cite here for package and for the overall dataset
  packageStartupMessage("Please cite:\n")
  packageStartupMessage("Caleb Lucas and Joshua McCrain (2020). cspp: A Package for The Correlates of State Policy Project Data.")
  packageStartupMessage("R package version 0.3.0.\n")
  packageStartupMessage("Jordan, Marty P. and Matt Grossmann. 2020. The Correlates of State Policy Project v.2.2.")
  packageStartupMessage("East Lansing, MI: Institute for Public Policy and Social Research (IPPSR).")
  packageStartupMessage("\nYou are using version 2.2 of the CSPP data.\n")
}

