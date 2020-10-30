## Resubmission: 0.3.1

This is a resubmission. In this version we have:

* Edited the documentation to include more detailed descriptions and uses cases of the functions and data.

* Added a new function, plot_panel, that visualizes the data from the package.

* Edited the existing get_cspp_data function to include a new argument (core) that allows users to merge a set of common variables into the result of their search request regardless of whether it marches those variables.

### Test environments
* local OS X install, R 3.5.2
* win-builder (devel and release)

### R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

    installed size is  9.7Mb
    sub-directories of 1Mb or more:
      data   7.0Mb
      help   1.6Mb

Explanation: This is a package for a dataset with good documentation and necessarily contains that data and extensive docs, hence the package size.