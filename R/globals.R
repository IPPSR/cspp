
# make CRAN happy
utils::globalVariables(c("state.abb","codebook","st.abb","st","state","plot_var","year",
                         "lat","lon","year","correlates","state_icpsr","category",
                         "map_example","region","group","long","."),
                       package = "cspp",
                       add = F)
