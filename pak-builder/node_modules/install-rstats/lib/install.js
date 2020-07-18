
const install_win32 = require('./install-win32');
const install_macos = require('./install-macos');

async function install(versions) {
    versions = versions || [];
    if (versions.length == 0) { versions = ['release']; }
    if (process.platform === "win32") {
        return install_win32(versions);
    } else if (process.platform === "darwin") {
        return install_macos(versions);
    } else {
        throw new Error("Unsupported OS, only Windows and macOS are supported");
    }
}

module.exports = install;
