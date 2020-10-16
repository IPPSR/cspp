
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cspp: A Package for The Correlates of State Policy Project Data

<!-- badges: start -->

[![Build
Status](https://travis-ci.com/correlatesstatepolicy/cspp.svg?branch=master)](https://travis-ci.org/correlatesstatepolicy/cspp)
<!-- badges: end -->

**cspp** is a package designed to allow a user with only basic knowledge
of R to find variables on state politics and policy, create and export
datasets from these variables, subset the datasets by states and years,
create map visualizations, and export citations to common file formats
(e.g., `.bib`).

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
library(devtools)
install_github("correlatesstatepolicy/cspp")
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
get_var_info(var_names = c("pop","femal"))
#> # A tibble: 31 x 12
#>    variable years short_desc long_desc sources category plaintext_cite
#>    <chr>    <chr> <chr>      <chr>     <chr>   <chr>    <chr>         
#>  1 poptotal 1900… Populatio… Total po… "U.S. … demogra… <NA>          
#>  2 popdens… 1975… Populatio… Number o… "http:… demogra… Ryu, Seung-Hy…
#>  3 popfema… 1994… Female po… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#>  4 pctpopf… 2012… Female po… Percenta… "U.S. … demogra… Hamilton, Gre…
#>  5 popmale  1994… Male popu… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#>  6 pctpopm… 2012… Male popu… Percenta… "U.S. … demogra… Hamilton, Gre…
#>  7 popunde… 1994… Populatio… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#>  8 pctpopu… 2013… Populatio… Percenta… "U.S. … demogra… Hamilton, Gre…
#>  9 pop5to17 1994… Populatio… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#> 10 pop18to… 1994… Populatio… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#> # … with 21 more rows, and 5 more variables: bibtex_cite <chr>,
#> #   plaintext_cite2 <chr>, bibtex_cite2 <chr>, plaintext_cite3 <chr>,
#> #   bibtex_cite3 <chr>
```

A similar line of code using the `related_to` parameter, instead of
`var_name`, searches within the name **and** the description fields,
returning 96 results:

``` r
# Search by name and description:
get_var_info(related_to = c("pop", "femal"))
#> # A tibble: 96 x 12
#>    variable years short_desc long_desc sources category plaintext_cite
#>    <chr>    <chr> <chr>      <chr>     <chr>   <chr>    <chr>         
#>  1 poptotal 1900… Populatio… Total po… "U.S. … demogra… <NA>          
#>  2 popdens… 1975… Populatio… Number o… "http:… demogra… Ryu, Seung-Hy…
#>  3 popfema… 1994… Female po… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#>  4 pctpopf… 2012… Female po… Percenta… "U.S. … demogra… Hamilton, Gre…
#>  5 popmale  1994… Male popu… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#>  6 pctpopm… 2012… Male popu… Percenta… "U.S. … demogra… Hamilton, Gre…
#>  7 popunde… 1994… Populatio… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#>  8 pctpopu… 2013… Populatio… Percenta… "U.S. … demogra… Hamilton, Gre…
#>  9 pop5to17 1994… Populatio… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#> 10 pop18to… 1994… Populatio… The numb… "CQ Pr… demogra… Morgan, K.O.L…
#> # … with 86 more rows, and 5 more variables: bibtex_cite <chr>,
#> #   plaintext_cite2 <chr>, bibtex_cite2 <chr>, plaintext_cite3 <chr>,
#> #   bibtex_cite3 <chr>
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
variables in the category `demographics` for North Carolina, Virginia,
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
get_cites(var_names = "poptotal")
#>       variable
#> 1     poptotal
#> 2 cspp_dataset
#> 3 cspp_package
#>                                                                                                                                                        plaintext_cite
#> 1                                                                                                                                                                <NA>
#> 2 Jordan, Marty P. and Matt Grossmann. 2020. The Correlates of State Policy Project v.2.2. East Lansing, MI: Institute for Public Policy and Social Research (IPPSR).
#> 3                                    Caleb Lucas and Joshua McCrain (2020). cspp: A Package for The Correlates of State Policy Project Data. R package version 0.1.0.
#>                                                                                                                                                                                                                                                                                              bibtex_cite
#> 1                                                                                                                                                                                                                                                                                                   <NA>
#> 2 @misc{cspp_data, title = {The Correlates of State Policy Project v.2.2}, author = {Marty P. Jordan and Matt Grossmann}, year = {2020}, howpublished= {http://ippsr.msu.edu/public-policy/correlates-state-policy}, note = {East Lansing, MI: Institute for Public Policy and Social Research (IPPSR)}}
#> 3                                         @Manual{cspp_package, title = {cspp: A Package for The Correlates of State Policy Project Data}, author = {Caleb Lucas and Josh McCrain}, year = {2020}, note = {R package version 0.1.0}, url = {http://ippsr.msu.edu/public-policy/correlates-state-policy}}
#>   plaintext_cite2 bibtex_cite2 plaintext_cite3 bibtex_cite3               years
#> 1            <NA>         <NA>            <NA>         <NA> 1900-2008,2012-2017
#> 2            <NA>         <NA>            <NA>         <NA>                <NA>
#> 3            <NA>         <NA>            <NA>         <NA>                <NA>
#>         short_desc                  long_desc
#> 1 Population total Total population per state
#> 2             <NA>                       <NA>
#> 3             <NA>                       <NA>
#>                                                                                                                                                                                                                                                                                                                                         sources
#> 1 U.S. Census Bureau (http://www.census.gov/)\r\nOriginally provided by Stateminder: A data visualization project from Georgetown University. http://stateminder.org/ (no longer accessible online)\r\nFor 2012–2017: U.S. Census Bureau, American Fact Finder: https://www.census.gov/acs/www/data/data-tables-and-tools/american- factfinder/
#> 2                                                                                                                                                                                                                                                                                                                                          <NA>
#> 3                                                                                                                                                                                                                                                                                                                                          <NA>
#>       category
#> 1 demographics
#> 2         <NA>
#> 3         <NA>

# Using get_var_info to return variable citations
get_cites(var_names = get_var_info(related_to = "concealed carry")$variable)
#>       variable
#> 1       bjourn
#> 2       bprecc
#> 3 cspp_dataset
#> 4 cspp_package
#>                                                                                                                                                        plaintext_cite
#> 1                                                                                                                                                                <NA>
#> 2                                                                                                                                                                <NA>
#> 3 Jordan, Marty P. and Matt Grossmann. 2020. The Correlates of State Policy Project v.2.2. East Lansing, MI: Institute for Public Policy and Social Research (IPPSR).
#> 4                                    Caleb Lucas and Joshua McCrain (2020). cspp: A Package for The Correlates of State Policy Project Data. R package version 0.1.0.
#>                                                                                                                                                                                                                                                                                              bibtex_cite
#> 1                                                                                                                                                                                                                                                                                                   <NA>
#> 2                                                                                                                                                                                                                                                                                                   <NA>
#> 3 @misc{cspp_data, title = {The Correlates of State Policy Project v.2.2}, author = {Marty P. Jordan and Matt Grossmann}, year = {2020}, howpublished= {http://ippsr.msu.edu/public-policy/correlates-state-policy}, note = {East Lansing, MI: Institute for Public Policy and Social Research (IPPSR)}}
#> 4                                         @Manual{cspp_package, title = {cspp: A Package for The Correlates of State Policy Project Data}, author = {Caleb Lucas and Josh McCrain}, year = {2020}, note = {R package version 0.1.0}, url = {http://ippsr.msu.edu/public-policy/correlates-state-policy}}
#>   plaintext_cite2 bibtex_cite2 plaintext_cite3 bibtex_cite3     years
#> 1            <NA>         <NA>            <NA>         <NA> 1986-2016
#> 2            <NA>         <NA>            <NA>         <NA> 1986-2016
#> 3            <NA>         <NA>            <NA>         <NA>      <NA>
#> 4            <NA>         <NA>            <NA>         <NA>      <NA>
#>                                             short_desc
#> 1                              Carry in motor vehicles
#> 2 State preemption of local concealed carry ordinances
#> 3                                                 <NA>
#> 4                                                 <NA>
#>                                                                                                                                                                                                                                                                                                                                  long_desc
#> 1 Carry in motor vehicles (peaceable journey) (0 = not permitted unless locked in container, 0.5 = permitted with CC permit/license but only if in plain view, 1 = only with concealed carry permit (unless in locked container or glove box), 2 = either 'plain view' or 'concealed' restrictions, 3 = no restrictions even if concealed)
#> 2                                                                                                                                                                                                     State preemption of local concealed carry ordinances? (0 = no, 0.5 = limited/special legislation for particular localities, 1 = yes)
#> 3                                                                                                                                                                                                                                                                                                                                     <NA>
#> 4                                                                                                                                                                                                                                                                                                                                     <NA>
#>                                                                                                                                                               sources
#> 1 Sorens, Jason, Fait Muedini, and William P. Ruger. 'State and Local Public Policies in 2006: A New Database.' State Politics & Policy Quarterly 8.3 (2008): 309–26.
#> 2 Sorens, Jason, Fait Muedini, and William P. Ruger. 'State and Local Public Policies in 2006: A New Database.' State Politics & Policy Quarterly 8.3 (2008): 309–26.
#> 3                                                                                                                                                                <NA>
#> 4                                                                                                                                                                <NA>
#>      category
#> 1 gun control
#> 2 gun control
#> 3        <NA>
#> 4        <NA>
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
  theme(legend.position = "none")
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="60%" />

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
  theme(legend.position = "none")
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="60%" />

Since this function returns a `ggplot` object, you can customize it
endlessly:

``` r
generate_map(get_cspp_data(var_category = "demographics") %>%
                dplyr::filter(st.abb %in% c("NC", "VA", "SC", "TN", "GA", "WV", "MS", "AL", "KY")),
              var_name = "pctpopover65",
              poly_args = list(color = "black"),
              drop_NA_states = TRUE) +
  scale_fill_gradient(low = "white", high = "red") +
  theme(legend.position = "none") +
  ggtitle("% Population Over 65")
```

<img src="man/figures/README-unnamed-chunk-16-1.png" width="60%" />

## Network data

The function `get_network_data` returns a dataset from the [CSPP state
networks data](http://ippsr.msu.edu/public-policy/state-networks)
consisting of 120 variables. The data is structured as state dyads (an
edge list).

``` r
# Returns dataframe of state dyads
head(get_network_data())
#> # A tibble: 6 x 120
#>   State1 State2 st.abb2 st.abb1 dyadid S1region S2region S1division S2division
#>   <chr>  <chr>  <chr>   <chr>   <chr>  <chr>    <chr>    <chr>      <chr>     
#> 1 Alaba… Alaska AK      AL      AL-AK  South    West     East Sout… Pacific   
#> 2 Alaba… Arizo… AZ      AL      AL-AZ  South    West     East Sout… Mountain  
#> 3 Alaba… Arkan… AR      AL      AL-AR  South    South    East Sout… West Sout…
#> 4 Alaba… Calif… CA      AL      AL-CA  South    West     East Sout… Pacific   
#> 5 Alaba… Color… CO      AL      AL-CO  South    West     East Sout… Mountain  
#> 6 Alaba… Conne… CT      AL      AL-CT  South    Northea… East Sout… New Engla…
#> # … with 111 more variables: Border <dbl>, Distance <dbl>, State1_Lat <dbl>,
#> #   State1_Long <dbl>, State2_Lat <dbl>, State2_Long <dbl>,
#> #   ACS_Migration <dbl>, PopDif <dbl>, State1_Pop <dbl>, State2_Pop <dbl>,
#> #   IncomingFlights <dbl>, IRS_migration <dbl>, Income <dbl>,
#> #   IRS_migration_2010 <dbl>, Income_2010 <dbl>, Imports <dbl>, GSPDif <dbl>,
#> #   S1GSP <dbl>, S2GSP <dbl>, DemDif <dbl>, S1AvgDem <dbl>, S2AvgDem <dbl>,
#> #   S1SenDemProp <dbl>, S1HSDemProp <dbl>, S2SenDemProp <dbl>,
#> #   S2HSDemProp <dbl>, IdeologyDif <dbl>, PIDDif <dbl>, S1Ideology <dbl>,
#> #   S1PID <dbl>, S2Ideology <dbl>, S2PID <dbl>, policy_diffusion_tie <dbl>,
#> #   policy_diffusion_2015 <dbl>, policy_diffusion_2000.2015 <dbl>,
#> #   LibDif <dbl>, ELibDif <dbl>, SLibDif <dbl>, S1EconomicLiberalism <dbl>,
#> #   S1SocialLiberalism <dbl>, S2EconomicLiberalism <dbl>,
#> #   S2SocialLiberalism <dbl>, MassSocLibDif <dbl>, MassEconLibDif <dbl>,
#> #   PolSocLibDif <dbl>, PolEconLibDif <dbl>, State1PolSocLib <dbl>,
#> #   State1PolEconLib <dbl>, State1MassSocLib <dbl>, State1MassEconLib <dbl>,
#> #   State2PolSocLib <dbl>, State2PolEconLib <dbl>, State2MassSocLib <dbl>,
#> #   State2MassEconLib <dbl>, perceived_similarity <dbl>, RaceDif <dbl>,
#> #   LatinoDif <dbl>, WhiteDif <dbl>, BlackDif <dbl>, AsianDif <dbl>,
#> #   NativeDif <dbl>, S1Latino <dbl>, S1White <dbl>, S1Black <dbl>,
#> #   S1Asian <dbl>, S1Native <dbl>, S2Latino <dbl>, S2White <dbl>,
#> #   S2Black <dbl>, S2Asian <dbl>, S2Native <dbl>, ReligDif <dbl>,
#> #   ChristianDif <dbl>, EvangelicalDif <dbl>, MainlineDif <dbl>, BPDif <dbl>,
#> #   CatholicDif <dbl>, MormonDif <dbl>, JewishDif <dbl>, MuslimDif <dbl>,
#> #   BuddhistDif <dbl>, HinduDif <dbl>, NonesDif <dbl>, NPDif <dbl>,
#> #   ReligiosityDif <dbl>, S1Christian <dbl>, S1Evangelical <dbl>,
#> #   S1Mainline <dbl>, S1BlackProt <dbl>, S1Catholic <dbl>, S1Mormon <dbl>,
#> #   S1Jewish <dbl>, S1Muslim <dbl>, S1Buddhist <dbl>, S1Hindu <dbl>,
#> #   S1Nones <dbl>, S1NothingParticular <dbl>, S1HighlyReligious <dbl>,
#> #   S2Christian <dbl>, S2Evangelical <dbl>, …
```

The function has two optional parameters `category` and `merge_data`. If
a category or string of categories is specified, it returns variables
only in that category (see the data documentation in the link above).
Category options are “Distance Travel Migration”, “Economic”,
“Political”, “Policy”, “Demographic”.

``` r
network.df <- get_network_data(category = c("Economic", "Political"))

names(network.df)
#>  [1] "State1"             "State2"             "st.abb2"           
#>  [4] "st.abb1"            "dyadid"             "IRS_migration"     
#>  [7] "Income"             "IRS_migration_2010" "Income_2010"       
#> [10] "Imports"            "GSPDif"             "S1GSP"             
#> [13] "S2GSP"              "DemDif"             "S1AvgDem"          
#> [16] "S2AvgDem"           "S1SenDemProp"       "S1HSDemProp"       
#> [19] "S2SenDemProp"       "S2HSDemProp"        "IdeologyDif"       
#> [22] "PIDDif"             "S1Ideology"         "S1PID"             
#> [25] "S2Ideology"         "S2PID"
```

`merge_data` simplifies merging in data from the `get_cspp_data`
function. The object passed to `merge_data` must be a dataframe with a
variable named `st.abb`, or a dataframe generated by `get_cspp_data`. If
the dataframe passed to this parameter has more than one observation per
state (a panel) then this function averages over all values per state
prior to
merging.

``` r
cspp_data <- get_cspp_data(vars = c("sess_length", "hou_majority"), years = seq(1999, 2000))

network.df <- get_network_data(category = "Distance Travel Migration",
                               merge_data  = cspp_data)
#> Warning in get_network_data(category = "Distance Travel Migration", merge_data
#> = cspp_data): There are multiple observations per state in the `data` dataframe.
#> Creating one observation per state (dplyr::summarize()) prior to merging...

names(network.df)
#>  [1] "State1"          "State2"          "st.abb2"         "st.abb1"        
#>  [5] "dyadid"          "S1region"        "S2region"        "S1division"     
#>  [9] "S2division"      "Border"          "Distance"        "State1_Lat"     
#> [13] "State1_Long"     "State2_Lat"      "State2_Long"     "ACS_Migration"  
#> [17] "PopDif"          "State1_Pop"      "State2_Pop"      "IncomingFlights"
#> [21] "sess_length"     "hou_majority"

library(dplyr)

head(cspp_data %>% arrange(st.abb))
#>   year st.abb stateno    state state_fips state_icpsr sess_length hou_majority
#> 1 1999     AK       2   Alaska          2          81      167.56        0.752
#> 2 2000     AK       2   Alaska          2          81          NA        0.752
#> 3 1999     AL       1  Alabama          1          41       60.00       -0.129
#> 4 2000     AL       1  Alabama          1          41          NA       -0.115
#> 5 1999     AR       4 Arkansas          5          42       63.19        0.118
#> 6 2000     AR       4 Arkansas          5          42          NA        0.118
# the merged value of Alaska's hou_majority value will be mean(c(-0.129, -0.115))
```

# Citation

> Caleb Lucas and Joshua McCrain (2020). cspp: A Package for The
> Correlates of State Policy Project Data. R package version 0.1.0.

# Contact

[**Caleb Lucas**](https://caleblucas.com/) - Ph.D. Candidate, Michigan
State University ([Twitter](https://twitter.com/caleblucas)) <br />
[**Josh McCrain**](http://joshuamccrain.com) - Post-doc, IPPSR, Michigan
State University ([Twitter](https://twitter.com/joshmccrain))
