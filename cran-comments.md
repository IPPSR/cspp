## Initial submission: 0.1.0

### Test environments
* local OS X install, R 3.5.2
* win-builder (devel and release)

### R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* installed size is  6.8Mb
    sub-directories of 1Mb or more:
      data   6.2Mb

This is a package for a dataset and necessarily contains that data, hence the data directory size.

## Resubmission: 0.2.0

This is a resubmission. In this version I have:

* Removed the redundant "A package for the" from the title of the package in the DESCRIPTION file.

* Added a citation to the description.

## Resubmission: 0.3.0

This is a resubmission. In this version I have:

* Edited the beginning of the DESCRIPTION so that it does not begin with "This package" or anything similar.

* Included the reference in the description in the requested format.

* Removed \dontrun{} from the examples for all functions that were executable. Only one use of \dontrun{} remains. The get_cites() function includes an example that demonstrates how to write a file locally and since a supplied argument is a file path it throws an error if run as an example.
