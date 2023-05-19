#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(here)
    library(googlesheets4)
    library(janitor)
    library(dplyr)
    library(stringr)

    invisible(lapply(Sys.glob(here("R/*.R"))[-1], source))
})

auth()

advice = get_sheet() |>
    tidy_sheet() |>
    proc_sheet()

render_pages(advice, get_template())
