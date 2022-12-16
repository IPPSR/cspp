
# prints when the package is attached using library()
.onAttach <- function(libname, pkgname) {
  # inform user if there is updated data? tell them their local version?
  # only do this if they have an outdated version of the package?
  # print cite here for package and for the overall dataset
  packageStartupMessage("Please cite:\n")
  packageStartupMessage("Caleb Lucas and Joshua McCrain (2020). cspp: A Package for The Correlates of State Policy Project Data.")
  packageStartupMessage("R package version 0.3.3.\n")
  packageStartupMessage("Grossmann, M., Jordan, M. P. and McCrain, J. (2021) 'The Correlates of State Policy and the Structure of State Panel Data,'")
  packageStartupMessage("State Politics & Policy Quarterly. Cambridge University Press, pp. 1-21. doi: 10.1017/spq.2021.17.")
  packageStartupMessage("\nYou are using the version of the Correlates Dataset stored in your local copy of csppData. Running `library(csppData)` will print your version number.\n")
}

