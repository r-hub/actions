
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
