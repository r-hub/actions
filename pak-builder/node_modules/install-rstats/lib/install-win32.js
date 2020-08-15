
const resolve_all_versions = require('./resolve-all-versions');
const get_all_rtools_urls = require('./get-all-rtools-urls');
const download_files = require('./download-files');

const url_win = require('./url-win');
const ora = require('ora');
const {promisify} = require('util');
const sudo = promisify(require('sudo-prompt').exec);
const path = require('path');

async function install_win32(versions) {

    const rversions = await resolve_all_versions(versions, 'win');
    const urls = await Promise.all(rversions.map(url_win));
    const rtoolsurls = await get_all_rtools_urls(rversions);

    const allurls = urls.concat(rtoolsurls);
    const allfilenames = await download_files(allurls);

    const vs = rversions.join(", ");
    var rtvs = "";
    if (rtoolsurls.length == 1) {
        rtvs = ", and Rtools"
    } else if (rtoolsurls.length > 1) {
        rtvs = ", and " + rtoolsurls.length + " Rtools versions"
    }

    const spin = ora(
        'Installing R version(s): ' + vs + rtvs + ". This will take several minutes."
    ).start();

    const wd = process.cwd()
    process.chdir(__dirname);

    const script = path.join(__dirname, "/installer.bat");
    try {
        await sudo(
            script + ' ' + allfilenames.join(" "),
            { name: 'installrstats' }
        )
        spin.succeed()
    } catch(error) {
        spin.fail()
        throw error;
    } finally {
        process.chdir(wd);
    }
}

module.exports = install_win32;
