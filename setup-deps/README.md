# r-hub/actions/setup-deps

> Set up dependencies for R-hub checks.

A wrapper of [`r-lib/actions/setup-r-dependencies`](https://github.com/r-lib/actions/tree/v2-branch/setup-r-dependencies).

It mainly exists to keep control over the dependency installation to
avoid updates to the R-hub workflow file.

## Example

```yaml
      - uses: r-hub/actions/setup-deps@v1
        with:
          token: ${{ secrets.RHUB_TOKEN }}
```

## Inputs

* `token`: Custom GitHub personal access token. Useful to allow access
  to private repositories or other resources. Not used currently.
* `job-config`: The matrix config, as set up by the `setup` action.
* `extra-packages`: passed to `r-lib/actions/setup-r-dependencies`.
* `needs`: passed to `r-lib/actions/setup-r-dependencies`.
* `pak-version`: passed to `r-lib/actions/setup-r-dependencies`.
* `dependencies`: passed to `r-lib/actions/setup-r-dependencies`.

## License

MIT @ [R Consortium](https://www.r-consortium.org/)
