
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
  pkgs <- dir(built_base_dir(), recursive=TRUE, pattern = "^pak_")
  for (pkg in pkgs) {
    src <- file.path(built_base_dir(), pkg)
    tgt <- file.path(repo_base_dir(), dirname(pkg), basename(pkg))
    mkdirp(dirname(tgt))
    file.copy(src, tgt, overwrite = TRUE)
    update_pkgs(dirname(tgt))
  }
  pkgs
}

update_pkgs <- function(path) {
  os <- get_os()
  type <- switch(
    os,
    "mac" = "mac.binary",
    "win" = "win.binary",
    "linux" = "source"
  )

  oldwd <- getwd()
  on.exit(setwd(oldwd), add = TRUE)
  setwd(path)
  tools::write_PACKAGES(
    type = type,
    subdirs = TRUE,
    fields = repo_fields(),
    latestOnly = FALSE,
    addFiles = TRUE
  )

  if (os == "linux") postprocess_source_metadata()

  postprocess_rds(path)
}

postprocess_source_metadata <- function() {
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

postprocess_rds <- function(path) {
  rdsfile <- file.path(path, "PACKAGES.rds")
  if (!file.exists(rdsfile)) return()
  mtd <- readRDS(rdsfile)
  saveRDS(mtd, rdsfile, compress = "xz", version = 2)
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
