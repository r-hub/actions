
# 1.3.4

* Create shortcuts for i386 versions on Windows.

# 1.3.3

* Fix macOS URLs for R-4.1.0.

# 1.3.2

* Update dependencies, in particular, use newer rversions package
  to fix some parallel lookup issuies.

# 1.3.1

* Do not use sudo on GitHub Actions, on Windows, it gets stuck.

* Fix updating the path on Windows.

# 1.3.0

* Create shortcuts to all installed R versions on Windows as well.

* Create all user library directories on Windows as well.

* Automatically install the required Rtools version on Windows, if it is
  not installed already, and set it up correctly.

# 1.2.1

* Fix macOS R-devel installation, we now use the installer from R-hub.

* Fix a potential crash, when using install-rstats after a manual
  installation.

# 1.2.0

* On macOS, `install-rstats` now does not ask for the password, if the
  user can run `sudo` without one.

# 1.1.0

* install-rstats now supports Windows as well.

* The installer now creates all user library directories as well.

# 1.0.1

* For robustness, now we use the https://api.r-hub.io/rversions web
  service to resolve R versions, with a fallback to the R servers.

* Download now does not fail if the base name of the URL is not a
  valid filename. Invalid characters are converted to a dash.

* Download now creates the temporary directory if it does not exist.

# 1.0.0

First published release.
