
const core = require('@actions/core')

const input_rversions = core.getInput('rversions');
const rversions = input_rversions.split(/,\s*/);

async function run() {
    try {
        if (process.platform === 'win32') {
            var build_windows = require('./lib/build-windows');
            await build_windows(rversions);
        } else if (process.platform === 'darwin') {
            var build_macos = require('./lib/build-macos');
            await build_macos(rversions);
        } else if (process.platform === 'linux') {
            var build_linux = require('./lib/build-linux');
            await build_linux(rversions);
        } else {
            throw new Error('Unsupported OS, only Windows, Linux and macOS are supported');
        }
    } catch (error) {
        console.log(error);
        core.setFailed(error.message);
    }
}

run()
