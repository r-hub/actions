# r-hub/actions/checkout

> Check out a repo, a wrapper to https://github.com/actions/checkout.

This action exists to avoid having to update the R-hub workflow file
when the `actions/checkout` action has a new tag, and to have complete
control over the R-hub workflow in general.

## Inputs

* `repository`: Repository name with owner. For example,
  `actions/checkout`.
* `ref`: The branch, tag or SHA to checkout. When checking out the
  repository that triggered a workflow, this defaults to the reference or
  SHA for that event.  Otherwise, uses the default branch.

See https://github.com/actions/checkout.

## License

MIT @ [R Consortium](https://www.r-consortium.org/)
