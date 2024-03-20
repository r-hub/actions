# r-hub/actions/setup

> Set up platform matrices to run R-hub jobs.

Must run on `ubuntu-latest`.

## Inputs

* `config`: R-hub configuration. A comma separated list of platforms
  or a JSON string for a more detailed configuration. See `platforms.R`
  for how it is parsed.

## Outputs

* `containers`: container platforms. A build matrix in JSON, with
  columns `label`, `name`, `container`, `job-config`. The last one
  contains the (rest of the) build matrix as a JSON string.
* `platforms`: non-container platforms. A buidl matrix in JSON, with
  columns `label`, `name`, `os`, `r-version`, `job-config`. The last one
  contains the (rest of the) build matrix as a JSON string.

## License

MIT @ [R Consortium](https://www.r-consortium.org/)
