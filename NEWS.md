# `v1.5.0` (2024-12-05)

* New (experimental) `ssh-server` action.

# `v1.4.3` (2024-11-06)

* The `setup-r-*bsd` actions set `NOT_CRAN=true`, unless it is already set,
  similarly to the `r-lib/actions/setup-r` action.

* The `setup-r-netbsd` action now installs the X11 libraries.

* The workflows for the `setup-r-*bsd` actions are simpler now.

# `v1.4.2` (2024-11-06)

* The `setup-r-freebsd` action now uses the `/bin/sh` shell on older
  FreeBSD releases as well.

* The default release of the `setup-r-openbsd` action is now '7.6', which
  is the latest release, instead of '14.1' which does not make sense and
  was a copy-paste error.

* The `platform-info` action now always uses the
  `r-hub/actions/debug-shell@v1` action, so all workflows that use it
  create an interactive shell now on debug re-runs.

# `v1.4.1` (2024-11-05)

* New platforms: `clang20` and `noremap`.

# `v1.4.0` (2024-10-30)

* New actions: `setup-r-netbsd`, `setup-r-dragonflybsd`.

* Improved `setup-r-freebsd` and `setup-r-openbsd` actions:
  - Fix package caching.
  - Install qpdf.
  - Do not use sshfs, it causes issues.
  - Copy `$GITHUB_WORKFLOW` files to VM before `Rscript`,
    copy then back after.

* Do not set `NOT_CRAN=true` on VMs.

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
