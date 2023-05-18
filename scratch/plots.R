gap_combined |> 
  ggplot(aes(x = lifeExp, y = gdpPercap, color = continent)) +
  geom_point(alpha = 0.6) +
  facet_wrap(~year) +
  scale_color_brewer(type = "qual", palette = "Dark2") +
  scale_y_log10(labels = scales::label_dollar()) +
  hrbrthemes::theme_ipsum_rc()
