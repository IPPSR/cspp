## Resubmission: 0.3.1

This is a resubmission. In this version we have:

* Deleted the data files that previously made this package >5mb and, as requested, moved them to a separate, data only package.

* Added a new function, plot_panel, that visualizes the data from the package.

* Edited the existing get_cspp_data function to include a new argument (core) that allows users to merge a set of common variables into the result of their search request regardless of whether it matches those variables.

* Edited the documentation to include more detailed descriptions and uses cases of the functions and data.

### Test environments

* local OS X install, R 3.5.2
* win-builder (devel and release)

### R CMD check results

* No ERRORs

* No WARNINGs

* No NOTEs