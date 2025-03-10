base_url <- "https://mac.r-project.org/bin"

# We don't support darwin17, because it installs into /usr/local, which
# is impossible to keep separate from the other stuff that goes there

get_file_urls <- function(os = c("darwin20", "darwin17"),
                          arch = c("arm64", "x86_64")) {
  os <- match.arg(os)
  arch <- match.arg(arch)
  dir_url <- paste0(base_url, "/", os, "/", arch)
  pkg_url <- paste0(dir_url, "/PACKAGES")

  pkgs <- read.dcf(url(pkg_url))
  pkgs <-as.data.frame(pkgs)
  pkgs <- pkgs[is.na(pkgs$Bundle), ]

  dup <- duplicated(pkgs$Package)
  if (any(dup)) {
    stop(
      "Duplicated packages: ",
      paste0(pkgs$Package[dup], collapse = ", ")
    )
  }

  structure(paste0(dir_url, "/", pkgs$Binary), names = pkgs$Package)
}

mkdirp <- function(x) {
  dir.create(x, showWarnings = FALSE, recursive = TRUE)
}

strip <- function(path) {
  owd <- getwd()
  on.exit(setwd(owd), add = TRUE)
  setwd(path)
  bin <- c(
    dir("bin", full.names = TRUE),
    dir("sbin", full.names = TRUE)
  )
  for (bin1 in bin) {
    message("STRIP ", bin1)
    system2("strip", c("-x", bin1))
  }

  obj <- dir("lib", recursive = TRUE, full.names = TRUE, pattern = "[.]a$")
  for (obj1 in obj) {
    message("STRIP ", obj1)
    system2("strip", c("-S", obj1))
  }
}

bundle <- function(path, arch) {
  outfile <- paste0("r-macos-sysreqs-", arch, "-full.tar.xz")
  opts <- '--options="xz:compression-level=9"'
  system2("tar", c("cJf", outfile, opts, path))
}

add_system_pc <- function(path) {
  pc <- dir("pc", full.names = TRUE)
  pcdir <- file.path(path, "lib/pkgconfig")
  # do not overwrite existing ones that come from CRAN
  file.copy(pc, pcdir)
}

create_bundle <- function(os = c("darwin20", "darwin17"),
                          arch = c("arm64", "x86_64")) {
  options(timeout = 6000)
  os <- match.arg(os)
  arch <- match.arg(arch)
  urls <- get_file_urls(os, arch)
  root <- if (os == "darwin20") "/opt/R/" else "/usr/local/"
  out <- paste0(root, arch)
  ack <- paste0(out, "/_ack")
  mkdirp(ack)

  for (pkg in names(urls)) {
    url <- urls[pkg]
    ackfile <- paste0(ack, "/", pkg)
    if (file.exists(ackfile)) {
      message("OK ", pkg)
      next
    }

    message("DL ", pkg)
    download.file(url, basename(url), quiet = TRUE)
    message("EX ", pkg)
    untar(basename(url), exdir = "/")
    message("OK ", pkg)
    file.create(ackfile)
  }

  strip(out)
  add_system_pc(out)
  bundle(out, arch)
}

setup_r_sysreqs_main <- function() {
#  create_bundle(os = "darwin17", arch = "x86_64")
  create_bundle(arch = "arm64")
  create_bundle(arch = "x86_64")
  invisible()
}

main <- function() {
  options(timeout = 6000)
  setup_r_sysreqs_main()
  invisible()
}

if (is.null(sys.calls())) {
  main()
  invisible()
}
