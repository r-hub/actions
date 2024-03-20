# r-hub/actions/run-check

> Run R-hub checks.

This is a customized wrapper to
[`r-lib/actions/check-r-package`](https://github.com/r-lib/actions/tree/v2-branch/check-r-package).

Differences:

* It can remove the `.github` directory, if requested.
* Shows the output of installation, examples and tests.
* Checks for valgrind errors in the output, if the check runs on the
  `valgrind` container.
* Builds a binary package and uploads it as an artifact.

## Inputs

* `token`: Custom GitHub personal access token. Useful to allow access
  to private repositories or other resources. Not used currently.
* `job-config`: The matrix config, as set up by the `setup` action.
* `remove-dot-github`: Whether to delete `.github` directory before the
  check. This is usually not a good idea, but R-hub needs to do it when
  running on a package submitted to the RC cluster. (Default: `false`.)

## License

MIT @ [R Consortium](https://www.r-consortium.org/)
