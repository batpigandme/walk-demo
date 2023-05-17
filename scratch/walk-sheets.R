library(tidyverse)
library(googlesheets4)
# since we're using data built into googlesheets4 we don't need to auth
gs4_deauth()
ss <- gs4_example("gapminder")
sheets <- sheet_names(ss)
gap_dfs <- map(sheets, .f = \(x) read_sheet(ss, sheet = x))
# combine the sheets into a single data frame
gap_combined <- gap_dfs |> 
  list_rbind()
# use purrr to create multiple csvs from list of dfs
paths <- here::here("data", str_glue("gapminder_{tolower(sheets)}.csv"))
walk2(gap_dfs, paths, write_csv)
