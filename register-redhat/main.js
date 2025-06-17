const { spawn } = require("child_process");
const org = process.env.REDHAT_ORG;
const key = process.env.REDHAT_KEY;
if(!org || !key){
   throw "Need to set REDHAT_ORG and REDHAT_KEY environment variables";
}
const cmd = `subscription-manager register --org ${org} --activationkey ${key}`;
const subprocess = spawn(cmd, { stdio: "inherit", shell: true });
subprocess.on("exit", (exitCode) => {
  process.exitCode = exitCode;
});
