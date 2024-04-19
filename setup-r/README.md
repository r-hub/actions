# r-hub/actions/setup-r

> Install and setup R for R-hub jobs.

A wrapper of [`r-lib/actions/setup-r`](https://github.com/r-lib/actions/tree/v2-branch/setup-r).

It mainly exists to keep control over the R installation to avoid
updates to the R-hub workflow file.

Difference:

* Sets up the appropriate R-hub repository from
  https://github.com/r-hub/repos, if any.

## Example

```yaml
      - uses: r-hub/actions/setup-r@v1
        with:
          job-config: ${{ matrix.config.job-config }}
          token: ${{ secrets.RHUB_TOKEN }}
```

## Inputs

* `token`: Custom GitHub personal access token. Useful to allow access
  to private repositories or other resources. Not used currently.
* `job-config`: The matrix config, as set up by the `setup` action.

## License

MIT @ [R Consortium](https://www.r-consortium.org/)
