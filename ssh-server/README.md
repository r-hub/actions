# r-hub/actions/ssh-server

> Start an ssh server and create a Cloudflare tunnel

This is an experimental action that starts an ssh server on the runner
and also creates an ad-hoc CloudFlare tunnel to it.

## Features

* Downloads and configures the ssh public keys of the GitHub actor that
  started the workflow.
* Installs and starts the ssh server.
* Prints the command to run on the client to create the TCP -> HTTPS
  tunnel to Cloudflare's edge.

## Current limitations

* It only works in Ubuntu or Debian Linux containers, as the root user.
* It does not work if the ssh server is already running.
* The actor that triggered the workflow must have a public SSH key added
  to their GitHub profile and they must use that to connect.
* After the SSH server starts on the runner, the workflow run is blocked
  until it is cancelled or until its timeout is reached. The default
  timeout is 6 hours for GitHub-hosted runners.

## Usage

### To connect to a runner

* Add your SSH key to your Github account.
* Install the cloudflared client on your computer. E.g. on macOS run
  ```sh
  brew install cloudflared
  ```
* Call the action from a workflow, or add a manual trigger for it (see
  next section):
  ```yaml
  uses: r-hub/actions/ssh-server@v1
  ```
* Wait until the SSH banner shows up. It looks like this:
  ```
  --------------------------------------------------------------
   ____ ____  _   _
  / ___/ ___|| | | |
  \___ \___ \| |_| |
   ___) |__) |  _  |
  |____/____/|_| |_|

  brew install cloudflared
  cloudflared access tcp --url localhost:9210 --hostname building-mozambique-releases-bags.trycloudflare.com
  ssh root@localhost -p 9210

  Positron ssh: root@localhost:9210

  --------------------------------------------------------------
  Cancel the workflow run when you are done.
  ```
* Run the command starting with `cloudflared` on your computer.
* In another shell, run the `ssh` command:
  ```sh
  ssh root@localhost -p 9210
  ```

To avoid having to delete hosts from `~/.ssh/known_hosts` all the time,
I suggest that you add this to your `~/.ssh/config` file:
```
Host localhost
     UserKnownHostsFile /dev/null
     LogLevel QUIET
     StrictHostKeyChecking accept-new
```

### To disconnect

* Log out from your ssh connections.
* Cancel the workflow run.
* Interrupt the `cloudflared` client with CTRL+C.

## Manual trigger

A good way to allow triggering the action manually is to only run it
in re-runs, if the debug logging is turned on. Then, if a workflow run
fails and you want to debug it interactively, you can request a re-run
with debug symbols:

```yaml
- name: Interactive debug
  if: ${{ always() && runner.debug == '1' && github.run_attempt != '1' }}
  uses: r-hub/actions/ssh-server@main
```

## License

MIT @ [Posit Software, PBC](https://posit.co)
