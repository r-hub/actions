
const resolve_all_versions = require('./resolve-all-versions');
const download_files = require('./download-files');

const url_win = require('./url-win');
const ora = require('ora');
const {promisify} = require('util');
const sudo = promisify(require('sudo-prompt').exec);
const path = require('path');

async function install_win32(versions) {

    const rversions = await resolve_all_versions(versions, 'win');
    const urls = await Promise.all(rversions.map(url_win));
    const filenames = await download_files(urls);

    const vs = rversions.join(", ");
    const script = path.join(__dirname, "/installer.bat");

    const spin = ora(
        'Installing R version(s): ' + vs + ". This will take several minutes."
    ).start();

    try {
        await sudo(
            script + ' ' + filenames.join(" "),
            { name: 'installrstats' }
        )
        spin.succeed()
    } catch(error) {
        spin.fail()
        throw error;
    }
}

module.exports = install_win32;
