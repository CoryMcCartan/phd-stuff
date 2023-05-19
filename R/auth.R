default_pass <- function() Sys.getenv("GARGLE_PASSWORD")

nonce <- as.raw(c(203L, 54L, 186L, 182L, 82L, 222L, 198L, 174L, 155L, 24L, 39L,
                  198L, 132L, 167L, 182L, 210L))

auth_prep <- function(password = default_pass()) {
    # STEP ONE: download token from Cloud Console and save to credentials.json

    out = openssl::aes_cbc_encrypt(here("credentials.json"),
                                   openssl::sha256(charToRaw(password)),
                                   nonce)
    writeBin(as.raw(out), here("secret_credentials.json"))
}

auth <- function(password = default_pass()) {
    path <- here("secret_credentials.json")
    raw <- readBin(path, "raw", file.size(path))
    cred <- rawToChar(
        openssl::aes_cbc_decrypt(raw, openssl::sha256(charToRaw(password)), nonce)
    )
    googlesheets4::gs4_auth(path = cred)
}

