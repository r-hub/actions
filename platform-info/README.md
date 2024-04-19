# r-hub/actions/platform-info

> R platform information.

## Example

```yaml
      - uses: r-hub/actions/platform-info@v1
        with:
          token: ${{ secrets.RHUB_TOKEN }}
```
## Inputs

* `token`: Custom GitHub personal access token. Potentially useful to
  allow access to private repositories or other resources, but it is not
  used currently.
* `job-config`: The matrix config, as set up by the `setup` action. Not
  used currently.

## License

MIT @ [R Consortium](https://www.r-consortium.org/)
