# r-hub/actions/setup-r-freebsd

> Setup R on FreeBSD

It creates, sets up and starts a FreeBSD VM with R.
It uses the awesome https://github.com/vmactions project internally for
all the heavy lifting.

## Features

* Starts FreeBSD VM with R and pak installed.
* Sets up the `Rscript` custom shell to run R code on the VM.
* Sets up the `freebsd` custom shell to run shell code on the VM.

## Example

```yaml
- uses: r-hub/actions/setup-r-freebsd@v1
  with:
    release: '14.1'

- name: Run R code on the FreeBSD VM
  shell: Rscript {0}
  run: |
    sessionInfo()

- name: Run shell code on the FreeBSD VM
  shell: freebsd {0}
  run: |
    uname -a
```

## Inputs

* `relase`: FreeBSD release to use. Default is '14.1'. See
  https://github.com/vmactions/freebsd-vm#5-select-release for the list
  of supported releases.

## Example workflow for R packages

See the [freebsd.yaml] file for a complete example workflow for R
packages.

## License

MIT @ [Posit Software, PBC](https://posit.co)
