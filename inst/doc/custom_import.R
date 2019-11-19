## -----------------------------------------------------------------------------
library(lightr)

## -----------------------------------------------------------------------------
jdx_files <- list.files("data/heliomaster", pattern = "jdx$", full.names = TRUE)

## -----------------------------------------------------------------------------
first_jdx <- lr_parse_jdx(jdx_files[1])[[1]]
head(first_jdx)

## -----------------------------------------------------------------------------
res <- first_jdx[, c("wl", "processed")]

## -----------------------------------------------------------------------------
for (i in 2:length(jdx_files)) {
  next_jdx <- lr_parse_jdx(jdx_files[i])[[1]]
  
  res <- cbind(res, next_jdx[, "processed"])
}
colnames(res) <- c("wl", paste0("spec", seq_along(jdx_files)))

## -----------------------------------------------------------------------------
library(pavo)
res <- na.omit(res)
res <- res[res$wl > 300 & res$wl < 700, ]
res <- as.rspec(res, interp = FALSE, whichwl = 1)

plot(res)

## ---- eval = FALSE------------------------------------------------------------
#  library(tidyverse)
#  library(fs)
#  
#  get_uninterp <- function(path, extension) {
#    dir_ls(path = path, glob = extension) %>%
#      map_dfc(function(file) lightr:::dispatch_parser(file)[[1]]) %>%
#      select(wl, starts_with("processed"))
#  }
#  
#  get_uninterp("data/heliomaster/", extension = "*.jdx")

