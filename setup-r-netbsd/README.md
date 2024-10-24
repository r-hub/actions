# r-hub/actions/setup-r-netbsd

> Setup R on NetBSD

It creates, sets up and starts a NetBSD VM with R.
It uses the awesome https://github.com/vmactions project internally for
all the heavy lifting.

## Features

* Starts NetBSD VM with R and pak installed.
* Sets up the `Rscript` custom shell to run R code on the VM.
* Sets up the `netbsd` custom shell to run shell code on the VM.

## Example

```yaml
- uses: r-hub/actions/setup-r-netbsd@v1
  with:
    release: '10.0'

- name: Run R code on the NetBSD VM
  shell: Rscript {0}
  run: |
    sessionInfo()

- name: Run shell code on the NetBSD VM
  shell: netbsd {0}
  run: |
    uname -a
```

## Inputs

* `release`: NetBSD release to use. Default is '14.1'. See
  https://github.com/vmactions/netbsd-vm#5-select-release for the list
  of supported releases.

## Example workflow for R packages

See the [netbsd.yaml] file for a complete example workflow for R
packages.

## License

MIT @ [Posit Software, PBC](https://posit.co)
