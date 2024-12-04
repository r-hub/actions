# r-hub/actions/debug-shell

> Start a tmate shell for debug re-runs

It the workflow run is a re-run, with debugging enabled,
then it opens a tmate shell that you can ssh into for
interactive debugging.

It uses https://github.com/mxschmitt/action-tmate internally.

## Usage

* Add your SSH key to your GitHub account. This action does not work
  without an SSH key.
* If a workflow run fails, on the web UI select a re-run and turn on
  debug logging.
* Wait until the workflow output tells you that the tmate shell is
  ready, and copy paste the random hostname.
* Use `ssh` to log in to the VM.

## Example

```yaml
- uses: r-hub/actions/debug-shell@v1
  with:
    connect-timeout-seconds: '300'
```

## Inputs

* `connect-timeout-seconds`: How long in seconds to wait for a connection
  to be established. Default is '600'.

## License

MIT @ [Posit Software, PBC](https://posit.co)
