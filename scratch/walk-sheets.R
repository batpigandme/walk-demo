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

# use purrr to create multiple CSVs from list of dfs
# create subfolder with {fs} (if exists, does nothing)
fs::dir_create("data")
paths <- here::here("data", str_glue("gapminder_{tolower(sheets)}.csv"))
walk2(gap_dfs, paths, write_csv)

#---- STOP HERE TO SEE WHAT YOU'VE DONE ----#
# if you don't want to open the data folder, you can see them with {fs}
# the whole project tree
fs::dir_tree()
# just what's in the data folder
fs::dir_tree(here::here("data"))
# can also see the files as a list (as opposed to a tree)
fs::dir_ls(here::here("data"))

# Now delete the files using `walk()` so we can do this all over again
walk(paths, fs::file_delete)
