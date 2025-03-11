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
  used dependencies. The default is `full`.
* `arch`: Architecture to download system packages for. Possible values are
  `arm64` and `x86_64`. The default is the native architecture.
* `xquartz`: Whether to install XQuartz on macOS. Default is `true`. Set to
  `false` to omit installing XQuartz via Homebrew.

## License

MIT @ [R Consortium](https://www.r-consortium.org/)
