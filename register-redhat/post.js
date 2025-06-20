const { spawn } = require("child_process");
const cmd = 'subscription-manager unregister || true';
const subprocess = spawn(cmd, { stdio: "inherit", shell: true });
subprocess.on("exit", (exitCode) => {
  process.exitCode = exitCode;
});
