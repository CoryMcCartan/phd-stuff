get_sheet <- function() {
    ss <- "1PG_t0wTcTbDBlwpUioPnSWfyND78txoXOaVpspsSATQ"
    suppressMessages(read_sheet(ss, "Raw"))
}

tidy_sheet <- function(d) {
    d |>
        janitor::clean_names() |>
        rename(advice=something_you_wish_youd_known_earlier_in_your_ph_d) |>
        mutate(approved = !is.na(approved_title),
               merge_with = coalesce(merge_with, row_number() + 1L))
}

proc_sheet <- function(d) {
    d |>
        filter(approved) |>
        mutate(advice = str_glue("{advice}\n\n— {name}, {cohort} cohort")) |>
        group_by(merge_with) |>
        summarize(slug = str_c(as.character(as.Date(d$timestamp[1])),
                               "_", make_clean_names(category[1]), "_", merge_with[1]),
                  category = category[1],
                  title = approved_title[1],
                  authors = str_flatten(unique(name), ", "),
                  advice = str_c(advice, collapse="\n\n---\n\n")) |>
        select(-merge_with)
}
