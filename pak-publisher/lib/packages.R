
mkdirp <- function(x) {
  dir.create(x, showWarnings = FALSE, recursive = TRUE)
}

get_os <- function () {
  if (.Platform$OS.type == "windows") {
    "win"
  } else if (Sys.info()[["sysname"]] == "Darwin") {
    "mac"
  } else if (Sys.info()[["sysname"]] == "Linux") {
    "linux"
  } else {
    stop("Unknown OS")
  }
}

copy_package <- function() {
  os <- get_os()
  if (os == "mac") {
    copy_package_mac()
  } else if (os == "win") {
    copy_package_win()
  } else if (os == "linux") {
    copy_package_linux()
  }
}

copy_package_mac <- function() {
  ver <- as.character(packageVersion("pak"))
  pkg_file <- paste0("pak_", ver, ".tgz")
  local <- file.path(built_base_dir(), contrib.url("", "binary"), pkg_file)
  repo <- file.path(repo_base_dir(), contrib.url("", "binary"), pkg_file)
  mkdirp(dirname(repo))
  file.copy(local, repo, overwrite = TRUE)
  withr::with_dir(dirname(repo), {
    tools::write_PACKAGES(
      type = "mac.binary",
      subdirs = TRUE,
      fields = repo_fields(),
      latestOnly = FALSE
    )
  })
  repo
}

copy_package_win <- function() {
  ver <- as.character(packageVersion("pak"))
  pkg_file <- paste0("pak_", ver, ".zip")
  local <- file.path(built_base_dir(), contrib.url("", "binary"), pkg_file)
  repo <- file.path(repo_base_dir(), contrib.url("", "binary"), pkg_file)
  mkdirp(dirname(repo))
  file.copy(local, repo, overwrite = TRUE)
  withr::with_dir(dirname(repo), {
    tools::write_PACKAGES(
      type = "win.binary",
      subdirs = TRUE,
      fields = repo_fields(),
      latestOnly = FALSE
    )
  })

  postprocess_source_metadata(dirname(repo))

  repo
}

copy_package_linux <- function() {
  ver <- as.character(packageVersion("pak"))
  rver <- paste0("R", gsub(".", "-", getRversion()[,1:2], fixed = TRUE))
  platform <- R.Version()$platform
  pkg_file <- paste0("pak_", ver, "_", rver, "_", platform, ".tar.gz")
  local <- file.path(built_base_dir(), contrib.url("", "source"), pkg_file)
  repo <- file.path(repo_base_dir(), contrib.url("", "source"), pkg_file)
  mkdirp(dirname(repo))
  file.copy(local, repo, overwrite = TRUE)
  withr::with_dir(dirname(repo), {
    tools::write_PACKAGES(
      type = "source",
      subdirs = TRUE,
      fields = repo_fields(),
      latestOnly = FALSE,
      addFiles = TRUE
    )
  })
  repo
}

postprocess_source_metadata <- function(dir) {
  withr::local_dir(dir)
  pkgs <- read.dcf("PACKAGES")
  if (! "Built" %in% colnames(pkgs)) {
    stop("No 'Built' field, I need binary packages")
  }
  rverstr <- vapply(
    strsplit(pkgs[, "Built"], "; "),
    FUN.VALUE = character(1),
    function(x) {
      sub("^R[ ]*", "", x[[1]])
    }
  )
  rver <- package_version(rverstr)[, 1:2]
  pkgs[, "Depends"] <- paste0("R (>= ", rver, ")")
  pkgs <- pkgs[order(rver, decreasing=TRUE), ]

  # Plain
  write.dcf(pkgs, "PACKAGES")
  # .gz
  con <- gzfile("PACKAGES.gz", "wt")
  write.dcf(pkgs, con)
  close(con)
  # .rds
  saveRDS(pkgs, "PACKAGES.rds", compress = "xz", version = 2)
}

repo_fields <- function() {
  c("Package",
    "Version",
    "Depends",
    "Imports",
    "LinkingTo",
    "Suggests",
    "Enhances",
    "OS_type",
    "License",
    "Archs",
    "Built",
    "Packaged",
    "MD5sum"
  )
}

built_base_dir <- function() {
  "built"
}

repo_base_dir <- function() {
  "r-lib.github.io/p/pak/dev"
}

main <- function() {
  copy_package()
}
