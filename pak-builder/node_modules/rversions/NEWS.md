
# 1.0.2

* Fix `r_oldrel()` calculation, that was broken on R 4.x.

* Fix `r_release_tarball()` URL for R 4.x.

# 1.0.1

* Now we have a dummy implementation, that does not use the internet,
  for testing. It can be turned on by setting the `NODE_RVERSIONS_DUMMY`
  environment variable to `true`, before `require()`-ing the module.

# 1.0.0

First released version.
