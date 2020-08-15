
const execa = require('execa');

async function rimraf(file) {
    var options = {};
    options['stdout'] = 'inherit';
    options['stderr'] = 'inherit';
    var cmd, args;
    if (os.platform == "win32") {
        cmd = "cmd.exe";
        args = [ "/C", path.join(__dirname, 'rimraf.bat'), file ];
    } else {
        cmd = "rm";
        args = [ "-rf", file ];
    }
    await execa(cmd, args, options);
}

module.exports = rimraf;
