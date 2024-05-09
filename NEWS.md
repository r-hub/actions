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
