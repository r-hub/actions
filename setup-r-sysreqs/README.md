# r-hub/actions/setup-r-sysreqs

> Install and setup R system dependencies, on macOS.

It downloads and uncompresses the libraries and tools from
https://mac.r-project.org/bin/. It supports only darwin20.

## Example

```yaml
  - uses: r-hub/actions/setup-r-sysreqs@v1
    with:
      type: full
```

## Inputs

* `type`: Either `full` or `minimal`. Which dependency bundle to
  download. The `minimal` bundle only contains the most frequently
  used dependencies.

## License

MIT @ [R Consortium](https://www.r-consortium.org/)
