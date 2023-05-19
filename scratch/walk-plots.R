suppressPackageStartupMessages(library(tidyverse))
# conditional bars function from R4DS
# see <https://r4ds.hadley.nz/functions.html#combining-with-other-tidyverse>
conditional_bars <- function(df, condition, var) {
  df |>
    filter({{ condition }}) |>
    ggplot(aes(x = {{ var }})) +
    geom_bar() +
    ggtitle(rlang::englue("Count of diamonds by {{var}} where {{condition}}"))
}

# test run with one to make sure it works
diamonds |> conditional_bars(cut == "Good", clarity)

cuts <- levels(diamonds$cut)

# make the plots
plots <- map(cuts, \(x) conditional_bars(df = diamonds, cut == {{ x }}, clarity))

# make the file names
# make the folder to put them it (if exists, {fs} does nothing)
fs::dir_create("plots")
plot_paths <- here::here("plots", str_glue("{tolower(cuts)}_clarity.png"))

# use walk to save the plots
walk2(
  plot_paths,
  plots,
  \(path, plot) ggsave(path, plot, width = 6, height = 6)
)

# let's see what's in the plots folder using `fs::dir_tree()`
fs::dir_tree("plots")

# if you prefer, you can keep this info in a data frame
cut_plots <- tibble::tibble(
  cuts = cuts,
  plots = plots,
  paths = plot_paths
)
# your walk2 function, above, would then use
# `cut_plots$paths`, and `cut_plots$plots` for the arguments

# for more info, see the saving plots section of the iteration ch in R4DS
# src: <https://r4ds.hadley.nz/iteration.html#saving-plots>

# to delete all the plots, you can use `walk()` with `fs::file_delete()`
walk(plot_paths, fs::file_delete)
