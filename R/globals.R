
# make CRAN happy
utils::globalVariables(c("state.abb","codebook","st","state","plot_var","year",
                         "lat","lon","year","correlates","state_icpsr","category",
                         "map_example","region","group","long",".","network_data",
                         "network_vars","State1","dyadid", "where"),
                       package = "cspp",
                       add = F)
