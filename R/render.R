render_pages <- function(d, template) {
    for (i in seq_len(nrow(d))) {
        render_page(d[i, ], template)
    }
}

get_template <- function(path=here("advice/_template.qmd")) {
    str_c(readLines(path), collapse="\n")
}

make_path <- function(slug) {
    here(str_c("advice/", slug, ".qmd"))
}

render_page <- function(d, template) {
    output <- str_glue_data(d, template)
    writeLines(output, make_path(d$slug))
}


poss_encrypt <- function(advice, category, slug) {
    if (str_detect(category, "Harvard")) {
        html <-  markdown::mark_html(advice, options="-standalone")
        pass <- openssl::sha256(charToRaw(Sys.getenv("PHD_PASSWORD")))
        nonce <- openssl::sha256(charToRaw(slug))[1:16]
        out = openssl::aes_cbc_encrypt(charToRaw(html), pass, nonce)
        str_glue('<div id="nonce" hidden>{openssl::base64_encode(nonce)}</div>
                  <div id="encrypted" hidden>{openssl::base64_encode(out)}</div>

                  <script type="text/javascript" src="/js/auth.js"></script>')
    } else {
        advice
    }
}
