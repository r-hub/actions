strict_mode <- function() {
  options(
    useFancyQuotes = FALSE,
    warn = 2,
    warnPartialMatchArgs = TRUE,
    warnPartialMatchAttr = TRUE,
    warnPartialMatchDollar = TRUE
  )
}

no_repos <- function() {
  message(
    "No extra repositoes for R ", getRversion(),
    " on ", Sys.info()[["sysname"]],
    " (", Sys.info()[["machine"]],
    ") currently."
  )
}

set_repos_unknown <- function() {
  message("No extra repositories for ", Sys.info()[["sysname"]], " systems.")
}

set_repos_windows <- function() {
  no_repos()
}

no_repos_unknown_linux <- function() {
  message("No extra repositories for unknown Linux systems.")
}

set_repos_linux <- function() {
  if (!file.exists("/etc/os-release")) {
    return(no_repos_unknown_linux())
  }
  ok <- tryCatch(
    readRenviron("/etc/os-release"),
    error = function(e) "nope"
  )
  if (identical(ok, "nope")) {
    return(no_repos_unknown_linux())
  }

  id <- Sys.getenv("ID")
  ver <- Sys.getenv("VERSION_ID")

  if (id == "" || ver == "") {
    return(no_repos_unknown_linux())
  }

  arch <- Sys.info()[["machine"]]
  platform <- paste0(id, "-", ver)
  if (arch != "x86_64") {
    platform <- paste0(platform, "-", arch)
  }
  rver <- getRversion()
  rminor <- rver[,1:2]
  add_repo(c(RHUB = paste0(
    "https://raw.githubusercontent.com/r-hub/repos/main/",
    platform, "/",
    rminor
  )))
}

set_repos_macos <- function() {
  rver <- getRversion()
  rminor <- rver[,1:2]
  set_cran_repo("https://mac.cran.dev/")
  arch <- Sys.info()[["machine"]]
  if (arch == "x86_64") {
    add_repo(c(RHUB = paste0(
      "https://raw.githubusercontent.com/r-hub/repos/main/macos-x86_64/",
      rminor
    )))
  } else {
    add_repo(c(RHUB = paste0(
      "https://raw.githubusercontent.com/r-hub/repos/main/macos-arm64/",
      rminor
    )))
  }
}

set_cran_repo <- function(url) {
  message("Setting CRAN repository to ", url, ".")
  cat(
    append = TRUE, sep = "\n", file = "~/.Rprofile",
    sprintf(
      "local({ r <- getOption(\"repos\"); r[[\"CRAN\"]] <- \"%s\"; options(repos = r) })",
      url
    )
  )
}

add_repo <- function(repo) {
  for (i in seq_along(repo)) {
    message("Adding repository ", names(repo)[i], " = ", repo[i], ".")
    cat(
      append = TRUE, sep = "\n", file = "~/.Rprofile",
      sprintf("options(repos = c(%s = \"%s\", getOption(\"repos\")))", names(repo)[i], repo[i])
    )
  }
}

set_repos <- function() {
  sysname <- Sys.info()[["sysname"]]
  switch(
    sysname,
    "Linux" = set_repos_linux(),
    "Darwin" = set_repos_macos(),
    "Windows" = set_repos_windows(),
    set_repos_unknown()
  )
}

main <- function() {
  strict_mode()
  set_repos()
}

if (is.null(sys.calls())) {
  main()
}
