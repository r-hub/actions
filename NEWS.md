# `v1.3.0` (3024-10-24)

* New actions: `setup-r-freebsd`, `setup-r-openbsd` and `debug-shell`.

# `v1.2.3` (2024-10-15)

* Fixed `setup` action so it works without R being installed on the VM.
  It is not pre-installed on the new `ubuntu-latest` any more.

# `v1.2.2` (2024-10-11)

* Automatic quarto installation is now disabled because it does
  not work on many containers (#25, @pawelru).

# `v1.2.1` (2024-05-27)

* Fail job for UBSAN errors (#16).

# `v1.2.0` (2024-05-27)

* New `rchk` and `clang19` containers.

# `v1.1.11` (2024-05-25)

* New `c23` container.

# `v1.1.10` (2024-05-24)

* New `gcc14` container.

# `v1.1.9` (2024-05-13)

* `r-hub/checkout@v1` now does not forward `token`, it breaks the build
  if it is missing.

# `v1.1.8` (2024-05-12)

* `r-hub/checkout@v1` forwards the `token` and `submodules` parameters to
  `actions/checkout` (#15).

# `v1.1.7` (2024-05-09)

* `r-hub/setup-deps@v1` now uses a better cache key, so builds don't use
  packages from incompatible R builds
  (https://github.com/r-hub/rhub/issues/602).

# `v1.1.6` (2024-05-09)

* `r-hub/setup-deps@v1` always installs Pandoc now.

# `v1.1.5` (2024-05-09)

* `r-hub/setup-r-sysreqs@v1` now installs XQuartz on macOS by default.

# `v1.1.4` (2024-05-07)

* `r-hub/setup-r-sysreqs@v1` uses updated URLs to download the system
  package bundles.

# `v1.1.3` (2024-04-28)

* Fix macOS platforms, `macos-latest` is now arm64, so we need to
  use `macos-13` to run x86_64 jobs.

# `v1.1.2` (2024-04-19)

* Do not use dev `r-lib/actions` any more.

# `v1.1.1` (2024-03-29)

* `r-hub/setup-r@v1` now uses `r-hub/setup-r-sysreqs` to install system
  packages on macOS.

# `v1.1.0` (2024-03-29)

* New `r-hub/setup-r-sysreqs@v1` action.

# `v1.0.1` (2024-03-28)

* First version.
