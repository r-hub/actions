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

  if (id != "ubuntu" || ver != "22.04") {
    message("No extra repositories for ", id, " ", ver, " Linux systems.")
    return()
  }

  arch <- Sys.info()[["machine"]]
  if (arch != "x86_64") {
    return(no_repos())
  }
  rver <- getRversion()
  # We have 4.4.x and 4.5.x currently
  if (rver < "4.4.0" || rver >= "4.6.0") {
    return(no_repos())
  }

  rminor <- rver[,1:2]
  add_repo(c(RHUB = paste0(
    "https://raw.githubusercontent.com/r-hub/repos/main/ubuntu-22.04/",
    rminor
  )))
}

set_repos_macos <- function() {
  rver <- getRversion()
  rminor <- rver[,1:2]
  # CRAN has 4.4, so no need for that, only add repos for 4.5.x
  if (rminor != "4.5") {
    return(no_repos())
  }
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
