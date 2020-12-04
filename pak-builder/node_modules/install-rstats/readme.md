
# install-rstats

> Install various versions of R on macOS and Windows

## Features

* Downloads and installs multiple R versions, with a single command.
* Supports symbolic version names: `release`, `devel` and `oldrel`.
* On Windows, it installs the correct Rtools versions (if they are not
  installed already), and sets them up.
* Patches R to allow running multiple R versions at the same time.
  (macOS, not needed for Windows)
* Adds symlinks/shortcuts to start a certain R version: e.g. `R-4.0`.
* Updates access rights of to forbid installing packages into the
  system R library. (macOS, not needed for Windows)
* Creates user package libraries.

## Install

```
$ npm install -g install-rstats
```

## Usage

### Command line

```sh
install-rstats [rversion1] [rversion2] ...
```

On macOS, if you start `install-rstats` wihout `sudo`, it will ask for
your password (once) in a dialog box. If you want to avoid that, use
 `sudo` at the line:

```sh
sudo install-rstats [rversion1] [rversion2] ...
```

### From node.js

Use the `install()` function and supply the desired R versions in an
array. If no version is given, it installs the latest R release.

Example:

```js
const installr = require('install-rstats');

(async () => {
    await installr.install(['3.6', '4.0', 'devel'])
})();
```

### Supported R versions

* `release` is the current R release,
* `oldrel` is the latest release of the previous minor branch,
* `devel` is a development snapshot,
* `x.y` is the latest release of the x.y branch,
* `x.y.z` is version x.y.z.

## License

ISC @ R Consortium

This repo is part of the R-hub project, supported by
the R Consortium.
