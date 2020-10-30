
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cspp: A Package for The Correlates of State Policy Project Data

<!-- badges: start -->

[![Build
Status](https://travis-ci.com/correlatesstatepolicy/cspp.svg?branch=master)](https://travis-ci.org/correlatesstatepolicy/cspp)
[![](https://www.r-pkg.org/badges/version/cspp?color=blue)](https://cran.r-project.org/package=cspp)
[![](http://cranlogs.r-pkg.org/badges/grand-total/cspp?color=blue)](https://cran.r-project.org/package=cspp)
<!-- badges: end -->

**cspp** is a package designed to allow a user with only basic knowledge
of R to find variables on state politics and policy, create and export
datasets from these variables, subset the datasets by states and years,
create map visualizations, and export citations to common file formats
(e.g.,
`.bib`).

## Updates:

<!-- * **Version 0.3.1** -- Added the `plot_panel` function which facilitates the creation of timeseries plots, similar to [panelView](http://yiqingxu.org/software/panelView/panelView.html).  -->

**Version 0.3.1**

– Added the `plot_panel` function which facilitates the creation of
timeseries plots, similar to
[panelView](http://yiqingxu.org/software/panelView/panelView.html).

– Added the `core` argument to the `get_cspp_data` function. Set it to
`TRUE` to merge in common and important variables from the CSPP data.
Useful for teaching purposes.

## The Correlates of State Policy

[The Correlates of State Policy
Project](http://ippsr.msu.edu/public-policy/correlates-state-policy)
compiles more than 2,000 variables across 50 states (+ DC) from
1900-2016. The variables cover 16 broad categories:

  - Demographics and Population
  - Economic and Fiscal Policy
  - Government
  - Elections
  - Policy Scores and Public Opinion
  - Criminal Justice and the Legal System
  - Education
  - Healthcare and Health Insurance
  - Welfare Policy
  - Rights and Anti-Discrimination Protections
  - Environment
  - Drug and Alcohol Policy
  - Gun Control
  - Labor
  - Transportation
  - Regulatory Policy

## Basic Use: Finding and Returning State Politics Data

``` r
# For latest developmental verison:
library(devtools)
install_github("correlatesstatepolicy/cspp")

# For CRAN version:
install.packages("cspp")
```

The primary functions in this package are `get_var_info` and
`get_cspp_data`. The basic workflow for using this package is to 1) find
variables of interest and 2) pull them from the full data into a
dataframe within the R environment. Below is a basic working example.

``` r
# Load the package
library(cspp)

# Find variables based on a category
demo_variables <- get_var_info(categories = "demographics")

# Use these variables to get a full or subsetted version of the data
cspp_data <- get_cspp_data(vars = demo_variables$variable, 
                           years = seq(2000, 2010))
```

The `get_cspp_data` function returns a properly formatted state-year
panel, facilitating regressions and merging based on common state
identifiers.

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
glimpse(cspp_data[1:15],)
#> Rows: 561
#> Columns: 15
#> $ year          <int> 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2…
#> $ st.abb        <chr> "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "…
#> $ stateno       <dbl> 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 8.5, 9.0, 10.0,…
#> $ state         <chr> "Alabama", "Alaska", "Arizona", "Arkansas", "California…
#> $ state_fips    <int> 1, 2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19…
#> $ state_icpsr   <int> 41, 81, 61, 42, 71, 62, 1, 11, 55, 43, 44, 82, 63, 21, …
#> $ poptotal      <int> 4451687, 627428, 5166810, 2678217, 33998767, 4327788, 3…
#> $ popdensity    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ popfemale     <dbl> 2300000, 302820, 2600000, 1400000, 17000000, 2100000, 1…
#> $ pctpopfemale  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ popmale       <dbl> 2100000, 324112, 2600000, 1300000, 17000000, 2200000, 1…
#> $ pctpopmale    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ popunder5     <dbl> 295992, 47591, 382386, 181585, 2500000, 297505, 223344,…
#> $ pctpopunder14 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ pop5to17      <dbl> 827430, 143126, 984561, 498784, 6800000, 803290, 618344…
```

Even more generally, you can load the entire set of variables and/or the
entire set of data (all 900+ variables) into R through passing these
functions without any parameters:

``` r
# All variables
all_variables <- get_var_info()

# Full dataset
all_data <- get_cspp_data()
#> Note: the following variables have additional footnotes in the codebook (https://ippsr.msu.edu/sites/default/files/CorrelatesCodebook.pdf):
#> bfh_cpi_multiplier, gov_fin_fy, housing_prices_quar, noofvotes, cartheftrate, carthefttotal, murderrate, murdertotal, propcrimerate, propcrimetotal, raperate, rapetotal, bus_energy_consum, bus_energy_consum_pc
```

## Finding Variables

Given the large number of variables in the data, we provide additional
functionality within `get_var_info` to search for variables based on
strings or categories. For instance, the following searches for `pop`
and `femal` within the variable name, returning 31 variables:

``` r
# Search for variables by name
get_var_info(var_names = c("pop","femal")) %>% dplyr::glimpse()
#> Rows: 31
#> Columns: 12
#> $ variable        <chr> "poptotal", "popdensity", "popfemale", "pctpopfemale"…
#> $ years           <chr> "1900-2008,2012-2017", "1975-1999", "1994-2010", "201…
#> $ short_desc      <chr> "Population total", "Population density", "Female pop…
#> $ long_desc       <chr> "Total population per state", "Number of people per s…
#> $ sources         <chr> "U.S. Census Bureau (http://www.census.gov/)\r\nOrigi…
#> $ category        <chr> "demographics", "demographics", "demographics", "demo…
#> $ plaintext_cite  <chr> NA, "Ryu, Seung-Hyun. The effect of political ideolog…
#> $ bibtex_cite     <chr> NA, "@phdthesis{ryu2009effect,\r\n  title={The effect…
#> $ plaintext_cite2 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ bibtex_cite2    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ plaintext_cite3 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ bibtex_cite3    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
```

A similar line of code using the `related_to` parameter, instead of
`var_name`, searches within the name **and** the description fields,
returning 96 results:

``` r
# Search by name and description:
get_var_info(related_to = c("pop", "femal")) %>% dplyr::glimpse()
#> Rows: 96
#> Columns: 12
#> $ variable        <chr> "poptotal", "popdensity", "popfemale", "pctpopfemale"…
#> $ years           <chr> "1900-2008,2012-2017", "1975-1999", "1994-2010", "201…
#> $ short_desc      <chr> "Population total", "Population density", "Female pop…
#> $ long_desc       <chr> "Total population per state", "Number of people per s…
#> $ sources         <chr> "U.S. Census Bureau (http://www.census.gov/)\r\nOrigi…
#> $ category        <chr> "demographics", "demographics", "demographics", "demo…
#> $ plaintext_cite  <chr> NA, "Ryu, Seung-Hyun. The effect of political ideolog…
#> $ bibtex_cite     <chr> NA, "@phdthesis{ryu2009effect,\r\n  title={The effect…
#> $ plaintext_cite2 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ bibtex_cite2    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ plaintext_cite3 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ bibtex_cite3    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
```

You can also return whole categories of variables. The full list of
variable categories is available within the help file for
`?get_cspp_data`. You can alternatively see the list of categories
through the below snippet of code.

``` r
# See variable categories:
unique(get_var_info()$category)
#>  [1] "demographics"     "economic-fiscal"  "environment"      "government"      
#>  [5] "elections"        "policy-ideology"  "criminal justice" "education"       
#>  [9] "healthcare"       "welfare"          "rights"           "drug-alcohol"    
#> [13] "gun control"      "labor"            "transportation"   "misc. regulation"
```

``` r
# Find variables by category:
var_cats <- get_var_info(categories = c("gun control", "labor"))
```

You can then use the variable column in this dataframe to pull data from
`get_cspp_data` through `var_cats$variable`, an example of which is
below.

Another option in finding a variable is to load the variables into a
dataframe and use RStudio’s filter feature to search:

![RStudio Filter](man/figures/README-filter.png)

## Pulling data

The function `get_cspp_data` takes the following parameters, all of
which are optional:

  - `vars` - The specific (exact match) variable(s) to pull. Takes a
    single variable or a vector of variable names.
  - `var_category` - The category or categories from which to pull.
    Takes a single category or vector of categories from the 16 listed
    above.
  - `states` - Select which states to grab data from. States must be
    abbreviated and can take a vector or individual state. See
    `?state.abb` for an easy way to load state abbreviations.
  - `years` - Takes a single year or a vector or sequence of years, such
    as `seq(2001, 2005)`.
  - `output` - Choose to write the resulting dataframe straight to a
    file. Optional outputs include `csv`, `dta`, or `rdata`.
  - `path` - If outputting the file, choose where to write it to. If
    left blank, the file will save to your working directory.

In this example, the resulting dataframe includes the variables
`c("sess_length", "hou_majority", "term_length")` as well as all
variables in the category `demographics` for North Carolina, Virgina,
and Georgia from 1994 to 2004.

``` r
# Get subsetted data and save to dataframe
data <- get_cspp_data(vars = c("sess_length", "hou_majority", "term_length"),
                      var_category = "demographics",
                      states = c("NC", "VA", "GA"),
                      years = seq(1995, 2004))
```

You can also pass the `get_var_info` function into the `vars` parameter
of `get_cspp_data`, skipping a step:

``` r
# Use get_var_info to generate variable vector inline
get_cspp_data(vars = get_var_info(related_to = "concealed carry")$variable,
              states = "NC",
              years = 1999)
#>   year st.abb stateno          state state_fips state_icpsr bjourn bprecc
#> 1 1999     NC      33 North Carolina         37          47      2      1
```

Where the two returned variables, `bjourn` and `bprecc`, deal with
concealed carry of guns in motor vehicles and whether state laws
pre-empt local laws, respectively.

### Citations

Each variable in the CSPP data was collected from external sources.
We’ve made it easy to cite the source of each variable you use with
the `get_cites` function.

This function takes a variable name or vector of variable names (such as
that generated by the `get_var_info` function) and returns a dataframe
of citations.

``` r
# Simple dataframe for one variable
get_cites(var_names = "poptotal") %>% dplyr::glimpse()
#> Rows: 3
#> Columns: 12
#> $ variable        <chr> "poptotal", "cspp_dataset", "cspp_package"
#> $ plaintext_cite  <chr> NA, "Jordan, Marty P. and Matt Grossmann. 2020. The C…
#> $ bibtex_cite     <chr> NA, "@misc{cspp_data, title = {The Correlates of Stat…
#> $ plaintext_cite2 <chr> NA, NA, NA
#> $ bibtex_cite2    <chr> NA, NA, NA
#> $ plaintext_cite3 <chr> NA, NA, NA
#> $ bibtex_cite3    <chr> NA, NA, NA
#> $ years           <chr> "1900-2008,2012-2017", NA, NA
#> $ short_desc      <chr> "Population total", NA, NA
#> $ long_desc       <chr> "Total population per state", NA, NA
#> $ sources         <chr> "U.S. Census Bureau (http://www.census.gov/)\r\nOrigi…
#> $ category        <chr> "demographics", NA, NA

# Using get_var_info to return variable citations
cite_ex <- get_cites(var_names = get_var_info(related_to = "concealed carry")$variable)
cite_ex$plaintext_cite[3:4]
#> [1] "Jordan, Marty P. and Matt Grossmann. 2020. The Correlates of State Policy Project v.2.2. East Lansing, MI: Institute for Public Policy and Social Research (IPPSR)."
#> [2] "Caleb Lucas and Joshua McCrain (2020). cspp: A Package for The Correlates of State Policy Project Data. R package version 0.1.0."
```

There is also an option to output the citations to a .bib, .csv or .txt
file:

``` r
get_cites(var_names = "poptotal",
         write_out = TRUE,
         file_path = "~/path/to/file.csv",
         format = "csv")
```

## Maps and Choropleths

The `generate_map` function uses the CSPP data to generate US maps with
states filled in based on the value of a given variable (also called
choropleths). This function returns a `ggplot` object so it is highly
customizable. The optional parameters are:

  - `cspp_data` - A dataframe ideally generated by the `get_cspp_data`
    function. Any dataframe will work as long as it has the columns
    `st.abb`, `year`, and any additional column from which to fill in
    the map.
  - `var_name` - The specific variable to use to fill in the map. If
    left blank, it will take the first column after `year` and `st.abb`.
  - `average_years` - Default is FALSE. If set to TRUE, this returns a
    map that averages over all of the years per state in the dataframe.
    So if there are multiple years of population per state, it plots the
    average population per state in the panel.
  - `drop_NA_states` - By default, the function keeps states that are
    missing data, resulting in them being filled in as gray. If this is
    set to TRUE, the states are dropped. See the example below.
  - `poly_args` - A list of arguments that determine the aesthetics of
    state shapes. See `ggplot2::geom_polygon` for options.

**Note**: This function will attempt to plot any variable type; however,
plotting character or factor values on a map will likely result in a
hard to interpret graph.

``` r
library(ggplot2) # optional, but needed to remove legend

# Generates a map of the percentage of the population over 65
generate_map(get_cspp_data(var_category = "demographics"),
             var_name = "pctpopover65") +
  ggplot2::theme(legend.position = "none")
```

<img src="man/figures/README-unnamed-chunk-16-1.png" width="60%" />

In this example, since the dataframe passed is generated by
`get_cspp_data(var_category = "demographics")` and contains all years
for all states in the data, the function by default returns the value of
the most recent year without missing data.

If you set `drop_NA_states` to TRUE, and pass the function a dataframe
containing only certain states, it only plots those states:

``` r
library(dplyr)

generate_map(get_cspp_data(var_category = "demographics") %>%
                dplyr::filter(st.abb %in% c("NC", "VA", "SC")),
              var_name = "pctpopover65",
              poly_args = list(color = "black"),
              drop_NA_states = TRUE) +
  ggplot2::theme(legend.position = "none")
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="60%" />

Since this function returns a `ggplot` object, you can customize it
endlessly:

``` r
generate_map(get_cspp_data(var_category = "demographics") %>%
                dplyr::filter(st.abb %in% c("NC", "VA", "SC", "TN", "GA", "WV", "MS", "AL", "KY")),
              var_name = "pctpopover65",
              poly_args = list(color = "black"),
              drop_NA_states = TRUE) +
  ggplot2::scale_fill_gradient(low = "white", high = "red") +
  ggplot2::theme(legend.position = "none") +
  ggplot2::ggtitle("% Population Over 65")
```

<img src="man/figures/README-unnamed-chunk-18-1.png" width="60%" />

## Plot timeseries data

To facilitate the visualization of the timeseries and panel nature of
the CSPP data, the `plot_panel` function takes a dataframe from
`get_cspp_data` and plots a state-year panel in one of two formats. The
parameters of this function are as follows:

  - `cspp_data` - a dataframe generated by `get_cspp_data` or,
    alternatively, a dataframe with the columns `st.abb`, `year`, plus
    one other variable.
  - `var_name` - the name of the variable to be plotted.
  - `years` - the years to include in the panel.
  - `colors` - three color values that are used in the plot. The first
    color takes the lowest values of the variable, the second the
    highest, and the third is the color used for NA values.
  - `plot_type` - one of “grid” or “line”. Defaults to “grid”. Both are
    displayed next.

The function returns a `ggplot2` object, making it easier to change and
add layers onto the generated plot.

A common research design is to use variation in policy adoption as a
‘treatment’ in a pseudo-experimental setting. This function makes it
easy to visualize when states are subject to this treatment.

``` r
# panel of all states' adoption of medical marijuana laws
cspp <- get_cspp_data(vars = "drugs_medical_marijuana")

# visualize panel:
plot_panel(cspp)
#> Values from drugs_medical_marijuana used to fill cells.
```

<img src="man/figures/README-unnamed-chunk-19-1.png" width="100%" />

The function also works with continuous variables, such as the state
policy liberalism score:

``` r
plot_panel(cspp_data = get_cspp_data(vars = "pollib_median"),
           colors = c("firebrick4", "steelblue2", "gray"),
           years = seq(1960, 2010)) +
  ggplot2::ggtitle("Policy liberalism")
#> Values from pollib_median used to fill cells.
```

<img src="man/figures/README-unnamed-chunk-20-1.png" width="100%" />

# Citation

> Caleb Lucas and Joshua McCrain (2020). cspp: A Package for The
> Correlates of State Policy Project Data. R package version 0.3.1.

# Contact

[**Caleb Lucas**](https://caleblucas.com/) - Ph.D. Candidate, Michigan
State University ([Twitter](https://twitter.com/caleblucas)) <br />
[**Josh McCrain**](http://joshuamccrain.com) - Post-doc, IPPSR, Michigan
State University ([Twitter](https://twitter.com/joshmccrain))
