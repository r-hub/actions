
const exec = require('./exec');
const path = require('path');

async function r(rversion, code) {
    var cmd;
    if (rversion === undefined) {
        cmd = "R";
    } else {
        cmd = 'R-' + rversion;
    }
    const inst = path.join(__dirname, 'installer.R');
    const instx = inst.split('\\').join('/');
    const scode = `source('${instx}');${code}`
    await exec(cmd, ["-q", "-e", scode]);
}

module.exports = r;
