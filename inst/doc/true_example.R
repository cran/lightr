## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
has_pavo <- requireNamespace("pavo", quietly = TRUE)

## -----------------------------------------------------------------------------
library(lightr)

## ---- fig.cap="Atlantic puffin close up, by user john-289283 from pexels.com", out.width='100%'----
knitr::include_graphics("puffin-small.jpg")

## -----------------------------------------------------------------------------
raw_files <- lr_get_spec("data/puffin", ext = "ProcSpec")
txt_files <- lr_get_spec("data/puffin", ext = "txt")

## ---- fig.show='hold', eval=has_pavo------------------------------------------
library(pavo)
plot(raw_files, main = "Raw ProSpec files")
plot(txt_files, main = "Exported txt files")

## -----------------------------------------------------------------------------
all.equal(raw_files, txt_files, tol = 1e-4)

## ---- eval=has_pavo-----------------------------------------------------------
beak <- procspec(raw_files, opt = "smooth")
summary(beak, subset = c("B2", "H5"))

## ---- eval=has_pavo-----------------------------------------------------------
vis_beak <- vismodel(beak, visual = "avg.uv", achromatic = "ch.dc")
tcs_beak <- colspace(vis_beak)
coldist(tcs_beak, achromatic = TRUE)

