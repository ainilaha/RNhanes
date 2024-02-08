
library(nhanesA)

demo_all = nhanesSearchTableNames("DEMO")
demo_all

all_demo_data = sapply(demo_all, nhanes, simplify = FALSE)
sapply(all_demo_data, dim)

## skip P_DEMO

all_demo_data = head(all_demo_data, -1)
common_vars = lapply(all_demo_data, names) |> Reduce(f = intersect)
common_vars
demo_combined = lapply(all_demo_data, `[`, common_vars) |> do.call(what = rbind)
dim(demo_combined)


library(ragg)


library("ggplot2")

demo_combined <- transform(demo_combined, cycle = substring(SDDSRVYR, 8, 17))
## demo_combined <- transform(demo_combined, cycle = factor(as.numeric(SDDSRVYR)))

agg_png(filename = "images/demoplot.png",
        pointsize = 20, res = 96,
        width = 12 * 1.2, height = 7 * 1.2, units = "in")

## png(filename = "images/demoplot.png", width = 1200, height = 700)

demo_combined |> 
    xtabs(~ cycle + RIAGENDR + RIDRETH1, data = _) |>
    array2DF() |>
    ggplot(aes(x = cycle, y = Value, color = RIDRETH1, group = RIDRETH1)) +
        geom_point() + geom_path() + facet_wrap(~ RIAGENDR, nrow = 2)

dev.off()

