---
title: 'cspp: A Tool for the Correlates of State Policy Project Data'
tags:
  - R
  - dataset exploration
  - US politics
authors:
  - name: Caleb Lucas
    orcid: 0000-0003-0049-4680
    affiliation: 1
  - name: Josh McCrain
    affiliation: 2
affiliations:
 - name: RAND Corporation
   index: 1
 - name: Department of Political Science, University of Utah
   index: 2
bibliography: paper.bib
---

# Summary

The `cspp` R package provides a generalizable approach to access, subset, explore, and analyze large datasets in a research pipeline.^[The package depends on packages within the `tidyverse` [@Wickham2019]] While researchers routinely collect, combine, and explore data from a variety of disparate sources, duplicating these efforts is inefficient and the time costs associated with pursuing certain research topics limits knowledge production. `cspp` addresses this issue specifically in the context of US politics by simplifying interacting with and analyzing the Correlates of State Policy Project dataset [@grossmann_jordan_mccrain_2021]. This dataset, in an effort to address the data accessibility problem, combines more than 2,000 variables regarding all 50 US states (and DC) from 1900-2020. `cspp` allows users to easily access, search, subset, visualize, cite, and descriptively analyze any variables contained in the dataset, which continues to increase in size.

In doing so, `cspp` makes the Correlates of State Policy Project dataset accessible to researchers with a limited knowledge of `R` and improves the efficiency of the research pipeline for all scholars, including those with extensive programming experience, interested in US politics. It also demonstrates an approach that could make similar datasets in other domains that aggregate information more accessible and easier to use.

`cspp` is useful at each stage of the research process. At a project's inception, the package allows users to easily import the CSPP data into an R environment and subset the data by partial/exact string matches of variable descriptions, hand-coded variable categories, states, and years. After identifying variables of interest, users are able to visualize them in space by generating colorful maps and in time by creating state-year panel plots. They can then assess statistical relationships between variables by generating correlation plots. Finally, the package allows users to easily export citations in multiple file formats for the variables they will use in the analysis, a very useful functionality given the size of the dataset and number of disparate sources that it combines.

More specifically, the `cspp` package provides the following functionalities:

-   Import and subset the Correlates of State Policy Project (CSPP) data
-   Import and subset the companion State Networks (SN) dataset
-   Retrieve information, such as their category, source, and temporal coverage, regarding specific variables
-   Create maps that visualize any CSPP variable
-   Create visualizations that display a selected variable in a state-year panel
-   Generate correlation plots for any set of CSPP variables
-   Export the citations (plain text and BibTeX) associated with the selected portions of the CSPP data

We provide detailed descriptions of the corresponding functions and example usage in the `cspp` vignette.

# Statement of need

`cspp` is an R package available on GitHub with a stable release on CRAN that allows users to interact with the Correlates of State Policy Project dataset.^[The Correlates of State Policy Project dataset is published in *State Politics & Policy Quarterly* [@grossmann_jordan_mccrain_2021]] The package is user-friendly and provides a variety of functions that simplify common portions of the research pipeline, such as identifying variables relevant to a study, visualizing them, assessing their relationships, and obtaining their citations. The package enables users with a very limited knowledge of programming to accomplish these steps, including students learning about these processes, and streamlines the research pipeline for more advanced users already familiar with them. The package is already in use by both researchers and students and has been downloaded approximately 7,000 times.

# Acknowledgements

We thank Matt Grossmann, Director of the Institute for Public Policy and Social Research (IPPSR) and Professor of Political Science at Michigan State University, for support throughout this project. The authors are listed alphabetically.

# References