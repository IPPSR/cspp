## Test environments
* local OS X install, R 3.5.2
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* installed size is  6.8Mb
    sub-directories of 1Mb or more:
      data   6.2Mb

This is a pacakage for a dataset and necessarily contains that data, hence the data directory size.

## Resubmission

This is a resubmission. In this version I have:

* Removed the redundant "A package for the" from the title of the package in the DESCRIPTION file.

* Added a citation to the description.
