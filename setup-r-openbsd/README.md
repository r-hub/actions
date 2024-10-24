# r-hub/actions/setup-r-openbsd

> Setup R on OpenBSD

It creates, sets up and starts a OpenBSD VM with R.
It uses the awesome https://github.com/vmactions project internally for
all the heavy lifting.

## Features

* Starts OpenBSD VM with R and pak installed.
* Sets up the `Rscript` custom shell to run R code on the VM.
* Sets up the `openbsd` custom shell to run shell code on the VM.

## Example

```yaml
- uses: r-hub/actions/setup-r-openbsd@v1
  with:
    release: '7.6'

- name: Run R code on the OpenBSD VM
  shell: Rscript {0}
  run: |
    sessionInfo()

- name: Run shell code on the OpenBSD VM
  shell: openbsd {0}
  run: |
    uname -a
```

## Inputs

* `release`: OpenBSD release to use. Default is '7.6'. See
  https://github.com/vmactions/openbsd-vm#5-select-release for the list
  of supported releases.

## Example workflow for R packages

See the [openbsd.yaml] file for a complete example workflow for R
packages.

## License

MIT @ [Posit Software, PBC](https://posit.co)
