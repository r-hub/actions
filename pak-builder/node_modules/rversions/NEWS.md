
# 1.3.0

* Older oldrel versions: e.g. the release before `r_oldrel()` is
  `r_oldrel(2)`.

# 1.2.0

* Fix detection of the macOS installer version.

# 1.1.0

* New `r_devel()` function to get the (possible future) version number
  of the next R release.

* Fix caching of the list of all releases.

* Fix a caching issue, where the cache could be inadvertently modified
  if queries were running concurrently.

# 1.0.2

* Fix `r_oldrel()` calculation, that was broken on R 4.x.

* Fix `r_release_tarball()` URL for R 4.x.

# 1.0.1

* Now we have a dummy implementation, that does not use the internet,
  for testing. It can be turned on by setting the `NODE_RVERSIONS_DUMMY`
  environment variable to `true`, before `require()`-ing the module.

# 1.0.0

First released version.
