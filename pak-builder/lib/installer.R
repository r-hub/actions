
rimraf <- function(x) {
  if ("~" %in% x) stop("Cowardly refusing to delete `~`")
  unlink(x, recursive = TRUE, force = TRUE)
}

mkdirp <- function(x) {
  dir.create(x, showWarnings = FALSE, recursive = TRUE)
}

install_pkgdepends <- function() {
    # No cli just yet
    message("Installing pkgdepends")
    options(repos = c(CRAN = "https://cloud.r-project.org"))
    # This is a workaround for a remotes bug, it cannot install pkgdepends
    # on R 3.3, Windows.
    tryCatch(
      source("https://install-github.me/r-lib/pkgdepends"),
      error = function(err) {
        install.packages("remotes", type = "source")
        remotes::install_git("https://github.com/r-lib/pkgdepends.git")
      }
    )
}

install_pak <- function(path = "pak") {
    dsc <- desc::desc(path)

    cli::cli_h2("Installing local pak tree")
    pak <- pkgdepends::new_pkg_installation_proposal(
        "local::pak",
        config = list(
            dependencies = FALSE,
            `build-vignettes` = FALSE
        )
    )

    pak$resolve()
    pak$solve()
    pak$download()
    pak$install()
}

install_pak_deps <- function(path = "pak") {

    # To install pak's dependencies, we create a temporary
    # directory with a DESCRIPTION file, and then use
    # pkgdepends on this.

    dsc <- desc::desc(path)

    dir.create(tmp <- tempfile())
    on.exit(rimraf(tmp), add = TRUE)

    # Drop packages we don't actually need, these are the
    # dev dependencies
    dsc$del_dep("covr")
    dsc$del_dep("mockery")
    dsc$del_dep("withr")
    dsc$del_dep("testthat")
    dsc$del_dep("pingr")

    deps <- dsc$get_deps()
    deps$type[deps$type == "Suggests"] <- "Imports"
    dsc$set_deps(deps)
    dsc$write(file.path(tmp, "DESCRIPTION"))

    cli::cli_h2("Installing pak dependencies")
    privlib <- file.path(system.file(package = "pak"), "library")
    deps <- pkgdepends::new_pkg_installation_proposal(
        paste0("deps::", tmp),
        policy = "upgrade",
        config = list(
            library = privlib,
            `build-vignettes` = FALSE
         )
    )
    deps$resolve()
    deps$solve()

    # Warn for non-standard dependencies
    sol <- deps$get_solution()$data
    if (any(bad <- (! sol$type %in% c("deps", "standard")))) {
        cli::cli_alert_warning("Development dependencies: {sol$ref[bad]}")
    }

    deps$download()
    deps$install()
}

install_local_curl <- function() {
    cli::cli_h2("Installing static curl package")
    privlib <- file.path(system.file(package = "pak"), "library")
    install.packages("curl", repos = NULL, type = "source", lib = privlib)
}

minimize_library <- function() {
    cli::cli_h2("Cleaning up library")

    lib <- dirname(system.file(package = "pak"))
    pkgs <- dir(file.path(lib, "pak", "library"))

    # Remove docs
    rimraf(file.path(lib, "pak", "library", pkgs, "help"))
    rimraf(file.path(lib, "pak", "library", pkgs, "doc"))

    # Remove .so.dSYM junk files
    rimraf(dir(
        lib,
        full.names = TRUE,
        recursive = TRUE,
        pattern = "\\.so\\.dSYM$",
        include.dirs = TRUE
    ))

    # Strip shared libs
    shlibs <- dir(
        lib,
        full.names = TRUE,
        recursive = TRUE,
        pattern = "\\.so$",
        include.dirs = TRUE
    )
    cmd <- strsplit(Sys.getenv("R_STRIP_SHARED_LIB", "strip -x"), "\\s+")[[1]]
    for (shl in shlibs) processx::run(cmd[1], c(cmd[-1], shl))

    # Remove pak/library/_cache
    rimraf(file.path(lib, "pak", "library", "_cache"))
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

build_binary_mac <- function() {
  ver <- as.character(packageVersion("pak"))
  lib <- dirname(system.file(package = "pak"))
  pkg_file <- paste0("pak_", ver, ".tgz")

  withr::with_dir(lib, {
      utils::tar(
          pkg_file,
          files = "pak",
          tar = "internal",
          compression = "gzip",
          compression_level = 9
      )
  })

  local <- file.path(repo_base_dir(), contrib.url("", "binary"), pkg_file)
  mkdirp(dirname(local))

  file.copy(file.path(lib, pkg_file), local, overwrite = TRUE)

  pkg_file
}

build_binary_win <- function() {
    ver <- as.character(packageVersion("pak"))
    lib <- dirname(system.file(package = "pak"))
    pkg_file <- paste0("pak_", ver, ".zip")

    withr::with_dir(lib, {
        utils::zip(
            pkg_file,
            files = "pak"
        )
    })

    local <- file.path(repo_base_dir(), contrib.url("", "binary"), pkg_file)
    mkdirp(dirname(local))

    file.copy(file.path(lib, pkg_file), local, overwrite = TRUE)

    pkg_file
}

build_binary_linux <- function() {
  ver <- as.character(packageVersion("pak"))
  rver <- paste0("R", gsub(".", "-", getRversion()[,1:2], fixed = TRUE))
  platform <- R.Version()$platform
  lib <- dirname(system.file(package = "pak"))
  pkg_file <- paste0("pak_", ver, "_", rver, "_", platform, ".tar.gz")

  withr::with_dir(lib, {
      utils::tar(
          pkg_file,
          files = "pak",
          tar = "internal",
          compression = "gzip",
          compression_level = 9
      )
  })

  local <- file.path(repo_base_dir(), contrib.url("", "source"), pkg_file)
  mkdirp(dirname(local))

  file.copy(file.path(lib, pkg_file), local, overwrite = TRUE)

  pkg_file
}

build_binary <- function() {
    cli::cli_h2("Building binary package")
    os <- get_os()
    if (os == "mac") {
        build_binary_mac()
    } else if (os == "win") {
        build_binary_win()
    } else if (os == "linux") {
        build_binary_linux()
    }
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

download_curl <- function() {
    options(repos = c(CRAN = "https://cloud.r-project.org"))
    pkg <- download.packages("curl", ".")
    utils::untar(pkg[1,2])
}

repo_base_dir <- function() {
  "built"
}

main <- function() {
    # The image already has it on Linux
    if (get_os() != "linux") install_pkgdepends()
    install_pak()
    install_pak_deps()
    # Only need to patch on macOS
    if (get_os() == "mac") install_local_curl()
    minimize_library()
    build_binary()
}
