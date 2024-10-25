# r-hub/actions/setup-r-dragonflybsd

> Setup R on DragonFlyBSD

It creates, sets up and starts a DragonFlyBSD VM with R.
It uses the awesome https://github.com/vmactions project internally for
all the heavy lifting.

## Features

* Starts DragonFlyBSD VM with R and pak installed.
* Sets up the `Rscript` custom shell to run R code on the VM.
* Sets up the `dragonflybsd` custom shell to run shell code on the VM.

## Example

```yaml
- uses: r-hub/actions/setup-r-dragonflybsd@v1
  with:
    release: '6.4.0'

- name: Run R code on the DragonFlyBSD VM
  shell: Rscript {0}
  run: |
    sessionInfo()

- name: Run shell code on the DragonFlyBSD VM
  shell: dragonflybsd {0}
  run: |
    uname -a
```

## Inputs

* `release`: DragonFlyBSD release to use. Default is '6.4.0'. See
  https://github.com/vmactions/dragonflybsd-vm#5-select-release for the list
  of supported releases.

## Example workflow for R packages

See the [dragonflybsd.yaml] file for a complete example workflow for R
packages.

## License

MIT @ [Posit Software, PBC](https://posit.co)
